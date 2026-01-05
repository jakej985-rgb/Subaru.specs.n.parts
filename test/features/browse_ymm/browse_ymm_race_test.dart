import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';

// 1. Create a Fake DAO that allows us to control the completion of futures
class FakeVehiclesDao extends VehiclesDao {
  FakeVehiclesDao(super.db);

  // We use Completers to manually complete the futures
  Completer<List<String>>? _modelsCompleter;
  int? _requestedYear;

  @override
  Future<List<int>> getDistinctYears() async {
    return [2021, 2020];
  }

  @override
  Future<List<String>> getDistinctModelsByYear(int year) {
    _requestedYear = year;
    _modelsCompleter = Completer<List<String>>();
    return _modelsCompleter!.future;
  }

  void completeModels(List<String> models) {
    _modelsCompleter?.complete(models);
  }
}

class FakeAppDatabase extends AppDatabase {
  FakeAppDatabase(super.executor);

  late final FakeVehiclesDao _fakeVehiclesDao = FakeVehiclesDao(this);

  @override
  FakeVehiclesDao get vehiclesDao => _fakeVehiclesDao;
}

void main() {
  testWidgets('YmmFlowPage race condition: models list mismatch', (
    WidgetTester tester,
  ) async {
    final fakeDb = FakeAppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDbProvider.overrideWithValue(fakeDb)],
        child: const MaterialApp(home: YmmFlowPage()),
      ),
    );

    // Initial state: Year selection
    await tester.pumpAndSettle(); // Allow years to load
    expect(find.text('Select Year'), findsOneWidget);
    expect(find.text('2020'), findsOneWidget);
    expect(find.text('2021'), findsOneWidget);

    // 1. User taps 2020
    await tester.tap(find.text('2020'));
    await tester.pump(); // Trigger setState, start async _loadModels(2020)

    // Capture the completer for 2020
    final completer2020 = fakeDb.vehiclesDao._modelsCompleter!;
    expect(fakeDb.vehiclesDao._requestedYear, 2020);

    // 2. User goes Back immediately (simulated by tapping back button)
    // The back button is in the 'Select Model' view: `if (_selectedYear == null) ...`
    // Wait, if I tapped 2020, `_selectedYear` is set synchronously.
    // So the UI should now show '2020 > Select Model' (loading state or empty list).
    expect(find.text('2020 > Select Model'), findsOneWidget);

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump(); // setState: _selectedYear = null

    // Now back to year list
    expect(find.text('Select Year'), findsOneWidget);

    // 3. User taps 2021
    await tester.tap(find.text('2021'));
    await tester
        .pump(); // setState: _selectedYear = 2021, start async _loadModels(2021)

    // Capture the completer for 2021
    final completer2021 = fakeDb.vehiclesDao._modelsCompleter!;
    expect(fakeDb.vehiclesDao._requestedYear, 2021);
    expect(completer2021, isNot(equals(completer2020)));

    // 4. Now, complete the requests in REVERSE order (race condition)
    // First, complete 2021 (the current one)
    completer2021.complete(['Crosstrek']);
    // Wait for microtasks
    await tester.pump(Duration.zero);

    // Verify we see Crosstrek
    expect(find.text('Crosstrek'), findsOneWidget);

    // 5. NOW complete the OLD request (2020)
    completer2020.complete(['Impreza', 'WRX']);
    // Wait for microtasks
    await tester.pump(Duration.zero);

    // BUG: We are on 2021 view, but we see 2020 models!
    // If the bug exists, we will see 'Impreza' instead of (or in addition to?) 'Crosstrek'
    // Since _loadModels replaces the list: `_models = models`.

    // With the fix, we expect to see Crosstrek because we selected 2021, and the stale 2020 data should be ignored.

    // Verify the fix:
    expect(find.text('Impreza'), findsNothing);
    expect(find.text('Crosstrek'), findsOneWidget);
  });
}
