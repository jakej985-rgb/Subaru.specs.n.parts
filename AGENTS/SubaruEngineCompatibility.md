# Agent Plan: Add Subaru Engine Compatibility Module (EJ Phase 1/2 + FB)

## 0) Goal

Add a Compatibility feature that lets a user pick:

Chassis/Year/Model/Trim (optional v1)

Engine code (EJ251, EJ253, EJ205, FB20, etc.)

“Phase” (Phase 1 / Phase 2 / FB era) …and outputs:

Swap compatibility level (Plug-and-play / Minor changes / Harness merge / Not recommended)

Required changes checklist (ECU, intake manifold, cam/crank triggers, DBW vs cable, AVCS, MAF/MAP, EGR)

Known gotchas (PZEV, immobilizer, CAN-bus on FB, etc.)

## 1) App Structure Additions

### 1.1 Folder / Project Tree (additions)

**Note:** Adapted to `SubaruParts` namespace structure.

```
SubaruParts.Domain/
|_ Compatibility/
|     |_ EngineCode.cs
|     |_ EnginePhase.cs
|     |_ EngineProfile.cs
|     |_ VehicleProfile.cs
|     |_ CompatibilityRule.cs
|     |_ CompatibilityResult.cs
|     |_ Logic/
|        |_ CompatibilityEngine.cs
|        |_ RuleEvaluator.cs
|        |_ CompatibilityExplainer.cs

SubaruParts.Data/
|_ Seeds/
|  |_ engines.json
|  |_ rules.json
|_ Services/
   |_ CompatibilityRepository.cs (or Service)

SubaruParts.App/ (Android UI)
|_ Pages/
|  |_ CompatibilityPage.xaml
|  |_ CompatibilityPage.xaml.cs
|_ ViewModels/
   |_ CompatibilityViewModel.cs
```

## 2) Data Model (Domain)

### 2.1 Enums

`EnginePhase`: Phase1, Phase2, FB, FA, Unknown

`ThrottleType`: Cable, DBW, Unknown

`AirMetering`: MAF, MAP, SpeedDensity, Unknown

`ValveControl`: None, AVCS, AVLS, DualAVCS, Unknown

`EcuBus`: NonCan, CanBus


### 2.2 EngineProfile

Each engine code gets a profile:

Code: "EJ251"

Phase: Phase2

Years: [1999..2004] (range)

Throttle: Cable

AirMetering: MAF or MAP (if known)

ValveControl: None / AVCS

EcuBus: NonCan for EJ, CanBus for FB-era

Notes: short string


### 2.3 VehicleProfile (v1 simple)

For first pass, keep it lightweight:

Model: Impreza / Forester / Legacy / Outback

Year: int

Region: US / JDM / EU (optional)

HasImmobilizer: bool (optional but useful for 2005+)


### 2.4 CompatibilityResult

Score: 0–100

Level: enum: PlugAndPlay, MinorMods, MajorMods, NotRecommended

RequiredChanges: list of ChangeItem { Title, Details, Severity }

Warnings: list

RecommendedApproach: text (“use donor ECU/harness”, “swap intake manifold”, etc.)


## 3) Rules System (this is the magic)

### 3.1 Rule format (JSON, easy to expand)

rules.json entries like:

If donor.phase != target.phase -> MajorMods

If donor.valveControl includes AVCS and target ECU can’t -> require “AVCS wiring + ECU/merge”

If donor.ecuBus = CAN and target.ecuBus = NonCan -> “Not recommended without standalone / full swap”


Example rule schema:

```json
{
  "id": "fb_into_ej",
  "when": {
    "donor": { "ecuBus": "CanBus" },
    "target": { "ecuBus": "NonCan" }
  },
  "effect": {
    "level": "NotRecommended",
    "scoreDelta": -80,
    "addWarning": "FB/FA CAN-bus ECU + immobilizer makes EJ-era swap a full custom job.",
    "addChange": {
      "title": "Standalone ECU or full donor electronics",
      "details": "Requires complete harness/ECU/cluster/immobilizer integration or standalone.",
      "severity": "High"
    }
  }
}
```

### 3.2 Rule categories you should implement first

**Compatibility Rules**
* Phase rules
  * Phase1 <-> Phase1 = OK baseline
  * Phase2 <-> Phase2 = OK baseline
  * Phase1 <-> Phase2 = Major mods (triggers/intake/sensors)
  * EJ <-> FB = Not recommended unless standalone/full donor

* ECU/Controls rules
  * AVCS present but target ECU lacks = Major
  * DBW vs Cable mismatch = Minor/Major depending on approach
  * Immobilizer mismatch (2005+ often) = Major

* Intake/Sensor rules
  * MAP vs MAF mismatch = intake/ECU/sensor swap required
  * EGR present/absent mismatch = warning + fix required

* Emissions special-case
  * PZEV heads mismatch = warning/high complexity


## 4) Compatibility Engine (Logic layer)

### 4.1 CompatibilityEngine

Inputs:

`EngineProfile` donorEngine

`VehicleProfile` targetVehicle (or `EngineProfile` targetEngine if you do engine-to-engine mode)

Outputs:

`CompatibilityResult`


Algorithm:

1. Start baseline: score 100, level PlugAndPlay


2. Run rules in deterministic order (Phase → ECU → Sensors → Emissions)


3. Apply score deltas and “max severity wins” for level


4. Produce a friendly explanation via CompatibilityExplainer



### 4.2 CompatibilityExplainer

Generates user-readable summary:

“This is a Phase 2 EJ into a Phase 1 chassis: expect harness + trigger changes.”

Bullet list of required changes


## 5) UI (Android / .NET)

### 5.1 Compatibility Page

Minimal v1 UI:

Donor Engine dropdown (EJ205, EJ251, EJ253, EJ255, EJ257, FB20, FB25…)

Target selection:

Option A: “Target Vehicle Year/Model”

Option B: “Target Engine Code” (easier for v1)


Button: “Check Compatibility”

Output cards:

Compatibility level + score

Required changes checklist

Warnings



### 5.2 Reuse your theming

Make it match your neon / clean UI style:

severity colors (don’t hardcode, use theme tokens)

card glow for “Plug and Play”

warning glow for “Major Mods”


## 6) Seed Data (Data layer)

### 6.1 engines.json starter list (v1)

Include at least:

Phase 1: EJ22 (EJ22E), EJ25D

Phase 2 NA: EJ251, EJ252, EJ253

Phase 2 turbo: EJ205, EJ255, EJ257

FB: FB20, FB25


Each entry includes the fields from EngineProfile. Don’t try to be perfect—just structure it so you can add more later.


## 7) Testing (must-have)

### 7.1 Unit tests (Logic)

Create tests like:

Phase2 NA → Phase2 NA (EJ251 into EJ251 target) = PlugAndPlay or MinorMods

EJ253 (AVCS) → older Phase2 target ECU = MajorMods (AVCS rule triggered)

FB20 → EJ251 target = NotRecommended (CAN-bus rule)

DBW engine → cable target = requires change item


### 7.2 Snapshot tests (optional)

Validate the explanation text is stable (so UI doesn’t regress).


## 8) “Expand Later” Roadmap

v1: engine-to-engine compatibility + checklist
v2: add vehicle year/model trims + actual harness/ECU generation mapping
v3: add part cross-links (intake manifold, throttle body, sensors) as “required parts”
v4: add community notes + citations per rule
v5: offline-first sync of rules/engines dataset
