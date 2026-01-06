## 2026-01-06 - [DAO Input Validation Pattern]
**Vulnerability:** Missing input length validation in `SpecsDao.searchSpecs` and `PartsDao.searchParts` (DoS risk).
**Learning:** Client-side search queries using `contains` can be computationally expensive (or simply wasteful) if unchecked. Even with local SQLite, large inputs can cause memory spikes or freeze the UI thread (if not isolated).
**Prevention:** Enforce hard limits (e.g., 100 chars) on all DAO search methods. Return empty results immediately for violations.
