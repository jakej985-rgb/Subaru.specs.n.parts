## IdeaSmith Scope Snapshot
- Date: 2026-01-12
- Project: specsnparts
- Improvement: Global Unified Search (Alpha)

## User Pain Point
- Users have to pick between "Part Lookup" and "Vehicle Specs" before searching
- No way to quickly find a torque spec or part number from the Home page
- Discovery is blocked by mandatory drill-down flows (Year -> Model -> Trim)

## One Shippable Improvement
- Build: A "Search Global" overlay on the Home page that queries Specs, Parts, and Vehicles simultaneously and presents categorized results.
- Explicitly NOT building: A new FTS database table or persistent search index in this PR.

## In Scope
- **UI (`HomePage`):** Replace or add a "Global Search" bar at the top of the Home page.
- **UI (`SearchOverlay`):** A full-screen or modal search view with real-time results.
- **Provider (`GlobalSearchNotifier`):** A unified provider that calls `specsDao`, `partsDao`, and `vehiclesDao` in parallel.
- **Categorized Results:** Section headers for "Models", "Parts", and "Specs" in the results list.
- **Navigation:** Tapping a result goes to the correct deep link (e.g., Spec list for that vehicle, or Part dialog).

## Out of Scope
- Full-text search (FTS) virtual tables / indexing
- Multi-word relevance ranking (simple string matching only)
- Advanced filters (e.g., filter by year within search)
- Cloud/Remote search (offline only)

## Constraints
- Offline-first preserved
- Follow repo patterns: Riverpod + go_router + Drift
- No schema breaks in seed files
- Change set limited to 1 new feature folder and UI updates to Home

## Interfaces & Contracts
- Seed/data contracts (stable):
  - assets/seed/vehicles.json
  - assets/seed/specs/*.json
  - assets/seed/parts.json
- Routing contracts:
  - reuse `/specs`, `/part-lookup`, and `/browse` paths

## Acceptance Criteria
- [ ] Search bar appears on Home page
- [ ] Typing "STI" shows matching Vehicles, Parts (if any), and Specs
- [ ] Tapping a Vehicle result opens that vehicle's specs
- [ ] Tapping a Part result opens the Part details dialog
- [ ] Tapping a Spec result opens the Spec list for that vehicle
- [ ] Empty state shown if no categories have matches
- [ ] `dart format --output=none --set-exit-if-changed .` passes
- [ ] `flutter analyze` passes
- [ ] `flutter test` covers the unified search filtering logic

## Validation
- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

## Manual Verification Steps
1) Open Home → Tap Global Search.
2) Type "Oil" → Confirm parts (oil filters) and specs (oil capacity) appear in categorized sections.
3) Type a specific year "2004" → Confirm vehicles from that year appear.
4) Tap a "2004 Impreza" result → Confirm navigation to Spec List.

## Risks / Edge Cases
- **Parallel Query Lag**: Large datasets might slow down the UI thread (use `Future.wait` and limited limits).
- **Categorization Blur**: A result named "WRX" might appear in both Specs and Vehicles.
- **Deep Link Failures**: Navigating from search needs to pass correct YMMT context.
