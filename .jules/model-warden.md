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

## 2026-01-04 - Split Year Complexity (2012)
**Learning:** 2012 marks the separation of the "Impreza" (economy) and "WRX" (performance) lines in terms of chassis, though they were still sold under the Impreza banner officially. 
- Impreza: New GP/GJ chassis, FB20 engine.
- WRX/STI: Old GR/GV chassis, EJ255/257 engine.
**Action:** When populating 2012+, ensure the engine code and body style accurately reflect this split. WRX/STI should be carefully keyed to avoid mixing with the FB20 Impreza data.

## 2026-01-04 - Expansion to 1990 (Legacy)
**Learning:** Checking older models starting at 1990. No Legacy models exist in the dataset.
**Action:** creating `subaru-legacy-usdm-coverage.md` and populating Gen 1 Legacy (1990-1994), focusing on the critical EJ22T Sport Sedan/Touring Wagon heritage.

## 2026-01-04 - Legacy Gen 5 Transition (2010-2014)
**Learning:** Gen 5 Legacy (2010-2014) grew in size and saw the introduction of the **3.6R** (EZ36). Crucially, the **2.5GT** (Turbo) was discontinued after 2012, making the 2010-2012 GTs the last turbocharged manual Legacys in the US.
**Action:** Will ensure the 2.5GT is only populated for 2010-2012. 3.6R will populate for full generation.

## 2026-01-04 - Legacy Gen 6 Standardization (2015-2019)
**Learning:** Gen 6 (2015-2019) simplified the lineup. No more manual transmissions, no more turbo models (Legacy GT is dead). The lineup is strictly **2.5i** (FB25) and **3.6R** (EZ36) CVT only. 2018 facelift brought "Sport" trim styling updates.
**Action:** Populate standardized trims (2.5i, Premium, Limited, Sport, 3.6R Limited). Ensure no turbo/manual specs are attached to this generation.

## 2026-01-04 - Legacy Gen 7 Turbo Return (2020-Present)
**Learning:** Gen 7 (2020+) brought the turbo back! The **XT** trim returned with the **FA24** engine, replacing the H6 (3.6R). The 2.5L engine switched to **FB25 (Direct Injection)**. Trims are: Base, Premium, Sport, Limited, Limited XT, Touring XT, Sport XT (2023+).
**Action:** Populate Gen 7 with FA24 Turbo (XT) trims and ensure H6 is gone. Check for the "Sport" switching from NA to Turbo in later years (2023 update).

## 2026-01-04 - Impreza Gen 1 Coverage (1993-2001)
**Learning:** Gen 1 Impreza (GC/GF/GM) coverage is missing. This era includes the birth of the **Outback Sport** and the **2.5 RS** (the WRX precursor in the US). 
**Action:** Close the 1993-2001 gap. Ensure the 1998 2.5 RS (DOHC EJ25D) is distinguished from the 1999-2001 2.5 RS (SOHC EJ251).

## 2026-01-04 - Impreza Gen 2 (The WRX Era) (2002-2007)
**Learning:** Gen 2 (GD/GG) brought the **WRX** (2002) and **STI** (2004) to the US. 
- **2002-2003 (Bugeye):** WRX uses 2.0L EJ205.
- **2004-2005 (Blobeye):** STI arrives with 2.5L EJ257. WRX stays EJ205.
- **2006-2007 (Hawkeye):** WRX switches to 2.5L EJ255. Base model name changes from "RS" to "2.5i".
**Action:** Populate with attention to the WRX engine switch (2.0L -> 2.5L) in 2006 and the correct introduction year for the STI (2004).

## 2026-01-04 - The Great Split (2015-Present)
**Learning:** In 2015, Subaru formally separated the **WRX/STI** from the **Impreza** line. 
- **Impreza (2015+):** Strictly economy (FB20 engine).
- **WRX (2015+):** Performance (FA20DIT for VA chassis, FA24 for VB chassis).
- **STI (2015-2021):** The final stand of the EJ257.
**Action:** For 2015+ entries, I will split the data: 
- `model: "Impreza"` for non-turbo trims.
- `model: "WRX"` for WRX and STI trims. This matches proper YMMT classification for modern parts lookups.

## 2026-01-04 - Forester Expansion (1998-2008)
**Learning:** Forester coverage is non-existent.
- **Gen 1 (SF, 1998-2002):** The "SUV Tough, Car Easy" era. 2.5L DOHC (1998) -> SOHC (1999+).
- **Gen 2 (SG, 2003-2008):** The enthusiast era. **XT (Turbo)** arrives in 2004 with the EJ255. Cross-check for the 2004 vs 2005 introduction of the XT (Sources say 2004).
**Action:** Establish the Forester line. Validate the XT intro year carefully.

## 2026-01-04 - Forester Gen 3 & 4 (2009-2018)
**Learning:** 
- **Gen 3 (SH, 2009-2013):** The last manual turbo Forester! Uses EJ255.
- **Gen 4 (SJ, 2014-2018):** XT switches to **FA20DIT** (same as 2015+ WRX) but is **CVT only**. No more manual XT. Base models switch to FB25.
**Action:** accurately model the engine switch in 2014 (EJ255 -> FA20DIT) and the chassis code change.

## 2026-01-04 - Forester Gen 5 & Wilderness (2019-2024)
**Learning:** 
- **Gen 5 (SK, 2019-2024):** The Turbo (XT) is discontinued again! Lineup is strictly 2.5L FB25 DI.
- **Sport Trim:** Introduced in 2019, but it is **Non-Turbo** (aesthetic package).
- **Wilderness:** Introduced in **2022**. Critical off-road trim with unique gearing and lift.
**Action:** Ensure no 2019+ Foresters are marked as Turbo. Validate the Wilderness trim existence from 2022+.

## 2026-01-04 - Outback Separation (2000-2009)
**Learning:** The Outback began as a trim of the Legacy (1995-1999) but evolved into a standalone model line.
- **Gen 1 (1995-1999):** Covered as `model: "Legacy"`, `trim: "Outback"`.
- **Gen 2 (2000-2004):** Became distinct "Subaru Outback". Introduced **H6-3.0** in 2001.
- **Gen 3 (2005-2009):** Introduced **XT (Turbo)** with EJ255.
**Action:** Establish `model: "Outback"` starting from 2000. Ensure H6 (EZ30) and Turbo (EJ255) are correctly attributed.

## 2026-01-04 - Outback Gen 4 & The 2013 Engine Switch (2010-2014)
**Learning:** Gen 4 (BR, 2010-2014) grew significantly in size.
- **XT discontinued:** Replaced by the **3.6R** (EZ36) as the sole premium engine.
- **NA Engine Switch:** In **2013**, the base Outback switched from **EJ253** (SOHC) to **FB25** (DOHC). This is a critical mid-generation change.
**Action:** Populate Gen 4. Accurately model the disappearance of the Turbo and the mid-cycle engine update in 2013.

## 2026-01-04 - Outback Gen 5 & 6 (2015-2024)
**Learning:**
- **Gen 5 (BS, 2015-2019):** Continuation of Gen 4 formula. FB25 and EZ36 (3.6R). No Turbo.
- **Gen 6 (BT, 2020-2024):** **XT Returns!** The 3.6R is dead, replaced by the **FA24 Turbo** (denoted as XT).
- **Wilderness:** Introduced in **2022** (same year as Forester Wilderness). Lifted, geared lower, FA24 Turbo standard.
**Action:** Populate Gen 5 & 6. Validation must ensure 2020+ "XT" or "Wilderness" maps to FA24 Turbo, while 2015-2019 "3.6R" maps to EZ36.


## 2026-01-04 - [Complete USDM Catalog]
**Learning:**
- **Discontinued Models:** Several classic models were missing. Added **SVX** (EG33), **Baja** (EJ25/EJ255), **Tribeca** (EZ30/EZ36), and **Justy** (EF12).
- **Modern Gaps:** **Ascent** (FA24 Turbo) and **Solterra** (Electric) were completely absent.
- **Classics:** Added **DL/GL/GL-10** (EA82/Turbo), **BRAT** (EA71/81/82), and **XT/XT6** (EA82/ER27).
- **Filling Holes:** Filled significant year gaps for **WRX** (2016-2024) and **Crosstrek** (2013-2024).

**Action:**
- Populated `vehicles.json` with all missing entries.
- Created coverage trackers for every single model.
- Verified with `missing_models_validation_test.dart` (all passed).
- **Impact:** USDM Coverage is now effectively **100%** for all major retail models from 1978 to 2024.

## 2026-01-05 - 2025 Forester Coverage (Gen 6)
**Learning:** 2025 marks the introduction of the Gen 6 Forester (Model Code **SL**).
- **Lineup:** Base, Premium, Sport, Limited, Touring.
- **Engine:** All use the **FB25 NA** (2.5L Direct Injection).
- **Wilderness:** The "Wilderness" trim is currently a carryover of the 2024 model (Gen 5 SK) or unreleased on the new platform as of early 2025. To avoid ambiguity/guessing, it was omitted until confirmed.
- **Hybrid:** A Hybrid model is announced/expected but specs are not fully detailed/orderable in the same capacity as the core 5 yet. Omitted for now.
**Action:** Added the 5 core Gen 6 trims to `assets/seed/vehicles.json` with proper `(US)` suffix and `FB25 NA` engine code.
