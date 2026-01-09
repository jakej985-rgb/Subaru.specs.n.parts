import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';

import 'package:specsnparts/features/specs_by_category/category_year_results_page.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    // Seed Data
    final v = Vehicle(
      id: 'v_test',
      year: 2025,
      make: 'Subaru',
      model: 'Forester',
      trim: 'Base',
      engineCode: 'FB25',
      updatedAt: DateTime.now(),
    );
    await db.vehiclesDao.insertVehicle(v);

    final s = Spec(
      id: 's_test',
      category: 'Fluids', // Matches 'fluids' dataCategories
      title: 'Test Fluid',
      body: '1 Liter',
      tags: '2025,forester,base',
      updatedAt: DateTime.now(),
    );
    await db.specsDao.insertSpec(s);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('CategoryYearResultsPage shows vehicles and specs', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: CategoryYearResultsPage(categoryKey: 'fluids', year: 2025),
        ),
      ),
    );

    // Initial Loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for data
    await tester.pumpAndSettle();

    // Verify Content
    expect(find.text('Forester'), findsOneWidget); // Model Group
    expect(find.text('Base'), findsOneWidget); // Trim Result
    expect(find.text('Test Fluid'), findsOneWidget); // Spec Title
    expect(find.text('1 Liter'), findsOneWidget); // Spec Body
  });
}
