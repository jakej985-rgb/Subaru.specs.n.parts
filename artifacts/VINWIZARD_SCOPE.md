## IdeaSmith Scope Snapshot: VINWizard (Alpha)
- Date: 2026-01-12
- Project: Subaru.specs.n.parts
- Improvement: Implement 17-digit Subaru VIN decoding to suggest Year/Model/Trim.

## User Pain Point
- Users often don't know their exact "Market" or "Trim" variant, making it hard to find the right specs.
- Selecting Year -> Model -> Trim manually takes 5+ taps; a VIN takes 1 scan/entry.

## One Shippable Improvement
- Build: A VIN decoding utility that parses the 17-digit string and identifies the Year, Model, and potentially Engine/Body.

## In Scope
- `VinDecoder` utility: Logic to map 4th, 6th, and 10th characters to Subaru models/years.
- VIN entry field in the `GlobalSearchOverlay`.
- Result "Suggestion" that deep-links to the matching Vehicle in the database.

## Out of Scope
- Full vehicle history reports (Carfax-style).
- OBD2 integration.
- Decoding non-Subaru VINs.
- Automatic scanner (Camera/OCR) - text entry only for Alpha.

## Constraints
- Privacy-safe: Do not store the 12th-17th sequential digits (the serial number); only decode the first 11 digits.
- Offline-first: The decoder must use static mapping tables in code, not an external API.

## Acceptance Criteria
- [ ] Entering a valid Subaru VIN (e.g., `JF1GD...`) correctly identifies the Year and Model.
- [ ] The app suggests at least one matching vehicle from the `vehicles.json` database.
- [ ] `flutter analyze` passes.
