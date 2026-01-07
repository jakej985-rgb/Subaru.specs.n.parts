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
    final innerDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => innerDb.close());

    final fakeDb = FakeAppDatabase(
      NativeDatabase.memory(),
      EmptySpecsDao(innerDb),
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
    expect(find.text('No specs found'), findsOneWidget);

    // Should NOT find the Clear Search button (since query is empty in this initial state)
    expect(find.text('Clear Search'), findsNothing);
  });

  testWidgets(
    'SpecListPage shows detailed empty state with clear button when searching',
    (WidgetTester tester) async {
      final innerDb = AppDatabase(NativeDatabase.memory());
      addTearDown(() => innerDb.close());

      final fakeDb = FakeAppDatabase(
        NativeDatabase.memory(),
        EmptySpecsDao(innerDb),
      );
      addTearDown(() => fakeDb.close());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDbProvider.overrideWithValue(fakeDb)],
          child: const MaterialApp(home: SpecListPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Type a query
      await tester.enterText(find.byType(TextField), 'Turbo');
      await tester.pump(const Duration(milliseconds: 600)); // Debounce + pump
      await tester.pumpAndSettle();

      // Should find the detailed empty state message
      expect(find.text('No specs found for "Turbo"'), findsOneWidget);

      // Should find the clear button
      expect(find.text('Clear Search'), findsOneWidget);

      // Tap clear button
      await tester.tap(find.text('Clear Search'));
      await tester.pumpAndSettle();

      // Should revert to base empty state
      expect(find.text('No specs found'), findsOneWidget);
      expect(find.text('Clear Search'), findsNothing);
      expect(find.text('Turbo'), findsNothing); // Input should be cleared
    },
  );

  testWidgets('SpecListPage shows loading state initially', (
    WidgetTester tester,
  ) async {
    final innerDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => innerDb.close());

    final fakeDb = FakeAppDatabase(
      NativeDatabase.memory(),
      SlowSpecsDao(innerDb),
    );
    addTearDown(() => fakeDb.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: const MaterialApp(home: SpecListPage()),
      ),
    );

    // Initial pump - should be loading
    await tester.pump(const Duration(milliseconds: 100));

    // Should find circular progress indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish loading
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('SpecListPage shows debug hint when vehicle selected but no specs', (
    WidgetTester tester,
  ) async {
    final innerDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => innerDb.close());

    final fakeDb = FakeAppDatabase(
      NativeDatabase.memory(),
      EmptySpecsDao(innerDb),
    );
    addTearDown(() => fakeDb.close());

    final vehicle = Vehicle(
      id: 'v_debug',
      year: 2024,
      make: 'Subaru',
      model: 'DebugModel',
      trim: 'DebugTrim',
      engineCode: 'DebugEngine',
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: MaterialApp(home: SpecListPage(vehicle: vehicle)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No specs found'), findsOneWidget);
    // Use find.textContaining for the dynamic part
    expect(find.textContaining('Debug: No matches for 2024 DebugModel DebugTrim'), findsOneWidget);
  });
}
