import json
import sys

FILEPATH = 'assets/seed/specs/fluids.json'

def fix_file():
    with open(FILEPATH, 'r') as f:
        lines = f.readlines()

    new_lines = []
    in_target_block = False

    # Target Scope
    target_year = 2004
    target_model = "Impreza"
    target_trims = ["WRX STI Sedan (US)", "WRX STI (US)"]

    # Trackers for the current block
    current_year = None
    current_model = None
    current_trim = None

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Check for start of object
        if stripped == '{':
            current_year = None
            current_model = None
            current_trim = None
            in_target_block = False

        # Capture context
        if '"year":' in stripped:
            try:
                current_year = int(stripped.split(':')[1].strip().replace(',', ''))
            except:
                pass

        if '"model":' in stripped:
            current_model = stripped.split(':')[1].strip().replace('"', '').replace(',', '')

        if '"trim":' in stripped:
            current_trim = stripped.split(':')[1].strip().replace('"', '').replace(',', '')

        # Determine if we are in the target block
        if current_year == target_year and current_model == target_model and current_trim in target_trims:
            in_target_block = True

        if in_target_block:
            # Modify Engine Oil
            if '"engine_oil_qty":' in stripped:
                line = '    "engine_oil_qty": "w/ filter: 4.2 qt / 4.0 L | dry fill: 4.8 qt / 4.5 L",\n'

            # Modify Coolant
            if '"engine_coolant_qty":' in stripped:
                line = '    "engine_coolant_qty": "capacity: 8.1 qt / 7.7 L",\n'

            # Skip existing intercooler lines to prevent duplication
            if '"intercooler_spray_fluid' in stripped:
                continue

            # Insert Intercooler Spray before 'source_1'
            if '"source_1":' in stripped:
                 new_lines.append('    "intercooler_spray_fluid_qty": "capacity: 4.0 qt / 3.8 L",\n')
                 new_lines.append('    "intercooler_spray_fluid_unit": "Distilled Water",\n')

        new_lines.append(line)

    with open(FILEPATH, 'w') as f:
        f.writelines(new_lines)

if __name__ == '__main__':
    fix_file()
