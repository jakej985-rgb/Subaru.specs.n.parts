import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/tokens.dart';

/// Provider to fetch distinct engine codes with vehicle counts.
final engineCodesWithCountsProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  return db.vehiclesDao.getEngineCodesWithCounts();
});

class EngineFlowPage extends ConsumerStatefulWidget {
  const EngineFlowPage({super.key});

  @override
  ConsumerState<EngineFlowPage> createState() => _EngineFlowPageState();
}

class _EngineFlowPageState extends ConsumerState<EngineFlowPage> {
  String? _selectedEngine;
  List<Vehicle> _vehicles = [];
  bool _isLoadingVehicles = false;

  Future<void> _loadVehicles(String engineCode) async {
    setState(() {
      _isLoadingVehicles = true;
    });

    final db = ref.read(appDbProvider);
    try {
      final vehicles = await db.vehiclesDao.getVehiclesByEngineCode(engineCode);
      if (mounted && _selectedEngine == engineCode) {
        setState(() {
          _vehicles = vehicles;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingVehicles = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enginesAsync = ref.watch(engineCodesWithCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedEngine == null
              ? 'Browse by Engine'
              : 'Vehicles with $_selectedEngine',
        ),
        leading: _selectedEngine != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _selectedEngine = null;
                  _vehicles = [];
                }),
              )
            : null,
      ),
      body: _selectedEngine == null
          ? _buildEngineList(enginesAsync)
          : _buildVehicleList(),
    );
  }

  Widget _buildEngineList(AsyncValue<Map<String, int>> enginesAsync) {
    return enginesAsync.when(
      data: (engineCounts) {
        if (engineCounts.isEmpty) {
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

        final engines = engineCounts.keys.toList();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: engines.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final engine = engines[index];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedEngine = engine;
                  _vehicles = [];
                });
                _loadVehicles(engine);
              },
              borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
              child: CarbonSurface(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ThemeTokens.neonBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: ThemeTokens.neonBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              engine,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${engineCounts[engine]} vehicles',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ThemeTokens.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
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
    );
  }

  Widget _buildVehicleList() {
    if (_isLoadingVehicles) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No vehicles found with $_selectedEngine',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadVehicles(_selectedEngine!),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _vehicles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final v = _vehicles[index];
          return InkWell(
            onTap: () {
              // Save to recents and navigate to specs
              ref.read(recentVehiclesProvider.notifier).add(v);
              context.push('/specs', extra: {'vehicle': v});
            },
            borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
            child: CarbonSurface(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${v.year} ${v.model}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          v.trim ?? 'Base',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ThemeTokens.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: ThemeTokens.textMuted),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
