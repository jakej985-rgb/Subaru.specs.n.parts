import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/widgets/home_menu_card.dart';

void main() {
  testWidgets('HomeMenuCard has correct semantics', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeMenuCard(
            title: 'Browse',
            icon: Icons.search,
            onTap: () {},
          ),
        ),
      ),
    );

    // Find the widget
    final cardFinder = find.byType(HomeMenuCard);
    expect(cardFinder, findsOneWidget);

    // Print the semantics tree for debugging purposes (optional but helpful)
    // debugDumpSemanticsTree();

    // Check for semantics.
    // We expect the card to be a button and have the label "Browse".
    // Currently, InkWell might make it a button, but the label might be split between text and potentially icon.

    // Check if there is a semantic node that is a button with label "Browse".
    final buttonFinder = find.bySemantics(
      isButton: true,
      label: 'Browse',
    );

    if (buttonFinder.evaluate().isEmpty) {
        print('Semantics check failed: No button with label "Browse" found.');
        // Let's inspect what we have.
        final handle = tester.ensureSemantics();
        print(tester.getSemantics(find.byType(HomeMenuCard)));
        handle.dispose();
    }

    expect(buttonFinder, findsOneWidget, reason: 'HomeMenuCard should be a semantic button with the correct label');
  });
}
