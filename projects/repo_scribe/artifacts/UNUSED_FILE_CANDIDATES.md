# Unused File Candidates 🗑️

This list contains files that appear to be unused based on static analysis (grep, import checks, CI config review).

**Recommended Action:** Move to a `legacy/` folder or delete after final verification.

## 1. Scripts Directory (`scripts/`)
*   **Files:**
    *   `scripts/generate_engines_csv.py`
    *   `scripts/generate_fluids_csv_v2.py`
    *   `scripts/generate_jdm_bulbs.py`
    *   `scripts/generate_jdm_vehicles.py`
    *   `scripts/generate_torque_specs_csv.py`
    *   `scripts/lumen_deep_resolver_v2.py`
    *   `scripts/validate_engines_csv.py`
*   **Confidence:** **10/10**
*   **Evidence:**
    *   Not referenced in `.github/workflows/flutter-android.yml`.
    *   Not called by `tool/seed/sync_fitment_csv_to_specs_json.py`.
    *   `grep` search in `lib/` and `tool/` returns 0 results.
    *   These appear to be one-off data generation scripts used early in development.
*   **Recommendation:** Archive or Delete.

## 2. Preview Files (`lib/previews/`)
*   **Files:**
    *   `lib/previews/browse_previews.dart`
    *   `lib/previews/components_previews.dart`
    *   `lib/previews/fitment_previews.dart`
    *   `lib/previews/home_previews.dart`
    *   `lib/previews/part_lookup_previews.dart`
    *   `lib/previews/preview_wrappers.dart`
    *   `lib/previews/settings_previews.dart`
    *   `lib/previews/specs_by_category_previews.dart`
    *   `lib/previews/specs_previews.dart`
*   **Confidence:** **9/10**
*   **Evidence:**
    *   Not imported in `lib/main.dart` or `lib/app.dart`.
    *   Not registered in `lib/router/app_router.dart`.
    *   `grep` search for `package:specsnparts/previews` returns 0 results in `lib/`.
    *   These likely belonged to a Widgetbook or Storyboard implementation that is no longer active.
*   **Recommendation:** Verify if a "Storyboard" entry point exists (checked: none found). If not, safe to remove.

## 3. Tooling Tests (Partial)
*   **Files:**
    *   `tool/seed/test_sync_fitment.py`
*   **Confidence:** **8/10**
*   **Evidence:**
    *   Not called in `.github/workflows/flutter-android.yml` (only `sync_fitment_csv_to_specs_json.py` is called).
    *   Might be useful for local testing of the python script, but not part of the automated pipeline.
*   **Recommendation:** Keep as a dev utility, but mark as "Manual run only".
