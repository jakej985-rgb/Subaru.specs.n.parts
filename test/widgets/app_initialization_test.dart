


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:specsnparts/app.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';

class FakeSeedRunner extends SeedRunner {
  FakeSeedRunner(super.db);

  @override
  Future<void> runSeedIfNeeded() async {
    // Verify loading state is transient by delaying slightly (pumpAndSettle will wait)
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Insert test data directly
    await db.into(db.vehicles).insert(
      VehiclesCompanion(
        id: const Value('test_1'),
        year: const Value(2024),
        make: const Value('Subaru'),
        model: const Value('Impreza'),
        trim: const Value('Base'),
        engineCode: const Value('FB20'),
        updatedAt: Value(DateTime.fromMillisecondsSinceEpoch(1704067200000)),
      ),
    );
  }
}

void main() {
  testWidgets('Regression Test: App waits for seeding', (WidgetTester tester) async {
    // 1. Setup in-memory DB
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    // 2. Launch App with overridden DB AND SeedRunner
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(db),
          seedRunnerProvider.overrideWith((ref) => FakeSeedRunner(db)),
        ],
        child: const SubaruSpecsApp(),
      ),
    );


    // 3. Wait for initial home screen (this waits for loading to finish)
    // First pump starts the app, which shows loading
    await tester.pump();
    
    // Verify we see loading
    if (find.text('Updating specifications database...').evaluate().isNotEmpty) {
      // Wait for the delay
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    // 4. Tap "Browse by Year/Make/Model"
    final browseButton = find.text('Browse by Year/Make/Model');
    await tester.tap(browseButton);
    await tester.pumpAndSettle();

    // 5. Verify we are on "Select Vehicle" screen
    expect(find.text('Select Vehicle'), findsOneWidget);

    // 6. Verify data is loaded (Fix verification)
    // We expect the year 2024 to be visible
    expect(find.text('2024'), findsOneWidget);
  });
}

