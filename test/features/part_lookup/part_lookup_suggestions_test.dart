import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

// Fake implementation
class FakePartsDao extends PartsDao {
  FakePartsDao(super.db);

  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
    bool sortByOem = false,
  }) async {
    if (query == 'Oil Filter') {
      return [
        Part(
          id: '1',
          name: 'Oil Filter',
          oemNumber: '15208AA12A',
          aftermarketNumbers: '[]',
          fits: '[]',
          updatedAt: DateTime.now(),
        ),
      ];
    }
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
  testWidgets('PartLookupPage taps suggested search', (
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

    await tester.pump();

    // Checks for empty state text
    expect(find.text('Start typing to search parts...'), findsOneWidget);

    // Verify chips exist
    expect(find.text('Oil Filter'), findsOneWidget);
    expect(find.text('Brake Pad'), findsOneWidget);

    // Tap 'Oil Filter'
    await tester.tap(find.widgetWithText(InputChip, 'Oil Filter'));
    await tester.pump(); // Start debounce or state change

    // The existing code has a 500ms debounce.
    // The chip tap directly sets text and calls _search.
    // _search starts a timer.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(); // Process future

    // Verify search field text
    expect(find.widgetWithText(TextField, 'Oil Filter'), findsOneWidget);

    // Verify result shown
    expect(find.text('OEM: 15208AA12A'), findsOneWidget);
  });
}
