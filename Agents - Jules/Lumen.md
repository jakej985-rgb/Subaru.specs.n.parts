Got it — we’ll **standardize `assets/seed/specs/*.json` to the “row format” you pasted** (the one with `year/make/model/trim/body/market/function_key/...`) **AND** we’ll make the agent **auto-fill missing bulb rows** (per vehicle + per function) with `"n/a"` so the UI never has gaps.

Below is the **reworked agent spec** (SeedBridge v2). You can paste this straight into your agent runner.

---

## Agent: **SeedBridge v2** 🌉

**Fitment CSV ➜ Specs JSON (Row Format + Bulb Completion)**

### Mission

Convert and sync all spec data stored as CSV fitment tables:

* **Source:** `assets/seed/specs/fitment/*.csv`
* **Targets:** `assets/seed/specs/*.json`

**Primary goal:** Every output JSON entry should match this exact **row format**:

```json
{
  "year": 2024,
  "make": "Subaru",
  "model": "Levorg",
  "trim": "STI Sport (JDM)",
  "body": "Wagon",
  "market": "JDM",
  "function_key": "license_plate",
  "location_hint": "License Plate Lamp",
  "tech": "bulb",
  "bulb_code": "168",
  "base": "W2.1x9.5d",
  "qty": 2,
  "serviceable": true,
  "notes": "n/a",
  "source_1": "JDM FSM",
  "source_2": "JDM specs",
  "confidence": "medium"
}
```

---

## Hard Rules (Non-Negotiable)

✅ **Do**

* Keep **CSV as source-of-truth** (do not edit CSV).
* Output JSON must be **an array of row objects** using the same keys as the CSV header.
* Fill missing values with **`"n/a"`** consistently.
* Deterministic output (stable sort, idempotent merge).

🚫 **Do NOT**

* Change CSV headers/structure.
* Add new dependencies unless approved.
* Invent new JSON shapes. **Everything becomes row objects.**

---

## Output Contract

For each CSV:

`assets/seed/specs/fitment/<name>.csv`
➡️ Write/overwrite:
`assets/seed/specs/<name>.json`

Examples:

* `bulbs.csv` ➜ `assets/seed/specs/bulbs.json`
* `fluids.csv` ➜ `assets/seed/specs/fluids.json`
* `torque.csv` ➜ `assets/seed/specs/torque.json`

### Migration rule (existing JSON)

If `<name>.json` exists and is **not** already an array of row objects:

* Create a one-time backup: `<name>.legacy.json`
* Overwrite `<name>.json` with the row-object output generated from CSV

---

## Keying / Merge (No duplicates)

Each JSON row is uniquely identified by:

`year|make|model|trim|body|market|secondary`

**Secondary key selection:**

* If CSV contains `function_key` → secondary = `function_key`
* Else if CSV contains `spec_key` → secondary = `spec_key`
* Else if CSV contains `part_key` → secondary = `part_key`
* Else secondary = `"row"`

**Bulbs example key:**
`2024|Subaru|Levorg|STI Sport (JDM)|Wagon|JDM|license_plate`

Merge rule:

* If the key exists → update row fields from CSV
* If it doesn’t → insert
* Never allow two rows with the same key

---

## Field Mapping Rules

### 1) 1:1 column mapping

Every CSV column becomes a JSON field with the **same name**.

### 2) Type rules (only where safe)

* `year` → integer
* `qty` → integer if numeric, else `"n/a"` (string)
* `serviceable` → boolean if `true/false` present; if missing → default **true** for bulbs (see below)
* everything else → string

### 3) Missing values normalization

If a cell is blank or missing:

* For **strings** → `"n/a"`
* For **qty** → `"n/a"`
* For **serviceable** → default:

  * bulbs: `true` (most bulbs are serviceable; unknown shouldn’t block UI)
  * otherwise: `false` unless CSV says true

---

# Bulbs Special Rule: **Populate Missing Bulb Specs**

This is the new part you asked for.

### Goal

For every vehicle in the repo, ensure `assets/seed/specs/bulbs.json` includes a row for **every required bulb function**, even if the CSV doesn’t have it yet. Missing ones get `"n/a"`.

### Vehicle source

Use the repo’s vehicle list:

* **Primary:** `assets/seed/vehicles.json` (or whatever your canonical vehicle seed file is)

For each vehicle, build:
`year, make, model, trim, body, market`

If `body`/`market` are missing in vehicles seed:

* Attempt to infer from existing bulbs.csv rows for that same `year/make/model/trim`
* If still unknown → `"n/a"`

---

## Bulb Function Catalog (required list)

SeedBridge must maintain a canonical function list **inside the script** (no new files required). Start with:

### Exterior (minimum set)

* `headlight_low`
* `headlight_high`
* `parking_light`
* `turn_signal_front`
* `turn_signal_rear`
* `side_marker_front`
* `side_marker_rear`
* `brake`
* `tail`
* `reverse`
* `license_plate`
* `center_high_mount_stop`
* `fog_light`
* `drl`

### Interior (minimum set)

* `map_light_front`
* `dome_front`
* `dome_rear`
* `cargo`
* `glove_box`
* `vanity_mirror`
* `door_courtesy`
* `footwell`

*(You can expand this list later; the script should be easy to extend.)*

---

## Placeholder row template (when missing)

When a vehicle is missing a function_key, insert a row like:

```json
{
  "year": <year>,
  "make": "<make>",
  "model": "<model>",
  "trim": "<trim>",
  "body": "<body>",
  "market": "<market>",
  "function_key": "<function_key>",
  "location_hint": "<default label>",
  "tech": "bulb",
  "bulb_code": "n/a",
  "base": "n/a",
  "qty": "n/a",
  "serviceable": true,
  "notes": "n/a",
  "source_1": "n/a",
  "source_2": "n/a",
  "confidence": "n/a"
}
```

### Default `location_hint`

The script must provide a mapping `function_key -> label`, e.g.

* `license_plate` → `License Plate Lamp`
* `headlight_low` → `Low Beam Headlight`
* etc…

If no mapping exists: use `function_key` with underscores replaced by spaces (Title Case).

---

## Sorting Rules (Deterministic)

Sort rows by:

1. `year`
2. `make`
3. `model`
4. `trim`
5. `body`
6. `market`
7. `function_key` (if present)
8. fallback secondary key

---

## Implementation Requirements (Dart)

Create:

* `tool/seed/sync_fitment_csv_to_specs_json.dart`

Must support:

* `--only bulbs` (sync one file)
* `--dry-run` (no writes; prints summary)
* `--strict` (fails on duplicate keys or parse errors)

CSV parsing:

* If repo already depends on a CSV parser, use it.
* If not, implement a small quote-aware parser (no new deps).

---

## Tests

Add a test that:

* Uses a tiny fixture `bulbs.csv` with 1 vehicle missing several function keys
* Runs sync
* Asserts `bulbs.json` contains:

  * the original row(s)
  * plus placeholder rows for the missing functions
* Asserts stable order
* Asserts idempotency (run twice → identical output)

---

## Validation Commands

From repo root:

* `dart format --output=none --set-exit-if-changed .`
* `flutter analyze`
* `flutter test -r expanded`

---

## Done When

✅ `assets/seed/specs/*.json` are all in the **row format**, and
✅ `assets/seed/specs/bulbs.json` contains **complete function coverage** per vehicle with `"n/a"` placeholders.

---

If you paste the **actual bulbs.csv header line** (just the header), I’ll lock the “required field set” and the exact placeholder defaults to **match your columns 100%** (so we never accidentally omit/rename a field).
