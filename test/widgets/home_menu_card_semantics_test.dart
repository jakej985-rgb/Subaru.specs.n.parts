import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/widgets/home_menu_card.dart';

void main() {
  testWidgets('HomeMenuCard has correct semantics', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeMenuCard(title: 'Browse', icon: Icons.search, onTap: () {}),
        ),
      ),
    );

    // Find the widget
    final cardFinder = find.byType(HomeMenuCard);
    expect(cardFinder, findsOneWidget);

    // Check for semantics.
    // We expect the card to be a button and have the label "Browse".

    final buttonFinder = find.bySemanticsLabel('Browse');
    expect(
      buttonFinder,
      findsOneWidget,
      reason: 'HomeMenuCard should be a semantic button with the correct label',
    );

    handle.dispose();
  });
}
