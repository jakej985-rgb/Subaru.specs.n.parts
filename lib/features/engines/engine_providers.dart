import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/domain/engines/engine_parse.dart';

/// Index of engine family → list of motors in that family.
/// Motors are sorted using natural sort (EJ18, EJ20, EJ22, EJ25, EJ205, EJ207...).
final engineFamilyIndexProvider = FutureProvider<Map<String, List<String>>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final engineCounts = await db.vehiclesDao.getEngineCodesWithCounts();

  // Parse all engine codes and group by family
  final Map<String, Set<String>> familyToMotors = {};

  for (final engineCode in engineCounts.keys) {
    final key = parseEngineKey(engineCode);
    familyToMotors.putIfAbsent(key.family, () => <String>{}).add(key.motor);
  }

  // Sort families by priority, then sort motors within each family
  final sortedFamilies = familyToMotors.keys.toList()..sort(compareFamilies);

  final result = <String, List<String>>{};
  for (final family in sortedFamilies) {
    final motors = familyToMotors[family]!.toList()..sort(compareMotors);
    result[family] = motors;
  }

  return result;
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

/// Vehicle count per family (sum of all vehicles using motors in that family).
final familyVehicleCountsProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final engineCounts = await db.vehiclesDao.getEngineCodesWithCounts();

  final Map<String, int> familyTotals = {};

  for (final entry in engineCounts.entries) {
    final key = parseEngineKey(entry.key);
    familyTotals.update(
      key.family,
      (v) => v + entry.value,
      ifAbsent: () => entry.value,
    );
  }

  return familyTotals;
});

/// Vehicle count per motor.
final motorVehicleCountsProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  final engineCounts = await db.vehiclesDao.getEngineCodesWithCounts();
  final motorToRaw = await ref.watch(motorToEngineCodesProvider.future);

  final Map<String, int> motorTotals = {};

  for (final motor in motorToRaw.keys) {
    int count = 0;
    for (final rawCode in motorToRaw[motor]!) {
      count += engineCounts[rawCode] ?? 0;
    }
    motorTotals[motor] = count;
  }

  return motorTotals;
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
  final engineCounts = await db.vehiclesDao.getEngineCodesWithCounts();

  final Map<String, Set<String>> familyTrims = {};

  for (final engineCode in engineCounts.keys) {
    final key = parseEngineKey(engineCode);
    final vehicles = await db.vehiclesDao.getVehiclesByEngineCode(engineCode);

    familyTrims.putIfAbsent(key.family, () => <String>{});
    for (final v in vehicles) {
      if (v.trim != null) {
        familyTrims[key.family]!.add(v.trim!);
      }
    }
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
