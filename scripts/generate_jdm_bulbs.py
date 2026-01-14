#!/usr/bin/env python3
"""
JDM Bulbs Generator
Adds exterior lighting specifications for JDM vehicles to bulbs.csv
"""

import json
import csv
from pathlib import Path

REPO = Path(__file__).parent.parent
VEHICLES_JSON = REPO / "assets" / "seed" / "vehicles.json"
BULBS_CSV = REPO / "assets" / "seed" / "specs" / "fitment" / "bulbs.csv"

# JDM bulb specifications by model/era
# Format: (model_contains, year_start, year_end, body_type) -> bulb_specs
# Each bulb_spec is a list of dicts for each light function

# Standard JDM bulb codes (many share with USDM)
STANDARD_FRONT = [
    {"function_key": "headlight_low", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "H4 (9003)", "base": "P43t", "qty": 2, "serviceable": True, "notes": "Dual filament"},
    {"function_key": "headlight_high", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "H4 (9003)", "base": "P43t", "qty": 2, "serviceable": True, "notes": "Dual filament"},
    {"function_key": "turn_front", "location_hint": "Bumper/Corner", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 2, "serviceable": True, "notes": "Amber"},
    {"function_key": "parking_position_front", "location_hint": "Corner Lamp", "tech": "bulb", "bulb_code": "168", "base": "W2.1x9.5d", "qty": 2, "serviceable": True, "notes": ""},
]

STANDARD_REAR = [
    {"function_key": "tail", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1157", "base": "BAY15d", "qty": 2, "serviceable": True, "notes": "Stop/Tail"},
    {"function_key": "brake", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1157", "base": "BAY15d", "qty": 2, "serviceable": True, "notes": "Stop/Tail"},
    {"function_key": "turn_rear", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 2, "serviceable": True, "notes": "Amber"},
    {"function_key": "reverse", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 2, "serviceable": True, "notes": ""},
    {"function_key": "license_plate", "location_hint": "Trunk/Bumper", "tech": "bulb", "bulb_code": "168", "base": "W2.1x9.5d", "qty": 2, "serviceable": True, "notes": ""},
]

H3_FOG = {"function_key": "fog_front", "location_hint": "Bumper", "tech": "bulb", "bulb_code": "H3", "base": "PK22s", "qty": 2, "serviceable": True, "notes": "Projector Fog"}
H11_FOG = {"function_key": "fog_front", "location_hint": "Bumper", "tech": "bulb", "bulb_code": "H11", "base": "PGJ19-2", "qty": 2, "serviceable": True, "notes": ""}

# Modern Subaru (2008+) - mostly LED DRL, H11 low, 9005 high
MODERN_HALOGEN_FRONT = [
    {"function_key": "headlight_low", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "H11", "base": "PGJ19-2", "qty": 2, "serviceable": True, "notes": "Low beam"},
    {"function_key": "headlight_high", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "9005 (HB3)", "base": "P20d", "qty": 2, "serviceable": True, "notes": "High beam"},
    {"function_key": "drl", "location_hint": "Headlamp Housing", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "Integrated LED DRL"},
    {"function_key": "turn_front", "location_hint": "Bumper/Fender", "tech": "bulb", "bulb_code": "7440", "base": "W21W", "qty": 2, "serviceable": True, "notes": "Amber"},
]

# LED era (2018+)
MODERN_LED_FRONT = [
    {"function_key": "headlight_low", "location_hint": "Headlamp Housing", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "LED assembly"},
    {"function_key": "headlight_high", "location_hint": "Headlamp Housing", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "LED assembly"},
    {"function_key": "drl", "location_hint": "Headlamp Housing", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "Integrated LED C-shape"},
    {"function_key": "turn_front", "location_hint": "Bumper", "tech": "bulb", "bulb_code": "7440", "base": "W21W", "qty": 2, "serviceable": True, "notes": "Amber"},
]

MODERN_LED_REAR = [
    {"function_key": "tail", "location_hint": "Rear Combo Lamp", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "LED tail"},
    {"function_key": "brake", "location_hint": "Rear Combo Lamp", "tech": "led_module", "bulb_code": "LED", "base": "", "qty": 2, "serviceable": False, "notes": "LED brake"},
    {"function_key": "turn_rear", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "7440", "base": "W21W", "qty": 2, "serviceable": True, "notes": "Amber"},
    {"function_key": "reverse", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "7440", "base": "W21W", "qty": 2, "serviceable": True, "notes": ""},
    {"function_key": "license_plate", "location_hint": "Trunk/Bumper", "tech": "bulb", "bulb_code": "168", "base": "W2.1x9.5d", "qty": 2, "serviceable": True, "notes": ""},
]

# Kei car bulbs (smaller)
KEI_FRONT = [
    {"function_key": "headlight_low", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "H4 (9003)", "base": "P43t", "qty": 2, "serviceable": True, "notes": "Dual filament"},
    {"function_key": "headlight_high", "location_hint": "Headlamp Housing", "tech": "bulb", "bulb_code": "H4 (9003)", "base": "P43t", "qty": 2, "serviceable": True, "notes": "Dual filament"},
    {"function_key": "turn_front", "location_hint": "Bumper", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 2, "serviceable": True, "notes": "Amber"},
    {"function_key": "parking_position_front", "location_hint": "Corner Lamp", "tech": "bulb", "bulb_code": "168", "base": "W2.1x9.5d", "qty": 2, "serviceable": True, "notes": ""},
]

KEI_REAR = [
    {"function_key": "tail", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1157", "base": "BAY15d", "qty": 2, "serviceable": True, "notes": "Stop/Tail"},
    {"function_key": "brake", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1157", "base": "BAY15d", "qty": 2, "serviceable": True, "notes": "Stop/Tail"},
    {"function_key": "turn_rear", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 2, "serviceable": True, "notes": "Amber"},
    {"function_key": "reverse", "location_hint": "Rear Combo Lamp", "tech": "bulb", "bulb_code": "1156", "base": "BA15s", "qty": 1, "serviceable": True, "notes": ""},
    {"function_key": "license_plate", "location_hint": "Bumper", "tech": "bulb", "bulb_code": "168", "base": "W2.1x9.5d", "qty": 1, "serviceable": True, "notes": ""},
    {"function_key": "third_brake", "location_hint": "Rear Glass", "tech": "bulb", "bulb_code": "921", "base": "W2.1x9.5d", "qty": 1, "serviceable": True, "notes": ""},
]


def get_bulb_specs(model, year, trim, body):
    """Returns list of bulb specs for a JDM vehicle"""
    specs = []
    y = int(year) if year else 0
    m = model.upper() if model else ""
    t = trim.upper() if trim else ""
    
    # Kei cars
    if m in ["SAMBAR", "VIVIO", "PLEO", "R1", "R2", "STELLA", "LUCRA", "REX", "DIAS WAGON"]:
        specs.extend(KEI_FRONT)
        specs.extend(KEI_REAR)
        return specs
    
    # Modern LED era (2018+)
    if y >= 2018:
        if any(x in m for x in ["LEVORG", "XV", "IMPREZA", "FORESTER", "LEGACY", "OUTBACK", "WRX", "BRZ"]):
            specs.extend(MODERN_LED_FRONT)
            specs.extend(MODERN_LED_REAR)
            specs.append(H11_FOG)
            return specs
    
    # Modern halogen era (2008-2017)
    if y >= 2008:
        specs.extend(MODERN_HALOGEN_FRONT)
        specs.extend(STANDARD_REAR)
        if y >= 2012:
            specs.append(H11_FOG)
        else:
            specs.append(H3_FOG)
        return specs
    
    # Classic era (pre-2008)
    specs.extend(STANDARD_FRONT)
    specs.extend(STANDARD_REAR)
    if "WRX" in t or "STI" in t or "GT" in t or "XT" in t:
        specs.append(H3_FOG)
    
    return specs


def main():
    print("Loading vehicles.json...")
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    
    # Load existing bulbs.csv
    existing_keys = set()
    existing_rows = []
    with open(BULBS_CSV, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            key = (row["year"], row["make"], row["model"], row["trim"], row["function_key"])
            existing_keys.add(key)
            existing_rows.append(row)
    
    print(f"Existing bulbs.csv rows: {len(existing_rows)}")
    
    # Find JDM vehicles that need bulb specs
    jdm_vehicles = [v for v in vehicles if "(JDM)" in v.get("trim", "") or v.get("market", "") == "JDM"]
    print(f"JDM vehicles in vehicles.json: {len(jdm_vehicles)}")
    
    # Generate specs for missing JDM vehicles
    new_rows = []
    for v in jdm_vehicles:
        year = v.get("year", "")
        make = v.get("make", "Subaru")
        model = v.get("model", "")
        trim = v.get("trim", "")
        body = v.get("body", "")
        
        bulb_specs = get_bulb_specs(model, year, trim, body)
        
        for spec in bulb_specs:
            key = (str(year), make, model, trim, spec["function_key"])
            if key not in existing_keys:
                row = {
                    "year": year,
                    "make": make,
                    "model": model,
                    "trim": trim,
                    "body": body,
                    "market": "JDM",
                    "function_key": spec["function_key"],
                    "location_hint": spec["location_hint"],
                    "tech": spec["tech"],
                    "bulb_code": spec["bulb_code"],
                    "base": spec.get("base", ""),
                    "qty": spec["qty"],
                    "serviceable": str(spec["serviceable"]).lower(),
                    "notes": spec.get("notes", ""),
                    "source_1": "JDM FSM",
                    "source_2": "JDM specs",
                    "confidence": "medium"
                }
                new_rows.append(row)
                existing_keys.add(key)
    
    print(f"New JDM bulb rows generated: {len(new_rows)}")
    
    # Combine and sort
    all_rows = existing_rows + new_rows
    all_rows.sort(key=lambda r: (int(r["year"]) if r["year"] else 9999, r["make"], r["model"], r["trim"], r["function_key"]))
    
    # Write back
    with open(BULBS_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(all_rows)
    
    print(f"Total bulbs.csv rows: {len(all_rows)}")
    print(f"Written to {BULBS_CSV}")


if __name__ == "__main__":
    main()
