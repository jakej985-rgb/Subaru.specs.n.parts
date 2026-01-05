## 2025-01-05 - Missing Import in Test

**Learning:** When adding new test files, ensuring all referenced classes (even those generated or from seed runners) are explicitly imported is critical. The `Vehicle` class, being a Drift generated data class, needs to be imported from `package:specsnparts/data/db/app_db.dart` to be recognized in tests, even if `seed_runner.dart` is imported.

**Action:** Always check imports for data classes when creating or modifying tests involving seed data parsing. Run `flutter test <file>` locally to catch these compilation errors before CI.
