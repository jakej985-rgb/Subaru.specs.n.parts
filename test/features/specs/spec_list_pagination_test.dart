import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';

// Create a Fake implementation since Mockito generation is not available
class FakeSpecsDao extends SpecsDao {
  FakeSpecsDao(super.db);

  int getSpecsPagedCallCount = 0;
  int lastLimit = 0;
  int lastOffset = 0;

  @override
  Future<List<Spec>> searchSpecs(String query,
      {int limit = 50, int offset = 0}) async {
    getSpecsPagedCallCount++;
    lastLimit = limit;
    lastOffset = offset;

    // Generate dummy specs to simulate data
    return List.generate(limit, (index) => Spec(
      id: offset + index,
      title: 'Spec ${offset + index} for $query',
      body: 'Body ${offset + index}',
      category: 'Category',
      tags: 'tag',
    ));
  }

  @override
  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) async {
    getSpecsPagedCallCount++;
    lastLimit = limit;
    lastOffset = offset;

    // Generate dummy specs to simulate data
    return List.generate(limit, (index) => Spec(
      id: offset + index,
      title: 'Spec ${offset + index}',
      body: 'Body ${offset + index}',
      category: 'Category',
      tags: 'tag',
    ));
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor);

  late final FakeSpecsDao _fakeSpecsDao = FakeSpecsDao(this);

  @override
  FakeSpecsDao get specsDao => _fakeSpecsDao;
}

void main() {
  testWidgets('SpecListPage implements pagination', (WidgetTester tester) async {
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

    // Initial load
    await tester.pumpAndSettle();

    // Verify initial call
    expect(fakeDb.specsDao.getSpecsPagedCallCount, 1);
    expect(fakeDb.specsDao.lastOffset, 0);
    // Based on existing code, default page limit is 20
    expect(fakeDb.specsDao.lastLimit, 20);

    // Verify that items are displayed
    expect(find.text('Spec 0'), findsOneWidget);
    expect(find.text('Spec 19'), findsOneWidget);

    // Scroll to the bottom to trigger load more
    final scrollFinder = find.byType(Scrollable);
    await tester.scrollUntilVisible(
      find.text('Spec 19'), // Scroll to the last item of the first page
      500.0,
      scrollable: scrollFinder,
    );

    // Simulate pulling up / scrolling further to hit the threshold
    await tester.drag(scrollFinder, const Offset(0, -1000));
    await tester.pump(); // Start loading

    // Verify second call
    // Note: The listener triggers when close to bottom.
    // We might need to wait or pump frames.

    // pumpAndSettle might not work if there is an infinite animation (loading spinner)
    // but here the loading spinner appears and then disappears when data comes back.
    await tester.pumpAndSettle();

    expect(fakeDb.specsDao.getSpecsPagedCallCount, 2);
    expect(fakeDb.specsDao.lastOffset, 20);
    expect(fakeDb.specsDao.lastLimit, 20);

    // Verify new items
    expect(find.text('Spec 20'), findsOneWidget);
  });

  testWidgets('SpecListPage implements search pagination', (WidgetTester tester) async {
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

    // Initial load happens
    await tester.pumpAndSettle();

    // Reset counters
    fakeDb.specsDao.getSpecsPagedCallCount = 0;

    // Enter search query
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();
    // Wait for debounce (500ms)
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify search called
    expect(fakeDb.specsDao.getSpecsPagedCallCount, 1);
    expect(fakeDb.specsDao.lastOffset, 0);
    expect(fakeDb.specsDao.lastLimit, 20); // Should use the same page limit

    expect(find.text('Spec 0 for Test'), findsOneWidget);

    // Scroll to load more search results
    final scrollFinder = find.byType(Scrollable);
    await tester.scrollUntilVisible(
      find.text('Spec 19 for Test'),
      500.0,
      scrollable: scrollFinder,
    );

    await tester.drag(scrollFinder, const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(fakeDb.specsDao.getSpecsPagedCallCount, 2);
    expect(fakeDb.specsDao.lastOffset, 20);
    expect(fakeDb.specsDao.lastLimit, 20);

    expect(find.text('Spec 20 for Test'), findsOneWidget);
  });
}
