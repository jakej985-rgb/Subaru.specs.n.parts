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

  int searchCallCount = 0;

  @override
  Future<List<Part>> searchParts(String query,
      {int limit = 50, int offset = 0}) async {
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
  testWidgets('PartLookupPage clear button functionality', (WidgetTester tester) async {
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

    // Initial state: Search icon visible, Clear button hidden
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsNothing);

    // Enter text
    await tester.enterText(find.byType(TextField), 'filter');
    await tester.pump();

    // Text entered: Clear button visible
    // Note: The search icon might be replaced or remain depending on implementation.
    // The requirement is that the clear button appears.
    // We'll check for the tooltip too if we add it.
    expect(find.byIcon(Icons.clear), findsOneWidget);

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
