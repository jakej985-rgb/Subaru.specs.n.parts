## 2026-01-10 - A/C Specs for GD STI
**Learning:** The 2004 STI (and GD platform) uses ZXL 200PG compressor oil and ~0.5kg of R134a. This info is crucial for A/C service but was missing.
**Action:** Added `s_ac_refrigerant_capacity_gd` and `s_ac_compressor_oil_type_gd` to `fluids.json` with appropriate tags (`gd`, `sti`, `ac`). Also clarified the 6MT/Front Diff shared fluid situation for Gen 2 STIs in `transmission.json`.
