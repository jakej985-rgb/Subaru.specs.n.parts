## 2025-01-05 - Missing Import in Test

**Learning:** When adding new test files, ensuring all referenced classes (even those generated or from seed runners) are explicitly imported is critical. The `Vehicle` class, being a Drift generated data class, needs to be imported from `package:specsnparts/data/db/app_db.dart` to be recognized in tests, even if `seed_runner.dart` is imported.

**Action:** Always check imports for data classes when creating or modifying tests involving seed data parsing. Run `flutter test <file>` locally to catch these compilation errors before CI.

## 2025-01-06 - Blocking UI Hides Race Conditions

**Learning:** A full-screen blocking loader prevents users (and tests) from navigating away or changing selections, effectively masking race conditions by forcing serial execution. However, this is poor UX. When unblocking the UI to improve UX (e.g., using a non-modal loader), race conditions become possible and must be handled (e.g., by checking `mounted` and `_selectedYear` after async calls).

**Action:** When testing for race conditions, ensure the UI actually permits the sequence of interactions required to trigger the race. If the UI blocks, the test is invalid (or testing a different state). Prefer non-blocking loaders with state checks for async results.
