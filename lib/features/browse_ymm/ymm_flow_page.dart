import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
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
  List<String> _models = [];
  List<Vehicle> _vehicles = [];

  // Initialize to true because we load years immediately in initState
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  Future<void> _loadYears() async {
    // No setState here because we are in initState (or started from it)
    // and initialized _isLoading = true.
    final db = ref.read(appDbProvider);
    try {
      // Efficiently fetch only distinct years
      final List<int> years = await db.vehiclesDao.getDistinctYears();
      if (mounted) {
        setState(() {
          _years = years;
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
      // Optimized: Fetch distinct models directly from DB
      final List<String> models = await db.vehiclesDao.getDistinctModelsByYear(
        year,
      );
      if (mounted && _selectedYear == year) {
        setState(() {
          _models = models;
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
      appBar: AppBar(title: const Text('Select Vehicle')),
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
                ..._years.map(
                  (y) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedYear = y;
                          _models = [];
                          _isLoading = true;
                        });
                        _loadModels(y);
                      },
                      borderRadius: BorderRadius.circular(
                        ThemeTokens.radiusMedium,
                      ),
                      child: CarbonSurface(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              y.toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: ThemeTokens.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (_selectedModel == null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back to years',
                        onPressed: () => setState(() => _selectedYear = null),
                        style: IconButton.styleFrom(
                          foregroundColor: ThemeTokens.neonBlue,
                        ),
                      ),
                      Text(
                        '$_selectedYear > Select Model',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                ..._models.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedModel = m;
                          _vehicles = [];
                          _isLoading = true;
                        });
                        _loadVehicles(_selectedYear!, m);
                      },
                      borderRadius: BorderRadius.circular(
                        ThemeTokens.radiusMedium,
                      ),
                      child: CarbonSurface(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              m,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: ThemeTokens.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (_selectedVehicle == null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back to models',
                        onPressed: () => setState(() => _selectedModel = null),
                        style: IconButton.styleFrom(
                          foregroundColor: ThemeTokens.neonBlue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$_selectedYear $_selectedModel > Select Trim',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                ..._vehicles.map(
                  (v) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedVehicle = v);
                      },
                      borderRadius: BorderRadius.circular(
                        ThemeTokens.radiusMedium,
                      ),
                      child: CarbonSurface(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${v.trim ?? "Base"} (${v.engineCode ?? "?"})',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              color: ThemeTokens.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back to trims',
                        onPressed: () =>
                            setState(() => _selectedVehicle = null),
                        style: IconButton.styleFrom(
                          foregroundColor: ThemeTokens.neonBlue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_selectedVehicle!.year} ${_selectedVehicle!.model} ${_selectedVehicle!.trim}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                NeonPlate(
                  onTap: () {
                    // Navigate to specs page with selected vehicle for filtering
                    context.push(
                      '/specs',
                      extra: {
                        'vehicle': _selectedVehicle,
                        'categories': widget.initialCategories,
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.list, color: ThemeTokens.neonBlue),
                      const SizedBox(width: 16),
                      Text(
                        'View Specs',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                NeonPlate(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: ThemeTokens.surfaceRaised,
                        title: const Text('Coming Soon'),
                        content: const Text(
                          'Parts filtering is under construction.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: ThemeTokens.neonBlue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.build, color: ThemeTokens.textSecondary),
                      const SizedBox(width: 16),
                      Text(
                        'View Parts',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: ThemeTokens.textSecondary),
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
