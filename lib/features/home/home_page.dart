import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/features/home/garage_view.dart';
import 'package:specsnparts/theme/tokens.dart';
import '../../widgets/adaptive_scroll.dart';
import '../../widgets/home_menu_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double cardHeight = 130;
  static const double spacing = 16;
  static const double headerHeightEstimate = 70; // title + spacing

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double scaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final scaledCardHeight = cardHeight * (scaleFactor > 1.2 ? 1.15 : 1.0);

    final items = [
      ('Browse Specs', Icons.grid_view, () => context.go('/browse')),
      ('Part Lookup', Icons.search, () => context.go('/parts')),
      ('Settings', Icons.settings, () => context.go('/settings')),
    ];

    final favorites = ref.watch(favoriteVehiclesProvider);
    final recents = ref.watch(recentVehiclesProvider);
    final double garageHeight =
        (favorites.isNotEmpty ? 200.0 : 0) + (recents.isNotEmpty ? 200.0 : 0);

    // Estimate total content height:
    final totalCards = items.length;
    final estimatedContentHeight = headerHeightEstimate +
        garageHeight +
        (totalCards * scaledCardHeight) +
        ((totalCards - 1) * spacing) +
        250; // extra breathing room + search bar height

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/specs'),
        icon: const Icon(Icons.list_alt),
        label: const Text('All Specs'),
        backgroundColor: ThemeTokens.neonBlue,
        foregroundColor: ThemeTokens.surface,
      ),
      body: SafeArea(
        child: AdaptiveScroll(
          estimatedContentHeight: estimatedContentHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Unified Global Search Trigger
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () => context.push('/global-search'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeTokens.surfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeTokens.neonBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: ThemeTokens.neonBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search models, parts, specs...',
                            style: TextStyle(
                              color: ThemeTokens.textMuted.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Subaru Specs & Parts',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // Your Garage (Recents/Favorites)
              const GarageView(),

              const SizedBox(height: 8),

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
              // Extra padding for FAB clearance
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
