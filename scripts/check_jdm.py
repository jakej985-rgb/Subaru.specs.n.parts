#!/usr/bin/env python3
"""Check current JDM coverage in vehicles.json"""
import json
from pathlib import Path

REPO = Path(__file__).parent.parent
VEHICLES = REPO / "assets" / "seed" / "vehicles.json"

with open(VEHICLES, "r", encoding="utf-8-sig") as f:
    vehicles = json.load(f)

# Check for JDM markers
jdm = [v for v in vehicles if "JDM" in v.get("trim", "").upper() or "JDM" in v.get("market", "").upper()]
print(f"Vehicles with JDM marker: {len(jdm)}")
for v in jdm[:10]:
    print(f"  {v['year']} {v['model']} {v.get('trim', '')}")

# Check unique markets
markets = set()
for v in vehicles:
    t = v.get("trim", "").upper()
    if "(US)" in t or "USDM" in t:
        markets.add("USDM")
    elif "(JDM)" in t or "JDM" in t:
        markets.add("JDM")
    else:
        markets.add("unspecified")

print(f"\nMarkets found: {markets}")

# Check engine codes that are typically JDM
jdm_engines = ["EJ20G", "EJ20K", "EJ207", "EJ20X", "EJ20Y"]
for eng in jdm_engines:
    matches = [v for v in vehicles if eng in v.get("engineCode", "")]
    if matches:
        print(f"\n{eng} found in {len(matches)} vehicles:")
        for m in matches[:3]:
            print(f"  {m['year']} {m['model']} {m.get('trim', '')} [{m.get('engineCode', '')}]")
