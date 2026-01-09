# SpecHarvester Journal

## 2024-05-24 - 2004 STI 5x100 Bolt Pattern
**Learning:** The 2004 Subaru WRX STI (USDM) is the *only* model year of the US STI to use the 5x100 bolt pattern. All subsequent years (2005-2021) switched to 5x114.3 for stronger hubs. This is a critical compatibility point for wheel fitment.
**Action:** Verified that `s_wheel_bolt_pattern_sti_gd_04` is correctly present and scoped for `2004` and `sti` tags, distinct from `s_wheel_bolt_pattern_sti_gd_0507`. Added `s_wheel_size_sti_04` to complete the wheel specs.

## 2024-05-24 - Lug Nut Torque Variance
**Learning:** While modern Subarus generally standardize on 89 ft-lbs (120 Nm), the GD chassis (especially earlier years) often listed lower torque specs in the FSM (e.g., 65-73 ft-lbs). Using the modern 89 ft-lbs is generally safe, but purists and factory manuals differ.
**Action:** Added `s_torque_lug_nut_gd_sti` with the specific 2004 FSM range (65.7 ft-lbs / 90 Nm) to respect the authority of the manual, while keeping `s_torque_lug_nut_modern` for general use.

## 2024-05-24 - BRZ vs. Impreza Transmission Torque Specs
**Learning:** The BRZ manual transmission (Aisin AZ6/TL70) has distinct drain/fill torque specs (27 ft-lbs / 37 Nm) compared to the standard Subaru 5MT/6MT (often 32.5 ft-lbs or higher). Conflicting info exists online, but FSM and reputable guides (ft86club, 900brz) align on 37Nm (27 ft-lbs).
**Action:** Added `s_torque_trans_drain_brz_mt` and `s_torque_trans_fill_brz_mt` explicitly for BRZ/86 platform to prevent over-torquing with generic Subaru specs.

## 2026-01-08 - STI 6MT Drain Plug Torque & Gasket Variance
**Learning:** The Subaru 6MT (TY856) drain plug torque specification is heavily dependent on the gasket type. Aluminum gaskets (silver) require a lower torque of **32.5 ft-lbs (44 Nm)**, while Copper/Metal gaskets (black/copper) require **51.6 ft-lbs (70 Nm)**. Mistaking these can lead to leaks or stripped threads. Early STIs (2004-2007) may use either depending on the specific maintenance kit used.
**Action:** Created `s_torque_trans_drain_sti_6mt` with explicit notes distinguishing the torque values based on gasket type, ensuring safety for all 6MT owners.
