#!/usr/bin/env python3
"""
FluidsYMMTFitmentWriter Script
Generates fluids.csv from vehicles.json with OEM-based fluid specifications.
Starts with oldest models first (1978+).
"""

import json
import csv
import os
from pathlib import Path

# Paths
SCRIPT_DIR = Path(__file__).parent
REPO_ROOT = SCRIPT_DIR.parent
VEHICLES_JSON = REPO_ROOT / "assets" / "seed" / "vehicles.json"
FLUIDS_CSV = REPO_ROOT / "assets" / "seed" / "specs" / "fitment" / "fluids.csv"

# CSV Header (exact as specified)
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

# Engine-based fluid specs (researched from OEM and reputable sources)
# Format: { engine_code_pattern: { fluid_type: { qty, unit, notes } } }

ENGINE_SPECS = {
    # EA71 (1.6L) - 1978-1979 BRAT
    "EA71": {
        "engine_oil": {
            "qty": "w/ filter: 3.8 qt / 3.6 L",
            "notes": "flat tappet engine; zinc additive recommended"
        },
        "engine_coolant": {
            "qty": "capacity: 5.6 qt / 5.3 L"
        },
        "manual_trans": {
            "qty": "capacity: 2.9 qt / 2.7 L",
            "notes": "front diff shared with manual trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "",  # Likely manual steering on these years
            "notes": ""
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "ultimatesubaru.org forums",
        "confidence": "medium"
    },
    
    # EA81 (1.8L) - 1980-1984 BRAT
    "EA81": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L | w/o filter: 3.2 qt / 3.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 5.8 qt / 5.5 L"
        },
        "manual_trans": {
            "qty": "capacity: 2.9 qt / 2.7 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "",
            "notes": ""
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "worldsbestoil.ca specifications",
        "confidence": "medium"
    },
    
    # EA82 (1.8L SOHC) - 1985-1994
    "EA82": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 5.8 qt / 5.5 L"
        },
        "manual_trans": {
            "qty": "capacity: 2.9 qt / 2.7 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Factory Service Manual",
        "confidence": "high"
    },
    
    # EA82T (1.8L Turbo) - 1985-1991
    "EA82T": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 5.8 qt / 5.5 L"
        },
        "manual_trans": {
            "qty": "capacity: 2.9 qt / 2.7 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "drain & fill: 2.6 qt / 2.5 L | total (dry): 10.0 qt / 9.5 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Factory Service Manual",
        "confidence": "high"
    },
    
    # EF12 (1.2L 3-cyl) - 1987-1994 Justy
    "EF12": {
        "engine_oil": {
            "qty": "w/ filter: 3.0 qt / 2.8 L"
        },
        "engine_coolant": {
            "qty": "MT: 4.5 qt / 4.3 L | ECVT: 5.2 qt / 4.9 L"
        },
        "manual_trans": {
            "qty": "FWD: 2.3 qt / 2.2 L | 4WD: 3.5 qt / 3.3 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 1.9 qt / 1.8 L | total FWD: 3.6 qt / 3.4 L | total 4WD: 4.3 qt / 4.1 L",
            "notes": "ECVT (CVT predecessor)"
        },
        "rear_diff": {
            "qty": "capacity: 0.6 qt / 0.57 L",
            "notes": "4WD only"
        },
        "power_steering": {
            "qty": "",
            "notes": "manual steering standard"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "dustysjustys.com specifications",
        "confidence": "high"
    },
    
    # ER27 (2.7L Flat-6) - 1988-1991 XT6
    "ER27": {
        "engine_oil": {
            "qty": "w/ filter: 5.3 qt / 5.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 5.8 qt / 5.5 L"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.8 qt / 9.3 L"
        },
        "front_diff": {
            "qty": "capacity: 1.3 qt / 1.2 L",
            "notes": "separate from automatic trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "ultimatesubaru.org forums",
        "confidence": "medium"
    },
    
    # EJ22 (2.2L) - 1990-1999 Legacy, Impreza
    "EJ22": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.5 qt / 6.2 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L"
        },
        "front_diff": {
            "qty": "",
            "notes": "MT: shared with trans; AT: capacity 1.3 qt / 1.2 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Legacy FSM",
        "confidence": "high"
    },
    
    # EJ22T (2.2L Turbo) - 1991-1994 Legacy Turbo
    "EJ22T": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.5 qt / 6.2 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Legacy Turbo FSM",
        "confidence": "high"
    },
    
    # EG33 (3.3L Flat-6) - 1991-1997 SVX
    "EG33": {
        "engine_oil": {
            "qty": "w/ filter: 6.3 qt / 6.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 8.2 qt / 7.8 L"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 10.0 qt / 9.5 L"
        },
        "front_diff": {
            "qty": "capacity: 1.3 qt / 1.2 L",
            "notes": "separate from automatic trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "seccs.org SVX Club specifications",
        "confidence": "high"
    },
    
    # EJ18 (1.8L) - 1993-2001 Impreza base
    "EJ18": {
        "engine_oil": {
            "qty": "w/ filter: 4.2 qt / 4.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.3 qt / 6.0 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Impreza FSM",
        "confidence": "high"
    },
    
    # EJ20 variants (2.0L Turbo) - JDM WRX/STI
    "EJ20": {
        "engine_oil": {
            "qty": "w/ filter: 4.5 qt / 4.3 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.5 qt / 6.2 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "JDM Subaru Service Manual",
        "source_2": "AMSOIL Product Guide",
        "confidence": "medium"
    },
    
    # EJ25D (2.5L DOHC) - 1996-1999
    "EJ25D": {
        "engine_oil": {
            "qty": "w/ filter: 4.4 qt / 4.2 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.8 qt / 6.4 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Outback/Legacy FSM",
        "confidence": "high"
    },
    
    # EJ251 (2.5L SOHC) - 1999-2005
    "EJ251": {
        "engine_oil": {
            "qty": "w/ filter: 4.4 qt / 4.2 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.8 qt / 6.4 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Forester/Legacy FSM",
        "confidence": "high"
    },
    
    # EJ252/EJ253 (2.5L SOHC) - 2004-2011
    "EJ253": {
        "engine_oil": {
            "qty": "w/ filter: 4.4 qt / 4.2 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.8 qt / 6.4 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Owner's Manual",
        "confidence": "high"
    },
    
    # EJ205 (2.0L Turbo) - 2002-2005 WRX, 2004-2008 Forester XT
    "EJ205": {
        "engine_oil": {
            "qty": "w/ filter: 4.5 qt / 4.3 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.0 qt / 6.6 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru WRX FSM",
        "confidence": "high"
    },
    
    # EJ207 (2.0L Turbo JDM) - JDM STI
    "EJ207": {
        "engine_oil": {
            "qty": "w/ filter: 4.5 qt / 4.3 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.0 qt / 6.6 L"
        },
        "manual_trans": {
            "qty": "capacity: 4.1 qt / 3.9 L",
            "notes": "6MT; front diff shared with manual trans"
        },
        "rear_diff": {
            "qty": "capacity: 1.1 qt / 1.0 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "JDM Subaru Service Manual",
        "source_2": "iwsti.com specifications",
        "confidence": "medium"
    },
    
    # EJ255 (2.5L Turbo) - 2006-2014 WRX, Forester XT, Legacy GT
    "EJ255": {
        "engine_oil": {
            "qty": "w/ filter: 4.5 qt / 4.3 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.4 qt / 7.0 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.8 qt / 3.6 L",
            "notes": "5MT; front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru WRX/Legacy FSM",
        "confidence": "high"
    },
    
    # EJ257 (2.5L Turbo STI) - 2004+ STI
    "EJ257": {
        "engine_oil": {
            "qty": "w/ filter: 4.5 qt / 4.3 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.4 qt / 7.0 L"
        },
        "manual_trans": {
            "qty": "capacity: 4.1 qt / 3.9 L",
            "notes": "6MT; front diff shared with manual trans"
        },
        "rear_diff": {
            "qty": "capacity: 1.1 qt / 1.0 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru STI FSM",
        "confidence": "high"
    },
    
    # EJ25 generic (2.5L NA) - fallback for unspecified EJ25
    "EJ25": {
        "engine_oil": {
            "qty": "w/ filter: 4.4 qt / 4.2 L"
        },
        "engine_coolant": {
            "qty": "capacity: 6.8 qt / 6.4 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "automatic_trans": {
            "qty": "initial fill: 3.5 qt / 3.3 L | total: 9.8 qt / 9.3 L"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Owner's Manual",
        "confidence": "medium"
    },
    
    # EZ30 (3.0L H6) - 2001-2009 Outback/Legacy H6
    "EZ30": {
        "engine_oil": {
            "qty": "w/ filter: 6.3 qt / 6.0 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.6 qt / 7.2 L"
        },
        "automatic_trans": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 6.8 qt / 6.4 L"
        },
        "front_diff": {
            "qty": "capacity: 1.4 qt / 1.3 L",
            "notes": "separate from automatic trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Outback H6 FSM",
        "confidence": "high"
    },
    
    # EZ36 (3.6L H6) - 2010+ Outback/Legacy/Tribeca H6
    "EZ36": {
        "engine_oil": {
            "qty": "w/ filter: 6.9 qt / 6.5 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.4 qt / 7.0 L"
        },
        "automatic_trans": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 10.4 qt / 9.8 L"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 13.4 qt / 12.7 L"
        },
        "front_diff": {
            "qty": "capacity: 1.4 qt / 1.3 L",
            "notes": "AT only; separate from automatic trans"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "capacity: 0.9 qt / 0.85 L",
            "notes": "some models have EPS (no PS fluid)"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Outback/Tribeca FSM",
        "confidence": "high"
    },
    
    # FA20 (2.0L DIT Turbo) - 2015+ WRX, 2013+ BRZ/86
    "FA20": {
        "engine_oil": {
            "qty": "w/ filter: 5.4 qt / 5.1 L"
        },
        "engine_coolant": {
            "qty": "MT: 7.2 qt / 6.8 L | AT: 7.5 qt / 7.1 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.8 qt / 12.1 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "power_steering": {
            "qty": "",
            "notes": "EPS (no PS fluid)"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru WRX/BRZ FSM",
        "confidence": "high"
    },
    
    # FA24 (2.4L DIT Turbo) - 2020+ Outback XT, Ascent, 2022+ WRX, 2022+ BRZ
    "FA24": {
        "engine_oil": {
            "qty": "w/ filter: 4.8 qt / 4.5 L"
        },
        "engine_coolant": {
            "qty": "capacity: 9.2 qt / 8.7 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.8 qt / 12.1 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.9 qt / 0.85 L"
        },
        "power_steering": {
            "qty": "",
            "notes": "EPS (no PS fluid)"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru WRX/Outback FSM",
        "confidence": "high"
    },
    
    # FB20 (2.0L DI) - 2012+ Impreza, Crosstrek, Forester
    "FB20": {
        "engine_oil": {
            "qty": "w/ filter: 4.6 qt / 4.4 L"
        },
        "engine_coolant": {
            "qty": "capacity: 8.2 qt / 7.8 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "",
            "notes": "EPS (no PS fluid)"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Impreza/Crosstrek FSM",
        "confidence": "high"
    },
    
    # FB25 (2.5L DI) - 2011+ Forester, Outback, Legacy
    "FB25": {
        "engine_oil": {
            "qty": "w/ filter: 4.4 qt / 4.2 L"
        },
        "engine_coolant": {
            "qty": "capacity: 7.4 qt / 7.0 L"
        },
        "manual_trans": {
            "qty": "capacity: 3.7 qt / 3.5 L",
            "notes": "front diff shared with manual trans"
        },
        "cvt": {
            "qty": "drain & fill: 4.0 qt / 3.8 L | total: 12.0 qt / 11.4 L"
        },
        "rear_diff": {
            "qty": "capacity: 0.8 qt / 0.76 L"
        },
        "power_steering": {
            "qty": "",
            "notes": "EPS (no PS fluid)"
        },
        "clutch_hydraulic": {
            "qty": "capacity: 0.2 qt / 0.19 L",
            "notes": "DOT 3 or DOT 4 brake fluid"
        },
        "source_1": "AMSOIL Product Guide",
        "source_2": "Subaru Forester/Outback FSM",
        "confidence": "high"
    },
}


def get_engine_base(engine_code: str) -> str:
    """Extract base engine code from full engine code string."""
    if not engine_code:
        return ""
    
    # Clean up engine code
    code = engine_code.strip()
    
    # Handle specific patterns (order matters - more specific first)
    
    # EA series (1970s-1990s)
    if "EA71" in code:
        return "EA71"
    elif "EA81" in code and "EA82" not in code:
        return "EA81"
    elif "EA82T" in code or "EA82 Turbo" in code.upper():
        return "EA82T"
    elif "EA82" in code:
        return "EA82"
    
    # EF series (Justy)
    elif "EF12" in code:
        return "EF12"
    
    # ER series (XT6)
    elif "ER27" in code:
        return "ER27"
    
    # EG series (SVX)
    elif "EG33" in code:
        return "EG33"
    
    # FA series (2012+)
    elif "FA24" in code:
        return "FA24"
    elif "FA20" in code:
        return "FA20"
    
    # FB series (2011+)
    elif "FB25" in code:
        return "FB25"
    elif "FB20" in code:
        return "FB20"
    
    # EZ series (H6)
    elif "EZ36" in code:
        return "EZ36"
    elif "EZ30" in code:
        return "EZ30"
    
    # EJ Turbo variants (specific first)
    elif "EJ257" in code:
        return "EJ257"
    elif "EJ255" in code:
        return "EJ255"
    elif "EJ207" in code:
        return "EJ207"
    elif "EJ205" in code:
        return "EJ205"
    elif "EJ22T" in code or ("EJ22" in code and "Turbo" in code):
        return "EJ22T"
    
    # EJ NA variants
    elif "EJ253" in code or "EJ252" in code:
        return "EJ253"
    elif "EJ251" in code:
        return "EJ251"
    elif "EJ25D" in code:
        return "EJ25D"
    elif "EJ25" in code and "NA" in code:
        return "EJ25"
    elif "EJ25" in code:
        return "EJ25"  # Fallback for generic EJ25
    elif "EJ22" in code:
        return "EJ22"
    elif "EJ18" in code:
        return "EJ18"
    elif "EJ20" in code and "Turbo" in code:
        return "EJ20"
    elif "EJ20" in code:
        return "EJ20"
    elif "EJ15" in code or "EJ16" in code:
        return "EJ18"  # Similar specs to EJ18 for JDM NA variants
    
    return ""



def extract_market(trim: str) -> str:
    """Extract market from trim string."""
    trim_upper = trim.upper()
    if "(US)" in trim_upper or "USDM" in trim_upper:
        return "USDM"
    elif "(JDM)" in trim_upper or "JDM" in trim_upper:
        return "JDM"
    elif "(EUDM)" in trim_upper:
        return "EUDM"
    elif "(AUDM)" in trim_upper:
        return "AUDM"
    return ""


def has_manual_trans(trim: str, model: str, engine_code: str) -> bool:
    """Determine if vehicle likely has manual transmission available."""
    # Most early Subarus had MT available
    # SVX was auto-only in US
    if model == "SVX":
        return False
    if model == "XT6":
        return False  # Auto only for XT6
    return True  # Default: MT available


def has_auto_trans(trim: str, model: str, engine_code: str) -> bool:
    """Determine if vehicle likely has automatic transmission available."""
    # Most models had AT available
    if "STI" in trim.upper():
        return False  # STI typically MT only
    return True


def is_4wd(trim: str, model: str) -> bool:
    """Determine if vehicle is AWD/4WD."""
    trim_upper = trim.upper()
    # Most Subarus are AWD, but early models varied
    if "FWD" in trim_upper or "2WD" in trim_upper:
        return False
    # SVX, Legacy, most Imprezas are AWD
    if model in ["SVX", "Legacy", "Forester"]:
        return True
    if model == "Impreza" and ("WRX" in trim_upper or "STI" in trim_upper or "RS" in trim_upper):
        return True
    if model == "Justy":
        # Justy could be FWD or 4WD
        if "4WD" in trim_upper or "AWD" in trim_upper:
            return True
        return False  # Default to FWD for Justy
    # BRAT, GL, XT were typically 4WD
    if model in ["BRAT", "GL", "GL-10", "XT"]:
        return True
    return True  # Default to AWD


def create_fluid_row(vehicle: dict) -> dict:
    """Create a fluids CSV row for a vehicle."""
    year = vehicle.get("year", "")
    make = vehicle.get("make", "Subaru")
    model = vehicle.get("model", "")
    trim = vehicle.get("trim", "")
    engine_code = vehicle.get("engineCode", "")
    
    # Extract market and body from trim or set defaults
    market = extract_market(trim)
    body = ""  # Not explicitly in vehicles.json; leave blank
    
    # Get engine base for specs lookup
    engine_base = get_engine_base(engine_code)
    specs = ENGINE_SPECS.get(engine_base, {})
    
    # Determine transmission/drivetrain characteristics
    has_mt = has_manual_trans(trim, model, engine_code)
    has_at = has_auto_trans(trim, model, engine_code)
    is_awd = is_4wd(trim, model)
    
    # Build the row
    row = {
        "year": year,
        "make": make,
        "model": model,
        "trim": trim,
        "body": body,
        "market": market,
        "engine_oil_qty": specs.get("engine_oil", {}).get("qty", ""),
        "engine_oil_unit": "combo+condition" if specs.get("engine_oil", {}).get("qty") else "",
        "engine_coolant_qty": specs.get("engine_coolant", {}).get("qty", ""),
        "engine_coolant_unit": "combo+condition" if specs.get("engine_coolant", {}).get("qty") else "",
        "brake_fluid_qty": "",  # Usually not specified by capacity
        "brake_fluid_unit": "",
        "washer_fluid_qty": "",  # Usually just "fill to max"
        "washer_fluid_unit": "",
        "power_steering_fluid_qty": specs.get("power_steering", {}).get("qty", "") if specs.get("power_steering", {}).get("notes", "") != "manual steering standard" else "",
        "power_steering_fluid_unit": "combo+condition" if specs.get("power_steering", {}).get("qty") else "",
        "clutch_hydraulic_fluid_qty": specs.get("clutch_hydraulic", {}).get("qty", "") if has_mt else "",
        "clutch_hydraulic_fluid_unit": "combo+condition" if (has_mt and specs.get("clutch_hydraulic", {}).get("qty")) else "",
        "manual_trans_fluid_qty": specs.get("manual_trans", {}).get("qty", "") if has_mt else "",
        "manual_trans_fluid_unit": "combo+condition" if (has_mt and specs.get("manual_trans", {}).get("qty")) else "",
        "automatic_trans_fluid_qty": specs.get("automatic_trans", {}).get("qty", "") if has_at else "",
        "automatic_trans_fluid_unit": "combo+condition" if (has_at and specs.get("automatic_trans", {}).get("qty")) else "",
        "cvt_fluid_qty": specs.get("cvt", {}).get("qty", "") if has_at else "",
        "cvt_fluid_unit": "combo+condition" if (has_at and specs.get("cvt", {}).get("qty")) else "",
        "front_diff_fluid_qty": specs.get("front_diff", {}).get("qty", ""),
        "front_diff_fluid_unit": "combo+condition" if specs.get("front_diff", {}).get("qty") else "",
        "rear_diff_fluid_qty": specs.get("rear_diff", {}).get("qty", "") if is_awd else "",
        "rear_diff_fluid_unit": "combo+condition" if (is_awd and specs.get("rear_diff", {}).get("qty")) else "",
        "center_diff_or_transfer_fluid_qty": "",  # Usually integrated
        "center_diff_or_transfer_fluid_unit": "",
        "ac_refrigerant_qty": "",  # Not researched for this batch
        "ac_refrigerant_unit": "",
        "ac_compressor_oil_qty": "",
        "ac_compressor_oil_unit": "",
        "notes": "",
        "source_1": specs.get("source_1", ""),
        "source_2": specs.get("source_2", ""),
        "confidence": specs.get("confidence", "low") if engine_base else "low"
    }
    
    # Build notes from various sources
    notes_parts = []
    if specs.get("engine_oil", {}).get("notes"):
        notes_parts.append(f"engine oil: {specs['engine_oil']['notes']}")
    if specs.get("manual_trans", {}).get("notes") and has_mt:
        notes_parts.append(specs['manual_trans']['notes'])
    if specs.get("automatic_trans", {}).get("notes") and has_at:
        notes_parts.append(f"AT: {specs['automatic_trans']['notes']}")
    if specs.get("front_diff", {}).get("notes"):
        notes_parts.append(specs['front_diff']['notes'])
    if specs.get("rear_diff", {}).get("notes") and is_awd:
        notes_parts.append(f"rear diff: {specs['rear_diff']['notes']}")
    if specs.get("power_steering", {}).get("notes"):
        notes_parts.append(specs['power_steering']['notes'])
    if not is_awd and model != "SVX":
        notes_parts.append("FWD (no rear diff)")
    
    # Add washer fluid note
    notes_parts.append("washer: fill to max")
    
    row["notes"] = "; ".join(notes_parts)
    
    return row


def main():
    """Main function to generate fluids.csv."""
    print("Loading vehicles.json...")
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        vehicles = json.load(f)
    
    print(f"Found {len(vehicles)} vehicles")
    
    # Sort by year, make, model, trim, body, market (oldest first)
    vehicles_sorted = sorted(vehicles, key=lambda v: (
        v.get("year", 9999),
        v.get("make", ""),
        v.get("model", ""),
        v.get("trim", ""),
        "",  # body
        extract_market(v.get("trim", ""))
    ))
    
    print("Generating fluids rows...")
    rows = []
    seen_keys = set()
    
    for vehicle in vehicles_sorted:
        row = create_fluid_row(vehicle)
        
        # Create uniqueness key
        key = (
            row["year"],
            row["make"],
            row["model"],
            row["trim"],
            row["body"],
            row["market"]
        )
        
        if key in seen_keys:
            print(f"  Skipping duplicate: {key}")
            continue
        
        seen_keys.add(key)
        rows.append(row)
    
    print(f"Writing {len(rows)} rows to fluids.csv...")
    
    # Ensure directory exists
    FLUIDS_CSV.parent.mkdir(parents=True, exist_ok=True)
    
    with open(FLUIDS_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=HEADER)
        writer.writeheader()
        writer.writerows(rows)
    
    print(f"Done! Written to {FLUIDS_CSV}")
    
    # Validation
    print("\nValidation:")
    print(f"  Total rows: {len(rows)}")
    print(f"  Unique YMMT keys: {len(seen_keys)}")
    
    # Check for rows with specs
    rows_with_oil = sum(1 for r in rows if r["engine_oil_qty"])
    rows_with_coolant = sum(1 for r in rows if r["engine_coolant_qty"])
    rows_with_mt = sum(1 for r in rows if r["manual_trans_fluid_qty"])
    rows_with_at = sum(1 for r in rows if r["automatic_trans_fluid_qty"])
    
    print(f"  Rows with engine oil specs: {rows_with_oil}")
    print(f"  Rows with coolant specs: {rows_with_coolant}")
    print(f"  Rows with MT fluid specs: {rows_with_mt}")
    print(f"  Rows with AT fluid specs: {rows_with_at}")


if __name__ == "__main__":
    main()
