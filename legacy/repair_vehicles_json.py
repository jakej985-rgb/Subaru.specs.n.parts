import json
import re
from datetime import datetime

VEHICLES_JSON = 'assets/seed/vehicles.json'

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9]+', '_', text)
    return text.strip('_')

def repair():
    with open(VEHICLES_JSON, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
    
    fixed_count = 0
    for v in data:
        if 'id' not in v or not v['id']:
            # Generate ID
            model = slugify(v.get('model', 'unknown'))
            trim = slugify(v.get('trim', 'base'))
            year = v.get('year', 0)
            v['id'] = f"v_{model}_{year}_{trim}"
            fixed_count += 1
        
        if 'updatedAt' not in v:
            v['updatedAt'] = "2026-01-10T00:00:00Z"
            fixed_count += 1
            
    if fixed_count > 0:
        print(f"Fixed {fixed_count} issues in vehicles.json")
        with open(VEHICLES_JSON, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)
    else:
        print("No issues found in vehicles.json")

if __name__ == '__main__':
    repair()
