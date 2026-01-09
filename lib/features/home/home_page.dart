import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/adaptive_scroll.dart';
import '../../widgets/home_menu_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double cardHeight = 130;
  static const double spacing = 16;
  static const double headerHeightEstimate = 70; // title + spacing

  @override
  Widget build(BuildContext context) {
    // Basic scaling for accessibility/large fonts, if needed.
    // In a real app, we might check MediaQuery.textScaleFactorOf(context).
    // For now, we stick to the plan's logic or simple fixed logic.
    // The plan suggested: final textScale = MediaQuery.textScaleFactorOf(context);

    // textScaler.scale(1) returns the scaled font size for 1.
    // Effectively we want the factor.
    // In newer Flutter, textScaleFactor is deprecated for textScaler.
    // We can assume 1.0 if we want to be simple, or compute ratio.
    // Let's stick to the plan's logic but adapted for newer Flutter if needed.
    // Actually, let's just use a safe estimation.

    // Note: MediaQuery.textScaleFactor is deprecated in recent Flutter.
    // Using textScaler.scale(1) / 1 gives the factor.
    final double scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    final scaledCardHeight = cardHeight * (scaleFactor > 1.2 ? 1.15 : 1.0);

    final items = [
      (
        'Browse by Year/Make/Model',
        Icons.directions_car,
        () => context.go('/browse/ymm'),
      ),
      (
        'Browse by Engine',
        Icons.engineering,
        () => context.go('/browse/engine'),
      ),
      ('Part Lookup', Icons.search, () => context.go('/parts')),
      (
        'Specs by Category',
        Icons.list_alt,
        () => context.go('/specs/categories'),
      ),
      ('Settings', Icons.settings, () => context.go('/settings')),
    ];

    // Estimate total content height:
    final totalCards = items.length;
    final estimatedContentHeight =
        headerHeightEstimate +
        (totalCards * scaledCardHeight) +
        ((totalCards - 1) * spacing) +
        80; // extra breathing room (top/bottom padding of AdaptiveScroll usually 16+16=32, plus internal 8+18 spacing)

    // Wait, AdaptiveScroll has padding=16.
    // Inside AdaptiveScroll child:
    // SizedBox(8)
    // Text (approx 34 height with font 28)
    // SizedBox(18)
    // Cards...

    // So Header area = 8 + 34 + 18 = 60.
    // Padding = 16 top + 16 bottom = 32.
    // Total static = 92.
    // Cards = count * height.
    // Spacing = (count - 1) * spacing.

    // Re-calculating headerHeightEstimate more precisely or using the constant provided in plan (70) + padding.
    // Plan said: headerHeightEstimate = 70.
    // estimatedContentHeight = header + cards + spacing + 32 (breathing room).
    // This looks safe.

    return Scaffold(
      body: SafeArea(
        child: AdaptiveScroll(
          estimatedContentHeight: estimatedContentHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Subaru Specs & Parts',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // Cards
              for (int i = 0; i < items.length; i++) ...[
                HomeMenuCard(
                  title: items[i].$1,
                  icon: items[i].$2,
                  onTap: items[i].$3,
                  height: scaledCardHeight,
                ),
                if (i != items.length - 1) const SizedBox(height: spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
