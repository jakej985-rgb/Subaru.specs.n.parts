import json
import sys

def validate_coverage():
    try:
        with open('assets/seed/vehicles.json', 'r') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("Error: assets/seed/vehicles.json not found.")
        sys.exit(1)

    crosstrek_2024 = [v for v in data if v.get('year') == 2024 and v.get('model') == 'Crosstrek']

    expected_trims = {
        'Base': 'FB20',
        'Premium': 'FB20',
        'Sport': 'FB25',
        'Limited': 'FB25',
        'Wilderness': 'FB25'
    }

    found_trims = {v['trim']: v.get('engineCode') for v in crosstrek_2024}

    missing = []
    for trim, engine in expected_trims.items():
        if trim not in found_trims:
            missing.append(trim)
        elif found_trims[trim] != engine:
            print(f"Warning: Trim {trim} has engine {found_trims[trim]}, expected {engine}")

    if missing:
        print(f"FAILED: Missing 2024 Crosstrek trims: {', '.join(missing)}")
        sys.exit(1)

    print("SUCCESS: All 2024 Crosstrek trims found with correct engine codes.")
    sys.exit(0)

if __name__ == "__main__":
    validate_coverage()
