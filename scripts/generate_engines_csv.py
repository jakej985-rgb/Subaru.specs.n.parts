#!/usr/bin/env python3
"""
EnginesYMMTFitmentWriter v1
Generates engines.csv with YMMT engine specs (US + Metric in same cell).
"""

import json
import csv
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
REPO_ROOT = SCRIPT_DIR.parent
VEHICLES_JSON = REPO_ROOT / "assets" / "seed" / "vehicles.json"
ENGINES_CSV = REPO_ROOT / "assets" / "seed" / "specs" / "fitment" / "engines.csv"

HEADER = [
    "year", "make", "model", "trim", "body", "market",
    "engine_code", "engine_family", "engine_phase", "displacement", "cyl_config",
    "power", "torque", "induction", "fuel_system", "compression_ratio",
    "bore", "stroke", "head_config", "valvetrain", "timing_drive",
    "redline", "oil_viscosity", "oil_spec", "coolant_spec",
    "spark_plug", "plug_gap", "notes", "source_1", "source_2", "confidence"
]

# Helper to infer cylinder configuration when not explicitly provided
def infer_cyl_config(family):
    """Return a human readable cylinder/config string based on engine family.
    Known families:
    - EA, EJ, EZ, FA, FB, CB: flat (boxer)
    - EN, KF: flat (boxer) for kei
    - 1NR, 1NZ: inline (I4)
    Fallback: unknown
    """
    if not family:
        return "unknown"
    f = family.upper()
    
    # Electric
    if "EV" in f: return "Electric Motor"
    
    # 6-cylinder boxers
    if f.startswith(("EZ", "EG", "ER")):
        return "6 cyl boxer"
        
    # 4-cylinder boxers
    if f.startswith(("EA", "EJ", "FA", "FB", "CB", "EL")):
        return "4 cyl boxer"
    
    # 4-cylinder inline
    if f.startswith(("EN", "1NR", "1NZ")) or "TOYOTA" in f:
        return "4 cyl inline"
        
    # 3-cylinder inline
    if f.startswith(("EF", "KF", "1KR")):
        return "3 cyl inline"
        
    # 2-cylinder inline
    if f.startswith("EK"):
        return "2 cyl inline"

    return "unknown"


# Engine specs database - keyed by engine code
# Format: US / Metric in same cell
ENGINE_SPECS = {
    # EA71 (1.6L) - 1978-1979
    "EA71": {
        "family": "EA", "phase": "",
        "displacement": "1.6 L / 1595 cc",
        "power": "67 hp / 50.0 kW",
        "torque": "81 lb-ft / 110 Nm",
        "induction": "NA", "fuel_system": "Carb",
        "compression": "8.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "60.0 mm / 2.36 in",
        "head": "SOHC", "valvetrain": "8v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "10W-40", "oil_spec": "API SF/SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BP5ES", "gap": "0.039 in / 1.0 mm",
        "notes": "flat-4; zinc additive recommended",
        "source_1": "Subaru Service Manual", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EA81 (1.8L) - 1980-1989
    "EA81": {
        "family": "EA", "phase": "",
        "displacement": "1.8 L / 1781 cc",
        "power": "73 hp / 54.4 kW",
        "torque": "94 lb-ft / 127 Nm",
        "induction": "NA", "fuel_system": "Carb | SPFI",
        "compression": "8.7:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "67.0 mm / 2.64 in",
        "head": "SOHC", "valvetrain": "8v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "10W-40", "oil_spec": "API SF/SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BP5ES", "gap": "0.039 in / 1.0 mm",
        "notes": "flat-4; some years fuel injected",
        "source_1": "Subaru Service Manual", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EA82 (1.8L SOHC) - 1985-1994
    "EA82": {
        "family": "EA", "phase": "",
        "displacement": "1.8 L / 1781 cc",
        "power": "90 hp / 67.1 kW",
        "torque": "101 lb-ft / 137 Nm",
        "induction": "NA", "fuel_system": "SPFI | MPFI",
        "compression": "9.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "67.0 mm / 2.64 in",
        "head": "SOHC", "valvetrain": "8v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR5ES", "gap": "0.039 in / 1.0 mm",
        "notes": "flat-4; electronic fuel injection",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EA82T (1.8L Turbo) - 1985-1991
    "EA82T": {
        "family": "EA", "phase": "",
        "displacement": "1.8 L / 1781 cc",
        "power": "111 hp / 82.8 kW",
        "torque": "134 lb-ft / 182 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "7.7:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "67.0 mm / 2.64 in",
        "head": "SOHC", "valvetrain": "8v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR6ES", "gap": "0.031 in / 0.8 mm",
        "notes": "flat-4 turbo; Hitachi turbocharger",
        "source_1": "Subaru XT Turbo FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EF12 (1.2L 3-cyl) - 1987-1994 Justy
    "EF12": {
        "family": "EF", "phase": "",
        "displacement": "1.2 L / 1189 cc",
        "power": "66 hp / 49.2 kW",
        "torque": "69 lb-ft / 94 Nm",
        "induction": "NA", "fuel_system": "Carb | SPFI",
        "compression": "9.1:1",
        "bore": "78.0 mm / 3.07 in", "stroke": "83.0 mm / 3.27 in",
        "head": "SOHC", "valvetrain": "6v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR5EY", "gap": "0.039 in / 1.0 mm",
        "notes": "inline-3; first ECVT option",
        "source_1": "Subaru Justy FSM", "source_2": "dustysjustys.com",
        "confidence": "high"
    },
    # ER27 (2.7L Flat-6) - 1988-1991 XT6
    "ER27": {
        "family": "ER", "phase": "",
        "displacement": "2.7 L / 2672 cc",
        "power": "145 hp / 108.1 kW",
        "torque": "156 lb-ft / 212 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "9.5:1",
        "bore": "89.2 mm / 3.51 in", "stroke": "71.5 mm / 2.81 in",
        "head": "SOHC", "valvetrain": "12v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR5ES", "gap": "0.039 in / 1.0 mm",
        "notes": "flat-6; XT6 only",
        "source_1": "Subaru XT6 FSM", "source_2": "ultimatesubaru.org",
        "confidence": "medium"
    },
    # EG33 (3.3L Flat-6) - 1991-1997 SVX
    "EG33": {
        "family": "EG", "phase": "",
        "displacement": "3.3 L / 3318 cc",
        "power": "230 hp / 171.5 kW",
        "torque": "228 lb-ft / 309 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.0:1",
        "bore": "96.9 mm / 3.81 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "24v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK PFR5G-11", "gap": "0.043 in / 1.1 mm",
        "notes": "flat-6 DOHC; SVX only",
        "source_1": "Subaru SVX FSM", "source_2": "seccs.org",
        "confidence": "high"
    },
    # EJ18E (1.8L) - 1993-2001
    "EJ18E": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "1.8 L / 1820 cc",
        "power": "110 hp / 82.0 kW",
        "torque": "110 lb-ft / 149 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "9.5:1",
        "bore": "87.9 mm / 3.46 in", "stroke": "75.0 mm / 2.95 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ/SL",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR5E-11", "gap": "0.043 in / 1.1 mm",
        "notes": "base Impreza engine (Phase 1)",
        "source_1": "Subaru Impreza FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ20G (2.0L Turbo JDM) - 1992+
    "EJ20G": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "2.0 L / 1994 cc",
        "power": "250 hp / 186.4 kW",
        "torque": "224 lb-ft / 304 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "7500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "JDM WRX (early); Closed deck",
        "source_1": "JDM Subaru FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EJ22E (2.2L NA) - 1990-2001
    "EJ22E": {
        "family": "EJ", "phase": "Phase 1/2",
        "displacement": "2.2 L / 2212 cc",
        "power": "135 hp / 100.7 kW",
        "torque": "140 lb-ft / 190 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "9.5:1",
        "bore": "96.9 mm / 3.81 in", "stroke": "75.0 mm / 2.95 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ/SL",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR5E-11", "gap": "0.043 in / 1.1 mm",
        "notes": "common NA engine; reliable (EJ22E)",
        "source_1": "Subaru Legacy FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ22T (2.2L Turbo) - 1991-1994
    "EJ22T": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "2.2 L / 2212 cc",
        "power": "160 hp / 119.3 kW",
        "torque": "181 lb-ft / 245 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "96.9 mm / 3.81 in", "stroke": "75.0 mm / 2.95 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR6E-11", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy Turbo",
        "source_1": "Subaru Legacy Turbo FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ25D (2.5L DOHC) - 1996-1999
    "EJ25D": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "2.5 L / 2457 cc",
        "power": "165 hp / 123.0 kW",
        "torque": "162 lb-ft / 220 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.1:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK PFR5G-11", "gap": "0.043 in / 1.1 mm",
        "notes": "Phase 1 DOHC; first 2.5L",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ251 (2.5L SOHC) - 1999-2005
    "EJ251": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.5 L / 2457 cc",
        "power": "165 hp / 123.0 kW",
        "torque": "166 lb-ft / 225 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.1:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL/SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR5F-11", "gap": "0.043 in / 1.1 mm",
        "notes": "Phase 2 SOHC; very swap-friendly",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ253 (2.5L SOHC) - 2006-2012
    "EJ253": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.5 L / 2457 cc",
        "power": "170 hp / 126.8 kW",
        "torque": "170 lb-ft / 230 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.1:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "SOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR5F-11", "gap": "0.043 in / 1.1 mm",
        "notes": "late years DBW; some immobilizer",
        "source_1": "Subaru Owner Manual", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ205 (2.0L Turbo) - 2002-2005
    "EJ205": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "227 hp / 169.3 kW",
        "torque": "217 lb-ft / 294 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL/SM synthetic",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "USDM WRX; no immobilizer (swap-friendly)",
        "source_1": "Subaru WRX FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ207 (2.0L Turbo JDM STI) - 1998-2007
    "EJ207": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "280 hp / 208.8 kW",
        "torque": "260 lb-ft / 353 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "8000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL synthetic",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "JDM STI; AVCS; high rev; gold standard",
        "source_1": "JDM STI FSM", "source_2": "iwsti.com",
        "confidence": "medium"
    },
    # EJ255 (2.5L Turbo) - 2006-2014
    "EJ255": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.5 L / 2457 cc",
        "power": "224 hp / 167.0 kW",
        "torque": "226 lb-ft / 306 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.4:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN synthetic",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR6F", "gap": "0.031 in / 0.8 mm",
        "notes": "WRX/Legacy GT/Forester XT; DBW complicates swaps",
        "source_1": "Subaru WRX/Legacy FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ257 (2.5L Turbo STI) - 2004+
    "EJ257": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.5 L / 2457 cc",
        "power": "305 hp / 227.4 kW",
        "torque": "290 lb-ft / 393 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.2:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN synthetic",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR6F", "gap": "0.031 in / 0.8 mm",
        "notes": "USDM STI; prefers STI 6MT",
        "source_1": "Subaru STI FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EZ30D (3.0L H6) - 2001-2009
    "EZ30D": {
        "family": "EZ", "phase": "",
        "displacement": "3.0 L / 3000 cc",
        "power": "245 hp / 182.7 kW",
        "torque": "219 lb-ft / 297 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.7:1",
        "bore": "89.2 mm / 3.51 in", "stroke": "80.0 mm / 3.15 in",
        "head": "DOHC", "valvetrain": "24v chain", "timing": "chain",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK ILFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "H6 3.0R; smooth power",
        "source_1": "Subaru Legacy/Outback FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EZ36D (3.6L H6) - 2010-2019
    "EZ36D": {
        "family": "EZ", "phase": "",
        "displacement": "3.6 L / 3630 cc",
        "power": "256 hp / 191.0 kW",
        "torque": "247 lb-ft / 335 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "91.0 mm / 3.58 in",
        "head": "DOHC", "valvetrain": "24v Dual AVCS", "timing": "chain",
        "redline": "6400 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK SILFR6A11", "gap": "0.043 in / 1.1 mm",
        "notes": "Largest Subaru H6; Tribeca/Outback/Legacy",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA20D (2.0L NA) - BRZ/86
    "FA20D": {
        "family": "FA", "phase": "",
        "displacement": "2.0 L / 1998 cc",
        "power": "205 hp / 152.9 kW",
        "torque": "156 lb-ft / 212 Nm",
        "induction": "NA", "fuel_system": "D-4S (DI + MPFI)",
        "compression": "12.5:1",
        "bore": "86.0 mm / 3.39 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "7400 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/RC",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK ZXE27HBR8", "gap": "0.031 in / 0.8 mm",
        "notes": "Toyota D-4S system; high compression",
        "source_1": "Subaru BRZ FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA20F (2.0L Turbo) - WRX/Forester XT
    "FA20F": {
        "family": "FA", "phase": "",
        "displacement": "2.0 L / 1998 cc",
        "power": "268 hp / 200.0 kW",
        "torque": "258 lb-ft / 350 Nm",
        "induction": "Turbo (DIT)", "fuel_system": "DI",
        "compression": "10.6:1",
        "bore": "86.0 mm / 3.39 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6700 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK ILKAR8H6", "gap": "0.024 in / 0.6 mm",
        "notes": "Twin-scroll turbo (DIT); WRX S4/Forester XT",
        "source_1": "Subaru WRX FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA24D (2.4L NA) - BRZ/GR86 (2022+)
    "FA24D": {
        "family": "FA", "phase": "",
        "displacement": "2.4 L / 2387 cc",
        "power": "228 hp / 170.0 kW",
        "torque": "184 lb-ft / 249 Nm",
        "induction": "NA", "fuel_system": "D-4S (DI + MPFI)",
        "compression": "13.5:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "7500 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SP",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK RUTH", "gap": "",
        "notes": "2nd Gen BRZ engine",
        "source_1": "Subaru BRZ FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA24F (2.4L Turbo) - Ascent/Legacy/Outback/WRX
    "FA24F": {
        "family": "FA", "phase": "",
        "displacement": "2.4 L / 2387 cc",
        "power": "260 hp / 193.9 kW",
        "torque": "277 lb-ft / 376 Nm",
        "induction": "Turbo (DIT)", "fuel_system": "DI",
        "compression": "10.6:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SP",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILKAR8D6", "gap": "0.024 in / 0.6 mm",
        "notes": "High torque turbo (DIT); Ascent/Outback XT/WRX",
        "source_1": "Subaru Ascent FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB20B (2.0L NA Port) - Impreza/Crosstrek (pre-2017/18)
    "FB20B": {
        "family": "FB", "phase": "",
        "displacement": "2.0 L / 1995 cc",
        "power": "148 hp / 110.4 kW",
        "torque": "145 lb-ft / 197 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.5:1",
        "bore": "84.0 mm / 3.31 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v chain", "timing": "chain",
        "redline": "6500 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.043 in / 1.1 mm",
        "notes": "Port injection FB20",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB20D (2.0L NA DI) - Impreza (2017+)/Crosstrek (2018+)
    "FB20D": {
        "family": "FB", "phase": "",
        "displacement": "2.0 L / 1995 cc",
        "power": "152 hp / 113.3 kW",
        "torque": "145 lb-ft / 197 Nm",
        "induction": "NA", "fuel_system": "DI",
        "compression": "12.5:1",
        "bore": "84.0 mm / 3.31 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v chain", "timing": "chain",
        "redline": "6500 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/SP",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.043 in / 1.1 mm",
        "notes": "Direct injection FB20",
        "source_1": "Subaru FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB25B (2.5L NA Port) - Forester (2011-2018)/Legacy (2013-2019)
    "FB25B": {
        "family": "FB", "phase": "",
        "displacement": "2.5 L / 2498 cc",
        "power": "170 hp / 126.8 kW",
        "torque": "174 lb-ft / 236 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.0:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "Port injection FB25",
        "source_1": "Subaru Forester FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB25D (2.5L NA DI) - Forester (2019+)/Legacy (2020+)
    "FB25D": {
        "family": "FB", "phase": "",
        "displacement": "2.5 L / 2498 cc",
        "power": "182 hp / 135.7 kW",
        "torque": "176 lb-ft / 239 Nm",
        "induction": "NA", "fuel_system": "DI",
        "compression": "12.0:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/SP synthetic",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "Direct injection FB25",
        "source_1": "Subaru Forester FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    "Electric": {
        "family": "EV", "phase": "",
        "displacement": "0 L / 0 cc",
        "power": "215 hp / 160 kW",
        "torque": "249 lb-ft / 337 Nm",
        "induction": "Electric", "fuel_system": "BEV",
        "compression": "",
        "bore": "", "stroke": "",
        "head": "", "valvetrain": "", "timing": "",
        "redline": "",
        "oil_visc": "", "oil_spec": "",
        "coolant": "Toyota Genuine Traction Battery Coolant (Blue)",
        "plug": "", "gap": "",
        "notes": "Dual Motor AWD (StarDrive); 72.8 kWh battery",
        "source_1": "Subaru Solterra FSM", "source_2": "Subaru Media",
        "confidence": "high"
    },
    # ============================================================================
    # JDM-SPECIFIC ENGINES
    # ============================================================================
    
    # EN07 (660cc Kei) - Vivio, R1, R2, Pleo, Stella, Sambar
    "EN07": {
        "family": "EN", "phase": "",
        "displacement": "0.66 L / 658 cc",
        "power": "48 hp / 35.8 kW",
        "torque": "42 lb-ft / 57 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.0:1",
        "bore": "56.0 mm / 2.20 in", "stroke": "66.8 mm / 2.63 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SN",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR6E", "gap": "0.039 in / 1.0 mm",
        "notes": "Kei-class inline-4; DOHC 16v",
        "source_1": "Subaru Kei FSM", "source_2": "JDM specs",
        "confidence": "medium"
    },
    # EN07 Supercharged (660cc SC)
    "EN07S": {
        "family": "EN", "phase": "",
        "displacement": "0.66 L / 658 cc",
        "power": "64 hp / 47.7 kW",
        "torque": "74 lb-ft / 100 Nm",
        "induction": "Supercharged", "fuel_system": "MPFI",
        "compression": "8.5:1",
        "bore": "56.0 mm / 2.20 in", "stroke": "66.8 mm / 2.63 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "8000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SN",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR7E", "gap": "0.031 in / 0.8 mm",
        "notes": "Kei Supercharged; Vivio RX-R, Pleo RS",
        "source_1": "Subaru Kei FSM", "source_2": "JDM specs",
        "confidence": "medium"
    },
    # EN05 (550cc older Kei)
    "EN05": {
        "family": "EN", "phase": "",
        "displacement": "0.55 L / 544 cc",
        "power": "42 hp / 31.3 kW",
        "torque": "35 lb-ft / 47 Nm",
        "induction": "NA", "fuel_system": "Carb",
        "compression": "9.5:1",
        "bore": "56.0 mm / 2.20 in", "stroke": "55.2 mm / 2.17 in",
        "head": "SOHC", "valvetrain": "8v", "timing": "chain",
        "redline": "7000 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SF/SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR5ES", "gap": "0.039 in / 1.0 mm",
        "notes": "Early Kei (pre-1990 regulations)",
        "source_1": "Subaru Rex FSM", "source_2": "JDM specs",
        "confidence": "low"
    },
    # EF10 (1.0L Justy)
    "EF10": {
        "family": "EF", "phase": "",
        "displacement": "1.0 L / 997 cc",
        "power": "56 hp / 41.8 kW",
        "torque": "57 lb-ft / 77 Nm",
        "induction": "NA", "fuel_system": "Carb",
        "compression": "9.5:1",
        "bore": "78.0 mm / 3.07 in", "stroke": "69.4 mm / 2.73 in",
        "head": "SOHC", "valvetrain": "6v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "10W-30", "oil_spec": "API SG",
        "coolant": "ethylene glycol 50/50",
        "plug": "NGK BPR5EY", "gap": "0.039 in / 1.0 mm",
        "notes": "inline-3; early Justy",
        "source_1": "Subaru Justy FSM", "source_2": "dustysjustys.com",
        "confidence": "medium"
    },
    # KF (660cc Daihatsu OEM - Sambar, Stella, Pleo 2011+)
    "KF": {
        "family": "KF", "phase": "",
        "displacement": "0.66 L / 658 cc",
        "power": "52 hp / 38.8 kW",
        "torque": "44 lb-ft / 60 Nm",
        "induction": "NA", "fuel_system": "DVVT",
        "compression": "11.3:1",
        "bore": "63.0 mm / 2.48 in", "stroke": "70.4 mm / 2.77 in",
        "head": "DOHC", "valvetrain": "12v", "timing": "chain",
        "redline": "7000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Toyota/Daihatsu coolant",
        "plug": "NGK LKAR7AIX-P", "gap": "0.039 in / 1.0 mm",
        "notes": "Daihatsu KF; inline-3 DVVT",
        "source_1": "Daihatsu FSM", "source_2": "JDM specs",
        "confidence": "medium"
    },
    # KF Turbo
    "KFT": {
        "family": "KF", "phase": "",
        "displacement": "0.66 L / 658 cc",
        "power": "64 hp / 47.7 kW",
        "torque": "69 lb-ft / 94 Nm",
        "induction": "Turbo", "fuel_system": "DVVT",
        "compression": "9.0:1",
        "bore": "63.0 mm / 2.48 in", "stroke": "70.4 mm / 2.77 in",
        "head": "DOHC", "valvetrain": "12v", "timing": "chain",
        "redline": "7000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Toyota/Daihatsu coolant",
        "plug": "NGK LKAR8AIX-P", "gap": "0.031 in / 0.8 mm",
        "notes": "Daihatsu KF Turbo; Stella Custom RS",
        "source_1": "Daihatsu FSM", "source_2": "JDM specs",
        "confidence": "medium"
    },
    # EL15 (1.5L JDM Impreza)
    "EL15": {
        "family": "EL", "phase": "",
        "displacement": "1.5 L / 1498 cc",
        "power": "105 hp / 78.3 kW",
        "torque": "100 lb-ft / 136 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.1:1",
        "bore": "79.0 mm / 3.11 in", "stroke": "76.4 mm / 3.01 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL/SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK BKR5E-11", "gap": "0.043 in / 1.1 mm",
        "notes": "JDM Impreza 1.5i",
        "source_1": "Subaru JDM FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EJ15 (1.5L early JDM)
    "EJ15": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "1.5 L / 1493 cc",
        "power": "97 hp / 72.3 kW",
        "torque": "98 lb-ft / 133 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "9.7:1",
        "bore": "87.9 mm / 3.46 in", "stroke": "61.5 mm / 2.42 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR5E-11", "gap": "0.043 in / 1.1 mm",
        "notes": "Early JDM Impreza 1.5",
        "source_1": "Subaru JDM FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EJ16 (1.6L JDM)
    "EJ16": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "1.6 L / 1597 cc",
        "power": "100 hp / 74.6 kW",
        "torque": "103 lb-ft / 140 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "9.8:1",
        "bore": "87.9 mm / 3.46 in", "stroke": "65.8 mm / 2.59 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SJ",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK BKR5E-11", "gap": "0.043 in / 1.1 mm",
        "notes": "JDM Impreza 1.6",
        "source_1": "Subaru JDM FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # FB16 (1.6L JDM Levorg/XV)
    "FB16": {
        "family": "FB", "phase": "",
        "displacement": "1.6 L / 1599 cc",
        "power": "115 hp / 85.8 kW",
        "torque": "108 lb-ft / 146 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "11.0:1",
        "bore": "78.8 mm / 3.10 in", "stroke": "82.0 mm / 3.23 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6200 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.043 in / 1.1 mm",
        "notes": "JDM XV/Impreza 1.6i",
        "source_1": "Subaru JDM FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB16 DIT (1.6L Turbo - Levorg)
    "FB16T": {
        "family": "FB", "phase": "",
        "displacement": "1.6 L / 1599 cc",
        "power": "170 hp / 126.8 kW",
        "torque": "184 lb-ft / 250 Nm",
        "induction": "Turbo (DIT)", "fuel_system": "DI",
        "compression": "11.0:1",
        "bore": "78.8 mm / 3.10 in", "stroke": "82.0 mm / 3.23 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "5600 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR8B11", "gap": "0.031 in / 0.8 mm",
        "notes": "Levorg 1.6GT DIT; compact turbo",
        "source_1": "Subaru Levorg FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # CB18 (1.8L Turbo - New Levorg/Outback/Forester 2020+)
    "CB18": {
        "family": "CB", "phase": "",
        "displacement": "1.8 L / 1795 cc",
        "power": "177 hp / 132.0 kW",
        "torque": "221 lb-ft / 300 Nm",
        "induction": "Turbo (DIT)", "fuel_system": "DI (Lean burn)",
        "compression": "10.4:1",
        "bore": "80.6 mm / 3.17 in", "stroke": "88.0 mm / 3.46 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "5600 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SP",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR8D7S", "gap": "0.028 in / 0.7 mm",
        "notes": "New lean-burn DIT; Levorg/Outback/Forester STI Sport",
        "source_1": "Subaru Levorg 2nd Gen FSM", "source_2": "Subaru Media",
        "confidence": "high"
    },
    # EJ20G (2.0L Turbo Phase 1 - GC8 WRX 1992-1996)
    "EJ20G": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "2.0 L / 1994 cc",
        "power": "220 hp / 164.0 kW",
        "torque": "203 lb-ft / 275 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "7500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL",
        "coolant": "Subaru coolant 50/50",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "1st gen WRX turbo; TD05H turbo",
        "source_1": "Subaru JDM WRX FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ20K (2.0L Turbo Phase 1.5 - GC8 WRX/STI 1996-2000)
    "EJ20K": {
        "family": "EJ", "phase": "Phase 1.5",
        "displacement": "2.0 L / 1994 cc",
        "power": "280 hp / 208.8 kW",
        "torque": "260 lb-ft / 353 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "8000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "STI Version III-VI; IHI VF28 turbo; semi-closed deck",
        "source_1": "Subaru JDM STI FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ206 (2.0L Twin Turbo - Legacy BH/BE)
    "EJ206": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "260 hp / 193.9 kW",
        "torque": "253 lb-ft / 343 Nm",
        "induction": "Twin Turbo", "fuel_system": "MPFI",
        "compression": "8.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy GT-B twin turbo; sequential turbos",
        "source_1": "Subaru Legacy BE/BH FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ208 (2.0L Twin Turbo Phase 2 - Legacy BH/BE late)
    "EJ208": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "280 hp / 208.8 kW",
        "torque": "268 lb-ft / 363 Nm",
        "induction": "Twin Turbo", "fuel_system": "MPFI",
        "compression": "8.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "7500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy B4 RSK twin turbo; revised ECU",
        "source_1": "Subaru Legacy BE/BH FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ20X (2.0L Single Turbo - Legacy BL/BP)
    "EJ20X": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "250 hp / 186.4 kW",
        "torque": "243 lb-ft / 330 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "9.0:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v AVCS", "timing": "belt",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6G", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy 2.0GT; single VF38 turbo",
        "source_1": "Subaru Legacy BL/BP FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ20Y (2.0L Turbo Spec.B - Legacy BL/BP)
    "EJ20Y": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.0 L / 1994 cc",
        "power": "265 hp / 197.6 kW",
        "torque": "257 lb-ft / 348 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "9.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "belt",
        "redline": "7000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6G", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy Spec.B; VF44 turbo; 6MT",
        "source_1": "Subaru Legacy Spec.B FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EZ30R (3.0L H6 Spec.B - higher power)
    "EZ30R": {
        "family": "EZ", "phase": "",
        "displacement": "3.0 L / 3000 cc",
        "power": "245 hp / 182.7 kW",
        "torque": "219 lb-ft / 297 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "11.0:1",
        "bore": "89.2 mm / 3.51 in", "stroke": "80.0 mm / 3.15 in",
        "head": "DOHC", "valvetrain": "24v Dual AVCS", "timing": "chain",
        "redline": "6800 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK ILFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "Legacy 3.0R Spec.B; high compression",
        "source_1": "Subaru Legacy 3.0R FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ22 Turbo (22B STI)
    "EJ22T": {
        "family": "EJ", "phase": "Phase 1",
        "displacement": "2.2 L / 2212 cc",
        "power": "280 hp / 208.8 kW",
        "torque": "267 lb-ft / 362 Nm",
        "induction": "Turbo", "fuel_system": "MPFI",
        "compression": "8.0:1",
        "bore": "96.9 mm / 3.81 in", "stroke": "75.0 mm / 2.95 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "8000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PFR6B", "gap": "0.031 in / 0.8 mm",
        "notes": "22B STI engine; 400 made; closed deck",
        "source_1": "Subaru 22B FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # 1NR-FE (Toyota - Trezia)
    "1NR-FE": {
        "family": "Toyota", "phase": "",
        "displacement": "1.3 L / 1329 cc",
        "power": "95 hp / 70.8 kW",
        "torque": "89 lb-ft / 121 Nm",
        "induction": "NA", "fuel_system": "Dual VVT-i",
        "compression": "11.5:1",
        "bore": "72.5 mm / 2.85 in", "stroke": "80.5 mm / 3.17 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6400 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Toyota Super Long Life",
        "plug": "DENSO SC20HR11", "gap": "0.043 in / 1.1 mm",
        "notes": "Toyota 1NR-FE; Trezia rebadge",
        "source_1": "Toyota FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # 1NZ-FE (Toyota - Trezia 1.5)
    "1NZ-FE": {
        "family": "Toyota", "phase": "",
        "displacement": "1.5 L / 1497 cc",
        "power": "105 hp / 78.3 kW",
        "torque": "103 lb-ft / 140 Nm",
        "induction": "NA", "fuel_system": "VVT-i",
        "compression": "10.5:1",
        "bore": "75.0 mm / 2.95 in", "stroke": "84.7 mm / 3.33 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN",
        "coolant": "Toyota Super Long Life",
        "plug": "DENSO K16R-U11", "gap": "0.043 in / 1.1 mm",
        "notes": "Toyota 1NZ-FE; Trezia rebadge",
        "source_1": "Toyota FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # FB20 Hybrid
    "FB20H": {
        "family": "FB", "phase": "",
        "displacement": "2.0 L / 1995 cc",
        "power": "148 hp / 110.4 kW",
        "torque": "145 lb-ft / 197 Nm",
        "induction": "NA + e-BOXER", "fuel_system": "DI",
        "compression": "12.5:1",
        "bore": "84.0 mm / 3.31 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v", "timing": "chain",
        "redline": "6200 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/SP",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.043 in / 1.1 mm",
        "notes": "e-BOXER hybrid; XV/Forester Advance; +13hp motor",
        "source_1": "Subaru XV FSM", "source_2": "Subaru Media",
        "confidence": "high"
    },
}
def get_engine_base(engine_code, model, year_val, trim=""):
    if not engine_code: return ""
    code = engine_code.strip()
    
    # Direct mappings for specific codes
    direct_map = {
        # Toyota OEM
        "1NR-FE": "1NR-FE", "1NZ-FE": "1NZ-FE",
        # Kei engines
        "EN07": "EN07", "EN05": "EN05",
        "KF": "KF",
        # JDM-specific EJ
        "EJ20G": "EJ20G", "EJ20K": "EJ20K", 
        "EJ206": "EJ206", "EJ208": "EJ208",
        "EJ20X": "EJ20X", "EJ20Y": "EJ20Y",
        # Other JDM
        "EL15": "EL15", "EF10": "EF10",
        "EZ30R": "EZ30R",
        # FA/FB variants
        "FB16": "FB16", "CB18": "CB18",
    }
    for pattern, result in direct_map.items():
        if pattern in code:
            return result
    
    # Handle Supercharged/Turbo variants
    if "EN07" in code:
        if "Supercharged" in code or "SC" in code:
            return "EN07S"
        return "EN07"
    
    if "KF" in code:
        if "Turbo" in code:
            return "KFT"
        return "KF"
    
    if "FB16" in code:
        if "Turbo" in code or "DIT" in code:
            return "FB16T"
        return "FB16"
    
    if "FB20" in code:
        if "Hybrid" in code:
            return "FB20H"
    
    # 5-char codes check for USDM
    patterns = [
        ("EA71", "EA71"), ("EA82T", "EA82T"), ("EA82", "EA82"), ("EA81", "EA81"),
        ("EF12", "EF12"), ("ER27", "ER27"), ("EG33", "EG33"),
        ("Electric", "Electric"),
        ("EJ257", "EJ257"), ("EJ255", "EJ255"), ("EJ207", "EJ207"), ("EJ205", "EJ205"),
        ("EJ253", "EJ253"), ("EJ252", "EJ253"), ("EJ251", "EJ251"), ("EJ25D", "EJ25D"), ("EJ25", "EJ253"),
        ("EJ22T", "EJ22T"), ("EJ22", "EJ22E"), ("EJ18", "EJ18E"),
        ("EJ15", "EJ15"), ("EJ16", "EJ16"),  # JDM specific, map to themselves
    ]
    for pattern, result in patterns:
        if pattern in code:
            if pattern == "EJ20" and "5" in code: return "EJ205"
            if pattern == "EJ20" and "7" in code: return "EJ207"
            if pattern == "EJ20" and "8" in code: return "EJ208"
            if pattern == "EJ20" and "6" in code: return "EJ206"
            if pattern == "EJ20" and "X" in code: return "EJ20X"
            if pattern == "EJ20" and "Y" in code: return "EJ20Y"
            if pattern == "EJ20" and "K" in code: return "EJ20K"
            if pattern == "EJ20" and "G" in code: return "EJ20G"
            return result
    
    # Handle EJ20 variants based on trim/year
    if "EJ20" in code:
        if "Turbo" in code:
            try:
                y = int(year_val)
            except:
                y = 0
            if y >= 2000:
                return "EJ205"  # GD WRX
            elif y >= 1996:
                return "EJ20K"  # GC8 late
            else:
                return "EJ20G"  # GC8 early
        return "EJ20G"  # Default turbo
    
    # Dynamic 5-char mapping for EZ/FA/FB
    if "EZ36" in code: return "EZ36D"
    if "EZ30" in code:
        if "R" in code or "Spec" in trim.upper():
            return "EZ30R"
        return "EZ30D"
    
    if "FA20" in code:
        # FA20F (Turbo) vs FA20D (NA)
        if "BRZ" in model: return "FA20D"
        if "WRX" in model or "Forester" in model or "Levorg" in model: return "FA20F"
        return "FA20D"
    
    if "FA24" in code:
        # FA24F (Turbo) vs FA24D (NA)
        if "BRZ" in model or "GR86" in model: return "FA24D"
        return "FA24F"
    
    try:
        y = int(year_val)
    except:
        y = 0
        
    if "FB20" in code:
        if "Hybrid" in code:
            return "FB20H"
        # FB20B (Port) vs FB20D (DI)
        if "Crosstrek" in model or "XV" in model:
            if y >= 2018: return "FB20D"
            else: return "FB20B"
        if "Impreza" in model:
            if y >= 2017: return "FB20D"
            else: return "FB20B"
        if "Forester" in model:
            if y >= 2019: return "FB20D"
            pass
        if y >= 2017: return "FB20D"
        return "FB20B"

    if "FB25" in code:
        # FB25B (Port) vs FB25D (DI)
        if "Forester" in model:
            if y >= 2019: return "FB25D"
            else: return "FB25B"
        if "Legacy" in model or "Outback" in model:
            if y >= 2020: return "FB25D"
            else: return "FB25B"
        if "Crosstrek" in model or "XV" in model: return "FB25D"
        if "Impreza" in model: return "FB25D"
        if "Exiga" in model: return "FB25B"
        
        if y >= 2019: return "FB25D"
        return "FB25B"
    
    if "CB18" in code:
        return "CB18"

    return ""


def extract_market(trim):
    t = trim.upper()
    if "(US)" in t or "USDM" in t: return "USDM"
    if "(JDM)" in t or "JDM" in t: return "JDM"
    return ""

def create_row(v):
    year = v.get("year", "")
    make = v.get("make", "Subaru")
    model = v.get("model", "")
    trim = v.get("trim", "")
    engine_code_raw = v.get("engineCode", "")
    market = extract_market(trim)
    
    eng = get_engine_base(engine_code_raw, model, year, trim)
    specs = ENGINE_SPECS.get(eng, {})
    
    row = {
        "year": year, "make": make, "model": model, "trim": trim, "body": "", "market": market,
        "engine_code": eng if eng else engine_code_raw,
        "engine_family": specs.get("family", ""),
        "engine_phase": specs.get("phase", ""),
        "displacement": specs.get("displacement", ""),
        "cyl_config": specs.get("cyl_config", infer_cyl_config(specs.get("family", ""))),
        "power": specs.get("power", ""),
        "torque": specs.get("torque", ""),
        "induction": specs.get("induction", ""),
        "fuel_system": specs.get("fuel_system", ""),
        "compression_ratio": specs.get("compression", ""),
        "bore": specs.get("bore", ""),
        "stroke": specs.get("stroke", ""),
        "head_config": specs.get("head", ""),
        "valvetrain": specs.get("valvetrain", ""),
        "timing_drive": specs.get("timing", ""),
        "redline": specs.get("redline", ""),
        "oil_viscosity": specs.get("oil_visc", ""),
        "oil_spec": specs.get("oil_spec", ""),
        "coolant_spec": specs.get("coolant", ""),
        "spark_plug": specs.get("plug", ""),
        "plug_gap": specs.get("gap", ""),
        "notes": specs.get("notes", ""),
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
    
    print("Generating engines rows...")
    rows, seen = [], set()
    for v in vehicles_sorted:
        row = create_row(v)
        key = (row["year"], row["make"], row["model"], row["trim"], row["body"], row["market"])
        if key in seen: continue
        seen.add(key)
        rows.append(row)
    
    print(f"Writing {len(rows)} rows to engines.csv...")
    ENGINES_CSV.parent.mkdir(parents=True, exist_ok=True)
    
    with open(ENGINES_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=HEADER, quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(rows)
    
    print(f"Done! Written to {ENGINES_CSV}")
    
    # Validation
    with_code = sum(1 for r in rows if r["engine_code"])
    with_power = sum(1 for r in rows if r["power"])
    with_disp = sum(1 for r in rows if r["displacement"])
    print(f"\nValidation:")
    print(f"  Rows with engine code: {with_code}/{len(rows)}")
    print(f"  Rows with displacement: {with_disp}/{len(rows)}")
    print(f"  Rows with power: {with_power}/{len(rows)}")

if __name__ == "__main__":
    main()
