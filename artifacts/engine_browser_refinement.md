# Engine Browser Refinement & Optimization: Technical Deep Dive

**Status:** Completed ✅ | **Implementation Period:** 2026-01-16
**Objective:** Transform the engine browsing experience into a high-performance, hierarchical flow with market-aware indicators and data-layer optimizations.

---

## 🏗 Modular UI Architecture

We refactored the sprawling engine browsing code into a modular set of components and pages under `lib/features/engines/`.

### 1. `EngineFamilyPage` (Entry Point)
The new primary landing page for engine browsing. It presents a high-level gallery of engine families.
- **Header:** Features an "**All Engines**" card linking to the grouped detailed list.
- **Grid/List:** Displays cards for each family (EA, EJ, FA, etc.) with:
  - Motor count (e.g., "24 motors")
  - Model count (e.g., "5 models")
  - Market badges aggregated at the family level.

### 2. `AllEnginesPage` (Detailed Grouped View)
A specialized view that groups every engine code by its family.
- **Performance (Virtualization):** Uses `ListView.builder` with a flattened heterogeneous list of `_HeaderItem` and `_EngineItem`. This ensures only visible items are rendered, providing smooth performance for 100+ engine codes.
- **Visual Distinction:** Family headers are color-coded (EJ=Blue, FA=Red, FB=Green) with clear "natural sort" ordering (EA → EJ → FA).

### 3. `EngineMotorPage` & `EngineVehicleResultsPage`
Deep-linkable pages that handle the narrowed-down browsing levels:
- **Motor Page:** Shows specific variants (e.g., EJ205 vs EJ207) with high-confidence engine descriptions.
- **Results Page:** Displays compatible vehicles with year/model/trim details and per-vehicle market badges.

### 4. `BrowseHubPage` (Navigation Consolidation)
To improve Home screen ergonomics, we introduced a centralized Browse Hub.
- **Role:** Acts as a gateway for all catalog exploration paths (Year/Make/Model, Engine, and Category-based).
- **Consolidation:** Reduced Home screen visual noise by moving three distinct entry points behind a single "Browse" trigger.

---

## ⚡ Data Layer & Performance Engineering

The original implementation suffered from massive overhead due to N+1 query patterns. We optimized this from the ground up.

### 1. Database Optimization (`VehiclesDao`)
We bypassed the "fetch one by one" problem by adding a bulk-mapping utility:
- **`getEngineCodesWithTrims()`**: A single SQL query that retrieves all distinct `engineCode` → `trim` pairs in the database.
- **Impact:** Reduced page load initial logic from ~150 sequential DB calls to **1 single pass**. This eliminates "loading flicker" during engine browsing.

### 2. Provider Consolidation & Model Counting
We moved heavy parsing and grouping logic into Riverpod providers and refined the counting logic to be more relevant to users:
- **`enginesByFamilyProvider`**: Performs the heavy lifing—fetching counts, fetching trims, parsing codes, grouping by family, and sorting everything.
- **Distinct Model Counting**: Counts are now based on **distinct car models** (e.g., Alcyone, Leone) rather than total database entries (trims). This accurately reflects the breadth of engine applicability.
- **Computation Reuse**: `engineFamilyIndexProvider` now derived its data from `enginesByFamilyProvider`, avoiding redundant parsing work.

---

## 🧬 Domain Logic: The Engine Parser

Engine data in the wild is often messy (e.g., "EJ255 Turbo", "EJ255/EJ257"). Our parser (`lib/domain/engines/engine_parse.dart`) provides a source of truth:

### 1. Parsing Strategy
- **Family Extraction:** Leading alphabetic characters (e.g., `EJ`).
- **Motor Code:** The first distinct token (e.g., `EJ255`).
- **Sorting Logic:** Implemented **Natural Sorting** so that `EA` comes before `EJ`, and `EJ20` comes before `EJ205`.

### 2. Family Priority
We defined a canonical sorting order based on era and significance:
1. **EA** (Classic)
2. **EJ** (Iconic)
3. **EG/ER/EZ** (Early / Multi-cylinder)
4. **FA/FB** (Modern)
5. **CB/EN/EF** (Turbo/Kei/Small)

---

## 🚩 Market-Aware Intelligence (`MarketBadge`)

The application now understands "Market Context" even though it's not explicitly in the schema.

### 1. Inference Engine
The `MarketBadge` system uses a set of heuristics to determine the market region from vehicle trim data:
- `(JDM)` or `STi` (often) → **JDM** 🇯🇵
- `(US)`, `(CAN)`, `(USDM)` → **USDM** 🇺🇸
- `(EU)`, `(EUDM)` → **EUDM** 🇪🇺
- `(AU)`, `(AUDM)` → **AUDM** 🇦🇺

### 2. Multi-Market Aggregation
When viewing groups (Families or Motors), the badge intelligently collapses multiple regions into a "Multi-Market" indicator or shows multiple flags if the set is small, providing users with instant visual feedback on part/engine availability.

---

## 🧭 Refined Navigation Flow

### 1. Unified Entry Point
- **Browse Hub:** Selecting "Browse" from the Home screen now leads to `/browse`, where users can choose their preferred discovery path. This pattern simplifies the top-level UX while keeping depth accessible.
- **Redirect:** `/browse/engine` → `/engines` (Forces users through the optimized family gallery first).
- **History-Aware Navigation:** Integrated "All Engines" as a detailed branch (`/browse/engine/all`) for advanced users who want a flat grouped list.
- **Deep Linking:** Every level of the BoxerTree has a clean URL structure, supporting future state-restoration or sharing.

---

## ✅ Quality Lock
- **416 Tests Passed**: Regression testing confirmed existing spec-matching logic remained intact.
- **0 Analysis Issues**: Clean bill of health from `flutter analyze`.
- **Natural Sort Verified**: `EJ205` correctly follows `EJ20` in the UI list.
