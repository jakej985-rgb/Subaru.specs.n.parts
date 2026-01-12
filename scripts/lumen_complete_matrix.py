#!/usr/bin/env python3
"""
Lumen Complete Bulb Matrix Writer

For every vehicle in vehicles.json, ensures bulbs.csv contains a COMPLETE lighting matrix:
- Every YMMT gets a row for EVERY function_key in the master keyset
- If not equipped or not serviceable, mark as n/a (schema-safe)
- Never downgrade existing real bulb data
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
BULBS_PATH = ASSETS_DIR / "specs" / "fitment" / "bulbs.csv"
REPORT_DIR = SCRIPT_DIR.parent / "artifacts"
REPORT_PATH = REPORT_DIR / "lumen_coverage_report.md"

# ============================================================================
# MASTER KEYSET - All function_keys that every YMMT must have
# ============================================================================

MASTER_KEYSET = {
    # Exterior - Front
    "headlight_low": ("Headlamp Housing", "exterior_front"),
    "headlight_high": ("Headlamp Housing", "exterior_front"),
    "parking": ("Front Corner Lamp", "exterior_front"),
    "turn_front": ("Front Corner Lamp", "exterior_front"),
    "side_marker_front": ("Fender Marker", "exterior_front"),
    "drl": ("Headlamp Housing", "exterior_front"),
    "fog_front": ("Front Bumper", "exterior_front"),
    "cornering": ("Front Corner Lamp", "exterior_front"),
    "turn_mirror": ("Mirror", "exterior_front"),
    "turn_fender": ("Fender", "exterior_front"),
    
    # Exterior - Rear
    "tail": ("Rear Combo Lamp", "exterior_rear"),
    "brake": ("Rear Combo Lamp", "exterior_rear"),
    "turn_rear": ("Rear Combo Lamp", "exterior_rear"),
    "reverse": ("Rear Combo Lamp", "exterior_rear"),
    "license_plate": ("License Plate Lamp", "exterior_rear"),
    "high_mount_stop": ("Rear Window", "exterior_rear"),
    "rear_fog": ("Rear Combo Lamp", "exterior_rear"),
    "side_marker_rear": ("Rear Bumper", "exterior_rear"),
    "turn_bumper": ("Rear Bumper", "exterior_rear"),
    "brake_trunk": ("Trunk Lid", "exterior_rear"),
    "reverse_trunk": ("Trunk Lid", "exterior_rear"),
    
    # Interior - Cabin
    "dome": ("Roof", "interior"),
    "map": ("Front Overhead Console", "interior"),
    "rear_map": ("Rear Overhead", "interior"),
    "cargo": ("Cargo Area", "interior"),
    "trunk": ("Trunk", "interior"),
    "glovebox": ("Glove Box", "interior"),
    "vanity": ("Sun Visor", "interior"),
    "door_courtesy": ("Door", "interior"),
    "footwell": ("Footwell", "interior"),
    "step_courtesy": ("Door Sill", "interior"),
    "ignition_ring": ("Steering Column", "interior"),
    "center_console": ("Center Console", "interior"),
    "shifter": ("Center Console", "interior"),
    "ambient": ("Cabin Trim", "interior"),
    
    # Interior - Controls (serviceability-sensitive)
    "cluster": ("Instrument Cluster", "controls"),
    "hvac": ("HVAC Control", "controls"),
    "radio": ("Center Stack", "controls"),
    "switch_bank": ("Dash Switches", "controls"),
}

# Location hint normalization map
LOCATION_HINT_NORMALIZATION = {
    # Exterior front
    "bumper": "Front Bumper",
    "Bumper": "Front Bumper",
    "front bumper": "Front Bumper",
    "Front Turn Signal": "Front Corner Lamp",
    "Corner Lamp": "Front Corner Lamp",
    "Fender": "Fender Marker",
    "Bumper/Corner": "Front Corner Lamp",
    
    # Exterior rear
    "Rear Glass": "Rear Window",
    "Spoiler": "Rear Window",
    "Rear Window / Spoiler": "Rear Window",
    "Trunk/Bumper": "License Plate Lamp",
    "Tailgate Lamp": "Tailgate",
    "Trunk Lid Lamp": "Trunk Lid",
    "Rear Quarter": "Rear Bumper",
    
    # Interior
    "third_brake": "Rear Window",  # Map old key to location
}

# Body types
CARGO_BODIES = {"Hatchback", "Wagon", "Crossover", "SUV", "Pickup", "Van", "Kei Van"}
TRUNK_BODIES = {"Sedan", "Coupe"}

# CSV field names
FIELDNAMES = [
    "year", "make", "model", "trim", "body", "market",
    "function_key", "location_hint", "tech", "bulb_code", "base",
    "qty", "serviceable", "notes", "source_1", "source_2", "confidence"
]


def normalize_location_hint(hint: str, function_key: str) -> str:
    """Normalize location hint to prevent duplicates."""
    if hint in LOCATION_HINT_NORMALIZATION:
        return LOCATION_HINT_NORMALIZATION[hint]
    
    # Use master keyset default if hint is empty
    if not hint and function_key in MASTER_KEYSET:
        return MASTER_KEYSET[function_key][0]
    
    return hint


def get_row_key(row: Dict[str, str]) -> Tuple:
    """Get the unique key for a row."""
    return (
        str(row.get("year", "")),
        row.get("make", ""),
        row.get("model", ""),
        row.get("trim", ""),
        row.get("body", ""),
        row.get("market", ""),
        row.get("function_key", ""),
        row.get("location_hint", ""),
    )


def get_vehicle_key(vehicle: Dict[str, Any]) -> Tuple:
    """Get the YMMT key for a vehicle."""
    return (
        str(vehicle.get("year", "")),
        vehicle.get("make", "Subaru"),
        vehicle.get("model", ""),
        vehicle.get("trim", ""),
        determine_body(vehicle),
        vehicle.get("market", "USDM"),
    )


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


def row_quality_score(row: Dict[str, str]) -> int:
    """
    Score a row for merge priority (higher = better data).
    Based on Lumen merge rules.
    """
    bulb_code = row.get("bulb_code", "n/a")
    confidence = row.get("confidence", "low")
    qty = int(row.get("qty", "0") or "0")
    
    if bulb_code and bulb_code != "n/a":
        if confidence == "high":
            return 100
        elif confidence == "medium":
            return 80
        else:
            return 60
    elif qty > 0:
        return 40  # Equipped unknown
    else:
        return 20  # Not equipped / module


def merge_rows(existing: Dict[str, str], new: Dict[str, str]) -> Dict[str, str]:
    """
    Merge two rows for the same key, keeping the best data.
    Never downgrade real bulb data to n/a.
    """
    existing_score = row_quality_score(existing)
    new_score = row_quality_score(new)
    
    if existing_score >= new_score:
        return existing
    else:
        return new


def is_function_equipped(
    function_key: str,
    year: int,
    body: str,
    market: str,
    existing_data: Dict[str, Dict[str, str]],
    model: str,
    trim: str
) -> Tuple[bool, str, str]:
    """
    Determine if a function is equipped for this vehicle.
    Returns: (is_equipped, notes, confidence)
    """
    category = MASTER_KEYSET.get(function_key, ("", ""))[1]
    
    # Controls are non-serviceable by default
    if category == "controls":
        return (False, "Non-serviceable module / not tracked", "medium")
    
    # Trunk vs Cargo based on body
    if function_key == "trunk":
        if body in CARGO_BODIES:
            return (False, "Not equipped (hatch/wagon/SUV body)", "high")
        else:
            return (True, "", "medium")
    
    if function_key == "cargo":
        if body in TRUNK_BODIES:
            return (False, "Not equipped (sedan/coupe body)", "high")
        else:
            return (True, "", "medium")
    
    # Side markers - USDM usually has them
    if function_key in ("side_marker_front", "side_marker_rear"):
        if market == "USDM":
            return (True, "USDM required", "medium")
        else:
            return (False, "Not equipped (non-USDM)", "medium")
    
    # Rear fog - non-US usually has them
    if function_key == "rear_fog":
        if market == "USDM":
            return (False, "Not equipped (USDM)", "medium")
        else:
            return (True, "Non-USDM market", "medium")
    
    # DRL - became common after ~2012
    if function_key == "drl":
        if year < 2012:
            return (False, "Not equipped (pre-DRL mandate era)", "medium")
        else:
            return (True, "", "medium")
    
    # Mirror turns - became common after ~2008
    if function_key == "turn_mirror":
        if year < 2008:
            return (False, "Not equipped (pre-mirror turn era)", "medium")
        else:
            return (True, "Era-based assumption", "low")
    
    # Turn fender - rarely equipped except JDM
    if function_key == "turn_fender":
        if market != "JDM":
            return (False, "Not equipped (non-JDM)", "medium")
        else:
            return (True, "JDM market", "low")
    
    # Cornering lamps - rare, only on higher trims
    if function_key == "cornering":
        return (False, "Not equipped (rare option)", "medium")
    
    # Fog lamps - trim-dependent, assume not equipped unless base has evidence
    if function_key == "fog_front":
        trim_lower = trim.lower()
        if any(x in trim_lower for x in ["limited", "premium", "touring", "sti", "gt"]):
            return (True, "Higher trim likely equipped", "low")
        else:
            return (False, "Base trim likely not equipped", "low")
    
    # High mount stop - almost all modern cars have it
    if function_key == "high_mount_stop":
        if year >= 1986:  # Mandated in US from 1986
            return (True, "CHMSL mandated", "medium")
        else:
            return (False, "Pre-CHMSL mandate", "medium")
    
    # Trunk-mounted brake/reverse - only some models have split taillights
    if function_key in ("brake_trunk", "reverse_trunk"):
        return (False, "Not equipped (no split taillight)", "low")
    
    # Turn bumper - rare
    if function_key == "turn_bumper":
        return (False, "Not equipped", "low")
    
    # Optional interior lights - default to equipped unknown
    if function_key in ("rear_map", "vanity", "door_courtesy", "footwell", 
                        "step_courtesy", "ignition_ring", "center_console", 
                        "shifter", "ambient"):
        if year >= 2010:
            return (True, "Modern vehicle likely equipped", "low")
        else:
            return (False, "Older vehicle likely not equipped", "low")
    
    # Core exterior and interior lights - always equipped
    core_exterior = {"headlight_low", "headlight_high", "parking", "turn_front", 
                     "tail", "brake", "turn_rear", "reverse", "license_plate"}
    core_interior = {"dome", "map", "glovebox"}
    
    if function_key in core_exterior or function_key in core_interior:
        return (True, "Core lamp", "medium")
    
    # Default: equipped unknown
    return (True, "Assumed equipped", "low")


def get_bulb_spec_for_function(
    function_key: str,
    year: int,
    market: str
) -> Tuple[str, str, str, str]:
    """
    Get default bulb spec for a function based on era.
    Returns: (bulb_code, base, tech, qty)
    """
    # Interior lights
    if function_key in ("dome", "map", "rear_map", "vanity"):
        if year < 1990:
            return ("DE3175", "31mm Festoon", "bulb", "1" if function_key not in ("map",) else "2")
        elif year < 2000:
            return ("168", "W2.1x9.5d", "bulb", "1" if function_key not in ("map",) else "2")
        else:
            return ("168", "W2.1x9.5d", "bulb", "1" if function_key not in ("map",) else "2")
    
    if function_key in ("glovebox", "footwell", "door_courtesy", "step_courtesy", 
                        "ignition_ring", "center_console", "shifter"):
        return ("74", "T5", "bulb", "1")
    
    if function_key in ("cargo", "trunk"):
        if year < 2000:
            return ("DE3175", "31mm Festoon", "bulb", "1")
        else:
            return ("168", "W2.1x9.5d", "bulb", "1")
    
    if function_key == "ambient":
        return ("n/a", "n/a", "led", "0")  # Usually LED module
    
    # Return n/a for equipment check to use existing or derive
    return ("n/a", "n/a", "n/a", "0")


def create_row(
    vehicle_key: Tuple,
    function_key: str,
    is_equipped: bool,
    bulb_code: str = "n/a",
    base: str = "n/a",
    tech: str = "n/a",
    qty: str = "0",
    serviceable: str = "false",
    notes: str = "",
    source_1: str = "Lumen carry-forward",
    source_2: str = "",
    confidence: str = "medium"
) -> Dict[str, str]:
    """Create a new row for the CSV."""
    year, make, model, trim, body, market = vehicle_key
    location_hint = MASTER_KEYSET.get(function_key, ("", ""))[0]
    
    if is_equipped and bulb_code == "n/a":
        # Equipped but unknown
        notes = notes or "Equipped, bulb spec unknown"
        confidence = "low"
        qty = "1"
        serviceable = "true"
        tech = "bulb"
    elif not is_equipped:
        # Not equipped
        bulb_code = "n/a"
        base = "n/a"
        tech = "n/a"
        qty = "0"
        serviceable = "false"
        notes = notes or "Not equipped"
    
    return {
        "year": year,
        "make": make,
        "model": model,
        "trim": trim,
        "body": body,
        "market": market,
        "function_key": function_key,
        "location_hint": location_hint,
        "tech": tech,
        "bulb_code": bulb_code,
        "base": base,
        "qty": qty,
        "serviceable": serviceable,
        "notes": notes,
        "source_1": source_1,
        "source_2": source_2,
        "confidence": confidence,
    }


def load_vehicles() -> List[Dict[str, Any]]:
    """Load vehicles from JSON file."""
    with open(VEHICLES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_existing_bulbs() -> Dict[Tuple, Dict[str, str]]:
    """Load existing bulbs from CSV file into a dict keyed by unique row key."""
    data = {}
    with open(BULBS_PATH, "r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Normalize location hint
            row["location_hint"] = normalize_location_hint(
                row.get("location_hint", ""),
                row.get("function_key", "")
            )
            key = get_row_key(row)
            if key in data:
                # Merge duplicates
                data[key] = merge_rows(data[key], row)
            else:
                data[key] = row
    return data


def save_bulbs(data: Dict[Tuple, Dict[str, str]]):
    """Save bulbs to CSV file, sorted properly."""
    def sort_key(key: Tuple) -> Tuple:
        year_str, make, model, trim, body, market, func_key, loc_hint = key
        try:
            year = int(year_str)
        except:
            year = 0
        return (year, make, model, trim, body, market, func_key, loc_hint)
    
    sorted_keys = sorted(data.keys(), key=sort_key)
    
    with open(BULBS_PATH, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        for key in sorted_keys:
            writer.writerow(data[key])


def write_report(report: Dict[str, Any]):
    """Write the coverage report."""
    os.makedirs(REPORT_DIR, exist_ok=True)
    
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write("# Lumen Coverage Report\n\n")
        f.write(f"**Generated:** {datetime.now().isoformat()}\n\n")
        f.write("---\n\n")
        
        f.write("## Summary\n\n")
        f.write(f"| Metric | Value |\n")
        f.write(f"|--------|-------|\n")
        f.write(f"| Vehicles processed | {report['vehicles_processed']} |\n")
        f.write(f"| Total rows in bulbs.csv | {report['total_rows']} |\n")
        f.write(f"| Rows added | {report['rows_added']} |\n")
        f.write(f"| Rows marked n/a (not equipped) | {report['rows_not_equipped']} |\n")
        f.write(f"| Rows marked equipped unknown | {report['rows_equipped_unknown']} |\n")
        f.write(f"| Duplicates merged | {report['duplicates_merged']} |\n")
        f.write(f"| Existing rows preserved | {report['existing_preserved']} |\n")
        f.write("\n")
        
        f.write("## Function Key Coverage\n\n")
        f.write("| function_key | Count | % with bulb_code |\n")
        f.write("|--------------|-------|------------------|\n")
        for fk, counts in sorted(report['by_function'].items()):
            total = counts['total']
            with_code = counts['with_code']
            pct = (with_code / total * 100) if total > 0 else 0
            f.write(f"| {fk} | {total} | {pct:.1f}% |\n")
        f.write("\n")
        
        if report['low_confidence_items']:
            f.write("## Low Confidence Items (to verify)\n\n")
            f.write("These items have `confidence=low` and should be verified:\n\n")
            for item in report['low_confidence_items'][:50]:  # Limit to 50
                f.write(f"- {item['year']} {item['model']} {item['trim']}: {item['function_key']}\n")
            if len(report['low_confidence_items']) > 50:
                f.write(f"\n... and {len(report['low_confidence_items']) - 50} more\n")


def main():
    print("[LUMEN] Complete Bulb Matrix Writer")
    print("=" * 60)
    
    # Load data
    print("\n[1/6] Loading vehicles.json...")
    vehicles = load_vehicles()
    print(f"      Found {len(vehicles)} vehicles")
    
    print("[2/6] Loading existing bulbs.csv...")
    bulbs_data = load_existing_bulbs()
    print(f"      Found {len(bulbs_data)} existing rows (after dedup)")
    
    # Report tracking
    report = {
        "vehicles_processed": 0,
        "total_rows": 0,
        "rows_added": 0,
        "rows_not_equipped": 0,
        "rows_equipped_unknown": 0,
        "duplicates_merged": 0,
        "existing_preserved": len(bulbs_data),
        "by_function": {fk: {"total": 0, "with_code": 0} for fk in MASTER_KEYSET},
        "low_confidence_items": [],
    }
    
    # Build index of existing data by vehicle key for carry-forward
    print("[3/6] Building carry-forward index...")
    vehicle_existing = {}
    for row_key, row in bulbs_data.items():
        vkey = row_key[:6]  # year, make, model, trim, body, market
        if vkey not in vehicle_existing:
            vehicle_existing[vkey] = {}
        vehicle_existing[vkey][row["function_key"]] = row
    
    # Process each vehicle
    print("[4/6] Processing vehicles and filling matrix...")
    for vehicle in vehicles:
        vkey = get_vehicle_key(vehicle)
        year = int(vehicle.get("year", 0))
        body = vkey[4]
        market = vkey[5]
        model = vehicle.get("model", "")
        trim = vehicle.get("trim", "")
        
        # For each function_key in master keyset
        for function_key, (default_loc, category) in MASTER_KEYSET.items():
            location_hint = default_loc
            row_key = vkey + (function_key, location_hint)
            
            # Check if row already exists
            if row_key in bulbs_data:
                existing = bulbs_data[row_key]
                # Track for report
                report["by_function"][function_key]["total"] += 1
                if existing.get("bulb_code", "n/a") != "n/a":
                    report["by_function"][function_key]["with_code"] += 1
                continue  # Keep existing data, never downgrade
            
            # Check for existing row with different location hint
            found_existing = False
            if vkey in vehicle_existing and function_key in vehicle_existing[vkey]:
                existing = vehicle_existing[vkey][function_key]
                # Copy to new key with normalized location
                bulbs_data[row_key] = existing.copy()
                bulbs_data[row_key]["location_hint"] = location_hint
                found_existing = True
                report["by_function"][function_key]["total"] += 1
                if existing.get("bulb_code", "n/a") != "n/a":
                    report["by_function"][function_key]["with_code"] += 1
            
            if found_existing:
                continue
            
            # Need to create a new row
            is_equipped, notes, confidence = is_function_equipped(
                function_key, year, body, market, bulbs_data, model, trim
            )
            
            # Get default bulb spec for equipped interior lights
            if is_equipped and category == "interior":
                bulb_code, base, tech, qty = get_bulb_spec_for_function(
                    function_key, year, market
                )
                if bulb_code != "n/a":
                    new_row = create_row(
                        vkey, function_key, True,
                        bulb_code=bulb_code, base=base, tech=tech,
                        qty=qty, serviceable="true",
                        notes=notes or "Era-based default",
                        confidence=confidence
                    )
                else:
                    new_row = create_row(
                        vkey, function_key, is_equipped,
                        notes=notes, confidence=confidence
                    )
            else:
                new_row = create_row(
                    vkey, function_key, is_equipped,
                    notes=notes, confidence=confidence
                )
            
            bulbs_data[row_key] = new_row
            report["rows_added"] += 1
            report["by_function"][function_key]["total"] += 1
            
            if new_row.get("bulb_code", "n/a") != "n/a":
                report["by_function"][function_key]["with_code"] += 1
            
            if new_row.get("qty", "0") == "0":
                report["rows_not_equipped"] += 1
            elif new_row.get("bulb_code", "n/a") == "n/a":
                report["rows_equipped_unknown"] += 1
            
            if new_row.get("confidence") == "low":
                report["low_confidence_items"].append({
                    "year": year,
                    "model": model,
                    "trim": trim,
                    "function_key": function_key,
                })
        
        report["vehicles_processed"] += 1
        
        # Progress indicator
        if report["vehicles_processed"] % 200 == 0:
            print(f"      Processed {report['vehicles_processed']}/{len(vehicles)} vehicles...")
    
    # Save results
    print("[5/6] Saving bulbs.csv (sorted and de-duplicated)...")
    save_bulbs(bulbs_data)
    report["total_rows"] = len(bulbs_data)
    
    print("[6/6] Writing coverage report...")
    write_report(report)
    
    print("\n" + "=" * 60)
    print("[OK] COMPLETE!")
    print("=" * 60)
    print(f"\nSummary:")
    print(f"  Vehicles processed: {report['vehicles_processed']}")
    print(f"  Total rows: {report['total_rows']}")
    print(f"  Rows added: {report['rows_added']}")
    print(f"  Not equipped (n/a): {report['rows_not_equipped']}")
    print(f"  Equipped unknown: {report['rows_equipped_unknown']}")
    print(f"\nReport saved to: {REPORT_PATH}")


if __name__ == "__main__":
    main()
