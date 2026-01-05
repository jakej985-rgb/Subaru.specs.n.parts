# Model Warden's Journal

## 2024-05-22 - Initial Setup
**Learning:** Initialized the journal.
**Action:** Will document all findings here.

## 2024-05-22 - 2024 Crosstrek Coverage
**Learning:** 2024 Crosstrek was missing 4/5 trims. Engine codes differ by trim (Base/Premium = FB20, Sport/Limited/Wilderness = FB25).
**Action:** Added Base, Premium, Limited, Wilderness. Used FB20/FB25 engine codes based on trim.

## 2024-05-27 - 2024 WRX Coverage
**Learning:** 2024 WRX coverage was incomplete, missing Premium, TR, and GT trims. 2024 introduces the "TR" trim (Performance-focused) and "GT" is the top trim with SPT (CVT).
**Action:** Added Premium, TR, and GT trims to `assets/seed/vehicles.json` for 2024 WRX. All share the FA24 engine code.

## 2024-05-28 - 2024 BRZ Coverage
**Learning:** 2024 BRZ was missing Premium and Limited trims. Existing "TS" trim was incorrectly capitalized; official Subaru branding is "tS".
**Action:** Added Premium and Limited trims. Renamed "TS" to "tS" in `assets/seed/vehicles.json`. Validated engine code is FA24 for all.

## 2026-01-04 - 2024 Outback Coverage
**Learning:** 2024 Outback coverage was completely missing. The lineup includes both 2.5L (FB25) and 2.4L Turbo (FA24) models. The "Onyx Edition" exists in both non-turbo (new for recent years) and turbo ("Onyx Edition XT") variants.
**Action:** Added all 9 trims: Base, Premium, Onyx Edition, Limited, Touring (FB25) and Onyx Edition XT, Wilderness, Limited XT, Touring XT (FA24). Normalized 2023 "Onyx XT" to "Onyx Edition XT" for consistency.
