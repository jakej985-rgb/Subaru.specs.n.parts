# Entry Points & Call Graph 📞

## 📱 Flutter Application

### `lib/main.dart`
*   **Role:** Application Root.
*   **Calls:**
    *   `WidgetsFlutterBinding.ensureInitialized()`
    *   `SharedPreferences.getInstance()`
    *   `runApp(ProviderScope(...))` -> `SubaruSpecsApp` (in `lib/app.dart`)

### `lib/app.dart`
*   **Role:** App Initialization & Material App Setup.
*   **Calls:**
    *   `ref.watch(seedRunnerProvider).runSeedIfNeeded()`: Triggers database seeding.
    *   `ref.watch(goRouterProvider)`: Gets the router configuration.

### `lib/data/seed/seed_runner.dart`
*   **Role:** Database Population.
*   **Calls:**
    *   Reads `assets/seed/*.json`.
    *   Inserts data into `AppDatabase` via DAOs.

## 🤖 Tooling & Scripts

### `tool/seed/sync_fitment_csv_to_specs_json.py`
*   **Role:** Data Integrity / Synchronization.
*   **Entry:** Command line (Python).
*   **Used By:** CI (GitHub Actions) to verify that generated JSON specs match source CSVs (if applicable).

## ⚙️ CI Workflows

### `.github/workflows/flutter-android.yml`
*   **Trigger:** Push/PR to `main` or `master`.
*   **Jobs:**
    1.  **Setup:** Java 17, Flutter Stable.
    2.  **Verify Formatting:** `dart format --output=none --set-exit-if-changed .`
    3.  **Code Gen:** `dart run build_runner build`
    4.  **Analyze:** `flutter analyze`
    5.  **Test:** `flutter test`
    6.  **Build:** `flutter build apk --debug`
    7.  **Seed Check:** `python3 tool/seed/sync_fitment_csv_to_specs_json.py --check`
