## IdeaSmith Scope Snapshot: Spec Comparison Engine (Alpha)
- Date: 2026-01-12
- Project: Subaru.specs.n.parts
- Improvement: Add a "Comparison Tray" to allow users to compare 2 vehicles side-by-side.

## User Pain Point
- Users have to flip back and forth between different Model Years to see if a part (like a hub or a brake rotor) changed between years.
- There is no easy way to confirm if a 2005 WRX spec is identical to a 2004 WRX spec without manual memorization.

## One Shippable Improvement
- Build: A persistent "Comparison Tray" that allows users to "Add to Compare" from any Vehicle page and a "Compare Page" showing key specs side-by-side.

## In Scope
- `ComparisonNotifier`: State management for a list of up to 2 vehicles.
- "Add to Compare" button in Vehicle/Spec Header.
- `ComparisonPage`: A table-like view comparing:
  - Identification (Year/Model/Trim)
  - Engine Code
  - Shared Fluids (Oil/Coolant)
  - Key Torque Specs (Wheels/Plugs)
- Navigation: FAB or Tray on Home/Specs pages when 1+ vehicle is selected.

## Out of Scope
- Comparing more than 2 vehicles (initially).
- Comparing Parts (only Vehicles/Specs).
- PDF Export of comparison.
- Deep diffing of every single data point (focused on core specs first).

## Constraints
- Must use existing `AppDatabase` and `YMMT` identity.
- No new DB tables; use in-memory state or SharedPreferences for the tray.

## Acceptance Criteria
- [ ] User can add 2 vehicles to a comparison list.
- [ ] Comparison page displays both vehicles' specs in adjacent columns.
- [ ] Differences are highlighted or easily scannable.
- [ ] `flutter analyze` and `flutter test` pass.
