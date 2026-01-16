import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/engines/engine_providers.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/market_badge.dart';
import 'package:specsnparts/theme/tokens.dart';

/// Page displaying all vehicles compatible with a specific motor.
/// Tap a vehicle to open the existing spec/detail page.
class EngineVehicleResultsPage extends ConsumerStatefulWidget {
  final String family;
  final String motor;

  const EngineVehicleResultsPage({
    super.key,
    required this.family,
    required this.motor,
  });

  @override
  ConsumerState<EngineVehicleResultsPage> createState() =>
      _EngineVehicleResultsPageState();
}

class _EngineVehicleResultsPageState
    extends ConsumerState<EngineVehicleResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedYear;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    return vehicles.where((v) {
      // Year filter
      if (_selectedYear != null && v.year != _selectedYear) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final searchTarget = '${v.year} ${v.model} ${v.trim ?? ''}'
            .toLowerCase();
        if (!searchTarget.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesByMotorProvider(widget.motor));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.motor} Vehicles'),
        centerTitle: true,
      ),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
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
                    'No vehicles found with ${widget.motor}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // Get unique years for filter chips
          final years = vehicles.map((v) => v.year).toSet().toList()
            ..sort((a, b) => b.compareTo(a)); // Descending

          final filteredVehicles = _filterVehicles(vehicles);

          return Column(
            children: [
              // Header with motor info
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
                          widget.motor,
                          style: Theme.of(context).textTheme.headlineSmall
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
                              '${widget.family} Series',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: ThemeTokens.textSecondary),
                            ),
                            Text(
                              '${vehicles.length} compatible vehicle${vehicles.length == 1 ? '' : 's'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: ThemeTokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      MarketBadge.fromTrims(vehicles.map((v) => v.trim)),
                    ],
                  ),
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search vehicles...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeTokens.radiusMedium,
                      ),
                    ),
                    filled: true,
                    fillColor: ThemeTokens.surface,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),

              // Year filter chips
              if (years.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: years.length + 1, // +1 for "All" chip
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "All" chip
                          final isSelected = _selectedYear == null;
                          return FilterChip(
                            label: const Text('All Years'),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedYear = null),
                            backgroundColor: ThemeTokens.surface,
                            selectedColor: ThemeTokens.neonBlue.withValues(
                              alpha: 0.2,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? ThemeTokens.neonBlue
                                  : ThemeTokens.textSecondary,
                            ),
                          );
                        }

                        final year = years[index - 1];
                        final isSelected = _selectedYear == year;
                        return FilterChip(
                          label: Text(year.toString()),
                          selected: isSelected,
                          onSelected: (_) => setState(
                            () => _selectedYear = isSelected ? null : year,
                          ),
                          backgroundColor: ThemeTokens.surface,
                          selectedColor: ThemeTokens.neonBlue.withValues(
                            alpha: 0.2,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? ThemeTokens.neonBlue
                                : ThemeTokens.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredVehicles.length} result${filteredVehicles.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ThemeTokens.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Vehicle list
              Expanded(
                child: filteredVehicles.isEmpty
                    ? Center(
                        child: Text(
                          'No matching vehicles',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: ThemeTokens.textMuted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredVehicles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final vehicle = filteredVehicles[index];
                          return _VehicleCard(vehicle: vehicle);
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
}

class _VehicleCard extends ConsumerWidget {
  final Vehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Save to recents and navigate to specs
        ref.read(recentVehiclesProvider.notifier).add(vehicle);
        context.push('/specs', extra: {'vehicle': vehicle});
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
                    '${vehicle.year} ${vehicle.model}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicle.trim ?? 'Base',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ThemeTokens.textSecondary,
                    ),
                  ),
                  if (vehicle.engineCode != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      vehicle.engineCode!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ThemeTokens.textMuted,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            MarketBadge.single(
              inferMarketFromTrim(vehicle.trim),
              compact: true,
              showLabel: true,
            ),

            // Favorite toggle
            Consumer(
              builder: (context, ref, _) {
                final isFav = ref
                    .watch(favoriteVehiclesProvider)
                    .any(
                      (fav) =>
                          '${fav.year}|${fav.model}|${fav.trim}' ==
                          '${vehicle.year}|${vehicle.model}|${vehicle.trim}',
                    );
                return InkWell(
                  onTap: () {
                    ref.read(favoriteVehiclesProvider.notifier).toggle(vehicle);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : ThemeTokens.textMuted,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: ThemeTokens.textMuted),
          ],
        ),
      ),
    );
  }
}
