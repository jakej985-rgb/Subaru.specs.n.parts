#!/usr/bin/env python3
"""
FluidsYMMTFitmentWriter v2 Script
Generates fluids.csv with proper fluid TYPES/SPECS in *_unit columns.
"""

import json
import csv
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
REPO_ROOT = SCRIPT_DIR.parent
VEHICLES_JSON = REPO_ROOT / "assets" / "seed" / "vehicles.json"
FLUIDS_CSV = REPO_ROOT / "assets" / "seed" / "specs" / "fitment" / "fluids.csv"

HEADER = [
    "year", "make", "model", "trim", "body", "market",
    "engine_oil_qty", "engine_oil_unit",
    "engine_coolant_qty", "engine_coolant_unit",
    "brake_fluid_qty", "brake_fluid_unit",
    "washer_fluid_qty", "washer_fluid_unit",
    "power_steering_fluid_qty", "power_steering_fluid_unit",
    "clutch_hydraulic_fluid_qty", "clutch_hydraulic_fluid_unit",
    "manual_trans_fluid_qty", "manual_trans_fluid_unit",
    "automatic_trans_fluid_qty", "automatic_trans_fluid_unit",
    "cvt_fluid_qty", "cvt_fluid_unit",
    "front_diff_fluid_qty", "front_diff_fluid_unit",
    "rear_diff_fluid_qty", "rear_diff_fluid_unit",
    "center_diff_or_transfer_fluid_qty", "center_diff_or_transfer_fluid_unit",
    "ac_refrigerant_qty", "ac_refrigerant_unit",
    "ac_compressor_oil_qty", "ac_compressor_oil_unit",
    "notes", "source_1", "source_2", "confidence"
]

# Fluid specs by era/engine - now includes SPEC (unit) for each fluid
# Format: { engine: { fluid: { qty, spec, notes } } }

ENGINE_SPECS = {
    # EA71 (1978-1979)
    "EA71": {
        "engine_oil": {"qty": "w/ filter: 3.8 qt / 3.6 L", "spec": "10W-40 (API SF/SG)"},
        "engine_coolant": {"qty": "capacity: 5.6 qt / 5.3 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 2.9 qt / 2.7 L", "spec": "80W-90 GL-4", "notes": "front diff shared with manual trans"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "80W-90 GL-5"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "AMSOIL Product Guide", "source_2": "ultimatesubaru.org", "confidence": "medium"
    },
    "EA81": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L | w/o filter: 3.2 qt / 3.0 L", "spec": "10W-40 (API SF/SG)"},
        "engine_coolant": {"qty": "capacity: 5.8 qt / 5.5 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 2.9 qt / 2.7 L", "spec": "80W-90 GL-4", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L", "spec": "DEXRON II"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "80W-90 GL-5"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "AMSOIL Product Guide", "source_2": "worldsbestoil.ca", "confidence": "medium"
    },
    "EA82": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "10W-30 | 10W-40 (API SG)"},
        "engine_coolant": {"qty": "capacity: 5.8 qt / 5.5 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 2.9 qt / 2.7 L", "spec": "80W-90 GL-4", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L", "spec": "DEXRON II"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "80W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON II ATF"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "Subaru FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EA82T": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "10W-30 | 10W-40 (API SG)"},
        "engine_coolant": {"qty": "capacity: 5.8 qt / 5.5 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 2.9 qt / 2.7 L", "spec": "80W-90 GL-4", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L", "spec": "DEXRON II"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "80W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON II ATF"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "Subaru FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EF12": {
        "engine_oil": {"qty": "w/ filter: 3.0 qt / 2.8 L", "spec": "10W-30 (API SG)"},
        "engine_coolant": {"qty": "MT: 4.5 qt / 4.3 L | ECVT: 5.2 qt / 4.9 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "FWD: 2.3 qt / 2.2 L | 4WD: 3.5 qt / 3.3 L", "spec": "80W GL-4", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 1.9 qt / 1.8 L | total FWD: 3.6 qt / 3.4 L | total 4WD: 4.3 qt / 4.1 L", "spec": "DEXRON II/III", "notes": "ECVT"},
        "rear_diff": {"qty": "capacity: 0.6 qt / 0.57 L", "spec": "80W-90 GL-5", "notes": "4WD only"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "dustysjustys.com", "source_2": "AMSOIL", "confidence": "high"
    },
    "ER27": {
        "engine_oil": {"qty": "w/ filter: 5.3 qt / 5.0 L", "spec": "10W-30 | 10W-40 (API SG)"},
        "engine_coolant": {"qty": "capacity: 5.8 qt / 5.5 L", "spec": "ethylene glycol 50/50"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.8 qt / 9.3 L", "spec": "DEXRON II"},
        "front_diff": {"qty": "capacity: 1.3 qt / 1.2 L", "spec": "80W-90 GL-5", "notes": "separate from AT"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "80W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON II ATF"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "AMSOIL", "source_2": "ultimatesubaru.org", "confidence": "medium"
    },
    "EG33": {
        "engine_oil": {"qty": "w/ filter: 6.3 qt / 6.0 L", "spec": "5W-30 (API SJ)"},
        "engine_coolant": {"qty": "capacity: 8.2 qt / 7.8 L", "spec": "Subaru coolant 50/50"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 10.0 qt / 9.5 L", "spec": "DEXRON III"},
        "front_diff": {"qty": "capacity: 1.3 qt / 1.2 L", "spec": "75W-90 GL-5", "notes": "separate from AT"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "DEXRON III ATF"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru SVX FSM", "source_2": "seccs.org", "confidence": "high"
    },
    "EJ18": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "5W-30 (API SJ/SL)"},
        "engine_coolant": {"qty": "capacity: 6.3 qt / 6.0 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Impreza FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ20": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 (API SL)"},
        "engine_coolant": {"qty": "capacity: 6.5 qt / 6.2 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared with manual trans"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3 | DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "JDM Subaru FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
    "EJ22": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "5W-30 (API SJ/SL)"},
        "engine_coolant": {"qty": "capacity: 6.5 qt / 6.2 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ22T": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "5W-30 (API SJ/SL)"},
        "engine_coolant": {"qty": "capacity: 6.5 qt / 6.2 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy Turbo FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ25D": {
        "engine_oil": {"qty": "w/ filter: 4.4 qt / 4.2 L", "spec": "5W-30 (API SJ)"},
        "engine_coolant": {"qty": "capacity: 6.8 qt / 6.4 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ251": {
        "engine_oil": {"qty": "w/ filter: 4.4 qt / 4.2 L", "spec": "5W-30 (API SL/SM)"},
        "engine_coolant": {"qty": "capacity: 6.8 qt / 6.4 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L", "spec": "Subaru ATF | DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3 | DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ253": {
        "engine_oil": {"qty": "w/ filter: 4.4 qt / 4.2 L", "spec": "5W-30 (API SM/SN)"},
        "engine_coolant": {"qty": "capacity: 6.8 qt / 6.4 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L", "spec": "Subaru ATF-HP"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L", "spec": "Subaru CVT Fluid"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Owner Manual", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ205": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SL/SM)"},
        "engine_coolant": {"qty": "capacity: 7.0 qt / 6.6 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L", "spec": "Subaru ATF-HP"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru WRX FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ207": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic"},
        "engine_coolant": {"qty": "capacity: 7.0 qt / 6.6 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 4.1 qt / 3.9 L", "spec": "75W-90 GL-5", "notes": "6MT; front diff shared"},
        "rear_diff": {"qty": "capacity: 1.1 qt / 1.0 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru PS Fluid"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "JDM STI FSM", "source_2": "iwsti.com", "confidence": "medium"
    },
    "EJ255": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SM/SN)"},
        "engine_coolant": {"qty": "capacity: 7.4 qt / 7.0 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "Subaru Extra-S 75W-90", "notes": "5MT; front diff shared"},
        "automatic_trans": {"qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L", "spec": "Subaru ATF-HP"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru WRX/Legacy FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ257": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SM/SN)"},
        "engine_coolant": {"qty": "capacity: 7.4 qt / 7.0 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 4.1 qt / 3.9 L", "spec": "Subaru Extra-S 75W-90", "notes": "6MT; front diff shared"},
        "rear_diff": {"qty": "capacity: 1.1 qt / 1.0 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru STI FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ25": {
        "engine_oil": {"qty": "w/ filter: 4.4 qt / 4.2 L", "spec": "5W-30 (API SM/SN)"},
        "engine_coolant": {"qty": "capacity: 6.8 qt / 6.4 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared with manual trans"},
        "automatic_trans": {"qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L", "spec": "Subaru ATF-HP"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L", "spec": "Subaru CVT Fluid"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "DEXRON III ATF"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Owner Manual", "source_2": "AMSOIL", "confidence": "medium"
    },
    "EZ30": {
        "engine_oil": {"qty": "w/ filter: 6.3 qt / 6.0 L", "spec": "5W-30 (API SL/SM)"},
        "engine_coolant": {"qty": "capacity: 7.6 qt / 7.2 L", "spec": "Subaru Super Coolant"},
        "automatic_trans": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 6.8 qt / 6.4 L", "spec": "Subaru ATF | DEXRON III"},
        "front_diff": {"qty": "capacity: 1.4 qt / 1.3 L", "spec": "75W-90 GL-5", "notes": "separate from AT"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "power_steering": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "DEXRON III ATF"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Outback H6 FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EZ36": {
        "engine_oil": {"qty": "w/ filter: 6.9 qt / 6.5 L", "spec": "0W-20 Synthetic (API SN)"},
        "engine_coolant": {"qty": "capacity: 7.4 qt / 7.0 L", "spec": "Subaru Super Coolant"},
        "automatic_trans": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 10.4 qt / 9.8 L", "spec": "Subaru ATF-HP"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 13.4 qt / 12.7 L", "spec": "Subaru CVT Fluid"},
        "front_diff": {"qty": "capacity: 1.4 qt / 1.3 L", "spec": "Subaru Gear Oil 75W-90", "notes": "AT only; separate"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "power_steering": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru PS Fluid", "notes": "some have EPS"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Outback/Tribeca FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "FA20": {
        "engine_oil": {"qty": "w/ filter: 5.4 qt / 5.1 L", "spec": "0W-20 Synthetic (API SN)"},
        "engine_coolant": {"qty": "MT: 7.2 qt / 6.8 L | AT: 7.5 qt / 7.1 L", "spec": "Subaru Super Coolant (blue)"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.8 qt / 12.1 L", "spec": "Subaru CVT Fluid Lineartronic II"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru WRX/BRZ FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "FA24": {
        "engine_oil": {"qty": "w/ filter: 4.8 qt / 4.5 L", "spec": "0W-20 Synthetic (API SP/SN+)"},
        "engine_coolant": {"qty": "capacity: 9.2 qt / 8.7 L", "spec": "Subaru Super Coolant (blue)"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.8 qt / 12.1 L", "spec": "Subaru CVT Fluid Lineartronic II"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-1234yf"},
        "source_1": "Subaru WRX/Outback FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "FB20": {
        "engine_oil": {"qty": "w/ filter: 4.6 qt / 4.4 L", "spec": "0W-20 Synthetic (API SN/SP)"},
        "engine_coolant": {"qty": "capacity: 8.2 qt / 7.8 L", "spec": "Subaru Super Coolant (blue)"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L", "spec": "Subaru CVT Fluid Lineartronic"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a | R-1234yf"},
        "source_1": "Subaru Impreza/Crosstrek FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "FB25": {
        "engine_oil": {"qty": "w/ filter: 4.4 qt / 4.2 L", "spec": "0W-20 Synthetic (API SN/SP)"},
        "engine_coolant": {"qty": "capacity: 7.4 qt / 7.0 L", "spec": "Subaru Super Coolant (blue)"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L", "spec": "Subaru CVT Fluid Lineartronic"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a | R-1234yf"},
        "source_1": "Subaru Forester/Outback FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "Electric": {
        "engine_coolant": {"qty": "Battery: 7.8 qt / 7.4 L | Heater: 4.2 qt / 4.0 L", "spec": "Toyota Genuine Traction Battery Coolant (Blue)"},
        "automatic_trans": {"qty": "Front eAxle: 4.1 qt / 3.9 L", "spec": "e-Transaxle Fluid TE"},
        "rear_diff": {"qty": "Rear eAxle: 3.3 qt / 3.1 L", "spec": "e-Transaxle Fluid TE"},
        "brake_fluid": {"qty": "", "spec": "DOT 3 | DOT 4"},
        "ac": {"qty": "", "spec": "R-1234yf"},
        "source_1": "Subaru Solterra FSM", "source_2": "toyota-club.net", "confidence": "high"
    },
    # ============================================================================
    # JDM ENGINES
    # ============================================================================
    # EN07 (660cc Kei)
    "EN07": {
        "engine_oil": {"qty": "w/ filter: 2.7 qt / 2.6 L", "spec": "5W-30 (API SN)"},
        "engine_coolant": {"qty": "capacity: 4.2 qt / 4.0 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 2.1 qt / 2.0 L", "spec": "75W-90 GL-4", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 2.5 qt / 2.4 L", "spec": "Subaru CVT Fluid"},
        "rear_diff": {"qty": "capacity: 0.6 qt / 0.57 L", "spec": "75W-90 GL-5", "notes": "4WD only"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Kei FSM", "source_2": "JDM specs", "confidence": "medium"
    },
    # KF (Daihatsu OEM 660cc)
    "KF": {
        "engine_oil": {"qty": "w/ filter: 2.9 qt / 2.7 L", "spec": "0W-20 (API SN)"},
        "engine_coolant": {"qty": "capacity: 4.0 qt / 3.8 L", "spec": "Toyota/Daihatsu coolant"},
        "cvt": {"qty": "drain & fill: 2.8 qt / 2.6 L", "spec": "Daihatsu CVT Fluid"},
        "rear_diff": {"qty": "capacity: 0.6 qt / 0.57 L", "spec": "75W-90 GL-5", "notes": "4WD only"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Daihatsu FSM", "source_2": "JDM specs", "confidence": "medium"
    },
    # FB16 (1.6L JDM)
    "FB16": {
        "engine_oil": {"qty": "w/ filter: 4.2 qt / 4.0 L", "spec": "0W-20 Synthetic (API SN)"},
        "engine_coolant": {"qty": "capacity: 6.8 qt / 6.4 L", "spec": "Subaru Super Coolant (blue)"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L", "spec": "Subaru CVT Fluid Lineartronic"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "Subaru Gear Oil 75W-90"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru XV FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    # CB18 (1.8L Turbo DIT - Levorg/Outback/Forester 2020+)
    "CB18": {
        "engine_oil": {"qty": "w/ filter: 5.3 qt / 5.0 L", "spec": "0W-20 Synthetic (API SP)"},
        "engine_coolant": {"qty": "capacity: 8.0 qt / 7.6 L", "spec": "Subaru Super Coolant (blue)"},
        "cvt": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 13.2 qt / 12.5 L", "spec": "Subaru CVT Fluid Lineartronic II"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "ac": {"qty": "", "spec": "R-1234yf"},
        "source_1": "Subaru Levorg 2nd Gen FSM", "source_2": "Subaru Media", "confidence": "high"
    },
    # EJ20G (2.0L JDM Turbo Phase 1)
    "EJ20G": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SL)"},
        "engine_coolant": {"qty": "capacity: 6.5 qt / 6.2 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.7 qt / 3.5 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 3 | DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru JDM WRX FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    # EJ20K (2.0L JDM Turbo Phase 1.5)
    "EJ20K": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SL)"},
        "engine_coolant": {"qty": "capacity: 7.0 qt / 6.6 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "75W-90 GL-5"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru JDM STI FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    # EJ206/EJ208 (Twin Turbo Legacy)
    "EJ206": {
        "engine_oil": {"qty": "w/ filter: 4.8 qt / 4.5 L", "spec": "5W-30 Synthetic (API SM)"},
        "engine_coolant": {"qty": "capacity: 7.2 qt / 6.8 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "automatic_trans": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 10.4 qt / 9.8 L", "spec": "Subaru ATF-HP"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "75W-90 GL-5"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy BE/BH FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ208": {
        "engine_oil": {"qty": "w/ filter: 4.8 qt / 4.5 L", "spec": "5W-30 Synthetic (API SM)"},
        "engine_coolant": {"qty": "capacity: 7.2 qt / 6.8 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "automatic_trans": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 10.4 qt / 9.8 L", "spec": "Subaru ATF-HP"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "75W-90 GL-5"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy BE/BH FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    # EJ20X/EJ20Y (Legacy BL/BP)
    "EJ20X": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SM)"},
        "engine_coolant": {"qty": "capacity: 7.2 qt / 6.8 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "Subaru Extra-S 75W-90", "notes": "front diff shared"},
        "automatic_trans": {"qty": "drain & fill: 4.0 qt / 3.8 L | total: 10.4 qt / 9.8 L", "spec": "Subaru ATF-HP"},
        "rear_diff": {"qty": "capacity: 0.9 qt / 0.85 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy BL/BP FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    "EJ20Y": {
        "engine_oil": {"qty": "w/ filter: 4.5 qt / 4.3 L", "spec": "5W-30 Synthetic (API SM)"},
        "engine_coolant": {"qty": "capacity: 7.2 qt / 6.8 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 4.1 qt / 3.9 L", "spec": "Subaru Extra-S 75W-90", "notes": "6MT; front diff shared"},
        "rear_diff": {"qty": "capacity: 1.0 qt / 0.95 L", "spec": "Subaru Gear Oil 75W-90"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru Legacy Spec.B FSM", "source_2": "AMSOIL", "confidence": "high"
    },
    # EL15 (1.5L JDM Impreza)
    "EL15": {
        "engine_oil": {"qty": "w/ filter: 3.8 qt / 3.6 L", "spec": "5W-30 (API SL/SM)"},
        "engine_coolant": {"qty": "capacity: 5.8 qt / 5.5 L", "spec": "Subaru Super Coolant"},
        "manual_trans": {"qty": "capacity: 3.2 qt / 3.0 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "cvt": {"qty": "drain & fill: 3.5 qt / 3.3 L", "spec": "Subaru CVT Fluid"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "clutch": {"qty": "capacity: 0.2 qt / 0.19 L", "spec": "DOT 4"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru JDM Impreza FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
    # EJ15/EJ16 (Small displacement JDM)
    "EJ15": {
        "engine_oil": {"qty": "w/ filter: 3.8 qt / 3.6 L", "spec": "5W-30 (API SJ)"},
        "engine_coolant": {"qty": "capacity: 5.6 qt / 5.3 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.2 qt / 3.0 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.0 qt / 8.5 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru JDM Impreza FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
    "EJ16": {
        "engine_oil": {"qty": "w/ filter: 3.8 qt / 3.6 L", "spec": "5W-30 (API SJ)"},
        "engine_coolant": {"qty": "capacity: 5.6 qt / 5.3 L", "spec": "Subaru coolant 50/50"},
        "manual_trans": {"qty": "capacity: 3.2 qt / 3.0 L", "spec": "75W-90 GL-5", "notes": "front diff shared"},
        "automatic_trans": {"qty": "initial fill: 2.6 qt / 2.5 L | total: 9.0 qt / 8.5 L", "spec": "DEXRON III"},
        "rear_diff": {"qty": "capacity: 0.8 qt / 0.76 L", "spec": "75W-90 GL-5"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Subaru JDM Impreza FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
    # EF10 (1.0L Justy)
    "EF10": {
        "engine_oil": {"qty": "w/ filter: 2.8 qt / 2.6 L", "spec": "10W-30 (API SG)"},
        "engine_coolant": {"qty": "capacity: 4.2 qt / 4.0 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 2.0 qt / 1.9 L", "spec": "80W GL-4", "notes": "front diff shared"},
        "rear_diff": {"qty": "capacity: 0.6 qt / 0.57 L", "spec": "80W-90 GL-5", "notes": "4WD only"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "Subaru Justy FSM", "source_2": "dustysjustys.com", "confidence": "medium"
    },
    # EN05 (550cc old Kei)
    "EN05": {
        "engine_oil": {"qty": "w/ filter: 2.5 qt / 2.4 L", "spec": "10W-30 (API SF/SG)"},
        "engine_coolant": {"qty": "capacity: 3.8 qt / 3.6 L", "spec": "ethylene glycol 50/50"},
        "manual_trans": {"qty": "capacity: 1.8 qt / 1.7 L", "spec": "80W GL-4", "notes": "front diff shared"},
        "rear_diff": {"qty": "capacity: 0.5 qt / 0.47 L", "spec": "80W-90 GL-5", "notes": "4WD only"},
        "ac": {"qty": "", "spec": "R-12"},
        "source_1": "Subaru Rex FSM", "source_2": "JDM specs", "confidence": "low"
    },
    # Toyota OEM engines (Trezia)
    "1NR-FE": {
        "engine_oil": {"qty": "w/ filter: 3.4 qt / 3.2 L", "spec": "0W-20 (API SN)"},
        "engine_coolant": {"qty": "capacity: 5.2 qt / 4.9 L", "spec": "Toyota Super Long Life"},
        "cvt": {"qty": "drain & fill: 3.0 qt / 2.8 L", "spec": "Toyota CVT Fluid FE"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Toyota FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
    "1NZ-FE": {
        "engine_oil": {"qty": "w/ filter: 3.7 qt / 3.5 L", "spec": "0W-20 (API SN)"},
        "engine_coolant": {"qty": "capacity: 5.4 qt / 5.1 L", "spec": "Toyota Super Long Life"},
        "cvt": {"qty": "drain & fill: 3.0 qt / 2.8 L", "spec": "Toyota CVT Fluid FE"},
        "ac": {"qty": "", "spec": "R-134a"},
        "source_1": "Toyota FSM", "source_2": "AMSOIL", "confidence": "medium"
    },
}


def get_engine_base(engine_code):
    if not engine_code:
        return ""
    code = engine_code.strip()
    
    # JDM-specific direct mappings first
    jdm_patterns = [
        ("1NR-FE", "1NR-FE"), ("1NZ-FE", "1NZ-FE"),
        ("EN07", "EN07"), ("EN05", "EN05"),
        ("KF", "KF"),
        ("CB18", "CB18"), ("FB16", "FB16"),
        ("EJ20G", "EJ20G"), ("EJ20K", "EJ20K"),
        ("EJ206", "EJ206"), ("EJ208", "EJ208"),
        ("EJ20X", "EJ20X"), ("EJ20Y", "EJ20Y"),
        ("EL15", "EL15"), ("EF10", "EF10"),
        ("EJ15", "EJ15"), ("EJ16", "EJ16"),
    ]
    for pattern, result in jdm_patterns:
        if pattern in code:
            return result
    
    # Standard engine patterns
    patterns = [
        ("EA71", "EA71"), ("EA82T", "EA82T"), ("EA82", "EA82"), ("EA81", "EA81"),
        ("EF12", "EF12"), ("ER27", "ER27"), ("EG33", "EG33"),
        ("FA24", "FA24"), ("FA20", "FA20"), ("FB25", "FB25"), ("FB20", "FB20"),
        ("Electric", "Electric"),
        ("EZ36", "EZ36"), ("EZ30", "EZ30"),
        ("EJ257", "EJ257"), ("EJ255", "EJ255"), ("EJ207", "EJ207"), ("EJ205", "EJ205"),
        ("EJ253", "EJ253"), ("EJ252", "EJ253"), ("EJ251", "EJ251"), ("EJ25D", "EJ25D"), ("EJ25", "EJ25"),
        ("EJ22T", "EJ22T"), ("EJ22", "EJ22"), ("EJ18", "EJ18"), ("EJ20", "EJ20"),
    ]
    for pattern, result in patterns:
        if pattern in code:
            if pattern == "EJ22" and "Turbo" in code:
                return "EJ22T"
            if pattern == "EJ20" and "Turbo" in code:
                return "EJ20"
            return result
    return ""


def extract_market(trim):
    t = trim.upper()
    if "(US)" in t or "USDM" in t: return "USDM"
    if "(JDM)" in t or "JDM" in t: return "JDM"
    return ""

def has_mt(trim, model, eng): return model not in ["SVX", "XT6"]
def has_at(trim, model, eng): return "STI" not in trim.upper()
def is_awd(trim, model):
    t = trim.upper()
    if "FWD" in t or "2WD" in t: return False
    if model in ["SVX", "Legacy", "Forester", "Outback", "Ascent", "Crosstrek", "Baja", "Tribeca", "Solterra", "WRX"]: return True
    if model == "Impreza" and any(x in t for x in ["WRX", "STI", "RS", "OUTBACK"]): return True
    if model == "Justy": return "4WD" in t or "AWD" in t
    if model in ["BRAT", "GL", "GL-10", "XT", "XT6"]: return True
    return True

def create_row(v):
    year = v.get("year", "")
    make = v.get("make", "Subaru")
    model = v.get("model", "")
    trim = v.get("trim", "")
    engine_code = v.get("engineCode", "")
    market = extract_market(trim)
    eng = get_engine_base(engine_code)
    specs = ENGINE_SPECS.get(eng, {})
    
    mt, at, awd = has_mt(trim, model, engine_code), has_at(trim, model, engine_code), is_awd(trim, model)
    notes_parts = []
    
    # Helper to get qty and spec
    def get_fluid(key):
        f = specs.get(key, {})
        return f.get("qty", ""), f.get("spec", ""), f.get("notes", "")
    
    oil_qty, oil_spec, oil_note = get_fluid("engine_oil")
    cool_qty, cool_spec, _ = get_fluid("engine_coolant")
    mt_qty, mt_spec, mt_note = get_fluid("manual_trans")
    at_qty, at_spec, at_note = get_fluid("automatic_trans")
    cvt_qty, cvt_spec, _ = get_fluid("cvt")
    fd_qty, fd_spec, fd_note = get_fluid("front_diff")
    rd_qty, rd_spec, rd_note = get_fluid("rear_diff")
    ps_qty, ps_spec, ps_note = get_fluid("power_steering")
    cl_qty, cl_spec, _ = get_fluid("clutch")
    ac_qty, ac_spec, _ = get_fluid("ac")
    
    if oil_note: notes_parts.append(f"engine oil: {oil_note}")
    if mt_note and mt: notes_parts.append(mt_note)
    if at_note and at: notes_parts.append(f"AT: {at_note}")
    if fd_note: notes_parts.append(fd_note)
    if rd_note and awd: notes_parts.append(f"rear diff: {rd_note}")
    if ps_note: notes_parts.append(ps_note)
    if not ps_qty and eng in ["FA20", "FA24", "FB20", "FB25"]: notes_parts.append("EPS (no PS fluid)")
    if not awd and model not in ["SVX", "XT6"]: notes_parts.append("FWD (no rear diff)")
    notes_parts.append("washer: fill to max")
    
    row = {
        "year": year, "make": make, "model": model, "trim": trim, "body": "", "market": market,
        "engine_oil_qty": oil_qty, "engine_oil_unit": oil_spec,
        "engine_coolant_qty": cool_qty, "engine_coolant_unit": cool_spec,
        "brake_fluid_qty": "", "brake_fluid_unit": "DOT 3 | DOT 4" if eng else "",
        "washer_fluid_qty": "", "washer_fluid_unit": "",
        "power_steering_fluid_qty": ps_qty if ps_note != "EPS" else "", "power_steering_fluid_unit": ps_spec if ps_qty else "",
        "clutch_hydraulic_fluid_qty": cl_qty if mt else "", "clutch_hydraulic_fluid_unit": cl_spec if mt and cl_qty else "",
        "manual_trans_fluid_qty": mt_qty if mt else "", "manual_trans_fluid_unit": mt_spec if mt and mt_qty else "",
        "automatic_trans_fluid_qty": at_qty if at and not cvt_qty else "", "automatic_trans_fluid_unit": at_spec if at and at_qty and not cvt_qty else "",
        "cvt_fluid_qty": cvt_qty if at else "", "cvt_fluid_unit": cvt_spec if at and cvt_qty else "",
        "front_diff_fluid_qty": fd_qty, "front_diff_fluid_unit": fd_spec if fd_qty else "",
        "rear_diff_fluid_qty": rd_qty if awd else "", "rear_diff_fluid_unit": rd_spec if awd and rd_qty else "",
        "center_diff_or_transfer_fluid_qty": "", "center_diff_or_transfer_fluid_unit": "",
        "ac_refrigerant_qty": "", "ac_refrigerant_unit": ac_spec,
        "ac_compressor_oil_qty": "", "ac_compressor_oil_unit": "",
        "notes": "; ".join(notes_parts),
        "source_1": specs.get("source_1", ""),
        "source_2": specs.get("source_2", ""),
        "confidence": specs.get("confidence", "low") if eng else "low"
    }
    return row

def main():
    print("Loading vehicles.json...")
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    print(f"Found {len(vehicles)} vehicles")
    
    vehicles_sorted = sorted(vehicles, key=lambda v: (v.get("year", 9999), v.get("make", ""), v.get("model", ""), v.get("trim", "")))
    
    print("Generating fluids rows with proper fluid specs...")
    rows, seen = [], set()
    for v in vehicles_sorted:
        row = create_row(v)
        key = (row["year"], row["make"], row["model"], row["trim"], row["body"], row["market"])
        if key in seen:
            continue
        seen.add(key)
        rows.append(row)
    
    print(f"Writing {len(rows)} rows to fluids.csv...")
    FLUIDS_CSV.parent.mkdir(parents=True, exist_ok=True)
    
    with open(FLUIDS_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=HEADER, quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(rows)
    
    print(f"Done! Written to {FLUIDS_CSV}")
    
    # Validation
    with_oil = sum(1 for r in rows if r["engine_oil_qty"])
    with_spec = sum(1 for r in rows if r["engine_oil_unit"] and "combo" not in r["engine_oil_unit"].lower())
    print(f"\nValidation:")
    print(f"  Rows with engine oil qty: {with_oil}/{len(rows)}")
    print(f"  Rows with proper oil spec (not combo): {with_spec}/{len(rows)}")
    
    # Check for combo+condition
    bad = [r for r in rows if "combo" in str(r.get("engine_oil_unit", "")).lower()]
    if bad:
        print(f"  ERROR: {len(bad)} rows still have 'combo' in unit!")
    else:
        print("  OK: No 'combo+condition' in any unit column!")

if __name__ == "__main__":
    main()
