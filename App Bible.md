# Subaru Specs & Parts App Bible 📖

**Version:** 1.0 (Current Codebase State)

---

## 1. Mission Statement

*Subaru Specs & Parts is an offline-first mobile app that helps Subaru owners and enthusiasts manage their vehicles, look up factory specifications, find OEM and aftermarket parts, and explore engine architecture. The app is designed to be fast, reliable, and useful, utilizing local storage so data is available instantly—even without an internet connection.*

---

## 2. Core Principles

* ✅ **Offline-first:** All data is seeded and stored locally via SQLite (Drift).
* ✅ **Speed & Reliability:** Instant access to specs and parts; no loading screens for core data.
* ✅ **Accuracy:** Factory data is preserved and heavily tested to prevent accidental overwrites (e.g., specific torque specs for exact trims).
* ✅ **Discoverability:** Multiple ways to find data (YMMT, VIN, Engine Family, Global Search).

---

## 3. Tech Stack & Architecture

* **Framework:** Flutter (Dart ^3.10)
* **State Management:** Riverpod 3 (using `Notifier`, `FutureProvider`, etc.)
* **Routing:** `go_router` (Nested routing, parameter passing)
* **Local Database:** Drift (SQLite) with CSV/JSON seed data parsing.
* **Storage:** `shared_preferences` for user settings and local state (e.g., Garage recents/favorites).

### Data Seeding Process
Data is managed via `SeedRunner`, which parses flat JSON and CSV files from `assets/seed/`. It populates `Specs`, `Parts`, and `Vehicles` tables on app initialization. The architecture uses both 'Library Files' (shared tags) and 'Override Maps' (exact YMMT matches).

---

## 4. Current Core Features

### 1. Garage (Home)
* View recently browsed vehicles and favorite vehicles.
* Managed by `RecentVehiclesNotifier` and `FavoriteVehiclesNotifier` using `shared_preferences`.

### 2. Vehicle Browser (YMMT)
* Drill down by Year, Make, Model, and Trim to find specific vehicle data.

### 3. Specifications (Specs)
* View specs categorized by Fluids, Torque, Wheels, Bulbs, Brakes, Maintenance, etc.
* Includes dynamic tagging logic (`_parseWideRow`) to assign properties to categories (e.g., "fluid" keys go to Fluids category).

### 4. BoxerTree Engine Browser
* Deep dive into Subaru engine families (EA, EJ, FA, FB, etc.).
* View distinct motors within families, and see which vehicles those motors are equipped in.

### 5. Part Lookup
* Search for parts by name, OEM part number, or aftermarket numbers.
* Results are linked to vehicle fitment.

### 6. Comparison Tool
* Select two different vehicle configurations to compare specs side-by-side.

### 7. Global Search
* A quick overlay search accessible across the app to find vehicles or specs rapidly.

### 8. VIN Decoder (Wizard)
* Basic offline VIN parsing logic to identify Year, Make, Model, and Engine data from the VIN string.

---

## 5. Database Schema (Drift)

* **Vehicles Table:** `id`, `year`, `make`, `model`, `trim`, `engineCode`, `updatedAt`
* **Specs Table:** `id`, `category`, `title`, `body`, `tags`, `updatedAt`
* **Parts Table:** `id`, `name`, `oemNumber`, `aftermarketNumbers`, `fits`, `notes`, `updatedAt`

---

## 6. Directory Structure

```text
lib/
├── app.dart                  # App initialization, Theme, Router setup
├── main.dart                 # Entry point, ProviderScope initialization
├── data/
│   ├── db/                   # Drift Tables and DAOs (Vehicles, Specs, Parts)
│   └── seed/                 # SeedRunner and CSV/JSON parsing logic
├── domain/
│   ├── engines/              # Engine string parsing and data structures
│   └── fitment/              # Fitment key generation rules
├── features/
│   ├── browse_ymm/           # Year/Make/Model/Trim flow
│   ├── comparison/           # Side-by-side vehicle comparison
│   ├── engines/              # BoxerTree Engine Family/Motor UI
│   ├── global_search/        # Global overlay search
│   ├── home/                 # Garage, Recent/Favorite vehicles
│   ├── part_lookup/          # Part search by OEM/name
│   ├── settings/             # App settings and data management
│   ├── specs/                # Vehicle specific specifications
│   ├── specs_by_category/    # Browse all specs by a specific category
│   └── vin_wizard/           # Offline VIN decoder
├── router/
│   └── app_router.dart       # go_router configuration
├── theme/
│   ├── app_theme.dart        # Global theming, colors, text styles
│   ├── tokens.dart           # Design tokens
│   └── widgets/              # Reusable UI components (Neon icons, plates)
└── widgets/                  # Shared utility widgets
```

---

## 7. Roadmap & Future Features

While the core reference capability is established, the following features are planned for future versions:

* **Maintenance Tracking:** Allow users to log completed maintenance tasks, dates, mileage, and costs.
* **Custom Vehicle Modifications:** Allow users to add aftermarket parts and override factory specs for their specific garage vehicles.
* **Cloud Sync:** Optional syncing to back up garage data and maintenance records.
* **Shared Garages:** Ability to share a vehicle's build sheet and maintenance history.

