import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/domain/engines/engine_parse.dart';

class EngineEntry {
  final String code;
  final String motor;
  final int modelCount;
  final Set<String> trims;

  EngineEntry({
    required this.code,
    required this.motor,
    required this.modelCount,
    required this.trims,
  });
}

final enginesByFamilyProvider = FutureProvider<Map<String, List<EngineEntry>>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final engineModels = await db.vehiclesDao.getEngineCodesWithModels();
  final engineTrims = await db.vehiclesDao.getEngineCodesWithTrims();

  // Group by family
  final Map<String, List<EngineEntry>> familyGroups = {};

  // We use engineTrims keys as the master list of all engine codes
  for (final engineCode in engineTrims.keys) {
    final models = engineModels[engineCode]?.toSet() ?? <String>{};
    final trims = engineTrims[engineCode]?.toSet() ?? <String>{};
    final key = parseEngineKey(engineCode);

    familyGroups.putIfAbsent(key.family, () => []).add(
          EngineEntry(
            code: engineCode,
            motor: key.motor,
            modelCount: models.length,
            trims: trims,
          ),
        );
  }

  // Sort families by priority
  final sortedFamilies = familyGroups.keys.toList()..sort(compareFamilies);

  // Sort engines within each family by motor code
  final result = <String, List<EngineEntry>>{};
  for (final family in sortedFamilies) {
    final engines = familyGroups[family]!
      ..sort((a, b) => compareMotors(a.motor, b.motor));
    result[family] = engines;
  }

  return result;
});

/// Index of engine family → list of motors in that family.
final engineFamilyIndexProvider = FutureProvider<Map<String, List<String>>>((
  ref,
) async {
  final enginesByFamily = await ref.watch(enginesByFamilyProvider.future);
  return enginesByFamily.map((family, engines) {
    final motors = engines.map((e) => e.motor).toSet().toList()
      ..sort(compareMotors);
    return MapEntry(family, motors);
  });
});

/// Index of motor code → list of raw engine codes in DB that map to this motor.
/// Used to query vehicles by motor.
final motorToEngineCodesProvider = FutureProvider<Map<String, Set<String>>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final engineCounts = await db.vehiclesDao.getEngineCodesWithCounts();

  final Map<String, Set<String>> motorToRaw = {};

  for (final engineCode in engineCounts.keys) {
    final key = parseEngineKey(engineCode);
    motorToRaw.putIfAbsent(key.motor, () => <String>{}).add(engineCode);
  }

  return motorToRaw;
});

/// Count of motors per family.
final familyMotorCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final familyIndex = await ref.watch(engineFamilyIndexProvider.future);
  return familyIndex.map((family, motors) => MapEntry(family, motors.length));
});

/// Model count per family (distinct model names using motors in that family).
final familyModelCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(appDbProvider);
  final engineModels = await db.vehiclesDao.getEngineCodesWithModels();

  final Map<String, Set<String>> familyModels = {};

  for (final entry in engineModels.entries) {
    final key = parseEngineKey(entry.key);
    familyModels.putIfAbsent(key.family, () => <String>{}).addAll(entry.value);
  }

  return familyModels.map((family, models) => MapEntry(family, models.length));
});

/// Model count per motor (distinct model names using this motor).
final motorModelCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(appDbProvider);
  final engineModels = await db.vehiclesDao.getEngineCodesWithModels();
  final motorToRaw = await ref.watch(motorToEngineCodesProvider.future);

  final Map<String, Set<String>> motorModels = {};

  for (final motor in motorToRaw.keys) {
    final Set<String> modelsForMotor = {};
    for (final rawCode in motorToRaw[motor]!) {
      modelsForMotor.addAll(engineModels[rawCode] ?? []);
    }
    motorModels[motor] = modelsForMotor;
  }

  return motorModels.map((motor, models) => MapEntry(motor, models.length));
});

/// Provider family to fetch vehicles by motor code.
/// Returns all vehicles whose engine code parses to the given motor.
final vehiclesByMotorProvider = FutureProvider.family<List<Vehicle>, String>((
  ref,
  motor,
) async {
  final db = ref.watch(appDbProvider);
  final motorToRaw = await ref.watch(motorToEngineCodesProvider.future);

  final rawCodes = motorToRaw[motor];
  if (rawCodes == null || rawCodes.isEmpty) {
    return [];
  }

  // Fetch vehicles for each raw engine code and combine
  final List<Vehicle> allVehicles = [];
  for (final rawCode in rawCodes) {
    final vehicles = await db.vehiclesDao.getVehiclesByEngineCode(rawCode);
    allVehicles.addAll(vehicles);
  }

  // Sort by year descending, then model, then trim
  allVehicles.sort((a, b) {
    final yearCmp = b.year.compareTo(a.year);
    if (yearCmp != 0) return yearCmp;
    final modelCmp = a.model.compareTo(b.model);
    if (modelCmp != 0) return modelCmp;
    return (a.trim ?? '').compareTo(b.trim ?? '');
  });

  return allVehicles;
});

/// Markets per engine family (set of trims found in that family).
/// Used to show market badges on family page.
final familyTrimsProvider = FutureProvider<Map<String, Set<String>>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final codeToTrims = await db.vehiclesDao.getEngineCodesWithTrims();

  final Map<String, Set<String>> familyTrims = {};

  for (final entry in codeToTrims.entries) {
    final key = parseEngineKey(entry.key);
    familyTrims.putIfAbsent(key.family, () => <String>{}).addAll(entry.value);
  }

  return familyTrims;
});

/// Markets per motor (set of trims found with that motor).
/// Used to show market badges on motor page.
final motorTrimsProvider = FutureProvider.family<Set<String>, String>((
  ref,
  motor,
) async {
  final vehicles = await ref.watch(vehiclesByMotorProvider(motor).future);
  return vehicles.map((v) => v.trim).whereType<String>().toSet();
});
