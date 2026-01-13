import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/comparison/comparison_provider.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/neon_divider.dart';

class ComparisonPage extends ConsumerWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comparisonProvider);
    final vehicles = state.vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spec Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear All',
            onPressed: () => ref.read(comparisonProvider.notifier).clear(),
          ),
        ],
      ),
      body: vehicles.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                _buildHeader(vehicles),
                const NeonDivider(),
                Expanded(
                  child: ListView(
                    children: [
                      _buildComparisonSection(ref, 'Engine & Core', [
                        'Engine Code',
                        'Cylinders',
                        'Drivetrain',
                      ], vehicles),
                      _buildComparisonSection(ref, 'Fluids & Capacities', [
                        'Engine Oil',
                        'Coolant',
                        'Brake Fluid',
                      ], vehicles),
                      _buildComparisonSection(ref, 'Torque Specs', [
                        'Wheel Lugs',
                        'Spark Plugs',
                        'Drain Plug',
                      ], vehicles),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.compare_arrows,
            size: 64,
            color: ThemeTokens.textMuted,
          ),
          const SizedBox(height: 16),
          const Text('Add 2 vehicles to compare specs side-by-side'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go find vehicles'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<Vehicle> vehicles) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: ThemeTokens.surfaceRaised,
      child: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox()), // Label column
          for (final vehicle in vehicles)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    '${vehicle.year}',
                    style: const TextStyle(
                      color: ThemeTokens.neonBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    vehicle.model,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    vehicle.trim ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThemeTokens.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (vehicles.length < 2)
            const Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  'Add another...',
                  style: TextStyle(color: ThemeTokens.textMuted, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(
    WidgetRef ref,
    String title,
    List<String> labels,
    List<Vehicle> vehicles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: ThemeTokens.textMuted,
              letterSpacing: 1.1,
            ),
          ),
        ),
        for (final label in labels)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ThemeTokens.textMuted,
                    ),
                  ),
                ),
                for (final vehicle in vehicles)
                  Expanded(
                    flex: 3,
                    child: _buildSpecValuePlaceholder(label, vehicle),
                  ),
                if (vehicles.length < 2)
                  const Expanded(flex: 3, child: Center(child: Text('-'))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpecValuePlaceholder(String label, Vehicle vehicle) {
    // In a real implementation, we would fetch the specific spec title
    // for this vehicle from the database.
    // For alpha, we use dummy data or derive from vehicle fields.
    String value = 'N/A';
    if (label == 'Engine Code') {
      value = vehicle.engineCode ?? 'TBD';
    }
    if (label == 'Cylinders') {
      value = vehicle.engineCode?.contains('6') == true ? 'H6' : 'H4';
    }
    if (label == 'Drivetrain') {
      value = 'AWD';
    }

    // Highlight differences? (Optional for alpha)
    return Center(
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, color: ThemeTokens.textPrimary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
