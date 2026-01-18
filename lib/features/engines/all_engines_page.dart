import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/engines/engine_providers.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/market_badge.dart';
import 'package:specsnparts/theme/tokens.dart';

class AllEnginesPage extends ConsumerStatefulWidget {
  const AllEnginesPage({super.key});

  @override
  ConsumerState<AllEnginesPage> createState() => _AllEnginesPageState();
}

class _AllEnginesPageState extends ConsumerState<AllEnginesPage> {
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
    final enginesByFamilyAsync = ref.watch(enginesByFamilyProvider);

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
          ? _buildEngineList(enginesByFamilyAsync)
          : _buildVehicleList(),
    );
  }

  Widget _buildEngineList(
    AsyncValue<Map<String, List<EngineEntry>>> enginesByFamilyAsync,
  ) {
    return enginesByFamilyAsync.when(
      data: (familyGroups) {
        if (familyGroups.isEmpty) {
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

        // Flatten the data for virtualization
        final List<_ListItem> items = [];
        for (final entry in familyGroups.entries) {
          final family = entry.key;
          final engines = entry.value;
          final allTrims = engines.expand((e) => e.trims).toSet();

          items.add(_HeaderItem(family: family, trims: allTrims));
          for (final engine in engines) {
            items.add(_EngineItem(engine: engine, family: family));
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item is _HeaderItem) {
              final familyColor = _getFamilyColor(item.family);
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: familyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: familyColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        item.family,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: familyColor,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getFamilyName(item.family),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ThemeTokens.textMuted,
                      ),
                    ),
                    const Spacer(),
                    MarketBadge.fromTrims(item.trims, compact: true),
                  ],
                ),
              );
            } else if (item is _EngineItem) {
              final engine = item.engine;
              final familyColor = _getFamilyColor(item.family);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedEngine = engine.code;
                      _vehicles = [];
                    });
                    _loadVehicles(engine.code);
                  },
                  borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                  child: CarbonSurface(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: familyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: familyColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                engine.code,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${engine.modelCount} model${engine.modelCount == 1 ? '' : 's'}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: ThemeTokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                        MarketBadge.fromTrims(engine.trims, compact: true),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: ThemeTokens.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
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
      case 'CB':
        return Colors.tealAccent;
      case 'EN':
      case 'EF':
        return Colors.orangeAccent;
      default:
        return ThemeTokens.neonBlue;
    }
  }

  String _getFamilyName(String family) {
    const names = {
      'EA': 'Classic Boxer',
      'EJ': 'Iconic Boxer',
      'EG': 'Early Series',
      'ER': 'Flat-6',
      'EZ': 'Modern Flat-6',
      'FA': 'DIT Turbo',
      'FB': 'Modern NA',
      'CB': 'Modern Turbo',
      'EN': 'Kei',
      'EF': 'Small',
      '1NR': 'Toyota',
      '1NZ': 'Toyota',
      'UNK': 'Unknown',
    };
    return names[family] ?? '';
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

    // Get market badge for header
    final allTrims = _vehicles.map((v) => v.trim).whereType<String>().toSet();

    return Column(
      children: [
        // Header with engine info and market badge
        Padding(
          padding: const EdgeInsets.all(16),
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
                    color: ThemeTokens.neonBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedEngine!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ThemeTokens.neonBlue,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${_vehicles.length} compatible vehicle${_vehicles.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ThemeTokens.textSecondary,
                    ),
                  ),
                ),
                MarketBadge.fromTrims(allTrims),
              ],
            ),
          ),
        ),

        // Vehicle list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadVehicles(_selectedEngine!),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _vehicles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final v = _vehicles[index];
                return InkWell(
                  onTap: () {
                    // Save to recents and navigate to specs
                    ref.read(recentVehiclesProvider.notifier).add(v);
                    context.push(
                      '/specs',
                      extra: {'vehicle': v, 'initialCategoryKey': 'engine'},
                    );
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: ThemeTokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        MarketBadge.single(
                          inferMarketFromTrim(v.trim),
                          compact: true,
                        ),
                        const SizedBox(width: 4),
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
        ),
      ],
    );
  }
}

abstract class _ListItem {}

class _HeaderItem extends _ListItem {
  final String family;
  final Set<String> trims;
  _HeaderItem({required this.family, required this.trims});
}

class _EngineItem extends _ListItem {
  final EngineEntry engine;
  final String family;
  _EngineItem({required this.engine, required this.family});
}
