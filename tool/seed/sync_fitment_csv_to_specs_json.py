#!/usr/bin/env python3
"""
Sync Fitment CSV to Specs JSON

Reads: assets/seed/specs/fitment/*.csv
Outputs: assets/seed/specs/<name>.json

Guarantees:
- Stable sorting
- Consistent "n/a" handling
- Strict JSON array format
- Full bulb coverage completion (for bulbs.csv)
"""

import csv
import json
import argparse
import sys
from pathlib import Path
from typing import List, Dict, Set, Any, Optional

# --- Constants ---

REQUIRED_BULBS_EXTERIOR = [
    "headlight_low", "headlight_high", "parking", "turn_front", "turn_rear",
    "side_marker_front", "side_marker_rear", "brake", "tail", "reverse", "license_plate",
    "high_mount_stop", "fog_front", "drl"
]

REQUIRED_BULBS_INTERIOR = [
    "map", "dome", "cargo", "trunk", "glovebox", "vanity",
    "door_courtesy", "footwell"
]

# Map common function keys to location hints for defaults
LOCATION_DEFAULTS = {
    "headlight_low": "Headlamp Housing",
    "headlight_high": "Headlamp Housing",
    "parking": "Front Corner Lamp",
    "turn_front": "Front Bumper",
    "turn_rear": "Rear Combo Lamp",
    "side_marker_front": "Fender Marker",
    "side_marker_rear": "Rear Bumper",
    "brake": "Rear Combo Lamp",
    "tail": "Rear Combo Lamp",
    "reverse": "Rear Combo Lamp",
    "license_plate": "License Plate Lamp",
    "high_mount_stop": "Rear Window",
    "fog_front": "Front Bumper",
    "drl": "Headlamp Housing",
    "map": "Front Overhead Console",
    "dome": "Roof",
    "cargo": "Cargo Area",
    "trunk": "Trunk",
    "glovebox": "Glove Box",
    "vanity": "Sun Visor",
    "door_courtesy": "Door",
    "footwell": "Footwell"
}

# --- Utils ---

def find_repo_root() -> Path:
    current = Path.cwd()
    for _ in range(10):
        if (current / "pubspec.yaml").exists() or (current / ".git").exists():
            return current
        current = current.parent
    print("Error: Could not find repo root (no pubspec.yaml or .git found up tree).")
    sys.exit(1)

def clean_row(row: Dict[str, str]) -> Dict[str, Any]:
    """Normalize CSV string values to JSON-ready types."""
    cleaned = {}
    for k, v in row.items():
        if k is None: continue # Skip trailing commas
        val = v.strip() if v else ""
        
        # Numeric conversions
        if k == "year":
            try:
                cleaned[k] = int(val)
            except ValueError:
                cleaned[k] = 0 # Should probably warn/fail, but 0 is safe for now
        elif k == "qty":
            if val.isdigit():
                cleaned[k] = int(val)
            else:
                cleaned[k] = "n/a"
        
        # Boolean normalization
        elif k == "serviceable":
            lower_val = val.lower()
            if lower_val == "true":
                cleaned[k] = True
            elif lower_val == "false":
                cleaned[k] = False
            else:
                cleaned[k] = "n/a" # Or keep string if preferred, but plan said n/a or false
        
        # String defaults
        else:
            cleaned[k] = val if val else "n/a"
            
    return cleaned

def get_row_identity(row: Dict[str, Any]) -> str:
    """unique key: year|make|model|trim|body|market|secondary"""
    secondary = row.get("function_key") or row.get("spec_key") or "row"
    parts = [
        str(row.get("year", "")),
        str(row.get("make", "")),
        str(row.get("model", "")),
        str(row.get("trim", "")),
        str(row.get("body", "")),
        str(row.get("market", "")),
        str(secondary),
    ]
    
    # Update: To avoid data loss on valid multiple bulbs (e.g. separate high/low if rows split, or multiple dome lights),
    # I will append location_hint to secondary if it exists for bulbs to avoid squashing valid data.
    if "location_hint" in row and row["location_hint"] != "n/a":
        parts.append(str(row["location_hint"]))
        
    return "|".join(parts)

def sort_rows(rows: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    def sort_key(r):
        return (
            r.get("year", 0),
            r.get("make", ""),
            r.get("model", ""),
            r.get("trim", ""),
            r.get("body", ""),
            r.get("market", ""),
            r.get("function_key", ""),
            r.get("location_hint", "")
        )
    return sorted(rows, key=sort_key)

# --- Bulb Completion Logic ---

def load_vehicles(root: Path) -> List[Dict[str, Any]]:
    v_path = root / "assets/seed/vehicles.json"
    if not v_path.exists():
        return []
    
    with open(v_path, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    if isinstance(data, list):
        return data
    elif isinstance(data, dict) and "value" in data:
        return data["value"]
    return []

def complete_bulbs(rows: List[Dict[str, Any]], vehicles: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    # 1. Build set of existing coverages
    existing_coverage = set()
    rows_by_vehicle = {} # Map "y|m|m|t|b|m" -> list of rows
    
    for row in rows:
        v_key = f"{row['year']}|{row['make']}|{row['model']}|{row['trim']}|{row['body']}|{row['market']}"
        f_key = row.get("function_key")
        if f_key:
            existing_coverage.add(f"{v_key}|{f_key}")
            
    # 2. Identify all target vehicles (union of vehicles.json and csv rows)
    # We prefer vehicle objects from vehicles.json for defaults
    target_vehicles = {} # Key -> vehicle dict
    
    for v in vehicles:
        key = f"{v['year']}|{v['make']}|{v['model']}|{v['trim']}|{v.get('body', 'n/a')}|{v.get('market', 'n/a')}"
        target_vehicles[key] = v
        
    for r in rows:
        key = f"{r['year']}|{r['make']}|{r['model']}|{r['trim']}|{r['body']}|{r['market']}"
        if key not in target_vehicles:
            # Reconstruct vehicle from row if missing in vehicles.json
            target_vehicles[key] = {
                "year": r["year"],
                "make": r["make"],
                "model": r["model"],
                "trim": r["trim"],
                "body": r["body"],
                "market": r["market"]
            }

    # 3. Fill gaps
    new_rows = []
    
    # All required functions
    required_funcs = REQUIRED_BULBS_EXTERIOR + REQUIRED_BULBS_INTERIOR
    
    csv_headers = [
        "year","make","model","trim","body","market","function_key","location_hint",
        "tech","bulb_code","base","qty","serviceable","notes","source_1",
        "source_2","confidence"
    ]
    
    for v_key, vehicle in target_vehicles.items():
        for func in required_funcs:
            coverage_key = f"{v_key}|{func}"
            if coverage_key not in existing_coverage:
                # Create placeholder
                placeholder = {
                    "year": int(vehicle["year"]),
                    "make": vehicle["make"],
                    "model": vehicle["model"],
                    "trim": vehicle["trim"],
                    "body": vehicle.get("body", "n/a"),
                    "market": vehicle.get("market", "n/a"),
                    "function_key": func,
                    "location_hint": LOCATION_DEFAULTS.get(func, func.replace("_", " ").title()),
                    "tech": "bulb",
                    "bulb_code": "n/a",
                    "base": "n/a",
                    "qty": "n/a",
                    "serviceable": True, # As per plan
                    "notes": "n/a",
                    "source_1": "n/a",
                    "source_2": "n/a",
                    "confidence": "n/a" 
                }
                new_rows.append(placeholder)
                existing_coverage.add(coverage_key) # Prevent duplicate adds if logic checks again

    print(f"  Added {len(new_rows)} placeholder bulb rows.")
    return rows + new_rows


# --- Main ---

def process_file(csv_path: Path, output_dir: Path, vehicles: List[Dict[str, Any]], args: argparse.Namespace) -> bool:
    print(f"Processing {csv_path.name}...")
    
    with open(csv_path, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        headers = reader.fieldnames
        raw_rows = list(reader)
        
    print(f"  Read {len(raw_rows)} rows.")
    
    # 1. Clean / Normalize
    rows = [clean_row(r) for r in raw_rows]
    
    # 2. Bulb Completion
    if csv_path.name == "bulbs.csv":
        rows = complete_bulbs(rows, vehicles)
        
    # 3. Deduplicate
    unique_rows = {}
    duplicates = 0
    for r in rows:
        ident = get_row_identity(r)
        if ident in unique_rows:
            duplicates += 1
            if args.strict:
                print(f"Error: Strict mode - Duplicate row key found: {ident}")
                sys.exit(1)
        # Last write wins
        unique_rows[ident] = r
        
    final_rows = list(unique_rows.values())
    
    # 4. Sort
    final_rows = sort_rows(final_rows)
    
    # 5. Output
    json_path = output_dir / csv_path.with_suffix(".json").name
    
    output_data = final_rows # Array of objects
    
    json_str = json.dumps(output_data, indent=2, ensure_ascii=False) + "\n"
    
    if args.check:
        if not json_path.exists():
            print(f"Error: --check failed. {json_path.name} does not exist.")
            return False
        
        with open(json_path, "r", encoding="utf-8") as f:
            existing_content = f.read()
            
        # Normalize newlines for comparison
        if existing_content.replace("\r\n", "\n") != json_str.replace("\r\n", "\n"):
            print(f"Error: --check failed. {json_path.name} content differs.")
            return False
        print(f"  {json_path.name} is in sync.")
            
    elif not args.dry_run:
        with open(json_path, "w", encoding="utf-8") as f:
            f.write(json_str)
        print(f"  Written {len(final_rows)} rows to {json_path.name}.")
    else:
        print(f"  [Dry Run] Would write {len(final_rows)} rows to {json_path.name}.")
        
    return True

def main():
    parser = argparse.ArgumentParser(description="Sync Fitment CSV to Specs JSON")
    parser.add_argument("--only", help="Process only specific CSV filename (e.g. bulbs)")
    parser.add_argument("--dry-run", action="store_true", help="Do not write files")
    parser.add_argument("--check", action="store_true", help="Fail if changes needed")
    parser.add_argument("--strict", action="store_true", help="Fail on duplicates")
    
    args = parser.parse_args()
    
    root = find_repo_root()
    input_dir = root / "assets/seed/specs/fitment"
    output_dir = root / "assets/seed/specs"
    
    if not input_dir.exists():
        print(f"Error: Input directory {input_dir} not found.")
        sys.exit(1)
        
    vehicles = load_vehicles(root)
    print(f"Loaded {len(vehicles)} vehicles for completion logic.")
    
    success = True
    
    for csv_file in input_dir.glob("*.csv"):
        if args.only and args.only not in csv_file.name:
            continue
            
        if not process_file(csv_file, output_dir, vehicles, args):
            success = False
            
    if args.check and not success:
        sys.exit(1)

if __name__ == "__main__":
    main()
