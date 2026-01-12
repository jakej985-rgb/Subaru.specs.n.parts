## IdeaSmith Scope Snapshot
- Date: 2026-01-12
- Project: specsnparts
- Improvement: Implement "Recent Searches", Fix "View Parts", and Add "Settings Tools"

## User Pain Point
- **Part Lookup:** Users needlessly re-type common searches on mobile.
- **Browse Flow:** "View Parts" is a dead-end ("Coming Soon") after selecting a vehicle.
- **Settings:** Users cannot clear their history or see app version info.

## Three Shippable Improvements (Sequential)
1.  **Part Lookup History:** Add "Recent Searches" chips to the empty state.
2.  **View Parts Navigation:** Wire `YmmFlowPage` "View Parts" button to `PartLookupPage` (passing vehicle context if possible, or just navigation).
3.  **Settings Page:** Add "Clear History" actions and "About" section.

## In Scope
-   **Part Lookup (`PartLookupPage`):**
    -   `RecentPartSearches` provider (SharedPrefs, circular buffer map 10).
    -   Empty state shows "Recent Searches" chips.
    -   Tap chip -> autofill & search.
-   **YMM Flow (`YmmFlowPage`):**
    -   Change "View Parts" `onTap` to `context.go('/parts', extra: vehicle)`.
    -   Update `PartLookupPage` to accept `Vehicle` extra (display "Filtering for [Vehicle]" banner if present).
-   **Settings (`SettingsPage`):**
    -   "Data Management" Section:
        -   "Clear Recent Vehicles" button.
        -   "Clear Search History" button.
    -   "About" Section:
        -   App Version (package_info_plus is standard, but maybe hardcode/read from pubspec if adding deps is blocked. *Decision: Hardcode "v1.0.0" for now to avoid dep check delay, unless package_info exists.*).
-   **Data:**
    -   `RecentPartSearchesNotifier` & `RecentVehiclesNotifier` (expose clear methods).

## Out of Scope
-   Complex "Vehicle Specific Part Filtering" (just passing the context contextually is enough for now).
-   Cloud sync.
-   New dependencies (use existing).

## Constraints
-   Offline-first.
-   Keep UI consistent (Carbon/Neon theme).

## Interfaces & Contracts
-   **Storage:** `prefs_recent_part_searches_v1`
-   **Router:** `/parts` accepts `extra: Vehicle?`.

## Acceptance Criteria
- [x] **Part History:** Recent searches appear, persist, and work on tap. (2026-01-12)
- [x] **Part Navigation:** "View Parts" in Browse Flow opens Part Lookup (no longer "Coming Soon"). (2026-01-12)
- [x] **Vehicle Context:** Part Lookup shows which vehicle came from Browse (visual banner only, filtering optional). (2026-01-12)
- [x] **Settings:** "Clear [Vehicles/Searches]" buttons actually wipe SharedPrefs. (2026-01-12)
- [x] **Settings:** About section shows version "1.0.0". (2026-01-12)
- [x] `dart format` / `flutter analyze` pass. (2026-01-12)

## Validation
- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test -r expanded`

## Manual Verification Steps
1.  **Search:** Go to Parts -> Search "turbo" -> Clear -> Verify "turbo" in recents.
2.  **Browse:** Go to Browse YMM -> Select Vehicle -> Tap "View Parts".
3.  **Context:** Verify Part Lookup opens with banner "Filtering for [Year] [Model]".
4.  **Settings:** Go to Settings -> Tap "Clear Search History".
5.  **Verify:** Return to Parts -> Recents should be gone.

## Risks / Edge Cases
-   Passing `Vehicle` object via GoRouter `extra` can be lost on web refresh (acceptable for this scope).
-   Settings "Clear" feedback needs a SnackBar confirmation.

## Completed Log
- 2026-01-12 — Garage & Recent Vehicles (Recents, Favorites, Persistence) (PR: 💡 IdeaSmith: Garage & Recent Vehicles)
- 2026-01-12 — Part Lookup History & Navigation (Recents, Context Banner, Browse Integration) (PR: 💡 IdeaSmith: Part Lookup Flow & History)
- 2026-01-12 — Data Management & About (Settings Page, Clear History Logic) (PR: 💡 IdeaSmith: Settings & Data Management)
