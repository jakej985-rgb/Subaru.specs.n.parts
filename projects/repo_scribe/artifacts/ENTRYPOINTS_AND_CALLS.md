# Entry Points & Calls 📞

## Application Execution Flow

1.  **`lib/main.dart`**:
    *   Initializes `WidgetsFlutterBinding`.
    *   Sets up `SharedPreferences`.
    *   Runs `SubaruSpecsApp` inside `ProviderScope`.
2.  **`lib/app.dart`**:
    *   Configures `MaterialApp.router`.
    *   Sets up theme and localization.
3.  **`lib/router/app_router.dart`**:
    *   Defines `GoRouter` configuration.
    *   Maps routes (e.g., `/`, `/vehicle/:id`) to Screens.

## CI/CD Workflow (`.github/workflows/flutter-android.yml`)

Triggers on push/PR to `main` or `master`.

1.  **Setup**: Java 17, Flutter Stable.
2.  **Dependencies**: `flutter pub get`.
3.  **Format Check**: `dart format --output=none --set-exit-if-changed .`
4.  **Code Gen**: `dart run build_runner build --delete-conflicting-outputs`
5.  **Analyze**: `flutter analyze`
6.  **Test**: `flutter test -r expanded -v`
7.  **Build**: `flutter build apk --debug`
8.  **Seed Check**: `python3 tool/seed/sync_fitment_csv_to_specs_json.py --check`

## Scripts & Tools

*   **`tool/seed/sync_fitment_csv_to_specs_json.py`**:
    *   **Role**: Critical Data Validation/Sync.
    *   **Called By**: CI Workflow.
    *   **Purpose**: Validates or syncs fitment CSV data to the JSON specs.
