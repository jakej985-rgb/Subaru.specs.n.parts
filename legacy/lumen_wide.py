#!/usr/bin/env python3
"""
Lumen Wide - One Row Per YMMT Bulb Matrix Writer

Outputs: assets/seed/specs/fitment/bulbs_wide.csv
- One row per YMMT (year,make,model,trim,body,market)
- Each bulb function is a column
- Values: n/a | unknown | packed_spec

Packed format: <bulb_code>|<base>|<qty>|<tech>|<serviceable>
"""

import json
import csv
from pathlib import Path
from typing import List, Dict, Any, Tuple, Optional
from datetime import datetime
import os

# Paths
SCRIPT_DIR = Path(__file__).parent
ASSETS_DIR = SCRIPT_DIR.parent / "assets" / "seed"
VEHICLES_PATH = ASSETS_DIR / "vehicles.json"
BULBS_NARROW_PATH = ASSETS_DIR / "specs" / "fitment" / "bulbs.csv"
BULBS_WIDE_PATH = ASSETS_DIR / "specs" / "fitment" / "bulbs_wide.csv"
REPORT_DIR = SCRIPT_DIR.parent / "artifacts"
REPORT_PATH = REPORT_DIR / "lumen_wide_report.md"

# ============================================================================
# WIDE CSV HEADER - exact column order
# ============================================================================

KEY_COLUMNS = ["year", "make", "model", "trim", "body", "market"]

EXTERIOR_FRONT = [
    "headlight_low", "headlight_high", "parking", "turn_front", "side_marker_front",
    "drl", "fog_front", "cornering", "turn_mirror", "turn_fender"
]

EXTERIOR_REAR = [
    "tail", "brake", "turn_rear", "reverse", "license_plate",
    "high_mount_stop", "rear_fog", "side_marker_rear", "turn_bumper", "brake_trunk", "reverse_trunk"
]

INTERIOR = [
    "dome", "map", "rear_map", "cargo", "trunk", "glovebox", "vanity",
    "door_courtesy", "footwell", "step_courtesy", "ignition_ring", "center_console", "shifter", "ambient"
]

CONTROLS = ["cluster", "hvac", "radio", "switch_bank"]

PROVENANCE = ["source_1", "source_2", "confidence"]

ALL_BULB_COLUMNS = EXTERIOR_FRONT + EXTERIOR_REAR + INTERIOR + CONTROLS
WIDE_HEADER = KEY_COLUMNS + ALL_BULB_COLUMNS + PROVENANCE

# Body types
CARGO_BODIES = {"Hatchback", "Wagon", "Crossover", "SUV", "Pickup", "Van", "Kei Van"}
TRUNK_BODIES = {"Sedan", "Coupe"}


def determine_body(vehicle: Dict[str, Any]) -> str:
    """Determines the body type from vehicle data."""
    body = vehicle.get("body", "")
    if body:
        return body
    
    trim = vehicle.get("trim", "").lower()
    model = vehicle.get("model", "").lower()
    
    if any(x in trim for x in ["wagon", "touring wagon"]):
        return "Wagon"
    elif any(x in trim for x in ["sedan", "touring sedan"]):
        return "Sedan"
    elif any(x in model for x in ["outback", "forester", "ascent", "crosstrek", "xv"]):
        return "Crossover"
    elif "brz" in model or "svx" in model or "alcyone" in model or "xt" in model:
        return "Coupe"
    elif "brat" in model:
        return "Pickup"
    elif "impreza" in model or "wrx" in model or "legacy" in model:
        return "Sedan"
    else:
        return "Hatchback"


def get_ymmt_key(vehicle: Dict[str, Any]) -> Tuple:
    """Get the YMMT key for a vehicle."""
    return (
        str(vehicle.get("year", "")),
        vehicle.get("make", "Subaru"),
        vehicle.get("model", ""),
        vehicle.get("trim", ""),
        determine_body(vehicle),
        vehicle.get("market", "USDM"),
    )


def pack_spec(bulb_code: str, base: str, qty: str, tech: str, serviceable: str) -> str:
    """Pack bulb spec into pipe-delimited format."""
    # Normalize values
    bulb_code = bulb_code or ""
    base = base or ""
    qty = qty or "0"
    tech = tech or "bulb"
    serviceable = serviceable if serviceable in ("true", "false") else "true"
    
    if not bulb_code or bulb_code == "n/a":
        return "n/a"
    
    return f"{bulb_code}|{base}|{qty}|{tech}|{serviceable}"


def unpack_spec(packed: str) -> Dict[str, str]:
    """Unpack a packed spec string."""
    if packed == "n/a" or packed == "unknown" or not packed:
        return {"bulb_code": packed, "base": "", "qty": "0", "tech": "", "serviceable": "false"}
    
    parts = packed.split("|")
    if len(parts) >= 5:
        return {
            "bulb_code": parts[0],
            "base": parts[1],
            "qty": parts[2],
            "tech": parts[3],
            "serviceable": parts[4],
        }
    return {"bulb_code": packed, "base": "", "qty": "0", "tech": "bulb", "serviceable": "true"}


def spec_priority(packed: str) -> int:
    """
    Get priority of a packed spec for merge decisions.
    Higher = better data, never downgrade.
    """
    if not packed or packed == "n/a":
        return 0
    if packed == "unknown":
        return 10
    if packed.startswith("LED_MODULE"):
        return 20
    # Real bulb spec
    return 100


def merge_specs(existing: str, new: str) -> str:
    """Merge specs, never downgrading."""
    if spec_priority(existing) >= spec_priority(new):
        return existing
    return new


def load_vehicles() -> List[Dict[str, Any]]:
    """Load vehicles from JSON file."""
    with open(VEHICLES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_narrow_bulbs() -> Dict[Tuple, Dict[str, str]]:
    """
    Load existing narrow-format bulbs.csv and organize by YMMT + function_key.
    Returns: {(ymmt_key, function_key): row_data}
    """
    data = {}
    if not BULBS_NARROW_PATH.exists():
        return data
    
    with open(BULBS_NARROW_PATH, "r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            ymmt_key = (
                row.get("year", ""),
                row.get("make", ""),
                row.get("model", ""),
                row.get("trim", ""),
                row.get("body", ""),
                row.get("market", ""),
            )
            func_key = row.get("function_key", "")
            if func_key:
                key = (ymmt_key, func_key)
                if key not in data:
                    data[key] = row
                else:
                    # Keep best quality data
                    existing = data[key]
                    existing_code = existing.get("bulb_code", "n/a")
                    new_code = row.get("bulb_code", "n/a")
                    if new_code and new_code != "n/a" and (not existing_code or existing_code == "n/a"):
                        data[key] = row
    
    return data


def convert_narrow_to_packed(row: Dict[str, str]) -> str:
    """Convert a narrow-format row to packed wide format."""
    bulb_code = row.get("bulb_code", "")
    base = row.get("base", "")
    qty = row.get("qty", "0")
    tech = row.get("tech", "bulb")
    serviceable = row.get("serviceable", "true")
    
    # Handle n/a and LED modules
    if not bulb_code or bulb_code == "n/a":
        # Check if it's marked as equipped but unknown
        if qty and int(qty) > 0:
            return "unknown"
        return "n/a"
    
    # Check for LED module
    if tech == "led_module" or (tech == "led" and serviceable == "false"):
        return f"LED_MODULE||0|led|false"
    
    return pack_spec(bulb_code, base, qty, tech, serviceable)


def is_function_equipped(
    function_key: str,
    year: int,
    body: str,
    market: str,
    trim: str
) -> Tuple[bool, str]:
    """
    Determine if a function is equipped.
    Returns: (is_unknown, reason)
    - If definitely not equipped: return (False, "")
    - If equipped but unknown spec: return (True, "unknown")
    - Returns False means "n/a" is appropriate
    """
    # Controls are non-serviceable modules by default
    if function_key in CONTROLS:
        return (False, "module")
    
    # Trunk vs Cargo based on body
    if function_key == "trunk":
        if body in CARGO_BODIES:
            return (False, "not_equipped")
        return (True, "unknown")
    
    if function_key == "cargo":
        if body in TRUNK_BODIES:
            return (False, "not_equipped")
        return (True, "unknown")
    
    # Side markers - USDM usually has them
    if function_key in ("side_marker_front", "side_marker_rear"):
        if market == "USDM":
            return (True, "unknown")
        return (False, "not_equipped")
    
    # Rear fog - non-US usually has them
    if function_key == "rear_fog":
        if market == "USDM":
            return (False, "not_equipped")
        return (True, "unknown")
    
    # DRL - became common after ~2012
    if function_key == "drl":
        if year < 2012:
            return (False, "not_equipped")
        return (True, "unknown")
    
    # Mirror turns - became common after ~2008
    if function_key == "turn_mirror":
        if year < 2008:
            return (False, "not_equipped")
        return (True, "unknown")
    
    # Turn fender - rarely equipped except JDM
    if function_key == "turn_fender":
        if market != "JDM":
            return (False, "not_equipped")
        return (True, "unknown")
    
    # Cornering lamps - rare
    if function_key == "cornering":
        return (False, "not_equipped")
    
    # Fog lamps - trim-dependent
    if function_key == "fog_front":
        trim_lower = trim.lower()
        if any(x in trim_lower for x in ["limited", "premium", "touring", "sti", "gt", "spec"]):
            return (True, "unknown")
        return (False, "not_equipped")
    
    # High mount stop - mandated from 1986
    if function_key == "high_mount_stop":
        if year >= 1986:
            return (True, "unknown")
        return (False, "not_equipped")
    
    # Trunk-mounted brake/reverse - rare
    if function_key in ("brake_trunk", "reverse_trunk", "turn_bumper"):
        return (False, "not_equipped")
    
    # Optional interior lights
    if function_key in ("rear_map", "vanity", "door_courtesy", "footwell",
                        "step_courtesy", "ignition_ring", "center_console",
                        "shifter", "ambient"):
        if year >= 2010:
            return (True, "unknown")
        return (False, "not_equipped")
    
    # Core lights - always equipped
    core = {"headlight_low", "headlight_high", "parking", "turn_front",
            "tail", "brake", "turn_rear", "reverse", "license_plate",
            "dome", "map", "glovebox"}
    if function_key in core:
        return (True, "unknown")
    
    # Default: unknown
    return (True, "unknown")


def get_default_interior_spec(function_key: str, year: int) -> str:
    """Get default interior bulb spec based on era."""
    if function_key in ("dome",):
        if year < 2000:
            return "DE3175|31mm Festoon|1|bulb|true"
        return "DE3175|31mm Festoon|1|bulb|true"
    
    if function_key in ("map", "rear_map", "vanity"):
        if year < 1990:
            return "194|W2.1x9.5d|2|bulb|true"
        return "168|W2.1x9.5d|2|bulb|true"
    
    if function_key in ("glovebox", "footwell", "door_courtesy", "step_courtesy",
                        "ignition_ring", "center_console", "shifter"):
        return "74|T5|1|bulb|true"
    
    if function_key in ("cargo", "trunk"):
        if year < 2000:
            return "DE3175|31mm Festoon|1|bulb|true"
        return "168|W2.1x9.5d|1|bulb|true"
    
    return "unknown"


def generate_wide_row(
    vehicle: Dict[str, Any],
    narrow_data: Dict[Tuple, Dict[str, str]]
) -> Dict[str, str]:
    """Generate a wide-format row for a single vehicle."""
    ymmt_key = get_ymmt_key(vehicle)
    year = int(vehicle.get("year", 0))
    body = ymmt_key[4]
    market = ymmt_key[5]
    trim = vehicle.get("trim", "")
    
    row = {
        "year": ymmt_key[0],
        "make": ymmt_key[1],
        "model": ymmt_key[2],
        "trim": ymmt_key[3],
        "body": body,
        "market": market,
    }
    
    best_source = "Lumen inference"
    best_confidence = "medium"
    has_high_confidence = False
    
    for func_key in ALL_BULB_COLUMNS:
        narrow_key = (ymmt_key, func_key)
        
        # Check for existing narrow data
        if narrow_key in narrow_data:
            narrow_row = narrow_data[narrow_key]
            packed = convert_narrow_to_packed(narrow_row)
            
            # Track provenance
            src = narrow_row.get("source_1", "")
            conf = narrow_row.get("confidence", "medium")
            if src and spec_priority(packed) > 10:
                best_source = src
            if conf == "high" and spec_priority(packed) > 10:
                has_high_confidence = True
            
            row[func_key] = packed
        else:
            # Need to determine value based on rules
            is_equipped, reason = is_function_equipped(func_key, year, body, market, trim)
            
            if not is_equipped:
                if reason == "module":
                    row[func_key] = "LED_MODULE||0|led|false"
                else:
                    row[func_key] = "n/a"
            else:
                # Equipped - try to get default spec for interior
                if func_key in INTERIOR:
                    default = get_default_interior_spec(func_key, year)
                    row[func_key] = default
                else:
                    row[func_key] = "unknown"
    
    # Set provenance
    row["source_1"] = best_source
    row["source_2"] = ""
    row["confidence"] = "high" if has_high_confidence else "medium"
    
    return row


def save_wide_csv(rows: List[Dict[str, str]]):
    """Save wide-format CSV, sorted properly."""
    def sort_key(row: Dict[str, str]) -> Tuple:
        try:
            year = int(row.get("year", 0))
        except:
            year = 0
        return (
            year,
            row.get("make", ""),
            row.get("model", ""),
            row.get("trim", ""),
            row.get("body", ""),
            row.get("market", ""),
        )
    
    sorted_rows = sorted(rows, key=sort_key)
    
    with open(BULBS_WIDE_PATH, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=WIDE_HEADER)
        writer.writeheader()
        writer.writerows(sorted_rows)


def write_report(stats: Dict[str, Any]):
    """Write the coverage report."""
    os.makedirs(REPORT_DIR, exist_ok=True)
    
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write("# Lumen Wide Coverage Report\n\n")
        f.write(f"**Generated:** {datetime.now().isoformat()}\n\n")
        f.write("---\n\n")
        
        f.write("## Summary\n\n")
        f.write(f"| Metric | Value |\n")
        f.write(f"|--------|-------|\n")
        f.write(f"| YMMT rows written | {stats['total_rows']} |\n")
        f.write(f"| Columns per row | {len(ALL_BULB_COLUMNS)} bulb columns |\n")
        f.write(f"| Cells with real spec | {stats['cells_with_spec']} |\n")
        f.write(f"| Cells with 'unknown' | {stats['cells_unknown']} |\n")
        f.write(f"| Cells with 'n/a' | {stats['cells_na']} |\n")
        f.write(f"| LED modules | {stats['cells_led_module']} |\n")
        f.write("\n")
        
        f.write("## Per-Function Coverage\n\n")
        f.write("| function | % with spec | % unknown | % n/a |\n")
        f.write("|----------|-------------|-----------|-------|\n")
        for func, counts in sorted(stats['by_function'].items()):
            total = counts['total']
            if total == 0:
                continue
            with_spec_pct = counts['with_spec'] / total * 100
            unknown_pct = counts['unknown'] / total * 100
            na_pct = counts['na'] / total * 100
            f.write(f"| {func} | {with_spec_pct:.1f}% | {unknown_pct:.1f}% | {na_pct:.1f}% |\n")


def main():
    print("[LUMEN WIDE] One Row Per YMMT Bulb Matrix Writer")
    print("=" * 60)
    
    # Load data
    print("\n[1/5] Loading vehicles.json...")
    vehicles = load_vehicles()
    print(f"      Found {len(vehicles)} vehicles")
    
    print("[2/5] Loading existing narrow bulbs.csv for specs...")
    narrow_data = load_narrow_bulbs()
    print(f"      Found {len(narrow_data)} existing spec entries")
    
    # Stats tracking
    stats = {
        "total_rows": 0,
        "cells_with_spec": 0,
        "cells_unknown": 0,
        "cells_na": 0,
        "cells_led_module": 0,
        "by_function": {f: {"total": 0, "with_spec": 0, "unknown": 0, "na": 0} for f in ALL_BULB_COLUMNS},
    }
    
    # Generate wide rows
    print("[3/5] Generating wide-format rows...")
    wide_rows = []
    
    for i, vehicle in enumerate(vehicles):
        row = generate_wide_row(vehicle, narrow_data)
        wide_rows.append(row)
        
        # Track stats
        for func_key in ALL_BULB_COLUMNS:
            val = row.get(func_key, "n/a")
            stats["by_function"][func_key]["total"] += 1
            
            if val == "n/a":
                stats["cells_na"] += 1
                stats["by_function"][func_key]["na"] += 1
            elif val == "unknown":
                stats["cells_unknown"] += 1
                stats["by_function"][func_key]["unknown"] += 1
            elif val.startswith("LED_MODULE"):
                stats["cells_led_module"] += 1
                stats["by_function"][func_key]["with_spec"] += 1
            else:
                stats["cells_with_spec"] += 1
                stats["by_function"][func_key]["with_spec"] += 1
        
        if (i + 1) % 500 == 0:
            print(f"      Processed {i + 1}/{len(vehicles)} vehicles...")
    
    stats["total_rows"] = len(wide_rows)
    
    # Save
    print("[4/5] Saving bulbs_wide.csv...")
    save_wide_csv(wide_rows)
    
    print("[5/5] Writing coverage report...")
    write_report(stats)
    
    print("\n" + "=" * 60)
    print("[OK] COMPLETE!")
    print("=" * 60)
    print(f"\nOutput: {BULBS_WIDE_PATH}")
    print(f"  Rows: {stats['total_rows']} (one per YMMT)")
    print(f"  Columns: {len(WIDE_HEADER)} total ({len(ALL_BULB_COLUMNS)} bulb columns)")
    print(f"\nCell breakdown:")
    print(f"  Real specs: {stats['cells_with_spec']}")
    print(f"  Unknown: {stats['cells_unknown']}")
    print(f"  N/A: {stats['cells_na']}")
    print(f"  LED modules: {stats['cells_led_module']}")
    print(f"\nReport: {REPORT_PATH}")


if __name__ == "__main__":
    main()
