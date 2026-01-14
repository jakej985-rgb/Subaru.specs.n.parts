#!/usr/bin/env python3
"""
Lumen Deep Resolver v2 - FSM/Catalog Research + JDM Lighting Specs

Expands the bulb resolution with:
1. Tail/Brake/Turn/Reverse specs from catalog research
2. JDM rear fog light specs
3. License plate bulb specs
4. More comprehensive model coverage
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
BULBS_WIDE_OUT = ASSETS_DIR / "specs" / "fitment" / "bulbs_wide_v2.csv"
REPORT_DIR = SCRIPT_DIR.parent / "artifacts"
REPORT_PATH = REPORT_DIR / "lumen_resolution_v2_report.md"

# ============================================================================
# TAIL/BRAKE LIGHT SPECS (FSM/Catalog Research)
# ============================================================================

TAIL_BRAKE_SPECS = {
    # Legacy Gen 1 (1990-1994)
    ("Legacy", 1990, 1994): {
        "tail": ("1157|BAY15d|2|bulb|true", "Catalog"),
        "brake": ("1157|BAY15d|2|bulb|true", "Catalog"),
    },
    # Legacy Gen 2 (1995-1999)
    ("Legacy", 1995, 1999): {
        "tail": ("1157|BAY15d|2|bulb|true", "Catalog"),
        "brake": ("1157|BAY15d|2|bulb|true", "Catalog"),
    },
    # Legacy/Outback Gen 3 (2000-2004)
    ("Legacy", 2000, 2004): {
        "tail": ("3157|W2.5x16q|2|bulb|true", "Catalog"),
        "brake": ("3157|W2.5x16q|2|bulb|true", "Catalog"),
    },
    ("Outback", 2000, 2004): {
        "tail": ("3157|W2.5x16q|2|bulb|true", "Catalog"),
        "brake": ("3157|W2.5x16q|2|bulb|true", "Catalog"),
    },
    # Legacy/Outback Gen 4 (2005-2009)
    ("Legacy", 2005, 2009): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("Outback", 2005, 2009): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Legacy/Outback Gen 5 (2010-2014)
    ("Legacy", 2010, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("Outback", 2010, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Legacy/Outback (2015-2019)
    ("Legacy", 2015, 2019): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("Outback", 2015, 2019): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Legacy/Outback (2020+) - LED
    ("Legacy", 2020, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    ("Outback", 2020, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Impreza Gen 1 (1993-2001)
    ("Impreza", 1993, 2001): {
        "tail": ("1157|BAY15d|2|bulb|true", "Catalog"),
        "brake": ("1157|BAY15d|2|bulb|true", "Catalog"),
    },
    # Impreza/WRX Gen 2 (2002-2007)
    ("Impreza", 2002, 2007): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("WRX", 2002, 2007): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("STI", 2004, 2007): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Impreza/WRX/STI Gen 3 (2008-2014)
    ("Impreza", 2008, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("WRX", 2008, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("STI", 2008, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # WRX/STI VA (2015-2021)
    ("WRX", 2015, 2021): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("STI", 2015, 2021): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    # Impreza (2017+)
    ("Impreza", 2017, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    # WRX VB (2022+)
    ("WRX", 2022, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Forester SF (1998-2002)
    ("Forester", 1998, 2002): {
        "tail": ("1157|BAY15d|2|bulb|true", "Catalog"),
        "brake": ("1157|BAY15d|2|bulb|true", "Catalog"),
    },
    # Forester SG (2003-2008)
    ("Forester", 2003, 2008): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Forester SH (2009-2013)
    ("Forester", 2009, 2013): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Forester SJ (2014-2018)
    ("Forester", 2014, 2018): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Forester SK (2019+) - LED
    ("Forester", 2019, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Crosstrek (2013-2017)
    ("Crosstrek", 2013, 2017): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("XV", 2012, 2017): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    # Crosstrek (2018+) - LED
    ("Crosstrek", 2018, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    ("XV", 2018, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # BRZ
    ("BRZ", 2013, 2020): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    ("BRZ", 2022, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # SVX
    ("SVX", 1992, 1997): {
        "tail": ("1157|BAY15d|2|bulb|true", "Catalog"),
        "brake": ("1157|BAY15d|2|bulb|true", "Catalog"),
    },
    
    # Tribeca
    ("Tribeca", 2006, 2014): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    
    # Ascent
    ("Ascent", 2019, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Baja
    ("Baja", 2003, 2006): {
        "tail": ("7443|W3x16q|2|bulb|true", "Catalog"),
        "brake": ("7443|W3x16q|2|bulb|true", "Catalog"),
    },
    
    # Solterra - EV
    ("Solterra", 2023, 2025): {
        "tail": ("LED_MODULE||0|led|false", "Factory LED"),
        "brake": ("LED_MODULE||0|led|false", "Factory LED"),
    },
}

# ============================================================================
# TURN SIGNAL SPECS
# ============================================================================

TURN_SPECS = {
    # Legacy/Outback
    ("Legacy", 1990, 1994): {
        "turn_front": ("1157NA|BAY15d|2|bulb|true", "Catalog"),
        "turn_rear": ("1156|BA15s|2|bulb|true", "Catalog"),
    },
    ("Legacy", 1995, 1999): {
        "turn_front": ("1157NA|BAY15d|2|bulb|true", "Catalog"),
        "turn_rear": ("1156|BA15s|2|bulb|true", "Catalog"),
    },
    ("Legacy", 2000, 2004): {
        "turn_front": ("1156NA|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("7440|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Outback", 2000, 2004): {
        "turn_front": ("1156NA|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("7440|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Legacy", 2005, 2009): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Outback", 2005, 2009): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Legacy", 2010, 2019): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Outback", 2010, 2019): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Legacy", 2020, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    ("Outback", 2020, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Impreza/WRX
    ("Impreza", 1993, 2001): {
        "turn_front": ("1156|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("1156|BA15s|2|bulb|true", "Catalog"),
    },
    ("Impreza", 2002, 2007): {
        "turn_front": ("1156NA|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("WRX", 2002, 2007): {
        "turn_front": ("1156NA|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("STI", 2004, 2007): {
        "turn_front": ("1156NA|BA15s|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Impreza", 2008, 2016): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("WRX", 2008, 2021): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("STI", 2008, 2021): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Impreza", 2017, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    ("WRX", 2022, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Forester
    ("Forester", 1998, 2002): {
        "turn_front": ("1157NA|BAY15d|2|bulb|true", "Catalog"),
        "turn_rear": ("1156|BA15s|2|bulb|true", "Catalog"),
    },
    ("Forester", 2003, 2008): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Forester", 2009, 2018): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Forester", 2019, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # Crosstrek
    ("Crosstrek", 2013, 2017): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("XV", 2012, 2017): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("Crosstrek", 2018, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    ("XV", 2018, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # BRZ
    ("BRZ", 2013, 2020): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    ("BRZ", 2022, 2025): {
        "turn_front": ("LED_MODULE||0|led|false", "Factory LED"),
        "turn_rear": ("LED_MODULE||0|led|false", "Factory LED"),
    },
    
    # SVX
    ("SVX", 1992, 1997): {
        "turn_front": ("1157NA|BAY15d|2|bulb|true", "Catalog"),
        "turn_rear": ("1156|BA15s|2|bulb|true", "Catalog"),
    },
    
    # Tribeca
    ("Tribeca", 2006, 2014): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    
    # Ascent
    ("Ascent", 2019, 2025): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
    
    # Baja
    ("Baja", 2003, 2006): {
        "turn_front": ("7440A|W3x16d|2|bulb|true", "Catalog"),
        "turn_rear": ("7440A|W3x16d|2|bulb|true", "Catalog"),
    },
}

# ============================================================================
# REVERSE LIGHT SPECS
# ============================================================================

REVERSE_SPECS = {
    ("Legacy", 1990, 1994): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Legacy", 1995, 1999): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Legacy", 2000, 2009): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Legacy", 2010, 2019): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Legacy", 2020, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Outback", 1995, 1999): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Outback", 2000, 2009): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Outback", 2010, 2019): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Outback", 2020, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("Impreza", 1993, 2001): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Impreza", 2002, 2016): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Impreza", 2017, 2025): ("921|W3x16d|2|bulb|true", "Catalog"),
    
    ("WRX", 2002, 2021): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("WRX", 2022, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    ("STI", 2004, 2021): ("921|W3x16d|2|bulb|true", "Catalog"),
    
    ("Forester", 1998, 2002): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Forester", 2003, 2018): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Forester", 2019, 2025): ("921|W3x16d|2|bulb|true", "Catalog"),
    
    ("Crosstrek", 2013, 2025): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("XV", 2012, 2025): ("921|W3x16d|2|bulb|true", "Catalog"),
    
    ("BRZ", 2013, 2020): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("BRZ", 2022, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
    
    ("SVX", 1992, 1997): ("1156|BA15s|2|bulb|true", "Catalog"),
    ("Tribeca", 2006, 2014): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Ascent", 2019, 2025): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Baja", 2003, 2006): ("921|W3x16d|2|bulb|true", "Catalog"),
    ("Solterra", 2023, 2025): ("LED_MODULE||0|led|false", "Factory LED"),
}

# ============================================================================
# LICENSE PLATE SPECS
# ============================================================================

LICENSE_PLATE_SPECS = {
    ("_default_", 1990, 2015): ("168|W2.1x9.5d|2|bulb|true", "Catalog"),
    ("_default_", 2016, 2025): ("168|W2.1x9.5d|2|bulb|true", "Catalog"),  # Most still use 168
}

# ============================================================================
# JDM REAR FOG SPECS
# ============================================================================

# JDM models have rear fog lights - typically left side only
JDM_REAR_FOG_SPECS = {
    # Standard incandescent rear fog (21W red)
    ("_jdm_default_", 1990, 2010): ("1156|BA15s|1|bulb|true", "JDM Spec"),
    ("_jdm_default_", 2011, 2015): ("7440|W3x16d|1|bulb|true", "JDM Spec"),
    ("_jdm_default_", 2016, 2025): ("LED_MODULE||0|led|false", "JDM LED"),
}


def lookup_spec(model: str, year: int, func_key: str, market: str) -> Optional[Tuple[str, str]]:
    """Look up spec from research tables."""
    model_norm = model.strip()
    
    # Tail/Brake
    if func_key in ("tail", "brake"):
        for (mdl, y1, y2), specs in TAIL_BRAKE_SPECS.items():
            if mdl == model_norm and y1 <= year <= y2:
                if func_key in specs:
                    return specs[func_key]
        return None
    
    # Turn signals
    if func_key in ("turn_front", "turn_rear"):
        for (mdl, y1, y2), specs in TURN_SPECS.items():
            if mdl == model_norm and y1 <= year <= y2:
                if func_key in specs:
                    return specs[func_key]
        return None
    
    # Reverse
    if func_key == "reverse":
        for (mdl, y1, y2), spec in REVERSE_SPECS.items():
            if mdl == model_norm and y1 <= year <= y2:
                return spec
        return None
    
    # License plate
    if func_key == "license_plate":
        for (mdl, y1, y2), spec in LICENSE_PLATE_SPECS.items():
            if (mdl == model_norm or mdl == "_default_") and y1 <= year <= y2:
                return spec
        return None
    
    # JDM rear fog
    if func_key == "rear_fog" and market == "JDM":
        for (mdl, y1, y2), spec in JDM_REAR_FOG_SPECS.items():
            if (mdl == model_norm or mdl.startswith("_jdm_")) and y1 <= year <= y2:
                return spec
        return None
    
    return None


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
    print("[LUMEN DEEP v2] FSM/Catalog + JDM Spec Resolver")
    print("=" * 60)
    
    # Load existing wide CSV
    print("\n[1/4] Loading bulbs_wide.csv...")
    rows = load_wide_csv()
    print(f"      Loaded {len(rows)} YMMT rows")
    
    header = list(rows[0].keys()) if rows else []
    
    # Functions to resolve in this pass
    TARGET_FUNCS = [
        "tail", "brake", "turn_front", "turn_rear", 
        "reverse", "license_plate", "rear_fog"
    ]
    
    stats = {
        "rows_processed": 0,
        "unknowns_resolved": 0,
        "by_function": {col: {"before": 0, "after": 0} for col in TARGET_FUNCS},
        "resolutions": [],
    }
    
    print("[2/4] Resolving FSM/Catalog specs...")
    for row in rows:
        year = int(row.get("year", 0))
        model = row.get("model", "")
        trim = row.get("trim", "")
        market = row.get("market", "USDM")
        
        for col in TARGET_FUNCS:
            current = row.get(col, "n/a")
            
            if current == "unknown":
                stats["by_function"][col]["before"] += 1
            
            if current != "unknown":
                continue
            
            result = lookup_spec(model, year, col, market)
            
            if result:
                spec, source = result
                row[col] = spec
                stats["unknowns_resolved"] += 1
                stats["by_function"][col]["after"] += 1
                
                if len(stats["resolutions"]) < 50:
                    stats["resolutions"].append({
                        "year": year,
                        "model": model,
                        "trim": trim,
                        "market": market,
                        "function": col,
                        "resolved_to": spec,
                        "source": source,
                    })
        
        stats["rows_processed"] += 1
        
        if stats["rows_processed"] % 500 == 0:
            print(f"      Processed {stats['rows_processed']}/{len(rows)}...")
    
    print("[3/4] Saving bulbs_wide_v2.csv...")
    save_wide_csv(rows, header)
    
    print("[4/4] Writing v2 resolution report...")
    os.makedirs(REPORT_DIR, exist_ok=True)
    
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write("# Lumen Deep Resolution v2 Report\n\n")
        f.write(f"**Generated:** {datetime.now().isoformat()}\n\n")
        f.write("## Focus: FSM/Catalog Research + JDM Specs\n\n")
        f.write("---\n\n")
        
        f.write("## Summary\n\n")
        f.write(f"| Metric | Value |\n")
        f.write(f"|--------|-------|\n")
        f.write(f"| Rows processed | {stats['rows_processed']} |\n")
        f.write(f"| Unknowns resolved this pass | {stats['unknowns_resolved']} |\n")
        f.write("\n")
        
        f.write("## Resolution by Function\n\n")
        f.write("| function | unknowns before | resolved | % resolved |\n")
        f.write("|----------|-----------------|----------|------------|\n")
        for col, counts in sorted(stats["by_function"].items()):
            before = counts["before"]
            resolved = counts["after"]
            pct = (resolved / before * 100) if before > 0 else 0
            f.write(f"| {col} | {before} | {resolved} | {pct:.1f}% |\n")
        
        f.write("\n## Sample Resolutions\n\n")
        f.write("| Year | Model | Market | Function | Resolved To | Source |\n")
        f.write("|------|-------|--------|----------|-------------|--------|\n")
        for res in stats["resolutions"][:30]:
            f.write(f"| {res['year']} | {res['model']} | {res['market']} | {res['function']} | `{res['resolved_to']}` | {res['source']} |\n")
    
    print("\n" + "=" * 60)
    print("[OK] COMPLETE!")
    print("=" * 60)
    print(f"\nResolved {stats['unknowns_resolved']} additional specs")
    print(f"Output: {BULBS_WIDE_OUT}")
    print(f"Report: {REPORT_PATH}")


if __name__ == "__main__":
    main()
