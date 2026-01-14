# Onboarding Cheat-Sheet 🚀

## 🏃 How to Run the App

1.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

2.  **Run Code Generation (Drift/Riverpod):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Start the App:**
    ```bash
    flutter run
    ```

## 📍 Main Entry Points

*   **Flutter App:** `lib/main.dart`
    *   Initializes `SharedPreferences`.
    *   Sets up the `ProviderScope`.
    *   Calls `SubaruSpecsApp` in `lib/app.dart`.
*   **Database Seeding:** `lib/data/seed/seed_runner.dart`
    *   Runs on app startup (via `appInitializationProvider` in `lib/app.dart`).
    *   Loads JSON data from `assets/seed/` into the SQLite database.
*   **Routing:** `lib/router/app_router.dart`
    *   Defines the `GoRouter` configuration and all app routes.

## 🔄 Key Flows

### 1. Browse by Vehicle
*   **User Action:** Taps "Browse by Year/Make/Model".
*   **Flow:** `HomePage` -> `YmmFlowPage` (`/browse/ymm`) -> `SpecListPage` (`/specs`).
*   **Data:** Users select filters; `SpecListPage` queries `SpecsDao` (`lib/data/db/daos/specs_dao.dart`).

### 2. Part Lookup
*   **User Action:** Taps "Part Lookup".
*   **Flow:** `HomePage` -> `PartLookupPage` (`/parts`).
*   **Data:** Searches parts database via `PartDao`.

### 3. Adding New Specs
*   **Location:** `assets/seed/specs/`
*   **Action:** Create or edit a `.json` file (e.g., `fluids.json`).
*   **Format:** Must strictly follow the existing JSON schema (see `assets/seed/README.md` if available, or mimic existing entries).
*   **Apply:** Restart the app. `SeedRunner` detects changes (via `version` or hash) and updates the DB.

## 🛠️ Common Commands

| Task | Command |
| :--- | :--- |
| **Analyze Code** | `flutter analyze` |
| **Run Tests** | `flutter test` |
| **Format Code** | `dart format .` |
| **Check Seed Sync** | `python3 tool/seed/sync_fitment_csv_to_specs_json.py --check` |
