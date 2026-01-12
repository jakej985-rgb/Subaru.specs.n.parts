import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

// Create a Fake implementation since Mockito generation is not available/easy here
class FakePartsDao extends PartsDao {
  FakePartsDao(super.db);

  int searchCallCount = 0;

  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    searchCallCount++;
    return [];
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor);

  late final FakePartsDao _fakePartsDao = FakePartsDao(this);

  @override
  FakePartsDao get partsDao => _fakePartsDao;
}

void main() {
  testWidgets('PartLookupPage debounces search input', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(fakeDb),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: PartLookupPage()),
      ),
    );

    expect(find.text('Part Lookup'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter "a"
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(); // Trigger the setState for query update

    // The debounce timer is running (500ms).
    // If we wait less than 500ms and enter more text, the previous timer should be cancelled.

    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'ab');
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    // Now wait for the debounce to finish
    await tester.pump(const Duration(milliseconds: 500));

    // Verify call count. It should be 1.
    // However, since `_search` is void and calls `ref.read`, we expect the single call to happen after the timeout.
    expect(fakeDb.partsDao.searchCallCount, 1);

    // Wait for the async gap (DB call) to complete and UI to update
    await tester.pump();
  });
}
