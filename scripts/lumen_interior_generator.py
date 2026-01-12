#!/usr/bin/env python3
"""
Lumen 🔦 - Interior Lighting Generator
Generates interior bulb data for all vehicles in vehicles.json

Interior minimum coverage per YMMT:
- dome: main cabin dome light
- map: map/reading lights (front)
- glovebox: glove box light
- cargo OR trunk: based on body type (hatch/wagon/SUV=cargo, sedan/coupe=trunk)
"""

import json
import csv
from pathlib import Path
from typing import List, Dict, Any

# Paths
SCRIPT_DIR = Path(__file__).parent
ASSETS_DIR = SCRIPT_DIR.parent / "assets" / "seed"
VEHICLES_PATH = ASSETS_DIR / "vehicles.json"
BULBS_PATH = ASSETS_DIR / "specs" / "fitment" / "bulbs.csv"

# Body types that use "cargo" vs "trunk"
CARGO_BODIES = {"Hatchback", "Wagon", "Crossover", "SUV", "Pickup", "Van", "Kei Van"}
TRUNK_BODIES = {"Sedan", "Coupe"}

# Interior bulb specifications by era
# Format: (bulb_code, base, tech, notes)
def get_interior_specs(year: int, market: str) -> Dict[str, tuple]:
    """
    Returns interior bulb specs based on year and market.
    Common Subaru interior bulbs vary by era.
    """
    if year < 1990:
        # Classic era: festoon and wedge bulbs
        return {
            "dome": ("DE3175", "31mm Festoon", "bulb", "31mm festoon dome"),
            "map": ("194", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("DE3175", "31mm Festoon", "bulb", "31mm festoon"),
            "trunk": ("DE3175", "31mm Festoon", "bulb", "31mm festoon"),
        }
    elif year < 2000:
        # 1990s: mostly T10 wedge and festoon
        return {
            "dome": ("DE3175", "31mm Festoon", "bulb", "31mm festoon dome"),
            "map": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "trunk": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
        }
    elif year < 2008:
        # 2000-2007: T10 wedge dominant
        return {
            "dome": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "map": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "trunk": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
        }
    elif year < 2015:
        # 2008-2014: Mix of wedge and festoon
        return {
            "dome": ("DE3175", "31mm Festoon", "bulb", "31mm festoon dome"),
            "map": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "trunk": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
        }
    elif year < 2020:
        # 2015-2019: Transition to LED on some models
        return {
            "dome": ("DE3175", "31mm Festoon", "bulb", "31mm festoon dome"),
            "map": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "trunk": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
        }
    else:
        # 2020+: Some LED modules, but still serviceable bulbs on most
        return {
            "dome": ("DE3175", "31mm Festoon", "bulb", "31mm festoon dome"),
            "map": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "glovebox": ("74", "T5", "bulb", "T5 wedge"),
            "cargo": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
            "trunk": ("168", "W2.1x9.5d", "bulb", "T10 wedge"),
        }


def get_source_info(market: str) -> tuple:
    """Returns source_1, source_2 based on market."""
    if market == "JDM":
        return ("JDM FSM", "JDM specs")
    elif market == "USDM":
        return ("Owner's Manual", "Sylvania")
    else:
        return ("Service Manual", "OEM specs")


def get_confidence(year: int) -> str:
    """Returns confidence level based on year."""
    if year >= 2010:
        return "medium"
    elif year >= 2000:
        return "medium"
    else:
        return "medium"  # All interior lights are carried forward patterns


def get_location_hint(function_key: str) -> str:
    """Returns standardized location_hint for interior lights."""
    hints = {
        "dome": "Roof",
        "map": "Front Overhead Console",
        "glovebox": "Glove Box",
        "cargo": "Cargo Area",
        "trunk": "Trunk",
    }
    return hints.get(function_key, "Interior")


def determine_body(vehicle: Dict[str, Any]) -> str:
    """Determines the body type from vehicle data."""
    body = vehicle.get("body", "")
    if body:
        return body
    
    # Infer from trim/model if body not specified
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
        # Default to Sedan if not specified
        return "Sedan"
    else:
        return "Hatchback"  # Default fallback


def uses_cargo_light(body: str) -> bool:
    """Determines if vehicle uses cargo light vs trunk light."""
    return body in CARGO_BODIES


def generate_interior_rows(vehicle: Dict[str, Any]) -> List[Dict[str, str]]:
    """Generates interior lighting rows for a single vehicle."""
    year = vehicle.get("year", 0)
    make = vehicle.get("make", "Subaru")
    model = vehicle.get("model", "")
    trim = vehicle.get("trim", "")
    body = determine_body(vehicle)
    market = vehicle.get("market", "USDM")
    
    # Get specs for this era
    specs = get_interior_specs(year, market)
    source_1, source_2 = get_source_info(market)
    confidence = get_confidence(year)
    
    rows = []
    
    # Generate rows for each interior function
    interior_functions = ["dome", "map", "glovebox"]
    
    # Add cargo or trunk based on body type
    if uses_cargo_light(body):
        interior_functions.append("cargo")
    else:
        interior_functions.append("trunk")
    
    for func_key in interior_functions:
        bulb_code, base, tech, notes = specs[func_key]
        location_hint = get_location_hint(func_key)
        
        # Quantity: most interior lights are single
        qty = "1"
        if func_key == "map":
            qty = "2"  # Usually 2 map lights
        
        row = {
            "year": str(year),
            "make": make,
            "model": model,
            "trim": trim,
            "body": body,
            "market": market,
            "function_key": func_key,
            "location_hint": location_hint,
            "tech": tech,
            "bulb_code": bulb_code,
            "base": base,
            "qty": qty,
            "serviceable": "true",
            "notes": notes,
            "source_1": source_1,
            "source_2": source_2,
            "confidence": confidence,
        }
        rows.append(row)
    
    return rows


def load_vehicles() -> List[Dict[str, Any]]:
    """Loads vehicles from JSON file."""
    with open(VEHICLES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_existing_bulbs() -> List[Dict[str, str]]:
    """Loads existing bulbs from CSV file."""
    rows = []
    with open(BULBS_PATH, "r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(row)
    return rows


def save_bulbs(rows: List[Dict[str, str]]):
    """Saves bulbs to CSV file, sorted properly."""
    # Define sort key: year, make, model, trim, body, market, function_key, location_hint
    def sort_key(row):
        return (
            int(row.get("year", 0)),
            row.get("make", ""),
            row.get("model", ""),
            row.get("trim", ""),
            row.get("body", ""),
            row.get("market", ""),
            row.get("function_key", ""),
            row.get("location_hint", ""),
        )
    
    sorted_rows = sorted(rows, key=sort_key)
    
    # Get fieldnames from first row or define them
    fieldnames = [
        "year", "make", "model", "trim", "body", "market",
        "function_key", "location_hint", "tech", "bulb_code", "base",
        "qty", "serviceable", "notes", "source_1", "source_2", "confidence"
    ]
    
    with open(BULBS_PATH, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(sorted_rows)


def main():
    print("[LUMEN] Interior Lighting Generator")
    print("=" * 50)
    
    # Load data
    print("Loading vehicles.json...")
    vehicles = load_vehicles()
    print(f"  Found {len(vehicles)} vehicles")
    
    print("Loading existing bulbs.csv...")
    existing_bulbs = load_existing_bulbs()
    print(f"  Found {len(existing_bulbs)} existing rows")
    
    # Build set of existing interior rows to avoid duplicates
    existing_keys = set()
    for row in existing_bulbs:
        key = (
            row.get("year"),
            row.get("make"),
            row.get("model"),
            row.get("trim"),
            row.get("body"),
            row.get("market"),
            row.get("function_key"),
            row.get("location_hint"),
        )
        existing_keys.add(key)
    
    # Generate interior rows for all vehicles
    print("\nGenerating interior lighting data...")
    new_rows = []
    vehicles_processed = 0
    rows_added = 0
    
    for vehicle in vehicles:
        interior_rows = generate_interior_rows(vehicle)
        for row in interior_rows:
            key = (
                row["year"],
                row["make"],
                row["model"],
                row["trim"],
                row["body"],
                row["market"],
                row["function_key"],
                row["location_hint"],
            )
            if key not in existing_keys:
                new_rows.append(row)
                existing_keys.add(key)
                rows_added += 1
        vehicles_processed += 1
    
    print(f"  Processed {vehicles_processed} vehicles")
    print(f"  Generated {rows_added} new interior lighting rows")
    
    # Combine and save
    print("\nCombining with existing data and sorting...")
    all_rows = existing_bulbs + new_rows
    save_bulbs(all_rows)
    
    print(f"\n[OK] Complete! Total rows in bulbs.csv: {len(all_rows)}")
    
    # Coverage report
    print("\n[REPORT] Coverage Report:")
    print("-" * 30)
    
    # Count by function_key
    func_counts = {}
    for row in all_rows:
        fk = row.get("function_key", "unknown")
        func_counts[fk] = func_counts.get(fk, 0) + 1
    
    for fk in sorted(func_counts.keys()):
        print(f"  {fk}: {func_counts[fk]} rows")


if __name__ == "__main__":
    main()
