## IdeaSmith Scope Snapshot
- Date: 2026-01-12
- Project: specsnparts
- Improvement: 20 small, shippable UX improvements

---

## Improvement #1: Nuclear Reset (Debug)

### User Pain Point
- Testing seed data or wiping state requires app uninstall
- "Clear Data" is piecemeal

### In Scope
- **UI (`SettingsPage`):** Add "Reset App Data" (red button)
- Wipes `shared_preferences` AND deletes `db.sqlite`

---

## Improvement #2: Licenses Page

### User Pain Point
- No attribution for used packages (standard requirement)

### In Scope
- **UI (`SettingsPage`):** Add "Open Source Licenses" tile
- Navigates to `LicensePage` (Flutter built-in)

---

## Improvement #3: Confirm Clear Data

### User Pain Point
- Accidental taps on "Clear Recents" wipe data instantly

### In Scope
- **UI (`SettingsPage`):** Add `showDialog` confirmation before clearing Favorites/Recents

---

## Improvement #4: Swipe Dismiss Recents

### User Pain Point
- removing recents requires "Clear All"
- Can't remove just one mistapped vehicle

### In Scope
- **UI (`GarageView`):** Wrap `_GarageCard` in `Dismissible` (Recents section only)
- Updates provider on dismiss

---

## Improvement #5: Garage Empty State

### User Pain Point
- Empty garage is invisible (SizedBox.shrink)
- New users see a blank gap

### In Scope
- **UI (`GarageView`):** Show "Your Garage is Empty" card with an icon if both lists empty

---

## Improvement #6: Garage Quick Fluids button

### User Pain Point
- Most common reason to save vehicle is checking oil/fluids
- Requires 3 taps (Tap Car -> Specs -> Filter Fluids)

### In Scope
- **UI (`GarageView`):** Add "Oil & Fluids" text button/icon on the card
- Deep links to `/specs?category=Fluids` (requires router handling or param)

---

## Improvement #7: Engine List Search

### User Pain Point
- Engine list is long (EJ, FA, FB, EG, EZ...)
- Hard to find specific code

### In Scope
- **UI (`EngineFlowPage`):** Add `SearchBar` above list
- Filter local list by query

---

## Improvement #8: Engine Family Headers

### User Pain Point
- Flat list of 50 engines is overwhelming
- Context missing (FA vs EJ)

### In Scope
- **UI (`EngineFlowPage`):** Group by first 2 letters (EJ, FA, EZ, etc.)
- Use sticky headers (or simple headers in ListView)

---

## Improvement #9: YMM Reset Action

### User Pain Point
- Selecting wrong Year requires Back -> Back -> Back
- No easy "Start Over"

### In Scope
- **UI (`YmmFlowPage`):** Add "Reset" text button in AppBar (if selection exists)
- Clears all state

---

## Improvement #10: Vehicle Detail Chips (YMM)

### User Pain Point
- "2004 Impreza WRX STI" is shown, but body (Sedan) and market (USDM) hidden
- Critical for correct fitment

### In Scope
- **UI (`YmmFlowPage`):** Add chips for `body` and `market` below vehicle title in selection view

---

## Improvement #11: Year Picker Grid Toggle

### User Pain Point
- List of years (1990-2025) requires lots of scrolling
- Grid is faster for years

### In Scope
- **UI (`CategoryYearPickerPage`):** Add ToggleButton in AppBar
- Switch between `ListView` and `GridView`

---

## Improvement #12: Sort Parts (Name/OEM)

### User Pain Point
- Parts list defaults to Name
- Sometimes finding by OEM number sequence is easier

### In Scope
- **UI (`PartLookupPage`):** Add popup menu filter icon
- Sort by Name vs Sort by OEM

---

## Improvement #13: Delete Search History Item

### User Pain Point
- Search history gets cluttered with typos
- "Clear All" is too aggressive

### In Scope
- **UI (`PartLookupPage`):** Add small "x" on history chips

---

## Improvement #14: Copy Aftermarket Number

### User Pain Point
- Can Copy OEM, but not Wix/Fram numbers
- Manual typing error prone

### In Scope
- **UI (`PartDialog`):** Wrap aftermarket rows in `InkWell`
- Tap copy to clipboard

---

## Improvement #15: Part "Fits" Preview

### User Pain Point
- List item shows name/OEM, but not if it fits specific engines
- Must open dialog to check "fits"

### In Scope
- **UI (`PartList`):** Show "Fits: EJ20, EJ25..." (truncated) in subtitle

---

## Improvement #16: Spec List Category Chips

### User Pain Point
- Spec list is long, mixed categories
- Search is only filter

### In Scope
- **UI (`SpecListPage`):** Horizontal scrollable `ChoiceChip` list at top
- Filters visible specs by category

---

## Improvement #17: Copy All Specs

### User Pain Point
- Sharing full build info requires one-by-one copy
- Tedious

### In Scope
- **UI (`SpecListPage`):** Add "Copy All" icon action
- Copies all *visible* specs to clipboard formatted text

---

## Improvement #18: Show Spec Source

### User Pain Point
- "Is this from FSM or ChatGPT?"
- Trust is low without provenance

### In Scope
- **UI (`SpecListPage`):** Show "Source: FSM (2004)" in small text on expanded tile or bottom of card

---

## Improvement #19: Scroll to Top

### User Pain Point
- Long lists (Specs/Parts) are one-way streets
- Fast scroll up is painful

### In Scope
- **UI (`SpecListPage`):** FAB appears when scrolled down
- Tapping scrolls to index 0

---

## Improvement #20: Debug Info (Version Tap)

### User Pain Point
- "Is my DB updated?" "Which path is used?"
- Troubleshooting users is hard

### In Scope
- **UI (`SettingsPage`):** 5 taps on Version -> Show Dialog with DB path, vehicle count, app version

---

## Completed Log
- 2026-01-12 — Garage & Recent Vehicles
- 2026-01-12 — Part Lookup History & Navigation
- 2026-01-12 — Data Management & About
- 2026-01-12 — Browse by Engine Functional
- 2026-01-12 — Garage Card PARTS Navigation
- 2026-01-12 — PlaceholderScreen Cleanup
- 2026-01-12 — Copy OEM Number
- 2026-01-12 — Aftermarket Numbers + Fits Chips in Part Dialog
- 2026-01-12 — Part List CarbonSurface Styling
- 2026-01-12 — Category Specs Long-Press Copy
- 2026-01-12 — Engine Vehicle Count Badges
- 2026-01-12 — Year Picker Model Counts
- 2026-01-12 — Clear Favorites in Settings
- 2026-01-12 — Engine Badges on Garage Cards
- 2026-01-12 — Quick Favorite from YMM Flow
- 2026-01-12 — Category Icons in Results Header
- 2026-01-12 — Pull-to-Refresh Vehicle Lists
- 2026-01-12 — Spec Counts in Category Hub
- 2026-01-12 — All Specs FAB on Home
- 2026-01-12 — Animated Empty States
