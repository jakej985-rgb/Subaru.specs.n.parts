// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:specsnparts/app.dart';
import 'package:specsnparts/data/db/app_db.dart';

import 'package:specsnparts/data/seed/seed_runner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

class MockSeedRunner extends SeedRunner {
  MockSeedRunner(super.db);

  @override
  Future<void> runSeedIfNeeded() async {
    // No-op for smoke test
  }
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDbProvider.overrideWithValue(AppDatabase(NativeDatabase.memory())),
          seedRunnerProvider.overrideWith((ref) {
            final db = ref.watch(appDbProvider);
            return MockSeedRunner(db);
          }),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const SubaruSpecsApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the app title is present.
    expect(find.text('Subaru Specs & Parts'), findsOneWidget);
  });
}
