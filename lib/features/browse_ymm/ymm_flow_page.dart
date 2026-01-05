import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';


class YmmFlowPage extends ConsumerStatefulWidget {
  const YmmFlowPage({super.key});

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

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  Future<void> _loadYears() async {
    final db = ref.read(appDbProvider);
    // Efficiently fetch only distinct years
    final List<int> years = await db.vehiclesDao.getDistinctYears();
    if (mounted) {
      setState(() => _years = years);
    }
  }

  Future<void> _loadModels(int year) async {
    final db = ref.read(appDbProvider);
    // Optimized: Fetch distinct models directly from DB
    final models = await db.vehiclesDao.getDistinctModelsByYear(year);
    if (mounted && _selectedYear == year) {
      setState(() {
        _models = models;
        _vehicles = []; // Clear previous vehicles
      });
    }
  }

  Future<void> _loadVehicles(int year, String model) async {
    final db = ref.read(appDbProvider);
    final vehicles = await db.vehiclesDao.getVehiclesByYearAndModel(year, model);
    if (mounted && _selectedModel == model) {
      setState(() {
        _vehicles = vehicles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Vehicle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_selectedYear == null) ...[
            const Text(
              'Select Year',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._years.map(
              (y) => ListTile(
                title: Text(y.toString()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() => _selectedYear = y);
                  _loadModels(y);
                },
              ),
            ),
          ] else if (_selectedModel == null) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back to years',
                  onPressed: () => setState(() => _selectedYear = null),
                ),
                Text(
                  '$_selectedYear > Select Model',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ..._models.map(
              (m) => ListTile(
                title: Text(m),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    _selectedModel = m;
                    _vehicles = [];
                  });
                  _loadVehicles(_selectedYear!, m);
                },
              ),
            ),
          ] else if (_selectedVehicle == null) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back to models',
                  onPressed: () => setState(() => _selectedModel = null),
                ),
                Text(
                  '$_selectedYear $_selectedModel > Select Trim',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ..._vehicles
                .map(
                  (v) => ListTile(
                    title: Text('${v.trim ?? "Base"} (${v.engineCode ?? "?"})'),
                    trailing: const Icon(Icons.check),
                    onTap: () {
                      setState(() => _selectedVehicle = v);
                    },
                  ),
                ),
          ] else ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back to trims',
                  onPressed: () => setState(() => _selectedVehicle = null),
                ),
                Expanded(
                  child: Text(
                    '${_selectedVehicle!.year} ${_selectedVehicle!.model} ${_selectedVehicle!.trim}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('View Specs'),
              onTap: () {
                // Show specs for this vehicle (filtered by tags/engine code ideally, but simple for now)
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    content: const Text('Specs filtering coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('View Parts'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    content: const Text('Parts filtering coming soon!'),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
