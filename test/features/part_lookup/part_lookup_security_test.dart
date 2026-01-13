import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

// Reuse Fake implementations to avoid real DB interaction
class FakePartsDao extends PartsDao {
  FakePartsDao(super.db);

  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
    bool sortByOem = false,
  }) async {
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
  testWidgets('PartLookupPage limits input length for security', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());
    addTearDown(() => fakeDb.close());

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

    // Find the TextField
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    final textField = tester.widget<TextField>(textFieldFinder);

    // Initially, there might be no limit or a limit. We expect to enforce 100.
    // This check is expected to FAIL before the fix if the limit is not set.
    expect(
      textField.maxLength,
      100,
      reason: 'TextField should have maxLength set to 100 to prevent DoS',
    );
  });
}
