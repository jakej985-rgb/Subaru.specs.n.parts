import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';

void main() {
  testWidgets('YmmFlowPage back buttons have semantic labels', (tester) async {
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
    ]);

    // Pump widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(db)],
        child: const MaterialApp(home: YmmFlowPage()),
      ),
    );

    // Initial state: years should be visible
    await tester.pump();
    await tester.pumpAndSettle();

    // Select Year
    await tester.tap(find.text('2022'));
    await tester.pumpAndSettle();

    // Verify back button exists and has tooltip/semantics
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);

    // Check tooltip
    final iconButton = tester.widget<IconButton>(
      find.ancestor(of: backButton, matching: find.byType(IconButton)),
    );
    expect(
      iconButton.tooltip,
      isNotNull,
      reason: 'Back button should have a tooltip',
    );
    expect(iconButton.tooltip, equals('Back to years'));

    await db.close();
  });
}
