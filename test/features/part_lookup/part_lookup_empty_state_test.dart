import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';

// Reuse Fake implementations
class FakePartsDao extends PartsDao {
  FakePartsDao(super.db);

  @override
  Future<List<Part>> searchParts(String query, {int limit = 50, int offset = 0}) async {
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
  testWidgets('PartLookupPage shows empty state initially', (WidgetTester tester) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(fakeDb),
        ],
        child: const MaterialApp(
          home: PartLookupPage(),
        ),
      ),
    );

    // Verify initial empty state
    expect(find.text('Start typing to search parts...'), findsOneWidget);
    expect(find.byIcon(Icons.manage_search), findsOneWidget);

    // Enter text
    await tester.enterText(find.byType(TextField), 'filter');
    await tester.pump();

    // Wait for debounce (500ms)
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(); // Rebuild after setState

    // Now `_searchQuery` is 'filter'.
    // `_results` is empty (fake dao returns []).

    // The empty state should be gone
    expect(find.text('Start typing to search parts...'), findsNothing);
    expect(find.byIcon(Icons.manage_search), findsNothing);

    // Should show "No parts found."
    expect(find.text('No parts found.'), findsOneWidget);
  });
}
