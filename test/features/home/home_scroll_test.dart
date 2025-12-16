import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/home_page.dart';

void main() {
  // Helper to pump the widget with a real router
  Future<void> pumpHomePage(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        // Add dummy routes for navigation targets to avoid errors if clicked (though we won't click in this test)
        GoRoute(path: '/browse/ymm', builder: (_, __) => Container()),
        GoRoute(path: '/browse/engine', builder: (_, __) => Container()),
        GoRoute(path: '/parts', builder: (_, __) => Container()),
        GoRoute(path: '/specs', builder: (_, __) => Container()),
        GoRoute(path: '/settings', builder: (_, __) => Container()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('HomePage has SingleChildScrollView when screen is small', (WidgetTester tester) async {
    // Set a small screen size (e.g., small iPhone SE 1st gen or smaller)
    // 320 width, 480 height. Safe area usually takes some, but let's assume tight constraint.
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1.0;

    await pumpHomePage(tester);

    // Verify SingleChildScrollView is present
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('HomePage has NO SingleChildScrollView when screen is large', (WidgetTester tester) async {
    // Set a large screen size (e.g., modern large phone)
    // 110 * 5 = 550. + Spacing 64 = 614. + Header 70 = 684. + Padding 32 = 716.
    // Screen height 844 (iPhone 12). Safe Area ~760. 716 < 760. Should fit.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;

    await pumpHomePage(tester);

    // Verify SingleChildScrollView is ABSENT
    expect(find.byType(SingleChildScrollView), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
