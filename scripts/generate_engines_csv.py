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
    "engine_code", "engine_family", "engine_phase", "displacement",
    "power", "torque", "induction", "fuel_system", "compression_ratio",
    "bore", "stroke", "head_config", "valvetrain", "timing_drive",
    "redline", "oil_viscosity", "oil_spec", "coolant_spec",
    "spark_plug", "plug_gap", "notes", "source_1", "source_2", "confidence"
]

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
    # EJ18 (1.8L) - 1993-2001
    "EJ18": {
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
        "notes": "base Impreza engine",
        "source_1": "Subaru Impreza FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EJ20 (2.0L Turbo JDM) - 1992+
    "EJ20": {
        "family": "EJ", "phase": "Phase 1/2",
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
        "notes": "JDM WRX/STI turbo; multiple variants",
        "source_1": "JDM Subaru FSM", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EJ22 (2.2L NA) - 1990-2001
    "EJ22": {
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
        "notes": "common NA engine; reliable",
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
    # EJ25 generic fallback
    "EJ25": {
        "family": "EJ", "phase": "Phase 2",
        "displacement": "2.5 L / 2457 cc",
        "power": "170 hp / 126.8 kW",
        "torque": "170 lb-ft / 230 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.1:1",
        "bore": "99.5 mm / 3.92 in", "stroke": "79.0 mm / 3.11 in",
        "head": "SOHC", "valvetrain": "16v", "timing": "belt",
        "redline": "6000 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SM/SN",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR5F-11", "gap": "0.043 in / 1.1 mm",
        "notes": "generic EJ25 NA",
        "source_1": "Subaru Owner Manual", "source_2": "AMSOIL",
        "confidence": "medium"
    },
    # EZ30 (3.0L H6) - 2001-2009
    "EZ30": {
        "family": "EZ", "phase": "",
        "displacement": "3.0 L / 3000 cc",
        "power": "212 hp / 158.1 kW",
        "torque": "210 lb-ft / 285 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.7:1",
        "bore": "89.2 mm / 3.51 in", "stroke": "80.0 mm / 3.15 in",
        "head": "DOHC", "valvetrain": "24v AVCS", "timing": "chain",
        "redline": "6500 rpm",
        "oil_visc": "5W-30", "oil_spec": "API SL/SM",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK PZFR5F-11", "gap": "0.043 in / 1.1 mm",
        "notes": "H6; timing chain",
        "source_1": "Subaru Outback H6 FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # EZ36 (3.6L H6) - 2010+
    "EZ36": {
        "family": "EZ", "phase": "",
        "displacement": "3.6 L / 3630 cc",
        "power": "256 hp / 190.9 kW",
        "torque": "247 lb-ft / 335 Nm",
        "induction": "NA", "fuel_system": "MPFI",
        "compression": "10.5:1",
        "bore": "92.0 mm / 3.62 in", "stroke": "91.0 mm / 3.58 in",
        "head": "DOHC", "valvetrain": "24v Dual AVCS", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN synthetic",
        "coolant": "Subaru Super Coolant",
        "plug": "NGK DILKAR7C9H", "gap": "0.035 in / 0.9 mm",
        "notes": "H6; timing chain; Outback/Legacy/Tribeca",
        "source_1": "Subaru Outback/Tribeca FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA20 (2.0L DIT) - 2013+ BRZ, 2015+ WRX
    "FA20": {
        "family": "FA", "phase": "",
        "displacement": "2.0 L / 1998 cc",
        "power": "268 hp / 199.9 kW",
        "torque": "258 lb-ft / 350 Nm",
        "induction": "Turbo", "fuel_system": "DI",
        "compression": "10.6:1",
        "bore": "86.0 mm / 3.39 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "chain",
        "redline": "6500 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN synthetic",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "FA20DIT turbo (WRX) or FA20D NA (BRZ); square bore/stroke",
        "source_1": "Subaru WRX/BRZ FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FA24 (2.4L DIT) - 2020+
    "FA24": {
        "family": "FA", "phase": "",
        "displacement": "2.4 L / 2387 cc",
        "power": "271 hp / 202.1 kW",
        "torque": "258 lb-ft / 350 Nm",
        "induction": "Turbo", "fuel_system": "DI",
        "compression": "10.6:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "86.0 mm / 3.39 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SP/SN+ synthetic",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "latest turbo; Outback XT/WRX/Ascent",
        "source_1": "Subaru WRX/Outback FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB20 (2.0L DI) - 2012+
    "FB20": {
        "family": "FB", "phase": "",
        "displacement": "2.0 L / 1995 cc",
        "power": "152 hp / 113.4 kW",
        "torque": "145 lb-ft / 197 Nm",
        "induction": "NA", "fuel_system": "DI",
        "compression": "10.5:1",
        "bore": "84.0 mm / 3.31 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "chain",
        "redline": "6500 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/SP synthetic",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "Impreza/Crosstrek; timing chain",
        "source_1": "Subaru Impreza/Crosstrek FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
    # FB25 (2.5L DI) - 2011+
    "FB25": {
        "family": "FB", "phase": "",
        "displacement": "2.5 L / 2498 cc",
        "power": "182 hp / 135.7 kW",
        "torque": "176 lb-ft / 239 Nm",
        "induction": "NA", "fuel_system": "DI",
        "compression": "10.3:1",
        "bore": "94.0 mm / 3.70 in", "stroke": "90.0 mm / 3.54 in",
        "head": "DOHC", "valvetrain": "16v Dual AVCS", "timing": "chain",
        "redline": "6000 rpm",
        "oil_visc": "0W-20", "oil_spec": "API SN/SP synthetic",
        "coolant": "Subaru Super Coolant (blue)",
        "plug": "NGK SILZKAR7B11", "gap": "0.035 in / 0.9 mm",
        "notes": "Forester/Outback/Legacy; timing chain",
        "source_1": "Subaru Forester/Outback FSM", "source_2": "AMSOIL",
        "confidence": "high"
    },
}

def get_engine_base(engine_code):
    if not engine_code: return ""
    code = engine_code.strip()
    patterns = [
        ("EA71", "EA71"), ("EA82T", "EA82T"), ("EA82", "EA82"), ("EA81", "EA81"),
        ("EF12", "EF12"), ("ER27", "ER27"), ("EG33", "EG33"),
        ("FA24", "FA24"), ("FA20", "FA20"), ("FB25", "FB25"), ("FB20", "FB20"),
        ("EZ36", "EZ36"), ("EZ30", "EZ30"),
        ("EJ257", "EJ257"), ("EJ255", "EJ255"), ("EJ207", "EJ207"), ("EJ205", "EJ205"),
        ("EJ253", "EJ253"), ("EJ252", "EJ253"), ("EJ251", "EJ251"), ("EJ25D", "EJ25D"), ("EJ25", "EJ25"),
        ("EJ22T", "EJ22T"), ("EJ22", "EJ22"), ("EJ18", "EJ18"), ("EJ20", "EJ20"),
        ("EJ15", "EJ18"), ("EJ16", "EJ18"),
    ]
    for pattern, result in patterns:
        if pattern in code:
            if pattern == "EJ22" and "Turbo" in code: return "EJ22T"
            return result
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
    
    eng = get_engine_base(engine_code_raw)
    specs = ENGINE_SPECS.get(eng, {})
    
    row = {
        "year": year, "make": make, "model": model, "trim": trim, "body": "", "market": market,
        "engine_code": eng if eng else engine_code_raw,
        "engine_family": specs.get("family", ""),
        "engine_phase": specs.get("phase", ""),
        "displacement": specs.get("displacement", ""),
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
