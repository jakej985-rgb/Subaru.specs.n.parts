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

## 2026-01-10 - VB WRX Brake Caliper Confusion
**Learning:** The 2022+ WRX (VB) uses 316mm front rotors on most trims (Base/Premium/Limited/GT), similar in size to the old "Subaru 4-Pot" brakes or even the 2004 STI Brembos (326mm is close), but the caliper is a **2-piston floating** design, not a 4-piston fixed caliper. Previous data conflated these.
**Action:** Added specific specs for VB WRX Front/Rear Rotors and Calipers (`s_brake_front_rotor_wrx_vb`, etc.) and clarified the `s_brake_4pot_front` entry to explicitly exclude the 2022+ WRX to prevent user confusion.

## 2026-01-14 - 2004 STI Torque Specs & Gasket Nuance
**Learning:** The 2004 STI 6MT drain plug torque is NOT a single value. It depends on the gasket: Aluminum (silver) takes 32.5 ft-lbs (44 Nm), while Copper/Metal (black/copper) takes 51.6 ft-lbs (70 Nm). Also, 2004 STI uses 5x100 hubs with a lower FSM lug torque (65.7 ft-lbs) compared to modern 89 ft-lbs.
**Action:** Updated `torque_specs.json` for 2004 STI to explicitly call out the gasket-dependent torque for the transmission drain plug and the specific lug nut torque, preventing potential thread damage or leaks.
