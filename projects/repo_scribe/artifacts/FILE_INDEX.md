# File Index 🗂️

## `lib/` (Application Code)

### `lib/` (Root)
*   `main.dart`
    *   **Role:** App Entry Point.
    *   **Purpose:** Bootstraps Flutter, Riverpod, and SharedPreferences.
*   `app.dart`
    *   **Role:** App Widget.
    *   **Purpose:** Handles initialization state (seeding) and sets up `MaterialApp` with `GoRouter`.

### `lib/router/`
*   `app_router.dart`
    *   **Role:** Navigation.
    *   **Purpose:** Defines the `GoRouter` routes (`/`, `/specs`, `/parts`, etc.).

### `lib/data/db/`
*   `app_db.dart`
    *   **Role:** Database.
    *   **Purpose:** Drift database definition and connection setup.

### `lib/data/seed/`
*   `seed_runner.dart`
    *   **Role:** Data Seeding.
    *   **Purpose:** logic to parse `assets/seed/*.json` and populate the DB on startup.

### `lib/features/`
*   `home/`
    *   **Role:** UI Feature.
    *   **Purpose:** Home screen widgets and logic.
*   `browse_ymm/`
    *   **Role:** UI Feature.
    *   **Purpose:** Year/Make/Model selection flow.
*   `specs/`
    *   **Role:** UI Feature.
    *   **Purpose:** Specification list display (`SpecListPage`).
*   `part_lookup/`
    *   **Role:** UI Feature.
    *   **Purpose:** Parts search functionality.
*   `settings/`
    *   **Role:** UI Feature.
    *   **Purpose:** App settings.

### `lib/previews/` (Candidate for Removal)
*   `*.dart` (e.g., `home_previews.dart`, `specs_previews.dart`)
    *   **Role:** UI Previews (Likely Widgetbook or similar).
    *   **Status:** **Appears Unused**. Not imported by `app.dart` or `app_router.dart`.

## `assets/` (Static Data)

### `assets/seed/`
*   `specs/*.json`
    *   **Role:** Data Source.
    *   **Purpose:** JSON files defining vehicle specs (torque, fluids, etc.). Loaded by `SeedRunner`.
*   `vehicles.json` (implied)
    *   **Role:** Data Source.
    *   **Purpose:** Vehicle definitions.

## `tool/` (Dev Tools)

### `tool/seed/`
*   `sync_fitment_csv_to_specs_json.py`
    *   **Role:** Data Validation Script.
    *   **Purpose:** Ensures data consistency. Called by CI.
    *   **Entry:** CI workflow.

## `scripts/` (Legacy/Unused)

### `scripts/`
*   `*.py` (e.g., `generate_engines_csv.py`, `generate_fluids_csv_v2.py`)
    *   **Role:** One-off generation scripts.
    *   **Status:** **Appears Unused**. No references in codebase or CI.

## `.github/workflows/`

### `flutter-android.yml`
*   **Role:** CI Configuration.
*   **Purpose:** Defines the build, test, and analysis pipeline.
