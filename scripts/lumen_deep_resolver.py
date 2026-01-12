#!/usr/bin/env python3
"""
Lumen Deep Resolver - Research unknown bulb specs and fill them in

Uses multiple strategies:
1. Model-generation lookup tables
2. Year-range based patterns
3. Era-appropriate defaults
4. Platform/chassis code inference
"""

import json
import csv
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from datetime import datetime
import os

# Paths
SCRIPT_DIR = Path(__file__).parent
ASSETS_DIR = SCRIPT_DIR.parent / "assets" / "seed"
BULBS_WIDE_PATH = ASSETS_DIR / "specs" / "fitment" / "bulbs_wide.csv"
BULBS_WIDE_OUT = ASSETS_DIR / "specs" / "fitment" / "bulbs_wide_resolved.csv"
REPORT_DIR = SCRIPT_DIR.parent / "artifacts"
REPORT_PATH = REPORT_DIR / "lumen_resolution_report.md"

# ============================================================================
# RESEARCH-BASED BULB SPECS BY MODEL/GENERATION
# ============================================================================

# Headlight specs by model/generation/year
HEADLIGHT_SPECS = {
    # Legacy
    ("Legacy", 1990, 1994): {"low": ("9004|HB1|2|bulb|true", "Service Manual"), "high": ("9004|HB1|2|bulb|true", "Service Manual")},
    ("Legacy", 1995, 1999): {"low": ("H4 (9003)|P43t|2|bulb|true", "Catalog"), "high": ("H4 (9003)|P43t|2|bulb|true", "Catalog")},
    ("Legacy", 2000, 2004): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Legacy", 2005, 2009): {"low": ("H7|PX26d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Legacy", 2010, 2014): {"low": ("H7|PX26d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Legacy", 2015, 2019): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Legacy", 2020, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Outback
    ("Outback", 1995, 1999): {"low": ("H4 (9003)|P43t|2|bulb|true", "Catalog"), "high": ("H4 (9003)|P43t|2|bulb|true", "Catalog")},
    ("Outback", 2000, 2004): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Outback", 2005, 2009): {"low": ("H7|PX26d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Outback", 2010, 2014): {"low": ("H7|PX26d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Outback", 2015, 2019): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Outback", 2020, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Impreza
    ("Impreza", 1993, 2001): {"low": ("H4 (9003)|P43t|2|bulb|true", "Catalog"), "high": ("H4 (9003)|P43t|2|bulb|true", "Catalog")},
    ("Impreza", 2002, 2007): {"low": ("9007 (HB5)|PX29t|2|bulb|true", "Catalog"), "high": ("9007 (HB5)|PX29t|2|bulb|true", "Catalog")},
    ("Impreza", 2008, 2011): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Impreza", 2012, 2016): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Impreza", 2017, 2025): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    
    # WRX
    ("WRX", 2002, 2003): {"low": ("9007 (HB5)|PX29t|2|bulb|true", "Catalog"), "high": ("9007 (HB5)|PX29t|2|bulb|true", "Catalog")},
    ("WRX", 2004, 2005): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("WRX", 2006, 2007): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("WRX", 2008, 2014): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("WRX", 2015, 2021): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("WRX", 2022, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # STI
    ("STI", 2004, 2005): {"low": ("D2R||2|hid|true", "Factory HID"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("STI", 2006, 2007): {"low": ("D2S||2|hid|true", "Factory HID"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("STI", 2008, 2014): {"low": ("D2S||2|hid|true", "Factory HID"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("STI", 2015, 2021): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Forester
    ("Forester", 1998, 2002): {"low": ("H4 (9003)|P43t|2|bulb|true", "Catalog"), "high": ("H4 (9003)|P43t|2|bulb|true", "Catalog")},
    ("Forester", 2003, 2008): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Forester", 2009, 2013): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Forester", 2014, 2018): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Forester", 2019, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Crosstrek / XV
    ("Crosstrek", 2013, 2017): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("Crosstrek", 2018, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    ("XV", 2012, 2017): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("XV", 2018, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # BRZ
    ("BRZ", 2013, 2016): {"low": ("H11|PGJ19-2|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    ("BRZ", 2017, 2020): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    ("BRZ", 2022, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Tribeca
    ("Tribeca", 2006, 2014): {"low": ("H7|PX26d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    
    # Ascent
    ("Ascent", 2019, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
    
    # Baja
    ("Baja", 2003, 2006): {"low": ("H1|P14.5s|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    
    # SVX
    ("SVX", 1992, 1997): {"low": ("9006 (HB4)|P22d|2|bulb|true", "Catalog"), "high": ("9005 (HB3)|P20d|2|bulb|true", "Catalog")},
    
    # Solterra
    ("Solterra", 2023, 2025): {"low": ("LED_MODULE||0|led|false", "Factory LED"), "high": ("LED_MODULE||0|led|false", "Factory LED")},
}

# Fog light specs by model/generation/year
FOG_SPECS = {
    # Generic H3 era
    ("Legacy", 1995, 2004): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("Legacy", 2005, 2009): ("9006 (HB4)|P22d|2|bulb|true", "Catalog"),
    ("Legacy", 2010, 2014): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("Legacy", 2015, 2019): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("Legacy", 2020, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Outback", 2000, 2004): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("Outback", 2005, 2009): ("9006 (HB4)|P22d|2|bulb|true", "Catalog"),
    ("Outback", 2010, 2014): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("Outback", 2015, 2019): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    ("Outback", 2020, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Impreza", 2000, 2007): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("Impreza", 2008, 2016): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("Impreza", 2017, 2025): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    
    ("WRX", 2002, 2007): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("WRX", 2008, 2014): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("WRX", 2015, 2021): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    ("WRX", 2022, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("STI", 2004, 2007): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("STI", 2008, 2014): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("STI", 2015, 2021): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    
    ("Forester", 1998, 2008): ("H3|PK22s|2|bulb|true", "Catalog"),
    ("Forester", 2009, 2013): ("H11|PGJ19-2|2|bulb|true", "Catalog"),
    ("Forester", 2014, 2018): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    ("Forester", 2019, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Crosstrek", 2013, 2017): ("PSX24W||2|bulb|true", "Catalog"),
    ("Crosstrek", 2018, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    ("XV", 2012, 2017): ("PSX24W||2|bulb|true", "Catalog"),
    ("XV", 2018, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("BRZ", 2013, 2020): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    ("BRZ", 2022, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Tribeca", 2006, 2014): ("9006 (HB4)|P22d|2|bulb|true", "Catalog"),
    
    ("Ascent", 2019, 2025): ("H16|PGJ19-3|2|bulb|true", "Catalog"),
    
    ("Baja", 2003, 2006): ("H3|PK22s|2|bulb|true", "Catalog"),
    
    ("SVX", 1992, 1997): ("H3|PK22s|2|bulb|true", "Catalog"),
}

# Parking/position light specs
PARKING_SPECS = {
    # Most Subarus before LED use 194/168
    ("_default_", 1990, 2015): ("194|W2.1x9.5d|2|bulb|true", "Generic"),
    ("_default_", 2016, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
}

# Side marker specs (USDM)
SIDE_MARKER_SPECS = {
    ("_default_", 1990, 2015): ("194|W2.1x9.5d|2|bulb|true", "Generic"),
    ("_default_", 2016, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
}

# High mount stop specs
HIGH_MOUNT_SPECS = {
    # Most use 921
    ("_default_", 1986, 2010): ("921|W3x16d|1|bulb|true", "Generic"),
    ("_default_", 2011, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
}

# DRL specs
DRL_SPECS = {
    # DRL became common around 2012
    ("_default_", 2012, 2016): ("PSX24W||2|bulb|true", "Generic"),
    ("_default_", 2017, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
}


def lookup_spec(model: str, year: int, func_key: str) -> Optional[Tuple[str, str]]:
    """Look up spec from research tables."""
    # Normalize model name
    model_norm = model.strip()
    
    # Map function_key to lookup table
    if func_key == "headlight_low":
        table = HEADLIGHT_SPECS
        field = "low"
    elif func_key == "headlight_high":
        table = HEADLIGHT_SPECS
        field = "high"
    elif func_key == "fog_front":
        table = FOG_SPECS
        field = None
    elif func_key == "parking":
        table = PARKING_SPECS
        field = None
    elif func_key in ("side_marker_front", "side_marker_rear"):
        table = SIDE_MARKER_SPECS
        field = None
    elif func_key == "high_mount_stop":
        table = HIGH_MOUNT_SPECS
        field = None
    elif func_key == "drl":
        table = DRL_SPECS
        field = None
    else:
        return None
    
    # Search for matching entry
    for (mdl, year_start, year_end), value in table.items():
        if (mdl == model_norm or mdl == "_default_") and year_start <= year <= year_end:
            if field:
                return value.get(field)
            else:
                return value
    
    return None


def parse_packed(packed: str) -> Dict[str, str]:
    """Parse a packed spec string."""
    if packed in ("n/a", "unknown", "") or "|" not in packed:
        return None
    parts = packed.split("|")
    if len(parts) >= 5:
        return {
            "bulb_code": parts[0],
            "base": parts[1],
            "qty": parts[2],
            "tech": parts[3],
            "serviceable": parts[4],
        }
    return None


def spec_priority(packed: str) -> int:
    """Priority for merge decisions."""
    if not packed or packed == "n/a":
        return 0
    if packed == "unknown":
        return 10
    if packed.startswith("LED_MODULE"):
        return 20
    # Real bulb spec
    return 100


def load_wide_csv() -> List[Dict[str, str]]:
    """Load bulbs_wide.csv."""
    rows = []
    with open(BULBS_WIDE_PATH, "r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(row)
    return rows


def save_wide_csv(rows: List[Dict[str, str]], header: List[str]):
    """Save resolved CSV."""
    with open(BULBS_WIDE_OUT, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        writer.writerows(rows)


def main():
    print("[LUMEN DEEP] Unknown Spec Resolver")
    print("=" * 60)
    
    # Load existing wide CSV
    print("\n[1/4] Loading bulbs_wide.csv...")
    rows = load_wide_csv()
    print(f"      Loaded {len(rows)} YMMT rows")
    
    # Get header from first row keys
    header = list(rows[0].keys()) if rows else []
    
    # Define bulb columns to process
    BULB_COLUMNS = [
        "headlight_low", "headlight_high", "parking", "turn_front", "side_marker_front",
        "drl", "fog_front", "cornering", "turn_mirror", "turn_fender",
        "tail", "brake", "turn_rear", "reverse", "license_plate",
        "high_mount_stop", "rear_fog", "side_marker_rear", "turn_bumper", "brake_trunk", "reverse_trunk",
        "dome", "map", "rear_map", "cargo", "trunk", "glovebox", "vanity",
        "door_courtesy", "footwell", "step_courtesy", "ignition_ring", "center_console", "shifter", "ambient",
        "cluster", "hvac", "radio", "switch_bank",
    ]
    
    # Track stats
    stats = {
        "rows_processed": 0,
        "unknowns_resolved": 0,
        "by_function": {col: {"before": 0, "after": 0} for col in BULB_COLUMNS},
        "resolutions": [],
    }
    
    # Process each row
    print("[2/4] Resolving unknown specs...")
    for row in rows:
        year = int(row.get("year", 0))
        model = row.get("model", "")
        trim = row.get("trim", "")
        market = row.get("market", "USDM")
        
        for col in BULB_COLUMNS:
            current = row.get(col, "n/a")
            
            # Track before count
            if current == "unknown":
                stats["by_function"][col]["before"] += 1
            
            # Only resolve unknowns
            if current != "unknown":
                continue
            
            # Try to look up spec
            result = lookup_spec(model, year, col)
            
            if result:
                spec, source = result
                row[col] = spec
                row["source_1"] = source  # Update source
                stats["unknowns_resolved"] += 1
                stats["by_function"][col]["after"] += 1
                
                if len(stats["resolutions"]) < 50:  # Limit report
                    stats["resolutions"].append({
                        "year": year,
                        "model": model,
                        "trim": trim,
                        "function": col,
                        "resolved_to": spec,
                        "source": source,
                    })
        
        stats["rows_processed"] += 1
        
        if stats["rows_processed"] % 500 == 0:
            print(f"      Processed {stats['rows_processed']}/{len(rows)}...")
    
    # Save
    print("[3/4] Saving bulbs_wide_resolved.csv...")
    save_wide_csv(rows, header)
    
    # Write report
    print("[4/4] Writing resolution report...")
    os.makedirs(REPORT_DIR, exist_ok=True)
    
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write("# Lumen Deep Resolution Report\n\n")
        f.write(f"**Generated:** {datetime.now().isoformat()}\n\n")
        f.write("---\n\n")
        
        f.write("## Summary\n\n")
        f.write(f"| Metric | Value |\n")
        f.write(f"|--------|-------|\n")
        f.write(f"| Rows processed | {stats['rows_processed']} |\n")
        f.write(f"| Unknowns resolved | {stats['unknowns_resolved']} |\n")
        f.write("\n")
        
        f.write("## Resolution by Function\n\n")
        f.write("| function | unknowns before | resolved | % resolved |\n")
        f.write("|----------|-----------------|----------|------------|\n")
        for col, counts in sorted(stats["by_function"].items()):
            before = counts["before"]
            resolved = counts["after"]
            pct = (resolved / before * 100) if before > 0 else 0
            if before > 0:
                f.write(f"| {col} | {before} | {resolved} | {pct:.1f}% |\n")
        
        f.write("\n## Sample Resolutions\n\n")
        f.write("| Year | Model | Trim | Function | Resolved To | Source |\n")
        f.write("|------|-------|------|----------|-------------|--------|\n")
        for res in stats["resolutions"][:30]:
            f.write(f"| {res['year']} | {res['model']} | {res['trim']} | {res['function']} | `{res['resolved_to']}` | {res['source']} |\n")
    
    print("\n" + "=" * 60)
    print("[OK] COMPLETE!")
    print("=" * 60)
    print(f"\nResolved {stats['unknowns_resolved']} unknown specs")
    print(f"Output: {BULBS_WIDE_OUT}")
    print(f"Report: {REPORT_PATH}")


if __name__ == "__main__":
    main()
