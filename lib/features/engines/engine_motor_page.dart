import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/features/engines/engine_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/market_badge.dart';
import 'package:specsnparts/theme/tokens.dart';

/// Page displaying all motors within a specific engine family.
/// Tap a motor to see compatible vehicles.
class EngineMotorPage extends ConsumerWidget {
  final String family;

  const EngineMotorPage({super.key, required this.family});

  String _getFamilyDescription(String family) {
    const descriptions = {
      'EA': 'Classic flat-4 engines (1966–1994)',
      'EJ': 'Legendary flat-4 engines (1989–2020+)',
      'EG': 'Early experimental variants',
      'ER': 'Flat-6 engines (ER27)',
      'EZ': 'Modern flat-6 engines',
      'FA': 'Direct-injection turbo flat-4',
      'FB': 'Modern naturally aspirated flat-4',
      'EE': 'Early kei-car engines',
      'EF': 'Small displacement engines (Justy)',
      'EN': 'Kei-car engines',
      'UNK': 'Unknown or unspecified engines',
    };
    return descriptions[family] ?? '$family series engines';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyIndexAsync = ref.watch(engineFamilyIndexProvider);
    final modelCountsAsync = ref.watch(motorModelCountsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('$family Motors'), centerTitle: true),
      body: familyIndexAsync.when(
        data: (familyIndex) {
          final motors = familyIndex[family];
          if (motors == null || motors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.memory,
                    size: 64,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No motors found in $family family',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                ],
              ),
            );
          }

          final vehicleCounts = modelCountsAsync.value ?? {};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Family header
              Padding(
                padding: const EdgeInsets.all(16),
                child: CarbonSurface(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ThemeTokens.neonBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          family,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ThemeTokens.neonBlue,
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getFamilyDescription(family),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: ThemeTokens.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${motors.length} motor variants',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ThemeTokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Motor list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: motors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final motor = motors[index];
                    final vehicleCount = vehicleCounts[motor] ?? 0;
                    final motorTrimsAsync = ref.watch(
                      motorTrimsProvider(motor),
                    );
                    final trims = motorTrimsAsync.value ?? <String>{};

                    return InkWell(
                      onTap: () => context.push('/engines/$family/$motor'),
                      borderRadius: BorderRadius.circular(
                        ThemeTokens.radiusMedium,
                      ),
                      child: CarbonSurface(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeTokens.neonBlue.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: ThemeTokens.neonBlue.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                motor,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ThemeTokens.neonBlue,
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getMotorDescription(motor),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ThemeTokens.textPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$vehicleCount model${vehicleCount == 1 ? '' : 's'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: ThemeTokens.textMuted,
                                        ),
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
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _getMotorDescription(String motor) {
    // Common motor descriptions
    const descriptions = {
      'EA71': '1.6L Carbureted',
      'EA81': '1.8L Carbureted',
      'EA82': '1.8L Fuel Injected',
      'EA82T': '1.8L Turbo',
      'EJ18': '1.8L SOHC',
      'EJ20': '2.0L DOHC',
      'EJ201': '2.0L SOHC NA',
      'EJ202': '2.0L SOHC NA',
      'EJ203': '2.0L SOHC NA',
      'EJ204': '2.0L DOHC NA AVCS',
      'EJ205': '2.0L DOHC Turbo',
      'EJ207': '2.0L DOHC Turbo (STI)',
      'EJ22': '2.2L SOHC',
      'EJ22T': '2.2L Turbo',
      'EJ25': '2.5L SOHC',
      'EJ251': '2.5L SOHC',
      'EJ252': '2.5L SOHC',
      'EJ253': '2.5L SOHC',
      'EJ254': '2.5L DOHC',
      'EJ255': '2.5L DOHC Turbo',
      'EJ257': '2.5L DOHC Turbo (STI)',
      'EZ30': '3.0L Flat-6',
      'EZ30R': '3.0L Flat-6 Revised',
      'EZ36': '3.6L Flat-6',
      'FA20': '2.0L DIT',
      'FA20F': '2.0L DIT Turbo',
      'FA24': '2.4L DIT',
      'FA24F': '2.4L DIT Turbo',
      'FB20': '2.0L Chain-Driven',
      'FB25': '2.5L Chain-Driven',
      'ER27': '2.7L Flat-6',
      'EF10': '1.0L 3-Cylinder',
      'EF12': '1.2L 3-Cylinder',
      'EN05': '0.5L 2-Cylinder',
      'EN07': '0.7L 4-Cylinder',
    };

    return descriptions[motor] ?? 'Boxer engine';
  }
}
