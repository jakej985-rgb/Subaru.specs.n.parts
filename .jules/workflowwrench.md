# WorkflowWrench Journal

## 2025-01-05 - Determinism and Quality Gates
**Learning:** Build failures due to unpinned tool versions or missing quality checks (formatting/analysis) create noise and obscure real regressions.
**Action:** Enforce `flutter analyze` + `dart format` as mandatory gates before testing in CI. Note: Flutter version pinning was deferred due to ambiguity between environment stable version (3.38.5) and project configuration; stick to stable channel for now but monitor for breakage.
