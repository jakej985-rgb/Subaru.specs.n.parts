import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/features/part_lookup/part_search_provider.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_divider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int _versionTapCount = 0;

  Future<bool> _confirmAction({
    required String title,
    required String content,
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.redAccent : null,
            ),
            child: Text(isDestructive ? 'Delete' : 'Confirm'),
          ),
        ],
      ),
    );

    return confirmed == true;
  }

  void _onVersionTap() {
    setState(() {
      _versionTapCount++;
    });
    if (_versionTapCount >= 5) {
      _showDebugInfo();
      _versionTapCount = 0;
    }
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Info'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App ID: com.specsnparts.app'),
            SizedBox(height: 8),
            Text('Build Mode: ${kReleaseMode ? "Release" : "Debug"}'),
            SizedBox(height: 8),
            Text('Database: SQLite (Drift)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: _onNuclearReset,
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Reset App Data'),
          ),
        ],
      ),
    );
  }

  Future<void> _onNuclearReset() async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    if (await _confirmAction(
      title: 'Nuclear Reset',
      content:
          'This will wipe ALL user data (favorites, recents, history). This cannot be undone.',
      isDestructive: true,
    )) {
      await ref.read(recentVehiclesProvider.notifier).clear();
      await ref.read(favoriteVehiclesProvider.notifier).clear();
      await ref.read(recentPartSearchesProvider.notifier).clear();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('App data reset complete.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onClearHistory() async {
    final messenger = ScaffoldMessenger.of(context);
    if (await _confirmAction(
      title: 'Clear History',
      content: 'Clear all recent vehicles?',
      isDestructive: true,
    )) {
      await ref.read(recentVehiclesProvider.notifier).clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Recent vehicles cleared')),
      );
    }
  }

  Future<void> _onClearSearchHistory() async {
    final messenger = ScaffoldMessenger.of(context);
    if (await _confirmAction(
      title: 'Clear Search History',
      content: 'Remove all saved search terms?',
      isDestructive: true,
    )) {
      await ref.read(recentPartSearchesProvider.notifier).clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Search history cleared')),
      );
    }
  }

  Future<void> _onClearFavorites() async {
    final messenger = ScaffoldMessenger.of(context);
    if (await _confirmAction(
      title: 'Clear Favorites',
      content: 'Remove all favorite vehicles?',
      isDestructive: true,
    )) {
      await ref.read(favoriteVehiclesProvider.notifier).clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Favorites cleared')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: _onClearHistory,
                ),
                const NeonDivider(),
                ListTile(
                  leading: const Icon(
                    Icons.travel_explore,
                    color: ThemeTokens.textPrimary,
                  ),
                  title: const Text('Clear Search History'),
                  subtitle: const Text('Removes saved part search terms'),
                  onTap: _onClearSearchHistory,
                ),
                const NeonDivider(),
                ListTile(
                  leading: const Icon(
                    Icons.favorite_border,
                    color: ThemeTokens.textPrimary,
                  ),
                  title: const Text('Clear Favorites'),
                  subtitle: const Text('Removes all favorite vehicles'),
                  onTap: _onClearFavorites,
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
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Subaru Specs & Parts',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.settings_suggest,
                        size: 48,
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.description_outlined,
                      color: ThemeTokens.textPrimary,
                    ),
                    title: Text('Open Source Licenses'),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: ThemeTokens.textMuted,
                    ),
                  ),
                ),
                const NeonDivider(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
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
                      GestureDetector(
                        onTap: _onVersionTap,
                        behavior: HitTestBehavior.opaque,
                        child: const Text(
                          'v1.0.0',
                          style: TextStyle(
                            color: ThemeTokens.neonBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
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
          ),
        ],
      ),
    );
  }
}

// Needed for kReleaseMode
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');
