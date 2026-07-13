Version 0.1


---

1. Mission Statement

> Subaru Specs & Garage is an offline-first mobile app that helps Subaru owners manage their vehicles using accurate VIN decoding, factory specifications, maintenance tracking, and customizable vehicle data. The app is designed to be fast, reliable, and useful whether you're doing a simple oil change or building a fully modified project car.


---

2. Core Principles


✅ Offline-first

✅ User owns their data

✅ Factory data is never overwritten

✅ User modifications are tracked separately

✅ Every feature should reduce the number of taps

✅ Speed is more important than flashy animations



---

3. Minimum Viable Product (MVP)

Add vehicle

VIN decode

Manual vehicle entry

Garage

Vehicle details

~~Maintenance tracking~~ (Not yet implemented)

Fluid specifications

Settings


Everything else waits until after version 1.0.


---

4. Data Models

The core data models are defined as Drift database tables (SQLite):
- **Vehicles**: Stores year, make, model, trim, and engineCode.
- **Specs**: Stores specifications categorized by type (e.g., fluid, torque) with flexible tags (JSON/comma string) to link to specific vehicle configurations.
- **Parts**: Stores part names, OEM numbers, aftermarket numbers, and fitment details (JSON list).

*Note: Maintenance tracking tables do not exist yet.*



---

5. Screen List

**Home / Garage**
> Give the user a quick overview of their selected vehicle.
Widgets: Current vehicle, Mileage, Quick actions. (Maintenance tracking not yet implemented).

**VIN Wizard**
> Scan or manually enter a VIN to decode vehicle details.

**Parts Lookup**
> Search for parts by name or OEM number.

**Specs List & Categories**
> Browse vehicle specifications (Torque, Fluids, Bulbs, etc.) filtered by vehicle or category.

**Browse YMM & Engines**
> Browse vehicles by Year, Make, Model or through the Engine Family hierarchy (e.g., Boxer Tree).

**Global Search**
> Search across the entire app for vehicles, parts, and specs.

**Comparison**
> Compare specifications or parts side-by-side.

**Settings**
> Manage app preferences.


---

6. Features

**VIN Decoder**
Scan barcode, manual VIN entry, decode online, allow editing after decoding. Saves factory specs separately.

**Garage**
Manage a list of user vehicles.

**Vehicle Specifications (Implemented V1.5)**
Look up torque specs, fluid capacities, bulb types, and maintenance intervals for specific vehicles.

**Parts Database (Implemented V1.5)**
Look up OEM and aftermarket parts and their fitment.

**Engine Browser (Boxer Tree)**
Explore Subaru engine families, motors, and the vehicles they are found in.

**Global Search**
Quickly find information across the entire application using an overlay search interface.

**Comparison**
Compare specs side-by-side.


---

7. Roadmap

**Version 1.0 (Current MVP Base)**
- [x] Garage
- [x] VIN
- [ ] Maintenance (Not implemented yet)

**Version 1.5 (Specs & Parts - Currently Implemented)**
- [x] Parts database
- [x] Torque specs (and other specs)
- [x] Engine Browser
- [x] Global Search
- [x] Comparison

**Version 2.0**
- [ ] Cloud sync
- [ ] Shared garages
