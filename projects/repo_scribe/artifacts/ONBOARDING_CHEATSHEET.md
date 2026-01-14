# Onboarding Cheatsheet 🚀

## Quick Start

1.  **Dependencies**: `flutter pub get`
2.  **Code Generation**: `dart run build_runner build --delete-conflicting-outputs`
3.  **Run App**: `flutter run`
4.  **Test**: `flutter test`

## Key Entry Points

*   **App Entry**: `lib/main.dart` -> `lib/app.dart`
*   **Routing**: `lib/router/app_router.dart`
*   **Database Config**: `lib/data/database/` (Drift)
*   **Data Seeds**: `assets/seed/specs/` (JSON files)

## Common Tasks

| Task | Where to Edit |
| :--- | :--- |
| **Add a new screen** | `lib/features/<feature_name>/presentation/` |
| **Add new data spec** | `assets/seed/specs/<category>.json` |
| **Modify database schema** | `lib/data/database/tables.dart` (then run codegen) |
| **Update logic** | `lib/features/<feature_name>/application/` |

## Debugging

*   **Logs**: Use `logging` package.
*   **DevTools**: Open via IDE or `flutter run` output URL.
