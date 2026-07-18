import json
import os
import sys

def verify():
    filepath = 'assets/seed/specs/fluids.json'
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        sys.exit(1)

    with open(filepath, 'r') as f:
        fluids_specs = json.load(f)

    # Find 2004 STI
    spec = next((s for s in fluids_specs if s['year'] == 2004 and s['model'] == 'Impreza' and (s['trim'] == 'WRX STI (US)' or s['trim'] == 'WRX STI Sedan (US)') and s['market'] == 'USDM'), None)

    if not spec:
        print("2004 STI spec not found")
        sys.exit(1)

    print(f"Found Spec for {spec['trim']}")

    # Check Intercooler
    intercooler_qty = spec.get('intercooler_spray_fluid_qty', '')
    notes = spec.get('notes', '').lower()

    if '3.8' in intercooler_qty:
        print("PASS: Intercooler Spray Qty matches 3.8")
    elif '3.8' in notes and ('intercooler' in notes or 'spray' in notes):
        print("PASS: Intercooler Spray found in notes")
    else:
        print(f"FAIL: Intercooler Spray missing. Qty: {intercooler_qty}, Notes: {notes}")
        sys.exit(1)

    # Check Engine Oil
    oil_qty = spec.get('engine_oil_qty', '')
    if '4.2 qt' in oil_qty and '4.0 L' in oil_qty:
        print("PASS: Engine Oil Qty matches 4.2 qt / 4.0 L")
    else:
        print(f"FAIL: Engine Oil Qty mismatch. Found: {oil_qty}")
        sys.exit(1)

    # Check Coolant
    coolant_qty = spec.get('engine_coolant_qty', '')
    if '8.1 qt' in coolant_qty and '7.7 L' in coolant_qty:
        print("PASS: Coolant Qty matches 8.1 qt / 7.7 L")
    else:
        print(f"FAIL: Coolant Qty mismatch. Found: {coolant_qty}")
        sys.exit(1)

if __name__ == '__main__':
    verify()
