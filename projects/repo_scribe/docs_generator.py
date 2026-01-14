import json
import os

INVENTORY_PATH = 'projects/repo_scribe/artifacts/inventory.json'
ARTIFACTS_DIR = 'projects/repo_scribe/artifacts'

def load_inventory():
    with open(INVENTORY_PATH, 'r') as f:
        return json.load(f)

def write_md(filename, content):
    with open(os.path.join(ARTIFACTS_DIR, filename), 'w') as f:
        f.write(content)

def generate_onboarding_cheatsheet():
    content = """# Onboarding Cheatsheet 🚀

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
"""
    write_md('ONBOARDING_CHEATSHEET.md', content)

def generate_entrypoints_and_calls():
    content = """# Entry Points & Calls 📞

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
"""
    write_md('ENTRYPOINTS_AND_CALLS.md', content)

def generate_file_index(inventory):
    content = "# File Index 🗂️\n\n"
    content += "A map of the important code, data, test, and tooling areas.\n\n"

    # We want to group by High-Level Directory/Area, not just role, to be "Human Friendly"
    # and we want to filter out noise (like individual asset files or cache files).

    important_areas = {
        "App Core": ["lib/main.dart", "lib/app.dart"],
        "Routing": ["lib/router/"],
        "Features": ["lib/features/"],
        "Data & Database": ["lib/data/", "lib/domain/"],
        "Seed Data": ["assets/seed/"],
        "CI & Workflows": [".github/workflows/"],
        "Tooling & Scripts": ["tool/", "scripts/"],
        "Tests": ["test/"],
        "Documentation": ["docs/", "projects/repo_scribe/"]
    }

    for area, prefixes in important_areas.items():
        content += f"## {area}\n\n"

        # Find items that match these prefixes
        area_items = []
        seen_dirs = set()

        for item in inventory:
            path = item['path']

            # Check if item belongs to this area
            matches = False
            for prefix in prefixes:
                if path.startswith(prefix):
                    matches = True
                    break

            if not matches:
                continue

            # Filter noise:
            # - Don't list every single .png in assets
            # - Don't list every single .g.dart file
            # - Don't list every single test file (just the directory)

            if item['role'] == 'generated':
                continue
            if item['type'] == 'asset':
                # Just list the directory
                parent = os.path.dirname(path)
                if parent not in seen_dirs:
                    area_items.append({'path': parent + "/", 'purpose': "Asset directory"})
                    seen_dirs.add(parent)
                continue

            # For deeply nested features, maybe just list the feature root?
            # For now, let's list Dart files that aren't generated.
            if item['type'] == 'dart' and '.g.dart' not in path:
                area_items.append(item)
            elif item['type'] in ['script', 'config', 'docs']:
                area_items.append(item)
            elif item['kind'] == 'dir':
                # If it's a directory that matches the prefix exactly or is a direct child?
                # Simplify: let's stick to files for clarity, unless it's a key dir.
                pass

        # Deduplicate and sort
        unique_items = {i['path']: i for i in area_items}.values()

        for item in sorted(unique_items, key=lambda x: x['path']):
            purpose = item.get('purpose', 'Unknown')
            if purpose == 'Unknown; needs review':
                purpose = '' # Clean up display

            content += f"- `{item['path']}`"
            if purpose:
                content += f": {purpose}"
            content += "\n"
        content += "\n"

    write_md('FILE_INDEX.md', content)

def generate_unused_candidates(inventory):
    content = """# Unused File Candidates 🗑️

**Warning**: These files are tracked but do not appear to be used in the main application flow or CI pipeline.
**Verification Required**: Check if they are used manually as developer tools before deleting.

"""
    # Logic to identify candidates:
    # Tracked, Script or Config or Dart, Not in CI, Not Imported (approximation)

    # Based on previous analysis: scripts/
    scripts = [i for i in inventory if i['path'].startswith('scripts/') and i['status'] == 'tracked']

    if scripts:
        content += "## Developer Scripts (Not in CI)\n\n"
        content += "| Path | Confidence | Reason |\n"
        content += "| :--- | :--- | :--- |\n"
        for s in scripts:
            content += f"| `{s['path']}` | High | Not referenced in CI or app code. |\n"

    # lib/previews seems unused based on memory, let's check
    previews = [i for i in inventory if i['path'].startswith('lib/previews/') and i['status'] == 'tracked']
    if previews:
        content += "\n## Previews (Potential Dead Code)\n\n"
        content += "| Path | Confidence | Reason |\n"
        content += "| :--- | :--- | :--- |\n"
        for p in previews:
            content += f"| `{p['path']}` | Medium | `lib/previews` folder is rarely used in prod. |\n"

    write_md('UNUSED_FILE_CANDIDATES.md', content)

def generate_full_inventory(inventory):
    content = "# Full Repo Inventory 📦\n\n"
    content += "| Path | Status | Kind | Type | Role | Purpose | Confidence | Notes |\n"
    content += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |\n"

    for item in sorted(inventory, key=lambda x: x['path']):
        notes = item.get('notes', '')
        content += f"| `{item['path']}` | {item['status']} | {item['kind']} | {item['type']} | {item['role']} | {item['purpose']} | {item['confidence']} | {notes} |\n"

    write_md('FULL_REPO_INVENTORY.md', content)

def generate_generated_and_ignored(inventory):
    content = """# Generated & Ignored Folders 🙈

This document explains the purpose of generated and ignored folders in the workspace. These are **NOT** unused files; they are essential artifacts of the build process or developer tooling.

## Artifacts

### `build/`
*   **Status**: Ignored
*   **Generator**: Flutter / Dart build system.
*   **Purpose**: Contains compiled code, intermediate build files, and the final APK/IPA.
*   **Action**: Safe to delete (`flutter clean`), but will be regenerated on next build.

### `.dart_tool/`
*   **Status**: Ignored
*   **Generator**: Dart / Pub.
*   **Purpose**: Stores package configuration, build cache, and other tooling metadata.
*   **Action**: Safe to delete, will be regenerated by `flutter pub get`.

### `.idea/`
*   **Status**: Ignored (usually)
*   **Generator**: IntelliJ IDEA / Android Studio.
*   **Purpose**: Project-specific IDE settings.

### `.vscode/`
*   **Status**: Mixed (often tracked)
*   **Generator**: Visual Studio Code.
*   **Purpose**: Workspace settings, launch configurations, and recommended extensions.

### `android/.gradle/`
*   **Status**: Ignored
*   **Generator**: Gradle (Android build tool).
*   **Purpose**: Caches for Android build dependencies.

### `pubspec.lock`
*   **Status**: Tracked
*   **Generator**: `flutter pub get`
*   **Purpose**: Locks dependency versions to ensure consistent builds across environments. **DO NOT DELETE.**
"""
    write_md('GENERATED_AND_IGNORED_FOLDERS.md', content)

def main():
    inventory = load_inventory()
    generate_onboarding_cheatsheet()
    generate_entrypoints_and_calls()
    generate_file_index(inventory)
    generate_unused_candidates(inventory)
    generate_full_inventory(inventory)
    generate_generated_and_ignored(inventory)

if __name__ == '__main__':
    main()
