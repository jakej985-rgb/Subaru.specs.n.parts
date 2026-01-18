import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/market_badge.dart';
import 'package:specsnparts/theme/tokens.dart';

class YmmFlowPage extends ConsumerStatefulWidget {
  final List<String>? initialCategories;
  const YmmFlowPage({super.key, this.initialCategories});

  @override
  ConsumerState<YmmFlowPage> createState() => _YmmFlowPageState();
}

class _YmmFlowPageState extends ConsumerState<YmmFlowPage> {
  int? _selectedYear;

  String? _selectedModel;
  Vehicle? _selectedVehicle;

  List<int> _years = [];
  Map<int, int> _modelCounts = {};
  List<String> _models = [];
  Map<String, int> _trimCounts = {};
  List<Vehicle> _vehicles = [];

  // Initialize to true because we load years immediately in initState
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  Future<void> _loadYears() async {
    final db = ref.read(appDbProvider);
    try {
      final years = await db.vehiclesDao.getDistinctYears();
      final modelCounts = await db.vehiclesDao.getYearModelCounts();

      if (mounted) {
        setState(() {
          _years = years;
          _modelCounts = modelCounts;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadModels(int year) async {
    final db = ref.read(appDbProvider);
    try {
      final models = await db.vehiclesDao.getDistinctModelsByYear(year);
      final trimCounts = await db.vehiclesDao.getModelTrimCounts(year);

      if (mounted && _selectedYear == year) {
        setState(() {
          _models = models;
          _trimCounts = trimCounts;
          _vehicles = []; // Clear previous vehicles
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadVehicles(int year, String model) async {
    final db = ref.read(appDbProvider);
    try {
      final List<Vehicle> vehicles = await db.vehiclesDao
          .getVehiclesByYearAndModel(year, model);
      if (mounted && _selectedModel == model) {
        setState(() {
          _vehicles = vehicles;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Vehicle'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_selectedYear == null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Select Year',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                ..._years.map((y) {
                  final modelCount = _modelCounts[y] ?? 0;
                  return _FlowCard(
                    title: y.toString(),
                    subtitle: 'Subaru Vehicle Model Range',
                    icon: Icons.calendar_today,
                    iconColor: ThemeTokens.neonBlue,
                    onTap: () {
                      setState(() {
                        _selectedYear = y;
                        _models = [];
                        _isLoading = true;
                      });
                      _loadModels(y);
                    },
                    infoChips: [
                      _InfoChip(
                        icon: Icons.directions_car,
                        label: '$modelCount model${modelCount == 1 ? "" : "s"}',
                      ),
                    ],
                  );
                }),
              ] else if (_selectedModel == null) ...[
                _BackHeader(
                  title: '$_selectedYear > Select Model',
                  tooltip: 'Back to years',
                  onBack: () => setState(() => _selectedYear = null),
                ),
                ..._models.map((m) {
                  final trimCount = _trimCounts[m] ?? 0;
                  return _FlowCard(
                    title: m,
                    subtitle: 'Exploring $m variations',
                    icon: Icons.directions_car,
                    iconColor: Colors.purpleAccent,
                    onTap: () {
                      setState(() {
                        _selectedModel = m;
                        _vehicles = [];
                        _isLoading = true;
                      });
                      _loadVehicles(_selectedYear!, m);
                    },
                    infoChips: [
                      _InfoChip(
                        icon: Icons.tune,
                        label:
                            '$trimCount variation${trimCount == 1 ? "" : "s"}',
                      ),
                    ],
                  );
                }),
              ] else if (_selectedVehicle == null) ...[
                _BackHeader(
                  title: '$_selectedYear $_selectedModel > Select Trim',
                  tooltip: 'Back to models',
                  onBack: () => setState(() => _selectedModel = null),
                ),
                ..._vehicles.map((v) {
                  return _FlowCard(
                    title: v.trim ?? "Base",
                    subtitle: 'Engine: ${v.engineCode ?? "N/A"}',
                    icon: Icons.tune,
                    iconColor: Colors.greenAccent,
                    onTap: () {
                      setState(() => _selectedVehicle = v);
                    },
                    trailing: MarketBadge.fromTrims(
                      v.trim != null ? {v.trim!} : {},
                      compact: true,
                    ),
                    infoChips: [
                      Consumer(
                        builder: (context, ref, _) {
                          final isFav = ref
                              .watch(favoriteVehiclesProvider)
                              .any(
                                (fav) =>
                                    '${fav.year}|${fav.model}|${fav.trim}' ==
                                    '${v.year}|${v.model}|${v.trim}',
                              );
                          return InkWell(
                            onTap: () {
                              ref
                                  .read(favoriteVehiclesProvider.notifier)
                                  .toggle(v);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav
                                        ? Colors.redAccent
                                        : ThemeTokens.textMuted,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isFav ? 'In Garage' : 'Add to Garage',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: ThemeTokens.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ] else ...[
                _BackHeader(
                  title: '${_selectedVehicle!.year} ${_selectedVehicle!.model} Summary',
                  tooltip: 'Back to trims',
                  onBack: () => setState(() => _selectedVehicle = null),
                ),
                const SizedBox(height: 12),
                CarbonSurface(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeTokens.neonBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: ThemeTokens.neonBlue,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedVehicle!.trim ?? 'Base',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${_selectedVehicle!.year} ${_selectedVehicle!.make} ${_selectedVehicle!.model}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: ThemeTokens.textMuted),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(recentVehiclesProvider.notifier)
                                    .add(_selectedVehicle!);
                                context.push(
                                  '/specs',
                                  extra: {
                                    'vehicle': _selectedVehicle,
                                    'categories': widget.initialCategories,
                                  },
                                );
                              },
                              icon: const Icon(Icons.list_alt),
                              label: const Text('VIEW SPECS'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeTokens.neonBlue,
                                foregroundColor: ThemeTokens.surface,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.push('/parts', extra: _selectedVehicle);
                              },
                              icon: const Icon(Icons.build),
                              label: const Text('VIEW PARTS'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ThemeTokens.neonBlue,
                                side: const BorderSide(color: ThemeTokens.neonBlue),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (_isLoading)
            IgnorePointer(
              child: Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _BackHeader extends StatelessWidget {
  final String title;
  final String tooltip;
  final VoidCallback onBack;

  const _BackHeader({
    required this.title,
    required this.tooltip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: tooltip,
            onPressed: onBack,
            style: IconButton.styleFrom(foregroundColor: ThemeTokens.neonBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final List<Widget> infoChips;
  final Widget? trailing;

  const _FlowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.infoChips = const [],
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
        child: CarbonSurface(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ThemeTokens.textSecondary,
                      ),
                    ),
                    if (infoChips.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (int i = 0; i < infoChips.length; i++) ...[
                            infoChips[i],
                            if (i < infoChips.length - 1)
                              const SizedBox(width: 12),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: ThemeTokens.textMuted),
            ],
          ),
        ),
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
