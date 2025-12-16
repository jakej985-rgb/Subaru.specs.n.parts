import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/app.dart';

void main() {
  testWidgets('Smoke test - App boots and shows Home', (WidgetTester tester) async {
    // Set a large surface size to ensure all items are visible without scrolling if possible,
    // or we will scroll.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      const ProviderScope(
        child: SubaruSpecsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Subaru Specs & Parts'), findsOneWidget);
    expect(find.text('Browse by Year/Make/Model'), findsOneWidget);

    // Scroll if necessary to find Settings
    final settingsFinder = find.text('Settings');
    await tester.scrollUntilVisible(
      settingsFinder,
      500.0,
      scrollable: find.byType(Scrollable),
    );

    expect(settingsFinder, findsOneWidget);

    // Reset window size
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
