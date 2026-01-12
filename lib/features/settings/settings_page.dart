import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/features/part_lookup/part_search_provider.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_divider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Data Management Section
          Text(
            'DATA MANAGEMENT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ThemeTokens.neonBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          CarbonSurface(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: ThemeTokens.textPrimary,
                  ),
                  title: const Text('Clear Recent Vehicles'),
                  subtitle: const Text(
                    'Removes all vehicles from your history',
                  ),
                  onTap: () async {
                    await ref.read(recentVehiclesProvider.notifier).clear();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recent vehicles cleared'),
                        ),
                      );
                    }
                  },
                ),
                const NeonDivider(),
                ListTile(
                  leading: const Icon(
                    Icons.travel_explore,
                    color: ThemeTokens.textPrimary,
                  ),
                  title: const Text('Clear Search History'),
                  subtitle: const Text('Removes saved part search terms'),
                  onTap: () async {
                    await ref.read(recentPartSearchesProvider.notifier).clear();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search history cleared')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          Text(
            'ABOUT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ThemeTokens.neonBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          CarbonSurface(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.settings_suggest,
                  size: 48,
                  color: ThemeTokens.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  'Subaru Specs & Parts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: ThemeTokens.neonBlue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Offline-first reference for enthusiasts.',
                  style: TextStyle(color: ThemeTokens.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
