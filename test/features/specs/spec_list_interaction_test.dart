import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';

// Fake implementation
class FakeSpecsDao extends SpecsDao {
  FakeSpecsDao(super.db);

  @override
  Future<List<Spec>> searchSpecs(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    return [
      Spec(
        id: '1',
        category: 'Fluids',
        title: 'Oil Capacity',
        body: '4.5 qt',
        tags: 'engine,oil',
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) async {
    return [
      Spec(
        id: '1',
        category: 'Fluids',
        title: 'Oil Capacity',
        body: '4.5 qt',
        tags: 'engine,oil',
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor);
  late final FakeSpecsDao _fakeSpecsDao = FakeSpecsDao(this);
  @override
  FakeSpecsDao get specsDao => _fakeSpecsDao;
}

void main() {
  testWidgets('SpecListPage allows copying spec value from dialog', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: const MaterialApp(home: SpecListPage()),
      ),
    );

    // Initial load
    await tester.pump();
    // Wait for microtasks (if any)
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Oil Capacity'), findsOneWidget);

    // Open Dialog
    await tester.tap(find.text('Oil Capacity'));
    await tester.pumpAndSettle();

    // List item is still in the tree behind the dialog
    expect(find.text('4.5 qt'), findsAtLeastNWidgets(1));

    // Check for Copy button - this should now pass
    expect(find.text('Copy'), findsOneWidget);
  });
}
