# Test Forge Journal

This journal tracks critical test-enablement learnings.

## 2024-05-23 - Initial Profile **Learning:** Headless environment lacks Flutter SDK. **Action:** Created `scripts/setup_env.sh` to install Flutter locally and persist to `.bashrc`.

## 2024-05-23 - Flaky Pagination Test **Learning:** `SpecListPage` tests (`spec_list_pagination_test.dart`) are flaky. They fail with `Expected: <2> Actual: <3>`, likely due to double-triggering of the infinite scroll listener during `scrollUntilVisible` and `drag`. **Action:** Future work should debounce the listener in the test or relax expectations.

## 2026-01-04 - SemanticsHandle Disposal **Learning:** 'addTearDown(handle.dispose)' fails in 'testWidgets' because verification happens before tear-down. **Action:** Call 'handle.dispose()' explicitly.
