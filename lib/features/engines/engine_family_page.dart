import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/features/engines/engine_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/market_badge.dart';
import 'package:specsnparts/theme/tokens.dart';

/// Page displaying all Subaru engine families (EA, EJ, FA, FB, etc.).
/// Tap a family to see its motors.
class EngineFamilyPage extends ConsumerWidget {
  const EngineFamilyPage({super.key});

  String _getFamilyDisplayName(String family) {
    const familyNames = {
      'EA': 'EA Series (Classic Boxer)',
      'EJ': 'EJ Series (Iconic Boxer)',
      'EG': 'EG Series',
      'ER': 'ER Series (Flat-6)',
      'EZ': 'EZ Series (Modern Flat-6)',
      'FA': 'FA Series (Direct-Injection Turbo)',
      'FB': 'FB Series (Modern NA)',
      'EE': 'EE Series (Early Kei)',
      'EF': 'EF Series (Small Displacement)',
      'EN': 'EN Series (Kei)',
      'UNK': 'Unknown / Unspecified',
    };
    return familyNames[family] ?? '$family Series';
  }

  IconData _getFamilyIcon(String family) {
    switch (family) {
      case 'EA':
        return Icons.history; // Classic
      case 'EJ':
        return Icons.directions_car; // Iconic
      case 'FA':
        return Icons.speed; // Turbo
      case 'FB':
        return Icons.eco; // Modern NA
      case 'ER':
      case 'EZ':
        return Icons.star; // Flat-6
      case 'EF':
      case 'EN':
      case 'EE':
        return Icons.electric_car; // Kei
      default:
        return Icons.settings;
    }
  }

  Color _getFamilyColor(String family) {
    switch (family) {
      case 'EA':
        return Colors.amber;
      case 'EJ':
        return ThemeTokens.neonBlue;
      case 'FA':
        return Colors.redAccent;
      case 'FB':
        return Colors.greenAccent;
      case 'ER':
      case 'EZ':
        return Colors.purpleAccent;
      default:
        return ThemeTokens.neonBlue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyIndexAsync = ref.watch(engineFamilyIndexProvider);
    final modelCountsAsync = ref.watch(familyModelCountsProvider);
    final familyTrimsAsync = ref.watch(familyTrimsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Engine Families'), centerTitle: true),
      body: familyIndexAsync.when(
        data: (familyIndex) {
          if (familyIndex.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.engineering,
                    size: 64,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No engine data available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final families = familyIndex.keys.toList();
          final modelCounts = modelCountsAsync.value ?? {};

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: families.length + 1, // +1 for "All Engines" header
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // "All Engines" header card
              if (index == 0) {
                return InkWell(
                  onTap: () => context.push('/browse/engine/all'),
                  borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                  child: CarbonSurface(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ThemeTokens.neonBlue.withValues(alpha: 0.2),
                                ThemeTokens.neonBlueDeep.withValues(
                                  alpha: 0.15,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.list_alt,
                            color: ThemeTokens.neonBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Engines',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ThemeTokens.neonBlue,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'View all engine codes grouped by family',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: ThemeTokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: ThemeTokens.neonBlue,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final family = families[index - 1]; // Adjust for header
              final motorCount = familyIndex[family]?.length ?? 0;
              final modelCount = modelCounts[family] ?? 0;
              final color = _getFamilyColor(family);
              final trims = familyTrimsAsync.value?[family] ?? <String>{};

              return InkWell(
                onTap: () => context.push('/engines/$family'),
                borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                child: CarbonSurface(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getFamilyIcon(family),
                          color: color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              family,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFamilyDisplayName(family),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: ThemeTokens.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _InfoChip(
                                  icon: Icons.memory,
                                  label: '$motorCount motors',
                                ),
                                const SizedBox(width: 12),
                                _InfoChip(
                                  icon: Icons.directions_car,
                                  label: '$modelCount models',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      MarketBadge.fromTrims(trims, compact: true),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: ThemeTokens.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: ThemeTokens.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ThemeTokens.textMuted),
        ),
      ],
    );
  }
}
