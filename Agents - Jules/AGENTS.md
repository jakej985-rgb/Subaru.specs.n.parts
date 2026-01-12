# AGENTS.md — Subaru Specs & Parts (Jules)

This folder contains specialist agent prompts to keep work focused, small, and safe.

## How to use
Pick **one agent** that matches the task, follow its Daily Process, and keep PRs small and scoped.

**Global rules (apply to every agent):**
- Run:
  - `flutter pub get`
  - `dart format .`
  - `flutter analyze`
  - `flutter test`
- Avoid big refactors unless explicitly asked.
- Avoid new dependencies unless you ask first.
- Prefer **one clear improvement** per PR.

---

## Agent roster

### ⚡ Bolt — Performance Optimizer
**Use when:** UI feels janky, queries are slow, rebuilds are excessive, or you want one measurable speed win.
**File:** `Bolt⚡️.md`

### 🐛 BugEater — Debugging / Bug Fixer
**Use when:** Something is broken, crashing, incorrect, or flaky; you need a root-cause fix with proof.
**File:** `Bug Eater🐛.md`

### 🩺 CompileMedic — Compiler / Build Triage
**Use when:** You have compiler errors, analyzer warnings, or build failures (local or CI).
**File:** `CompileMedic.md`

### 🧰 DataSmith — Seed Data Builder + Validator
**Use when:** Seed data needs cleanup, consistency, missing values, validation, or provenance improvements.
**File:** `Data Smith.md`

### 🔁 OEM-XRef — OEM ↔ Aftermarket Cross-Reference
**Use when:** Users need part number equivalence mapping (OEM ↔ aftermarket), supersessions, or better PN matching.
**File:** `OEM xref.md`

### 🛡️ FitmentGuard — Compatibility Rules Engine
**Use when:** You’re adding or fixing “fits/doesn’t fit/unknown” logic, swap compatibility, or explanation strings.
**File:** `fitment guard.md`

### 📚🛠️ TorqueSaga — Torque & Fluids Specs
**Use when:** Adding torque specs, fluid capacities/types, applicability ranges, safety notes, or clarifying presentation.
**File:** `TorqueSaga.md`

### 📚🔧 SpecKeeper — General Specs Curator (non-torque)
**Use when:** Adding or organizing specs like bolt pattern, OBD, diff types, trans families, ratios, and applicability.
**File:** `Spec Keeper 📚🔧 .md`

### 🔧 SwapOracle — No-Fuss Swaps & Mods
**Use when:** Capturing plug-and-play mods, no-fuss swaps, NA→Turbo guidance, and required parts/caveats.
**File:** `Swap Oracle.md`

### 🔍 VINWizard — VIN Decode → Vehicle Suggestions
**Use when:** Implementing VIN decoding, vehicle profile suggestions, validation, or privacy-safe VIN handling.
**File:** `VinWizard.md`

### ⚡ SearchTuner — Offline Search Speed + Relevance
**Use when:** Search feels slow, results are poorly ranked, OEM numbers don’t match well, or indexing is needed.
**File:** `Search Tuner.md`

### 🧱 SchemaMechanic — Drift Schema + Migrations
**Use when:** Any DB schema/migration/backfill work is needed, or you need safer upgrades.
**File:** `Schema Mechanic.md`

### 🧪🩺 TestForge — Tests / Regression Locks
**Use when:** Adding tests, improving coverage, stabilizing flaky tests, or creating “fails before / passes after” checks.
**File:** `TEST FORGE🧪🩺.md`

### 🔩 WorkflowWrench — CI / Build / Release Reliability
**Use when:** GitHub Actions fails, builds are flaky, codegen steps missing, caching/pinning needed, releases unreliable.
**File:** `Work Flow Wrench.md`

### 🧭 UXRouteKeeper — Navigation + UX Polish
**Use when:** Fixing go_router flows, back behavior, deep links, state restore, or reducing taps/confusion.
**File:** `UX Route Keeper.md`

### ✍️ DocScribe — Docs / Contributor Enablement
**Use when:** README/Docs are outdated, unclear, missing steps, or need examples/checklists that unblock contributors.
**File:** `DocScribe.md`

### 💡🛠️ IdeaSmith — Small Feature Builder
**Use when:** You want one small user-facing feature/UX win that fits existing patterns and stays offline-first.
**File:** `Idea Smith 💡🛠️ .md`

### 🗂️🚗 ModelWarden — Domain Model Guardian
**Use when:** Cleaning up enums/models/identifiers/validation so data stays consistent and future features are easier.
**File:** `MODEL WARDEN 🗂️🚗.md`

---

## Quick chooser (cheat sheet)
- Crash / wrong behavior → **BugEater**
- Compiler/build/analyzer errors → **CompileMedic**
- Performance/jank/slow queries → **Bolt**
- Messy or inconsistent seeds → **DataSmith**
- “What replaces this OEM #?” → **OEM-XRef**
- “Does this fit?” → **FitmentGuard**
- Torque/fluids missing → **TorqueSaga**
- Specs missing (non-torque) → **SpecKeeper**
- Swaps/mod paths → **SwapOracle**
- VIN to YMMT help → **VINWizard**
- Search slow/bad results → **SearchTuner**
- DB changes/migrations → **SchemaMechanic**
- Navigation polish → **UXRouteKeeper**
- Need tests / prevent regression → **TestForge**
- CI/build/release issues → **WorkflowWrench**
- Docs / contributor help → **DocScribe**
- One small feature idea → **IdeaSmith**
- Domain model consistency → **ModelWarden**
