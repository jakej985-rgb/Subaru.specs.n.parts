# Impreza / WRX / STI (1993–2007) — US + JDM
## Master Notes (Steps 1–7 + 9)

This document contains everything we built so far:
- Step 1: Year-by-year key trims with body style / engine / transmission / drivetrain
- Step 2: Transmission families + final drives + center diffs
- Step 3: ECU/Phase/AVCS/Throttle/Immobilizer (engine-level)
- Step 6: Differentials + LSD types
- Step 7: Mounts/crossmembers/driveshaft/shifter/clutch fitment rules
- Step 9: Swap Wizard rules (green/yellow/red)

**CSV seed file:** `impreza_wrx_sti_1993_2007_seed.csv`

---

## Step 1 — Year-by-year key trims (with body style)
| Year | Market | Trim | Body | Engine | Transmission | Drivetrain | Notes |
|---:|---|---|---|---|---|---|---|
| 1993 | US | L/Base | Sedan;Wagon | EJ18 NA | 5MT/4AT | FWD/AWD | US launch year |
| 1993 | JDM | Base grades | Sedan;Wagon | EJ15/EJ16/EJ18/EJ20 NA | 5MT/4AT | FWD/AWD | Wide grades |
| 1993 | JDM | WRX | Sedan;Wagon | EJ20 Turbo | 5MT | AWD | Pre-US WRX |
| 1994 | US | L | Sedan;Wagon | EJ18 NA | 5MT/4AT | FWD/AWD |  |
| 1994 | JDM | WRX | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 1994 | JDM | WRX STI V1 | Sedan | EJ20 Turbo | 5MT | AWD | STI debut; RA lightweight |
| 1995 | US | L | Sedan;Wagon | EJ18/EJ22 NA | 5MT/4AT | AWD |  |
| 1995 | JDM | WRX/STI V2 | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 1996 | US | L/Brighton | Sedan;Wagon | EJ22 NA | 5MT/4AT | AWD |  |
| 1996 | JDM | WRX/STI V3 | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 1997 | US | L/Brighton | Sedan;Wagon | EJ22 NA | 5MT/4AT | AWD |  |
| 1997 | US | Outback Sport | Wagon | EJ22 NA | 5MT/4AT | AWD |  |
| 1997 | JDM | WRX/STI V4 | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 1998 | US | 2.5 RS | Coupe | EJ25D NA | 5MT/4AT | AWD | Iconic RS |
| 1998 | US | L | Sedan;Wagon | EJ22 NA | 5MT/4AT | AWD |  |
| 1998 | JDM | WRX/STI V5 | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 1998 | JDM | STI 22B | Coupe | EJ22T Turbo | 5MT | AWD | Limited |
| 1999 | US | 2.5 RS | Coupe | EJ25 NA | 5MT/4AT | AWD |  |
| 1999 | US | L/Brighton | Sedan;Wagon | EJ22 NA | 5MT/4AT | AWD |  |
| 1999 | JDM | WRX/STI V6 | Sedan;Wagon | EJ20 Turbo | 5MT | AWD |  |
| 2000 | US | 2.5 RS | Coupe | EJ25 NA | 5MT/4AT | AWD | Final GC in US |
| 2000 | US | Outback Sport | Wagon | EJ22/EJ25 NA | 5MT/4AT | AWD |  |
| 2000 | JDM | WRX | Sedan;Wagon | EJ20 Turbo | 5MT/4AT | AWD | GD begins in JDM |
| 2000 | JDM | WRX STI | Sedan | EJ207 Turbo | 6MT | AWD | Early 6MT era |
| 2001 | US | 2.5 RS | Sedan;Coupe | EJ25 NA | 5MT/4AT | AWD |  |
| 2001 | US | Outback Sport | Wagon | EJ25 NA | 5MT/4AT | AWD |  |
| 2002 | US | 2.5 RS | Sedan;Wagon | EJ251 NA | 5MT/4AT | AWD |  |
| 2002 | US | WRX | Sedan;Wagon | EJ205 Turbo | 5MT/4AT | AWD | US WRX debut |
| 2002 | JDM | WRX | Sedan;Wagon | EJ20 Turbo | 5MT/4AT | AWD |  |
| 2002 | JDM | WRX STI | Sedan | EJ207 Turbo | 6MT | AWD | DCCD |
| 2003 | US | WRX | Sedan;Wagon | EJ205 Turbo | 5MT/4AT | AWD |  |
| 2003 | US | 2.5 TS | Sedan;Wagon | EJ251 NA | 5MT/4AT | AWD |  |
| 2004 | US | WRX | Sedan;Wagon | EJ205 Turbo | 5MT/4AT | AWD |  |
| 2004 | US | WRX STI | Sedan | EJ257 Turbo | 6MT | AWD | STI arrives US |
| 2004 | US | 2.5 RS/TS | Sedan;Wagon | EJ25 NA | 5MT/4AT | AWD |  |
| 2005 | US | WRX | Sedan;Wagon | EJ205 Turbo | 5MT/4AT | AWD |  |
| 2005 | US | WRX STI | Sedan | EJ257 Turbo | 6MT | AWD |  |
| 2005 | US | 2.5 RS | Sedan;Wagon | EJ25 NA | 5MT/4AT | AWD |  |
| 2006 | US | WRX | Sedan;Wagon | EJ255 Turbo | 5MT/4AT | AWD | Hawkeye; 3.70 FD |
| 2006 | US | WRX STI | Sedan | EJ257 Turbo | 6MT | AWD |  |
| 2006 | US | 2.5i | Sedan;Wagon | EJ25 NA | 5MT/4AT | AWD |  |
| 2007 | US | WRX | Sedan;Wagon | EJ255 Turbo | 5MT/4AT | AWD | Final GD in range |
| 2007 | US | WRX STI | Sedan | EJ257 Turbo | 6MT | AWD |  |
| 2007 | US | 2.5i | Sedan;Wagon | EJ25 NA | 5MT/4AT | AWD |  |

---

## Step 2 — Transmissions (codes/families, final drive, center diff)
| Trans (logical) | Family | Gears | Type | Final Drive | Center Diff | Years | Notes |
|---|---|---:|---|---:|---|---|---|
| NA_5MT_TY752_TY753 | TY752/TY753 | 5 | MT | 3.90 | Viscous | US 1993-1996 NA | Phase 1 era NA 5MT family |
| NA_5MT_TY754 | TY754 | 5 | MT | 3.90 | Viscous | US 1997-2001 NA | Stronger than early; common |
| NA_5MT_TY755 | TY755 | 5 | MT | 3.90/4.11 | Viscous | US 2002-2007 NA | Final drive varies by model; match rear diff |
| WRX_5MT_390 | TY754 | 5 | MT | 3.90 | Viscous | US WRX 2002-2005 | Classic WRX 5MT; reliability risk at high power |
| WRX_5MT_370 | TY755 | 5 | MT | 3.70 | Viscous | US WRX 2006-2007 | Unique 3.70 FD; must match rear diff |
| AUTO_4EAT_390_P1 | 4EAT | 4 | AT | 3.90 | Viscous | US 1993-1998 (Phase 1) | Early 4EAT; match rear diff |
| AUTO_4EAT_411_P2 | 4EAT | 4 | AT | 4.11 | Viscous | US 1999-2007 (Phase 2) | Later 4EAT; common |
| STI_6MT_TY856 | TY856 | 6 | MT | 3.90 | DCCD | US STI 2004-2007; JDM STI 2000-2007 | Requires R180 3.90 and STI driveline parts; pull-type clutch |

**Key traps**
- 2006–2007 WRX 5MT is **3.70** → requires matching **R160 3.70** rear diff.
- 4EAT Phase 2 is usually **4.11** → must match rear diff.
- STI 6MT is **3.90 + DCCD** → requires **R180 3.90** rear diff and STI driveline parts.

---

## Step 3 — Engine ECU/Phase/AVCS/Throttle/Immobilizer (engine-level)
| Engine | Displ (L) | Asp | Phase | AVCS | Throttle | Immobilizer | Common years | Notes |
|---|---:|---|---|---|---|---|---|---|
| EJ18 | 1.8 | NA | Phase 1 | No | Cable | No | US 1993-1996 | US base Impreza early years; simple ECU |
| EJ22 | 2.2 | NA | Phase 1/2 | No | Cable | No | US 1994-2001 | Common NA swap base; phase varies by year/market |
| EJ25D | 2.5 | NA | Phase 1 | No | Cable | No | US 1998-1999 (2.5RS DOHC era) | DOHC NA; phase 1 era wiring/sensors |
| EJ251 | 2.5 | NA | Phase 2 | No | Cable | No | US 1999-2005 (NA Impreza/RS/TS) | Phase 2 NA; very swap-friendly |
| EJ253 | 2.5 | NA | Phase 2 | No | Cable/DBW | Some 2006-2007 | US 2002-2007 (NA Impreza 2.5i/TS) | Late years can be DBW; some trims immobilizer |
| EJ205 | 2.0 | Turbo | Phase 2 | No (US) | Cable | No | US WRX 2002-2005; JDM EJ205 varies | Best swap ECU era (no immobilizer, cable) |
| EJ255 | 2.5 | Turbo | Phase 2 | No (US 06-07) | DBW | Some | US WRX 2006-2007 | 3.70 FD era; DBW complicates swaps |
| EJ257 | 2.5 | Turbo | Phase 2 | No (US 04-07) | Cable | No | US STI 2004-2007 | STI engine; prefers STI 6MT |
| EJ20G | 2.0 | Turbo | Phase 1 | No | Cable | No | JDM WRX 1993-1996; early STI | Early JDM turbo; wiring differs |
| EJ20K | 2.0 | Turbo | Phase 2 transitional | No | Cable | No | JDM WRX/WRX STI ~1997-2000 | Transitional era |
| EJ207 | 2.0 | Turbo | Phase 2 | Yes (JDM 01-07 typical) | Cable | No | JDM WRX STI 2001-2007 | Gold-standard JDM motor: AVCS, high rev, no immobilizer |
| EJ22T | 2.2 | Turbo | Phase 1 | No | Cable | No | JDM STI 22B (1998 limited) | Limited special; included for completeness |

---

## Step 6 — Differentials (rear)
| Diff | Family | Final Drive | LSD | Years | Notes |
|---|---|---:|---|---|---|
| R160_390 | R160 | 3.90 | Open (some WRX viscous LSD) | Common NA/WRX 1993-2005 | Match trans FD |
| R160_411 | R160 | 4.11 | Open | Common with 4EAT Phase 2 (1999-2007) | Match 4EAT 4.11 |
| R160_370 | R160 | 3.70 | Some viscous LSD | WRX 2006-2007 | Unique; common swap trap |
| R180_390 | R180 | 3.90 | Clutch LSD | STI 2004-2007 | Requires STI axles/hubs or hybrid conversion |

---

## Step 7 — Physical fitment rules (crossmembers, driveshafts, shifter, clutch)
- **Turbo engines require WRX/STI crossmember** (NA crossmember interferes with up-pipe/exhaust).
- **STI 6MT requires**: STI crossmember, STI driveshaft, STI shifter/linkage, STI pull-type clutch+flywheel, appropriate starter, and R180 3.90 rear diff (+ axles/hubs or hybrid solution).
- **Clutch type**: WRX/NA 5MT is typically push-type; STI 6MT is pull-type.

---

## Step 9 — Swap Wizard rules
| Rule ID | Severity | When | Message |
|---|---|---|---|
| FD_MATCH | error | trans.finalDrive != rearDiff.finalDrive | Final drive mismatch (front vs rear). |
| STI6_R180 | error | trans == STI_6MT AND rearDiff != R180_390 | STI 6MT requires R180 3.90 rear diff. |
| TURBO_XMEM | error | engine.isTurbo AND crossmember == NA | Turbo up-pipe/exhaust hits NA crossmember. |
| DBW_REQ | error | engine.requiresDBW AND DBW_Planned == false | DBW engine needs pedal + wiring + ECU support. |
| IMMOB | error | engine.hasImmobilizer AND Immobilizer_Planned == false | Immobilizer requires ECU+key+cluster match (or delete). |
| STI6_PARTS | mods | trans == STI_6MT | Requires STI crossmember, driveshaft, shifter, pull-type clutch/flywheel, starter; hubs/axles or hybrids; DCCD controller recommended. |
| 5MT_TORQUE_RISK | mods | engine in {EJ255,EJ257,EJ207} AND trans in {NA_5MT,WRX_5MT_390,WRX_5MT_370} | 5MT reliability risk at power; consider STI 6MT. |
| 4EAT_HEAT | mods | trans is 4EAT AND engine.isTurbo | 4EAT needs trans cooler/heat management. |


### Suggested scoring
- Start 100
- -100 for any **error** rule triggered
- -20 for major conversions (STI 6MT package / DBW / immobilizer)
- -10 for medium mods (turbo crossmember, hybrid axles/hubs, DCCD controller)
- -5 for advisory items (coolers, mounts, etc.)
