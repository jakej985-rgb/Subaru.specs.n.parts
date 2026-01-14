#!/usr/bin/env python3
"""
JDM Vehicle Catalog Generator
Adds comprehensive JDM (Japanese Domestic Market) Subaru vehicles to vehicles.json
"""

import json
from pathlib import Path

REPO = Path(__file__).parent.parent
VEHICLES_JSON = REPO / "assets" / "seed" / "vehicles.json"

# JDM Vehicle Definitions
# Format: (model, start_year, end_year, trims_by_era, engine_code)

JDM_VEHICLES = []

def add_vehicle(year, model, trim, engine_code, body="", drivetrain="AWD"):
    """Helper to add a JDM vehicle entry"""
    JDM_VEHICLES.append({
        "year": year,
        "make": "Subaru",
        "model": model,
        "trim": f"{trim} (JDM)",
        "body": body,
        "engineCode": engine_code,
        "drivetrain": drivetrain,
        "market": "JDM"
    })

# ============================================================================
# IMPREZA WRX (1992-2014 JDM, then became standalone WRX)
# ============================================================================

# GC8 Era (1992-2000)
for year in range(1992, 2001):
    if year <= 1996:
        add_vehicle(year, "Impreza", "WRX", "EJ20G Turbo", "Sedan")
        add_vehicle(year, "Impreza", "WRX Wagon", "EJ20G Turbo", "Wagon")
    else:
        add_vehicle(year, "Impreza", "WRX", "EJ20K Turbo", "Sedan")
        add_vehicle(year, "Impreza", "WRX Wagon", "EJ20K Turbo", "Wagon")
        add_vehicle(year, "Impreza", "WRX Type R", "EJ20K Turbo", "Coupe")
        add_vehicle(year, "Impreza", "WRX Type RA", "EJ20K Turbo", "Sedan")

# GD/GG Era (2000-2007)
for year in range(2000, 2008):
    add_vehicle(year, "Impreza", "WRX", "EJ205 Turbo", "Sedan")
    add_vehicle(year, "Impreza", "WRX Wagon", "EJ205 Turbo", "Wagon")
    if year >= 2002:
        add_vehicle(year, "Impreza", "WRX WR-Limited", "EJ205 Turbo", "Sedan")

# GH/GE Era (2007-2011)
for year in range(2007, 2012):
    add_vehicle(year, "Impreza", "WRX", "EJ205 Turbo", "Sedan")
    add_vehicle(year, "Impreza", "WRX STI A-Line", "EJ255 Turbo", "Sedan")

# GJ/GP Era (2011-2014) - Impreza based
for year in range(2011, 2015):
    add_vehicle(year, "Impreza", "WRX", "EJ207 Turbo", "Sedan")

# ============================================================================
# IMPREZA WRX STI (1994-2019 JDM)
# ============================================================================

# Version series (GC8)
sti_versions = [
    (1994, "STI Version I", "EJ20G Turbo"),
    (1995, "STI Version II", "EJ20G Turbo"),
    (1996, "STI Version III", "EJ20K Turbo"),
    (1997, "STI Version IV", "EJ20K Turbo"),
    (1998, "STI Version V", "EJ207 Turbo"),
    (1999, "STI Version VI", "EJ207 Turbo"),
]
for year, trim, eng in sti_versions:
    add_vehicle(year, "Impreza", trim, eng, "Sedan")
    add_vehicle(year, "Impreza", f"{trim} Wagon", eng, "Wagon")

# Special editions
add_vehicle(1998, "Impreza", "22B STI", "EJ22 Turbo", "Coupe")
add_vehicle(1999, "Impreza", "STI S201", "EJ207 Turbo", "Sedan")
add_vehicle(2000, "Impreza", "STI S201", "EJ207 Turbo", "Sedan")

# GDB Era (2000-2007)
for year in range(2000, 2008):
    add_vehicle(year, "Impreza", "WRX STI", "EJ207 Turbo", "Sedan")
    add_vehicle(year, "Impreza", "WRX STI Wagon", "EJ207 Turbo", "Wagon")
    if year >= 2004:
        add_vehicle(year, "Impreza", "WRX STI Spec C", "EJ207 Turbo", "Sedan")

# GRB/GVB Era (2007-2014)
for year in range(2007, 2015):
    add_vehicle(year, "Impreza", "WRX STI", "EJ207 Turbo", "Hatchback" if year < 2011 else "Sedan")
    add_vehicle(year, "Impreza", "WRX STI Spec C", "EJ207 Turbo", "Sedan")
    if year >= 2010:
        add_vehicle(year, "Impreza", "WRX STI A-Line", "EJ257 Turbo", "Sedan")

# VAB Era (2014-2019)
for year in range(2014, 2020):
    add_vehicle(year, "WRX STI", "Base", "EJ207 Turbo", "Sedan")
    add_vehicle(year, "WRX STI", "Type S", "EJ207 Turbo", "Sedan")
    if year >= 2017:
        add_vehicle(year, "WRX STI", "S208", "EJ207 Turbo", "Sedan")

# Final editions
add_vehicle(2019, "WRX STI", "EJ20 Final Edition", "EJ207 Turbo", "Sedan")

# ============================================================================
# WRX S4 (2014-present) - CVT Sport Sedan
# ============================================================================
for year in range(2014, 2022):
    if year < 2021:
        add_vehicle(year, "WRX S4", "GT", "FA20 Turbo", "Sedan")
        add_vehicle(year, "WRX S4", "GT-S", "FA20 Turbo", "Sedan")
    else:
        add_vehicle(year, "WRX S4", "GT-H", "FA24 Turbo", "Sedan")
        add_vehicle(year, "WRX S4", "STI Sport", "FA24 Turbo", "Sedan")

for year in range(2022, 2026):
    add_vehicle(year, "WRX S4", "GT-H", "FA24 Turbo", "Sedan")
    add_vehicle(year, "WRX S4", "STI Sport R", "FA24 Turbo", "Sedan")

# ============================================================================
# LEVORG (2014-present) - Sport Wagon
# ============================================================================
for year in range(2014, 2021):
    add_vehicle(year, "Levorg", "1.6GT", "FB16 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "1.6GT-S", "FB16 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "2.0GT", "FA20 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "2.0GT-S", "FA20 Turbo", "Wagon")
    if year >= 2016:
        add_vehicle(year, "Levorg", "2.0STI Sport", "FA20 Turbo", "Wagon")

# 2nd gen Levorg (2020+)
for year in range(2020, 2026):
    add_vehicle(year, "Levorg", "GT", "CB18 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "GT-H", "CB18 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "STI Sport", "CB18 Turbo", "Wagon")
    add_vehicle(year, "Levorg", "STI Sport R", "CB18 Turbo", "Wagon")

# ============================================================================
# LEGACY (JDM versions 1989-present)
# ============================================================================

# BC/BF Era (1989-1993)
for year in range(1989, 1994):
    add_vehicle(year, "Legacy", "Touring Sedan", "EJ20 NA", "Sedan")
    add_vehicle(year, "Legacy", "Touring Wagon", "EJ20 NA", "Wagon")
    if year >= 1990:
        add_vehicle(year, "Legacy", "RS", "EJ20 Turbo", "Sedan")
        add_vehicle(year, "Legacy", "GT", "EJ20 Turbo", "Wagon")

# BD/BG Era (1993-1998)
for year in range(1993, 1999):
    add_vehicle(year, "Legacy", "TS", "EJ20 NA", "Sedan")
    add_vehicle(year, "Legacy", "TS-R", "EJ20 NA", "Sedan")
    add_vehicle(year, "Legacy", "GT", "EJ20 Turbo", "Sedan")
    add_vehicle(year, "Legacy", "GT-B", "EJ20 Turbo", "Wagon")
    if year >= 1996:
        add_vehicle(year, "Legacy", "GT-B Limited", "EJ20 Turbo", "Wagon")

# BE/BH Era (1998-2003) - includes B4 and twin-turbo
for year in range(1998, 2004):
    add_vehicle(year, "Legacy", "B4 RSK", "EJ208 Twin Turbo", "Sedan")
    add_vehicle(year, "Legacy", "B4 RS", "EJ20 NA", "Sedan")
    add_vehicle(year, "Legacy", "GT-B E-tune", "EJ206 Twin Turbo", "Wagon")
    add_vehicle(year, "Legacy", "GT-B E-tune II", "EJ208 Twin Turbo", "Wagon")
    if year >= 2001:
        add_vehicle(year, "Legacy", "Blitzen", "EJ206 Twin Turbo", "Sedan")
        add_vehicle(year, "Legacy", "S401 STI", "EJ207 Turbo", "Wagon")

# BL/BP Era (2003-2009)
for year in range(2003, 2010):
    add_vehicle(year, "Legacy", "B4 2.0GT", "EJ20X Turbo", "Sedan")
    add_vehicle(year, "Legacy", "B4 2.0GT Spec.B", "EJ20Y Turbo", "Sedan")
    add_vehicle(year, "Legacy", "Touring Wagon 2.0GT", "EJ20X Turbo", "Wagon")
    add_vehicle(year, "Legacy", "Touring Wagon 2.0GT Spec.B", "EJ20Y Turbo", "Wagon")
    add_vehicle(year, "Legacy", "B4 3.0R", "EZ30 NA", "Sedan")
    add_vehicle(year, "Legacy", "B4 3.0R Spec.B", "EZ30R NA", "Sedan")
    if year >= 2006:
        add_vehicle(year, "Legacy", "S402 STI", "EJ207 Turbo", "Sedan")

# BM/BR Era (2009-2014)
for year in range(2009, 2015):
    add_vehicle(year, "Legacy", "B4 2.5GT", "EJ255 Turbo", "Sedan")
    add_vehicle(year, "Legacy", "B4 2.5GT S Package", "EJ255 Turbo", "Sedan")
    add_vehicle(year, "Legacy", "Touring Wagon 2.5GT", "EJ255 Turbo", "Wagon")
    add_vehicle(year, "Legacy", "B4 2.5i EyeSight", "FB25 NA", "Sedan")

# BN/BS Era (2014-2020)
for year in range(2014, 2021):
    add_vehicle(year, "Legacy", "B4", "FB25 NA", "Sedan")
    add_vehicle(year, "Legacy", "Outback", "FB25 NA", "Wagon")
    if year <= 2019:
        add_vehicle(year, "Legacy", "B4 Limited", "FA20 Turbo", "Sedan")

# ============================================================================
# FORESTER (JDM 1997-present)
# ============================================================================

# SF Era (1997-2002)
for year in range(1997, 2003):
    add_vehicle(year, "Forester", "C/tb", "EJ20 NA", "SUV")
    add_vehicle(year, "Forester", "S/tb", "EJ20 Turbo", "SUV")
    add_vehicle(year, "Forester", "S/tb Type A", "EJ20 Turbo", "SUV")

# SG Era (2002-2008)
for year in range(2002, 2008):
    add_vehicle(year, "Forester", "X", "EJ20 NA", "SUV")
    add_vehicle(year, "Forester", "XT", "EJ20 Turbo", "SUV")
    add_vehicle(year, "Forester", "Cross Sports", "EJ20 Turbo", "SUV")
    if year >= 2004:
        add_vehicle(year, "Forester", "STI", "EJ255 Turbo", "SUV")
        add_vehicle(year, "Forester", "STI Version", "EJ255 Turbo", "SUV")

# SH Era (2007-2012)
for year in range(2007, 2013):
    add_vehicle(year, "Forester", "2.0X", "EJ20 NA", "SUV")
    add_vehicle(year, "Forester", "2.0XS", "EJ20 NA", "SUV")
    add_vehicle(year, "Forester", "2.0XT", "EJ20 Turbo", "SUV")
    add_vehicle(year, "Forester", "S-Edition", "EJ25 Turbo", "SUV")

# SJ Era (2012-2018)
for year in range(2012, 2019):
    add_vehicle(year, "Forester", "2.0i", "FB20 NA", "SUV")
    add_vehicle(year, "Forester", "2.0i-L", "FB20 NA", "SUV")
    add_vehicle(year, "Forester", "2.0XT", "FA20 Turbo", "SUV")
    add_vehicle(year, "Forester", "tS STI", "FA20 Turbo", "SUV")

# SK Era (2018-present)
for year in range(2018, 2026):
    add_vehicle(year, "Forester", "Touring", "FB25 NA", "SUV")
    add_vehicle(year, "Forester", "Premium", "FB25 NA", "SUV")
    add_vehicle(year, "Forester", "X-Break", "FB25 NA", "SUV")
    add_vehicle(year, "Forester", "Advance", "FB20 Hybrid", "SUV")
    if year >= 2020:
        add_vehicle(year, "Forester", "STI Sport", "CB18 Turbo", "SUV")

# ============================================================================
# XV / CROSSTREK (JDM 2012-present)
# ============================================================================
for year in range(2012, 2018):
    add_vehicle(year, "XV", "2.0i", "FB20 NA", "Crossover")
    add_vehicle(year, "XV", "2.0i-L", "FB20 NA", "Crossover")
    add_vehicle(year, "XV", "Hybrid", "FB20 Hybrid", "Crossover")

for year in range(2017, 2026):
    add_vehicle(year, "XV", "1.6i-L EyeSight", "FB16 NA", "Crossover")
    add_vehicle(year, "XV", "2.0i-L EyeSight", "FB20 NA", "Crossover")
    add_vehicle(year, "XV", "2.0i-S EyeSight", "FB20 NA", "Crossover")
    add_vehicle(year, "XV", "Advance", "FB20 Hybrid", "Crossover")

# ============================================================================
# IMPREZA (Base JDM 1992-present)
# ============================================================================

# GC/GF Era (1992-2000)
for year in range(1992, 2001):
    add_vehicle(year, "Impreza", "1.5i", "EJ15 NA", "Sedan")
    add_vehicle(year, "Impreza", "1.6i", "EJ16 NA", "Sedan")
    add_vehicle(year, "Impreza", "1.8i", "EJ18 NA", "Sedan")
    add_vehicle(year, "Impreza", "2.0i", "EJ20 NA", "Sedan")
    add_vehicle(year, "Impreza", "Sports Wagon", "EJ18 NA", "Wagon")

# GD/GG Era (2000-2007)
for year in range(2000, 2008):
    add_vehicle(year, "Impreza", "1.5i", "EL15 NA", "Sedan")
    add_vehicle(year, "Impreza", "2.0i", "EJ20 NA", "Sedan")
    add_vehicle(year, "Impreza", "Sport Wagon 1.5i", "EL15 NA", "Wagon")
    add_vehicle(year, "Impreza", "Sport Wagon 2.0i", "EJ20 NA", "Wagon")

# GH/GE Era (2007-2011)
for year in range(2007, 2012):
    add_vehicle(year, "Impreza", "1.5i", "EL15 NA", "Hatchback")
    add_vehicle(year, "Impreza", "2.0i", "EJ20 NA", "Hatchback")
    add_vehicle(year, "Impreza", "S-GT", "EJ20 Turbo", "Hatchback")
    add_vehicle(year, "Impreza", "Anesis 1.5i", "EL15 NA", "Sedan")
    add_vehicle(year, "Impreza", "Anesis 2.0i", "EJ20 NA", "Sedan")

# GJ/GP Era (2011-2016)
for year in range(2011, 2017):
    add_vehicle(year, "Impreza", "G4 1.6i", "FB16 NA", "Sedan")
    add_vehicle(year, "Impreza", "G4 2.0i", "FB20 NA", "Sedan")
    add_vehicle(year, "Impreza", "Sport 1.6i", "FB16 NA", "Hatchback")
    add_vehicle(year, "Impreza", "Sport 2.0i", "FB20 NA", "Hatchback")

# GK/GT Era (2016-present)
for year in range(2016, 2026):
    add_vehicle(year, "Impreza", "G4 1.6i-L", "FB16 NA", "Sedan")
    add_vehicle(year, "Impreza", "G4 2.0i-L", "FB20 NA", "Sedan")
    add_vehicle(year, "Impreza", "Sport 1.6i-L", "FB16 NA", "Hatchback")
    add_vehicle(year, "Impreza", "Sport 2.0i-S", "FB20 NA", "Hatchback")
    if year >= 2020:
        add_vehicle(year, "Impreza", "STI Sport", "FB20 NA", "Hatchback")

# ============================================================================
# BRZ (JDM 2012-present)
# ============================================================================
for year in range(2012, 2021):
    add_vehicle(year, "BRZ", "R", "FA20 NA", "Coupe")
    add_vehicle(year, "BRZ", "S", "FA20 NA", "Coupe")
    add_vehicle(year, "BRZ", "GT", "FA20 NA", "Coupe")
    if year >= 2017:
        add_vehicle(year, "BRZ", "STI Sport", "FA20 NA", "Coupe")

for year in range(2021, 2026):
    add_vehicle(year, "BRZ", "R", "FA24 NA", "Coupe")
    add_vehicle(year, "BRZ", "S", "FA24 NA", "Coupe")
    add_vehicle(year, "BRZ", "STI Sport", "FA24 NA", "Coupe")

# ============================================================================
# EXIGA (2008-2018) - 7-seater
# ============================================================================
for year in range(2008, 2019):
    add_vehicle(year, "Exiga", "2.0i", "EJ20 NA", "Wagon")
    add_vehicle(year, "Exiga", "2.0GT", "EJ20 Turbo", "Wagon")
    add_vehicle(year, "Exiga", "2.5i", "EJ25 NA", "Wagon")
    if year >= 2012:
        add_vehicle(year, "Exiga", "Crossover 7", "FB25 NA", "Wagon")

# ============================================================================
# TREZIA (2010-2016) - rebadged Toyota
# ============================================================================
for year in range(2010, 2017):
    add_vehicle(year, "Trezia", "1.3i", "1NR-FE NA", "Hatchback", "FWD")
    add_vehicle(year, "Trezia", "1.5i", "1NZ-FE NA", "Hatchback", "FWD")

# ============================================================================
# KEI CARS - SAMBAR (1961-present)
# ============================================================================

# Sambar Van/Truck (own production 1990-2012)
for year in range(1990, 2013):
    add_vehicle(year, "Sambar", "Van", "EN07 NA", "Van", "RWD")
    add_vehicle(year, "Sambar", "Van 4WD", "EN07 NA", "Van")
    add_vehicle(year, "Sambar", "Truck", "EN07 NA", "Truck", "RWD")
    add_vehicle(year, "Sambar", "Truck 4WD", "EN07 NA", "Truck")
    if year >= 1992:
        add_vehicle(year, "Sambar", "Van SC", "EN07 Supercharged", "Van")
        add_vehicle(year, "Sambar", "Dias", "EN07 NA", "Van")
        add_vehicle(year, "Sambar", "Dias SC", "EN07 Supercharged", "Van")

# Sambar (Daihatsu OEM 2012+)
for year in range(2012, 2026):
    add_vehicle(year, "Sambar", "Van", "KF NA", "Van", "RWD")
    add_vehicle(year, "Sambar", "Van 4WD", "KF NA", "Van")
    add_vehicle(year, "Sambar", "Truck", "KF NA", "Truck", "RWD")
    add_vehicle(year, "Sambar", "Truck 4WD", "KF NA", "Truck")

# ============================================================================
# KEI CARS - VIVIO (1992-1998)
# ============================================================================
for year in range(1992, 1999):
    add_vehicle(year, "Vivio", "ef", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Vivio", "ef 4WD", "EN07 NA", "Hatchback")
    add_vehicle(year, "Vivio", "RX-R", "EN07 Supercharged", "Hatchback", "FWD")
    add_vehicle(year, "Vivio", "RX-RA", "EN07 Supercharged", "Hatchback")
    add_vehicle(year, "Vivio", "GX-R", "EN07 Supercharged", "Hatchback")
    add_vehicle(year, "Vivio", "Bistro", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Vivio", "T-Top", "EN07 Supercharged", "Targa")

# ============================================================================
# KEI CARS - PLEO (1998-2018)
# ============================================================================

# 1st gen (1998-2009)
for year in range(1998, 2010):
    add_vehicle(year, "Pleo", "A", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "L", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "RS", "EN07 Supercharged", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "RS 4WD", "EN07 Supercharged", "Hatchback")
    add_vehicle(year, "Pleo", "Nesta", "EN07 NA", "Hatchback", "FWD")

# 2nd gen (2010-2018) - Daihatsu OEM
for year in range(2010, 2019):
    add_vehicle(year, "Pleo", "A", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "L", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "Plus", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Pleo", "Plus 4WD", "KF NA", "Hatchback")

# ============================================================================
# KEI CARS - R1 (2005-2010)
# ============================================================================
for year in range(2005, 2011):
    add_vehicle(year, "R1", "i", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "R1", "R", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "R1", "S", "EN07 Supercharged", "Hatchback", "FWD")
    add_vehicle(year, "R1", "i 4WD", "EN07 NA", "Hatchback")
    add_vehicle(year, "R1", "S 4WD", "EN07 Supercharged", "Hatchback")

# ============================================================================
# KEI CARS - R2 (2003-2010)
# ============================================================================
for year in range(2003, 2011):
    add_vehicle(year, "R2", "i", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "R2", "R", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "R2", "S", "EN07 Supercharged", "Hatchback", "FWD")
    add_vehicle(year, "R2", "S 4WD", "EN07 Supercharged", "Hatchback")
    add_vehicle(year, "R2", "RC", "EN07 NA", "Hatchback", "FWD")

# ============================================================================
# KEI CARS - STELLA (2006-present)
# ============================================================================

# 1st gen (2006-2011) - own platform
for year in range(2006, 2012):
    add_vehicle(year, "Stella", "L", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "LX", "EN07 NA", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "RS", "EN07 Supercharged", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "RN 4WD", "EN07 NA", "Hatchback")
    add_vehicle(year, "Stella", "Custom RS", "EN07 Supercharged", "Hatchback")

# 2nd gen+ (2011+) - Daihatsu OEM
for year in range(2011, 2026):
    add_vehicle(year, "Stella", "L", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "G", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "Custom R", "KF Turbo", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "Custom RS", "KF Turbo", "Hatchback", "FWD")
    add_vehicle(year, "Stella", "L 4WD", "KF NA", "Hatchback")

# ============================================================================
# KEI CARS - LUCRA (2010-2014)
# ============================================================================
for year in range(2010, 2015):
    add_vehicle(year, "Lucra", "L", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Lucra", "G", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Lucra", "Custom G", "KF NA", "Hatchback", "FWD")
    add_vehicle(year, "Lucra", "Custom RS", "KF Turbo", "Hatchback", "FWD")
    add_vehicle(year, "Lucra", "L 4WD", "KF NA", "Hatchback")

# ============================================================================
# KEI CARS - REX (1972-1992)
# ============================================================================
for year in range(1981, 1993):
    add_vehicle(year, "Rex", "Standard", "EN05 NA", "Hatchback", "FWD")
    add_vehicle(year, "Rex", "4WD", "EN05 NA", "Hatchback")
    if year >= 1986:
        add_vehicle(year, "Rex", "VX", "EN07 NA", "Hatchback", "FWD")
        add_vehicle(year, "Rex", "VX Supercharger", "EN05 Supercharged", "Hatchback", "FWD")

# ============================================================================
# DIAS WAGON (1999-2009)
# ============================================================================
for year in range(1999, 2010):
    add_vehicle(year, "Dias Wagon", "Classic", "EN07 NA", "Wagon")
    add_vehicle(year, "Dias Wagon", "Super Charger", "EN07 Supercharged", "Wagon")
    add_vehicle(year, "Dias Wagon", "TA", "EN07 NA", "Wagon")

# ============================================================================
# JUSTY (JDM versions)
# ============================================================================
for year in range(1984, 1995):
    add_vehicle(year, "Justy", "J", "EF10 NA", "Hatchback", "FWD")
    add_vehicle(year, "Justy", "JL", "EF12 NA", "Hatchback", "FWD")
    add_vehicle(year, "Justy", "4WD", "EF12 NA", "Hatchback")
    if year >= 1988:
        add_vehicle(year, "Justy", "RS", "EF12 Supercharged", "Hatchback", "FWD")

# ============================================================================
# ALCYONE / SVX (JDM)
# ============================================================================
for year in range(1985, 1991):
    add_vehicle(year, "Alcyone", "VR", "EA82 Turbo", "Coupe")
    add_vehicle(year, "Alcyone", "VR-II", "EA82 Turbo", "Coupe")

for year in range(1991, 1997):
    add_vehicle(year, "Alcyone SVX", "S3", "EG33 NA", "Coupe")
    add_vehicle(year, "Alcyone SVX", "S4", "EG33 NA", "Coupe")
    add_vehicle(year, "Alcyone SVX", "Version L", "EG33 NA", "Coupe")

# ============================================================================
# OUTBACK (JDM - called Lancaster until 2003)
# ============================================================================
for year in range(1995, 2004):
    add_vehicle(year, "Legacy Lancaster", "6", "EZ30 NA", "Wagon")
    add_vehicle(year, "Legacy Lancaster", "S", "EJ25 NA", "Wagon")

for year in range(2003, 2010):
    add_vehicle(year, "Outback", "2.5i", "EJ25 NA", "Wagon")
    add_vehicle(year, "Outback", "3.0R", "EZ30 NA", "Wagon")

for year in range(2009, 2015):
    add_vehicle(year, "Outback", "2.5i", "FB25 NA", "Wagon")
    add_vehicle(year, "Outback", "2.5i EyeSight", "FB25 NA", "Wagon")
    add_vehicle(year, "Outback", "3.6R", "EZ36 NA", "Wagon")

for year in range(2014, 2026):
    add_vehicle(year, "Outback", "Limited", "FB25 NA", "Wagon")
    if year < 2021:
        add_vehicle(year, "Outback", "Limited EyeSight", "FB25 NA", "Wagon")
    else:
        add_vehicle(year, "Outback", "Limited EX", "CB18 Turbo", "Wagon")
        add_vehicle(year, "Outback", "X-Break", "CB18 Turbo", "Wagon")

# ============================================================================
# SOLTERRA (JDM 2022+)
# ============================================================================
for year in range(2022, 2026):
    add_vehicle(year, "Solterra", "ET-SS", "Electric", "SUV")
    add_vehicle(year, "Solterra", "ET-HS", "Electric", "SUV")


def main():
    print(f"Generated {len(JDM_VEHICLES)} JDM vehicle entries")
    
    # Load existing vehicles
    with open(VEHICLES_JSON, "r", encoding="utf-8-sig") as f:
        existing = json.load(f)
    
    print(f"Existing vehicles: {len(existing)}")
    
    # Create unique keys for deduplication
    existing_keys = set()
    for v in existing:
        key = (v["year"], v["model"], v.get("trim", ""))
        existing_keys.add(key)
    
    # Add new JDM vehicles (avoid duplicates)
    added = 0
    for v in JDM_VEHICLES:
        key = (v["year"], v["model"], v.get("trim", ""))
        if key not in existing_keys:
            existing.append(v)
            existing_keys.add(key)
            added += 1
    
    # Sort by year, model, trim
    existing.sort(key=lambda x: (x.get("year", 9999), x.get("model", ""), x.get("trim", "")))
    
    print(f"Added {added} new JDM vehicles")
    print(f"Total vehicles: {len(existing)}")
    
    # Write back
    with open(VEHICLES_JSON, "w", encoding="utf-8") as f:
        json.dump(existing, f, indent=2, ensure_ascii=False)
    
    print(f"Written to {VEHICLES_JSON}")
    
    # Summary by model
    from collections import Counter
    models = Counter(v["model"] for v in JDM_VEHICLES)
    print("\nJDM models added:")
    for model, count in models.most_common(20):
        print(f"  {model}: {count}")


if __name__ == "__main__":
    main()
