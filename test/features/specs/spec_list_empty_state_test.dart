import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';

// Empty DAO to test empty state
class EmptySpecsDao extends SpecsDao {
  EmptySpecsDao(super.db);

  @override
  Future<List<Spec>> searchSpecs(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    return [];
  }

  @override
  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) async {
    // Return empty list to simulate no data
    return [];
  }
}

// Slow DAO to test loading state
class SlowSpecsDao extends SpecsDao {
  SlowSpecsDao(super.db);

  // Convert Completer to a future that we can control if needed,
  // or just a simple delay. For this test, a delay is usually enough if we pump correctly.

  @override
  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [];
  }

  @override
  Future<List<Spec>> searchSpecs(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor, this._specsDao);

  final SpecsDao _specsDao;

  @override
  SpecsDao get specsDao => _specsDao;
}

void main() {
  testWidgets('SpecListPage shows empty state when no specs found', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(
      NativeDatabase.memory(),
      EmptySpecsDao(AppDatabase(NativeDatabase.memory())),
    );
    addTearDown(() => fakeDb.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: const MaterialApp(home: SpecListPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Should find the empty state message
    // Currently this should FAIL because we haven't implemented it
    expect(find.text('No specs found'), findsOneWidget);

    // Should NOT find the list view (or at least it should be empty/hidden if we replace it)
    // But if we just hide it or swap it, finding the text is the key.
  });

  testWidgets('SpecListPage shows loading state initially', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(
      NativeDatabase.memory(),
      SlowSpecsDao(AppDatabase(NativeDatabase.memory())),
    );
    addTearDown(() => fakeDb.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: const MaterialApp(home: SpecListPage()),
      ),
    );

    // Initial pump - should be loading
    // We assume the controller sets isLoadingInitial = true synchronously
    await tester.pump(const Duration(milliseconds: 100));

    // Should find circular progress indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish loading
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Should not find reference to loading anymore
    // Note: The list adds a loader at the bottom if loading MORE, but here we are checking the initial full screen loader
    // If our implementation swaps the body, the usage of CircularProgressIndicator at the bottom of the list might confuse findsOneWidget if the list was still visible.
    // However, if the list is empty, the bottom loader isn't shown either (index >= 0 is false if length is 0).

    // expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
