import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';

void main() {
  testWidgets('YmmFlowPage loads years and then models', (tester) async {
    // Setup in-memory DB
    final db = AppDatabase(NativeDatabase.memory());

    // Seed data
    await db.vehiclesDao.insertMultiple([
      Vehicle(
        id: '1',
        year: 2022,
        make: 'Subaru',
        model: 'WRX',
        updatedAt: DateTime.now(),
      ),
      Vehicle(
        id: '2',
        year: 2022,
        make: 'Subaru',
        model: 'Outback',
        updatedAt: DateTime.now(),
      ),
    ]);

    // Pump widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: YmmFlowPage(),
        ),
      ),
    );

    // Initial state: years should be visible
    await tester.pump(); // Ensure initState completes
    await tester.pumpAndSettle(); // Wait for _loadYears

    expect(find.text('2022'), findsOneWidget);
    expect(find.text('Select Year'), findsOneWidget);

    // Tap on year 2022
    await tester.tap(find.text('2022'));
    await tester.pumpAndSettle(); // Wait for _loadModels

    // Should now show models
    expect(find.text('Select Model'), findsOneWidget);
    expect(find.text('WRX'), findsOneWidget);
    expect(find.text('Outback'), findsOneWidget);

    await db.close();
  });
}
