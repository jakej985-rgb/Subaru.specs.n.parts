#!/usr/bin/env python3
"""Validate engines.csv coverage and format."""

import json
import csv
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
VEHICLES_JSON = REPO_ROOT / "assets" / "seed" / "vehicles.json"
ENGINES_CSV = REPO_ROOT / "assets" / "seed" / "specs" / "fitment" / "engines.csv"

def extract_market(trim):
    t = trim.upper()
    if "(US)" in t or "USDM" in t: return "USDM"
    if "(JDM)" in t or "JDM" in t: return "JDM"
    return ""

def main():
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    with open(ENGINES_CSV, "r", encoding="utf-8") as f:
        engines = list(csv.DictReader(f))
    
    vehicle_keys = set((v.get("year"), v.get("make"), v.get("model"), v.get("trim"), "", extract_market(v.get("trim", ""))) for v in vehicles)
    engine_keys = set((int(e["year"]) if e["year"] else 0, e["make"], e["model"], e["trim"], e["body"], e["market"]) for e in engines)
    
    print(f"Vehicles in JSON: {len(vehicles)}")
    print(f"Rows in engines.csv: {len(engines)}")
    
    missing = vehicle_keys - engine_keys
    if missing:
        print(f"\nMissing in engines.csv ({len(missing)}):")
        for m in sorted(missing)[:10]: print(f"  {m}")
    else:
        print("\n[OK] All vehicles covered in engines.csv!")
    
    # Spec coverage
    with_code = sum(1 for e in engines if e["engine_code"])
    with_disp = sum(1 for e in engines if e["displacement"])
    with_power = sum(1 for e in engines if e["power"])
    with_torque = sum(1 for e in engines if e["torque"])
    with_plug = sum(1 for e in engines if e["spark_plug"])
    
    print(f"\nSpec coverage:")
    print(f"  Engine code: {with_code}/{len(engines)} ({100*with_code/len(engines):.1f}%)")
    print(f"  Displacement: {with_disp}/{len(engines)} ({100*with_disp/len(engines):.1f}%)")
    print(f"  Power: {with_power}/{len(engines)} ({100*with_power/len(engines):.1f}%)")
    print(f"  Torque: {with_torque}/{len(engines)} ({100*with_torque/len(engines):.1f}%)")
    print(f"  Spark plug: {with_plug}/{len(engines)} ({100*with_plug/len(engines):.1f}%)")
    
    # Check US/Metric format in key columns
    format_errors = 0
    for e in engines:
        for col in ["displacement", "power", "torque"]:
            val = e.get(col, "")
            if val and "/" not in val:
                format_errors += 1
    
    print(f"\nFormat validation:")
    if format_errors == 0:
        print("  [OK] All key specs have US/Metric format (contains '/')")
    else:
        print(f"  [WARNING] {format_errors} specs missing dual units")
    
    # Show EVs (expected blank)
    evs = [e for e in engines if e["engine_code"] == "Electric"]
    if evs:
        print(f"\nElectric vehicles (no ICE specs): {len(evs)}")
        for ev in evs[:3]:
            print(f"  {ev['year']} {ev['model']} {ev['trim']}")
    
    print("\n" + "="*50)
    if not missing:
        print("VALIDATION PASSED - engines.csv is complete!")
    else:
        print("VALIDATION FAILED - missing vehicles")

if __name__ == "__main__":
    main()
