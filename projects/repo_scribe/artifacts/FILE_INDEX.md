# File Index 🗂️

## `lib/` (Application Code)

### `lib/` (Root)
*   `main.dart`: App Entry Point. Bootstraps Flutter, Riverpod, and SharedPreferences.
*   `app.dart`: App Widget. Handles initialization state and `GoRouter`.

### `lib/router/`
*   `app_router.dart`: Defines the app routes (`/`, `/specs`, etc.).

### `lib/data/db/`
*   `app_db.dart`: Drift database definition.
*   `dao/*.dart`: Data Access Objects (SpecsDao, PartsDao, VehiclesDao).

### `lib/data/seed/`
*   `seed_runner.dart`: Logic to parse `assets/seed/*.json` and populate the DB.

### `lib/features/`
*   `home/`: Home screen logic.
*   `browse_ymm/`: Year/Make/Model selection flow.
*   `specs/`: Specification list display.
*   `part_lookup/`: Parts search functionality.
*   `settings/`: App settings.

### `lib/previews/` (Unused)
*   `*.dart`: Legacy UI previews (likely Widgetbook). **Candidate for removal.**

## `assets/` (Static Data)

### `assets/seed/`
*   `specs/*.json`: Vehicle specs (torque, fluids, etc.).
*   `vehicles.json`: Vehicle definitions.
*   `parts.json`: Parts catalog.
*   `specs/fitment/*.csv`: Raw CSV data sources for specific spec categories.

## `tool/` (Dev Tools)

### `tool/seed/`
*   `sync_fitment_csv_to_specs_json.py`: Data validation/sync script used by CI.

## `scripts/` (Legacy)
*   `*.py` (e.g., `generate_engines_csv.py`): One-off generation scripts. **Candidate for removal.**

## `.github/workflows/`
*   `flutter-android.yml`: CI Configuration (Build, Test, Analyze).
