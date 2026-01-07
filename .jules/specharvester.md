# SpecHarvester Journal

## 2024-05-24 - 2004 STI 5x100 Bolt Pattern
**Learning:** The 2004 Subaru WRX STI (USDM) is the *only* model year of the US STI to use the 5x100 bolt pattern. All subsequent years (2005-2021) switched to 5x114.3 for stronger hubs. This is a critical compatibility point for wheel fitment.
**Action:** Verified that `s_wheel_bolt_pattern_sti_gd_04` is correctly present and scoped for `2004` and `sti` tags, distinct from `s_wheel_bolt_pattern_sti_gd_0507`. Added `s_wheel_size_sti_04` to complete the wheel specs.

## 2024-05-24 - Lug Nut Torque Variance
**Learning:** While modern Subarus generally standardize on 89 ft-lbs (120 Nm), the GD chassis (especially earlier years) often listed lower torque specs in the FSM (e.g., 65-73 ft-lbs). Using the modern 89 ft-lbs is generally safe, but purists and factory manuals differ.
**Action:** Added `s_torque_lug_nut_gd_sti` with the specific 2004 FSM range (65.7 ft-lbs / 90 Nm) to respect the authority of the manual, while keeping `s_torque_lug_nut_modern` for general use.
