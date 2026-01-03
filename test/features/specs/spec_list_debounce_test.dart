import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';

// Create a Fake implementation since Mockito generation is not available/easy here
class FakeSpecsDao extends SpecsDao {
  FakeSpecsDao(super.db);

  int searchCallCount = 0;

  @override
  Future<List<Spec>> searchSpecs(String query) async {
    searchCallCount++;
    return [];
  }

  @override
  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) async {
    return [];
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor);

  late final FakeSpecsDao _fakeSpecsDao = FakeSpecsDao(this);

  @override
  FakeSpecsDao get specsDao => _fakeSpecsDao;
}

void main() {
  testWidgets('SpecListPage debounces search input', (WidgetTester tester) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(fakeDb),
        ],
        child: const MaterialApp(
          home: SpecListPage(),
        ),
      ),
    );

    expect(find.text('Specs'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter "a"
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();

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
    expect(fakeDb.specsDao.searchCallCount, 1);

    // Wait for the async gap (DB call) to complete and UI to update
    await tester.pump();
  });
}
