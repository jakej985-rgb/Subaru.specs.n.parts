# Agent Instructions

## Known CI Failures + Fix Playbook

---

CI Failures Seen (GitHub Actions, Flutter 3.38.5 / Dart 3.10.4)

1) Compile error in seed coverage test: Undefined name 'Vehicle'

Log

test/data/seed/wrx_2024_coverage_test.dart:21:38: Error: Undefined name 'Vehicle'.

Line: Vehicle.fromJson(e)


Cause

The test file is missing the import that defines Vehicle (model or drift data class).


Fix

Add the correct import in wrx_2024_coverage_test.dart.

If Vehicle is a drift data class:
import 'package:specsnparts/data/db/app_db.dart';

If Vehicle lives in a model file, import that file instead (search repo for class Vehicle and import the defining library).



Verification

flutter test test/data/seed/wrx_2024_coverage_test.dart -r expanded -v


---

2) Widget test failing: pagination text not found

Log

SpecListPage implements pagination

Expected text "Spec 19" but finder found 0.


Most common causes

UI uses different display text than the test expects (seed title mismatch / label changed).

Async load not completed (missing pumpAndSettle, stream still pending).

Pagination fetch count/off-by-one (list does not contain item index 19).


Preferred fix (robust)

Add a stable Key to each spec row tile in the UI, then update tests to find by key instead of text.

Example key pattern: Key('spec_row_${spec.id}') or Key('spec_row_$index')


In tests, use:

await tester.scrollUntilVisible(find.byKey(Key('spec_row_19')), 200);



Verification

flutter test test/features/specs/spec_list_pagination_test.dart -r expanded -v


---

3) Widget test crash: Bad state: Too many elements (scrollUntilVisible)

Log

Bad state: Too many elements

from scrollUntilVisible → finder matched more than one widget


Fix

Make the finder unique:

Prefer find.byKey(...)

Or use .first / .at(0) when using text/type finders:

find.text('Spec 19').first





---

4) Drift warning: multiple DB instances created

Log

WARNING (drift): ... FakeAppDatabase multiple times ... race conditions ...


Fix options

Best: create one FakeAppDatabase per test file (or per test) and close it in tearDown / tearDownAll.

If tests intentionally open multiple DBs and you accept the risk:

Set driftRuntimeOptions.dontWarnAboutMultipleDatabases = true (tests only).




---

Always Triage Order (so CI turns green fastest)

1. Compilation failures in tests (like Vehicle undefined)


2. Widget tests failing by text/keys


3. Drift multi-DB warnings (stability improvement)
