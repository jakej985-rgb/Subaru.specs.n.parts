#!/usr/bin/env python3
"""Validate fluids.csv coverage against vehicles.json (v2 - checks for fluid specs, NOT combo+condition)."""

import json
import csv
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
VEHICLES_JSON = REPO_ROOT / "assets" / "seed" / "vehicles.json"
FLUIDS_CSV = REPO_ROOT / "assets" / "seed" / "specs" / "fitment" / "fluids.csv"

def extract_market(trim):
    trim_upper = trim.upper()
    if "(US)" in trim_upper or "USDM" in trim_upper: return "USDM"
    if "(JDM)" in trim_upper or "JDM" in trim_upper: return "JDM"
    return ""

def main():
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    with open(FLUIDS_CSV, "r", encoding="utf-8") as f:
        fluids = list(csv.DictReader(f))
    
    vehicle_keys = set((v.get("year"), v.get("make"), v.get("model"), v.get("trim"), "", extract_market(v.get("trim", ""))) for v in vehicles)
    fluid_keys = set((int(f["year"]) if f["year"] else 0, f["make"], f["model"], f["trim"], f["body"], f["market"]) for f in fluids)
    
    print(f"Vehicles in JSON: {len(vehicles)}")
    print(f"Rows in fluids CSV: {len(fluids)}")
    
    missing = vehicle_keys - fluid_keys
    if missing:
        print(f"\nMissing in fluids.csv ({len(missing)}):")
        for m in sorted(missing)[:10]: print(f"  {m}")
    else:
        print("\n[OK] All vehicles covered in fluids.csv!")
    
    # Spec coverage
    with_oil = sum(1 for f in fluids if f["engine_oil_qty"])
    with_oil_spec = sum(1 for f in fluids if f["engine_oil_unit"] and "combo" not in f["engine_oil_unit"].lower())
    with_cool = sum(1 for f in fluids if f["engine_coolant_qty"])
    with_cool_spec = sum(1 for f in fluids if f["engine_coolant_unit"] and "combo" not in f["engine_coolant_unit"].lower())
    with_cvt = sum(1 for f in fluids if f["cvt_fluid_qty"])
    with_cvt_spec = sum(1 for f in fluids if f["cvt_fluid_unit"] and "combo" not in f["cvt_fluid_unit"].lower())
    
    print(f"\nCapacity coverage:")
    print(f"  Engine oil qty: {with_oil}/{len(fluids)} ({100*with_oil/len(fluids):.1f}%)")
    print(f"  Coolant qty: {with_cool}/{len(fluids)} ({100*with_cool/len(fluids):.1f}%)")
    print(f"  CVT fluid qty: {with_cvt}/{len(fluids)} ({100*with_cvt/len(fluids):.1f}%)")
    
    print(f"\nFluid SPEC coverage (not 'combo+condition'):")
    print(f"  Engine oil spec: {with_oil_spec}/{len(fluids)} ({100*with_oil_spec/len(fluids):.1f}%)")
    print(f"  Coolant spec: {with_cool_spec}/{len(fluids)} ({100*with_cool_spec/len(fluids):.1f}%)")
    print(f"  CVT fluid spec: {with_cvt_spec}/{len(fluids)} ({100*with_cvt_spec/len(fluids):.1f}%)")
    
    # Check for 'combo' in any unit column (should be zero)
    combo_errors = 0
    for f in fluids:
        for col in ["engine_oil_unit", "engine_coolant_unit", "manual_trans_fluid_unit", 
                    "automatic_trans_fluid_unit", "cvt_fluid_unit", "rear_diff_fluid_unit",
                    "power_steering_fluid_unit", "clutch_hydraulic_fluid_unit", "brake_fluid_unit"]:
            if "combo" in f.get(col, "").lower():
                combo_errors += 1
    
    print(f"\nValidation:")
    if combo_errors == 0:
        print("  [OK] No 'combo+condition' in any *_unit column!")
    else:
        print(f"  [ERROR] {combo_errors} unit columns still have 'combo'")
    
    # Check qty format (should have : and /)
    format_ok = 0
    for f in fluids:
        for col in ["engine_oil_qty", "engine_coolant_qty"]:
            qty = f.get(col, "")
            if qty and ":" in qty and "/" in qty:
                format_ok += 1
    print(f"  Qty format check (has ':' and '/'): {format_ok} fields OK")
    
    # Show EVs with no specs (expected)
    # Show EVs with no specs (expected)
    evs = [f for f in fluids if not f["engine_oil_qty"]]
    if evs:
        print(f"\nVehicles without engine oil (EVs expected): {len(evs)}")
        
        solterra_ok = 0
        for e in evs:
            is_solterra = "Solterra" in e["model"]
            # Check for coolant and drive unit fluid (in at_fluid)
            has_coolant = bool(e["engine_coolant_qty"])
            has_trans = bool(e["automatic_trans_fluid_qty"])
            
            if is_solterra:
                if has_coolant and has_trans:
                    solterra_ok += 1
                else:
                    print(f"  [WARNING] {e['year']} {e['model']} missing specific EV fluids!")
            else:
                print(f"  {e['year']} {e['model']} {e['trim']}")

        if solterra_ok > 0:
             print(f"  [OK] {solterra_ok} Solterra EVs have correct Coolant & Transaxle/Diff specs.")
    
    print("\n" + "="*50)
    if not missing and combo_errors == 0:
        print("VALIDATION PASSED - fluids.csv is complete with proper fluid specs!")
    else:
        print("VALIDATION FAILED - issues found above")

if __name__ == "__main__":
    main()
