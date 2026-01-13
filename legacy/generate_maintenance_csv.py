#!/usr/bin/env python3
"""
MaintenanceYMMTFitmentWriter
Generates maintenance.csv with YMMT service intervals.
"""

import json
import csv
import math
from pathlib import Path

REPO = Path(__file__).parent.parent
VEHICLES_JSON = REPO / "assets" / "seed" / "vehicles.json"
ENGINES_CSV = REPO / "assets" / "seed" / "specs" / "fitment" / "engines.csv"
MAINTENANCE_CSV = REPO / "assets" / "seed" / "specs" / "fitment" / "maintenance.csv"

HEADER = [
    "year", "make", "model", "trim", "body", "market", "interval_schedule",
    "engine_oil_change", "oil_filter", "air_filter", "cabin_air_filter", "fuel_filter",
    "spark_plugs", "drive_belt_timing", "drive_belt_accessory",
    "coolant", "brake_fluid", "clutch_fluid",
    "manual_trans_fluid", "automatic_trans_fluid", "cvt_fluid",
    "front_diff_fluid", "rear_diff_fluid", "transfer_case_or_center_diff",
    "brake_inspection", "tire_rotation", "wheel_alignment",
    "engine_air_intake_inspection", "battery_service", "pcv_valve",
    "throttle_body_service", "check_engine_cooling_hoses",
    "check_brake_pads_rotors", "check_suspension_steering", "check_exhaust",
    "rotate_inspect_tires", "notes", "source_1", "source_2", "confidence"
]

# Constants
MI_TO_KM = 1.609344

def to_km(mi):
    val = mi * MI_TO_KM
    # Round to nearest 500
    return int(round(val / 500) * 500)

def to_mi(km):
    val = km / MI_TO_KM
    return int(round(val / 500) * 500)

def fmt(miles, months=None, condition="normal"):
    km = to_km(miles)
    time_str = f" / {months} mo" if months else " / n/a"
    return f"{condition}: {miles:,} mi / {km:,} km{time_str}"

def fmt_km(km, months=None, condition="normal"):
    miles = to_mi(km)
    time_str = f" / {months} mo" if months else " / n/a"
    return f"{condition}: {miles:,} mi / {km:,} km{time_str}"

def load_engines():
    eng_map = {}
    if not ENGINES_CSV.exists():
        return {}
    with open(ENGINES_CSV, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # key by YMMT
            key = (row["year"], row["make"], row["model"], row["trim"], row["market"])
            eng_map[key] = row
    return eng_map

def get_schedule(v, engine_row):
    year = int(v.get("year", 0))
    model = v.get("model", "")
    trim = v.get("trim", "")
    market = v.get("market", "") or ("JDM" if "(JDM)" in trim else "USDM")
    
    timing_drive = engine_row.get("timing_drive", "chain") if engine_row else "chain"
    # Fallback if engine row missing
    if "EJ" in v.get("engineCode", ""): timing_drive = "belt"
    if "FA" in v.get("engineCode", ""): timing_drive = "chain"
    if "FB" in v.get("engineCode", ""): timing_drive = "chain"
    if "EZ" in v.get("engineCode", ""): timing_drive = "chain"

    row = {k: "" for k in HEADER}
    row["year"] = str(year)
    row["make"] = v.get("make", "Subaru")
    row["model"] = model
    row["trim"] = trim
    row["body"] = v.get("body", "")
    row["market"] = market
    
    # Defaults
    row["source_1"] = "Subaru Warranty & Maintenance Booklet"
    row["confidence"] = "high"
    
    # ---------------------------------------------------------
    # JDM SCHEDULES
    # ---------------------------------------------------------
    if market == "JDM":
        row["interval_schedule"] = "JDM Maintenance Schedule"
        row["source_1"] = "Subaru Japan Owner's Manual"
        
        # JDM Standard: 10k km oil / 100k km belt
        oil_km = 10000
        oil_mo = 12 # usually 6 or 12 depending on severe. Standard 10k/12mo or 5k/6mo severe.
        
        row["engine_oil_change"] = f"{fmt_km(10000, 12, 'normal')} | {fmt_km(5000, 6, 'severe')}"
        row["oil_filter"] = fmt_km(10000, 12, "replace")
        row["air_filter"] = fmt_km(50000, 24, "replace")
        row["brake_fluid"] = fmt_km(30000, 24, "replace")
        row["spark_plugs"] = fmt_km(100000, None, "replace")
        
        if timing_drive == "belt":
            row["drive_belt_timing"] = fmt_km(100000, None, "replace")
            row["notes"] = "timing belt"
        else:
            row["drive_belt_timing"] = ""
            row["notes"] = "timing chain (no interval)"

        row["coolant"] = fmt_km(150000, 144, "replace") # Super Coolant

        # Diffs/Trans
        row["front_diff_fluid"] = fmt_km(40000, 24, "inspect")
        row["rear_diff_fluid"] = fmt_km(40000, 24, "inspect")
        row["cvt_fluid"] = fmt_km(40000, 24, "inspect")
        
        return row

    # ---------------------------------------------------------
    # USDM SCHEDULES
    # ---------------------------------------------------------
    
    # Pre-2011 (likely mineral oil, 3750/7500)
    if year < 2011:
        row["interval_schedule"] = "OEM Schedule (Pre-2011)"
        row["engine_oil_change"] = f"{fmt(7500, 7, 'normal')} | {fmt(3750, 3, 'severe')}"
        row["oil_filter"] = fmt(7500, 7, "replace")
        row["air_filter"] = fmt(30000, 30, "replace")
        row["cabin_air_filter"] = fmt(15000, 12, "replace")
        row["brake_fluid"] = fmt(30000, 30, "replace")
        
        # Plugs
        if "Turbo" in trim or "XT" in trim or "GT" in trim or "WRX" in trim or "STI" in trim:
            row["spark_plugs"] = fmt(60000, 60, "replace")
        elif "H6" in trim or "3.0" in trim or "3.6" in trim:
            row["spark_plugs"] = fmt(60000, 60, "replace")
        else:
            row["spark_plugs"] = fmt(30000, 30, "replace") # Copper plugs common on older NA EJ25

        # Timing Belt
        if timing_drive == "belt":
             row["drive_belt_timing"] = fmt(105000, 105, "replace")
             row["notes"] = "timing belt"
        else:
             row["drive_belt_timing"] = ""
             row["notes"] = "timing chain (no interval)"
             
        # Coolant (Green vs Blue switchover ~2008/2009)
        if year < 2008:
            row["coolant"] = fmt(30000, 30, "replace")
            row["notes"] += "; Green Coolant"
        else:
            row["coolant"] = f"initial: {fmt(137500, 132, 'replace')} | interval: {fmt(75000, 72, 'replace')}"
            row["notes"] += "; Blue Super Coolant"
            
    # 2011-2014 (Synthetic 7.5k)
    elif 2011 <= year < 2015:
        row["interval_schedule"] = "OEM Schedule (2011-2014)"
        row["engine_oil_change"] = f"{fmt(7500, 7, 'normal')} | {fmt(3750, 3, 'severe')}"
        row["oil_filter"] = fmt(7500, 7, "replace")
        row["air_filter"] = fmt(30000, 30, "replace")
        row["cabin_air_filter"] = fmt(15000, 12, "replace")
        row["brake_fluid"] = fmt(30000, 30, "replace")
        row["spark_plugs"] = fmt(60000, 60, "replace")
        
        if timing_drive == "belt":
             row["drive_belt_timing"] = fmt(105000, 105, "replace")
             row["notes"] = "timing belt"
        else:
             row["drive_belt_timing"] = ""
             row["notes"] = "timing chain (no interval)"

        row["coolant"] = f"initial: {fmt(137500, 132, 'replace')} | interval: {fmt(75000, 72, 'replace')}"

    # 2015+ (Modern 6k)
    else:
        row["interval_schedule"] = "OEM Schedule (2015+)"
        row["engine_oil_change"] = f"{fmt(6000, 6, 'normal')} | {fmt(3000, 3, 'severe')}"
        row["oil_filter"] = fmt(6000, 6, "replace")
        row["air_filter"] = fmt(30000, 30, "replace")
        row["cabin_air_filter"] = fmt(12000, 12, "replace") # often 12k on newer
        row["brake_fluid"] = fmt(30000, 30, "replace")
        row["spark_plugs"] = fmt(60000, 60, "replace")
        
        row["drive_belt_timing"] = ""
        row["notes"] = "timing chain (no interval)"
        if "STI" in trim: # STI kept EJs longer
             row["drive_belt_timing"] = fmt(105000, 105, "replace")
             row["notes"] = "timing belt"

        row["coolant"] = f"initial: {fmt(137500, 132, 'replace')} | interval: {fmt(75000, 72, 'replace')}"
    
    # Common inspections
    row["tire_rotation"] = row["engine_oil_change"].split("|")[0].replace("normal: ", "rotate: ")
    row["brake_inspection"] = row["tire_rotation"].replace("rotate: ", "inspect: ")
    row["front_diff_fluid"] = fmt(30000, 30, "inspect")
    row["rear_diff_fluid"] = fmt(30000, 30, "inspect")
    row["cvt_fluid"] = fmt(30000, 30, "inspect")
    
    return row

def main():
    print("Loading engines.csv...")
    eng_map = load_engines()
    
    print("Loading vehicles.json...")
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    
    # Sort
    vehicles.sort(key=lambda v: (v.get("year", 9999), v.get("make", ""), v.get("model", ""), v.get("trim", "")))
    
    rows = []
    seen = set()
    
    print("Generating maintenance rows...")
    for v in vehicles:
        year = v.get("year", "")
        make = v.get("make", "")
        model = v.get("model", "")
        trim = v.get("trim", "")
        body = v.get("body", "")
        market = "JDM" if "(JDM)" in trim or v.get("market") == "JDM" else "USDM"
        
        # Engine lookup key
        key = (str(year), make, model, trim, market)
        eng_row = eng_map.get(key)
        
        row = get_schedule(v, eng_row)
        
        # Validation checks
        if not row["interval_schedule"]:
             print(f"Warning: No schedule for {year} {model}")
        
        uniq_key = (year, make, model, trim, body, market)
        if uniq_key in seen:
            continue
        seen.add(uniq_key)
        rows.append(row)

    print(f"Writing {len(rows)} rows to maintenance.csv...")
    MAINTENANCE_CSV.parent.mkdir(parents=True, exist_ok=True)
    with open(MAINTENANCE_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=HEADER, quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(rows)
    print("Done!")

if __name__ == "__main__":
    main()
