
## 2026-01-05 - [Spec File Splitting]
**Learning:** Single `specs.json` file (~35KB) was becoming unwieldy.
**Action:** Split into 21 categorized files (e.g., `oil.json`, `torque.json`) in `assets/seed/specs/`. Updated `SeedRunner` to dynamic loading via `AssetManifest`. Updated tests to scan directory. Deleted original `specs.json`.

## 2026-01-05 - [Data Integrity & Future Scope]
**Learning:** `specs.json` is isolated (uses loose tags for mapping), but `parts.json` is tightly coupled to `vehicles.json` (uses explicit FKs like `v1` in `fits` lists).
**Action:** Marked `specs.json` as finished. Flagged `parts.json + vehicles.json` for a future *atomic* refactor. Any change to Vehicle IDs MUST update Part `fits` lists simultaneously.

## 2026-01-05 - [Guardrail Suite Completion]
**Learning:** Formatting consistency requires automated enforcement. Manual review misses things like "double spaces", "lowercase titles", or "trailing commas".
**Action:** Completed a 17-point automated test suite (`specs_format_audit_test.dart`) covering structure, IDs, categories, dates, tags, units, and typography. All 17 checks are now passing for the entire dataset.

## 2026-01-05 - [Date Format Normalization]
**Learning:** Found 30 specs with non-standard date format `2025-12-16T16:27:05.198660` (microseconds, no Z suffix).
**Action:** Normalized all to ISO 8601 with Z suffix: `2025-12-16T16:27:05Z`. Added guardrail test #13 to enforce this format.

## 2026-01-05 - [Category Naming Consistency]
**Learning:** Found `"Swap_rule"` category using underscore instead of space like other multi-word categories (e.g., `"Maintenance Intervals"`, `"Spark Plugs"`).
**Action:** Renamed to `"Swap Rules"` (7 specs). Added guardrail test to prevent future underscore categories.

## 2026-01-05 - [Tag Formatting & Unit Consistency]
**Learning:** Found ~30 specs with malformed tags (spaces after commas, trailing commas: `"impreza, engine, "`). Also found dimension specs without metric, pressure without kPa, and spark plug gap without mm.
**Action:** Normalized all tags to `"tag1,tag2,tag3"` pattern. Added metric conversions: dimensions now `183.8" (4669mm)`, pressure now `33 PSI (228 kPa)`, spark gap now `0.020"-0.022" (0.5mm)`.

## 2026-01-05 - [Descriptive Spec IDs]
**Learning:** Found 44 specs with non-descriptive IDs like `s1`, `s2`, etc. These make debugging, cross-referencing, and maintenance difficult.
**Action:** Renamed all to pattern `s_[category]_[descriptor]` (e.g., `s_oil_capacity_wrx_vb`). Added guardrail test to prevent future `sNN` IDs.

## 2026-01-05 - [Alignment Degree Symbol]
**Learning:** Old alignment specs (s23) used `"degrees"` word instead of `°` symbol. Newer GD specs use proper Unicode.
**Action:** Audit found via comprehensive format test. Fixed to `"-0.5° +/- 0.5°"`. Always use ° (Unicode 00B0) for degree values.

## 2026-01-05 - [Wiper & Spark Plug Formatting]
**Learning:** Formatting drift: Wipers were using mixed separators (`|` vs `.`) and Spark Plugs were missing metric conversions for newer engines (FA20).
**Action:** Standardized Wipers to dot separators (e.g. `Driver: 22". Passenger: 17".`). Enforced `Imperial (Metric)` pattern for Spark Plug gaps.

## 2026-01-05 - [SVX Specificity]
**Learning:** The SVX (EG33) often gets lumped into "Legacy / 90s" generic specs (like H4 bulbs). The SVX is unique: using 9006/9005 projector bulbs, 22/20" wipers, and Platinum spark plugs.
**Action:** Created dedicated SVX spec keys (`s_bulb_svx_low`, `s_wiper_svx`) to prevent fall-through to generic Legacy settings. Always check "weird" platforms (SVX, Tribeca, Baja) for unique consumable sizes.

## 2026-01-05 - [Lug Nut Torque Safety Split]
**Learning:** Found that "Lug Nut Torque" (`s3`) was applied generically ("most models") with a value of 89 ft-lbs. This is dangerous for Classic eras (Brat/GL/XT with 4x140 hubs) which require ~58-72 ft-lbs.
**Action:** Split generic specs into specific eras (Classic vs Modern) when safety-critical values differ significantly. Do not rely on "most models" for vintage coverage.

## 2026-01-05 - [Torque Unit Formatting]
**Learning:** Found new spec entries (Axle Nut Torque) violating the strict regex `RegExp(r'^[\d\.\s-]+ ft-lbs \([\d\.\s-]+ Nm\).*')`. The validator expects explicit formatting like `"162 ft-lbs (220 Nm)"` at the start of the string, while human-written entries often drift to `"Standard: 162 ft-lbs..."`.
**Action:** When adding new torque specs, always place the numeric value + primary unit + parenthetical unit at the very start of the `body` string. Use `specs_validation_test.dart` to catch this before PR.
