import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

// Reuse Fake implementations
class FakePartsDao extends PartsDao {
  FakePartsDao(super.db);

  int searchCallCount = 0;

  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
    bool sortByOem = false,
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
  testWidgets('PartLookupPage clear button functionality', (
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

    // Initial state: Search icon visible, Clear button hidden
    expect(find.byIcon(Icons.search), findsWidgets);
    expect(find.byIcon(Icons.clear), findsNothing);

    // Enter text
    await tester.enterText(find.byType(TextField), 'filter');
    await tester.pumpAndSettle();

    // Text entered: Clear button visible
    expect(find.byKey(const Key('clear_search_button')), findsOneWidget);

    // Tap clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    // Text should be cleared
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text ?? '', isEmpty);

    // Clear button hidden again
    expect(find.byIcon(Icons.clear), findsNothing);
  });
}
