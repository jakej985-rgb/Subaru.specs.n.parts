import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';

part 'vehicles_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehiclesDao extends DatabaseAccessor<AppDatabase>
    with _$VehiclesDaoMixin {
  VehiclesDao(super.db);

  /// Returns a distinct list of years sorted descending.
  Future<List<int>> getDistinctYears() {
    final q = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.year])
      ..orderBy([
        OrderingTerm(expression: vehicles.year, mode: OrderingMode.desc),
      ]);

    return q.map((row) => row.read(vehicles.year)!).get();
  }

  Future<List<String>> getDistinctModelsByYear(int year) {
    final query = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.model])
      ..where(vehicles.year.equals(year) & vehicles.model.isNotNull())
      ..orderBy([
        OrderingTerm(expression: vehicles.model, mode: OrderingMode.asc),
      ]);

    return query.map((row) => row.read(vehicles.model)!).get();
  }

  Future<List<Vehicle>> getVehiclesByYearAndModel(int year, String model) =>
      (select(
        vehicles,
      )..where((tbl) => tbl.year.equals(year) & tbl.model.equals(model))).get();

  Future<List<Vehicle>> getVehiclesByYear(int year) =>
      (select(vehicles)..where((tbl) => tbl.year.equals(year))).get();

  Future<void> insertVehicle(Vehicle vehicle) =>
      into(vehicles).insert(vehicle, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Vehicle> list) async {
    await batch((batch) {
      batch.insertAll(vehicles, list, mode: InsertMode.insertOrReplace);
    });
  }

  /// Returns a distinct list of engine codes sorted alphabetically.
  /// Filters out null/empty engine codes.
  Future<List<String>> getDistinctEngineCodes() {
    final query = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.engineCode])
      ..where(vehicles.engineCode.isNotNull())
      ..orderBy([
        OrderingTerm(expression: vehicles.engineCode, mode: OrderingMode.asc),
      ]);

    return query.map((row) => row.read(vehicles.engineCode)!).get();
  }

  /// Returns all vehicles with the specified engine code.
  Future<List<Vehicle>> getVehiclesByEngineCode(String engineCode) => (select(
    vehicles,
  )..where((tbl) => tbl.engineCode.equals(engineCode))).get();

  /// Returns engine codes with their vehicle counts.
  Future<Map<String, int>> getEngineCodesWithCounts() async {
    final query = selectOnly(vehicles)
      ..addColumns([vehicles.engineCode, vehicles.id.count()])
      ..where(vehicles.engineCode.isNotNull())
      ..groupBy([vehicles.engineCode])
      ..orderBy([
        OrderingTerm(expression: vehicles.engineCode, mode: OrderingMode.asc),
      ]);

    final results = await query
        .map(
          (row) => MapEntry(
            row.read(vehicles.engineCode)!,
            row.read(vehicles.id.count())!,
          ),
        )
        .get();

    return Map.fromEntries(results);
  }

  /// Returns vehicle counts for each year.
  Future<Map<int, int>> getVehicleCountsByYear() async {
    final query = selectOnly(vehicles)
      ..addColumns([vehicles.year, vehicles.id.count()])
      ..groupBy([vehicles.year])
      ..orderBy([
        OrderingTerm(expression: vehicles.year, mode: OrderingMode.desc),
      ]);

    final results = await query
        .map(
          (row) => MapEntry(
            row.read(vehicles.year)!,
            row.read(vehicles.id.count())!,
          ),
        )
        .get();

    return Map.fromEntries(results);
  }

  /// Returns distinct model counts for each year.
  Future<Map<int, int>> getYearModelCounts() async {
    final query =
        selectOnly(vehicles, distinct: true)..addColumns([
          vehicles.year,
          vehicles.model,
        ]);

    final results = await query.get();
    final Map<int, int> counts = {};
    for (final row in results) {
      final y = row.read(vehicles.year)!;
      counts[y] = (counts[y] ?? 0) + 1;
    }
    return counts;
  }

  /// Returns trim counts for each model in a given year.
  Future<Map<String, int>> getModelTrimCounts(int year) async {
    final query =
        selectOnly(vehicles)
          ..addColumns([vehicles.model, vehicles.id.count()])
          ..where(vehicles.year.equals(year))
          ..groupBy([vehicles.model]);

    final results = await query.get();
    final Map<String, int> counts = {};
    for (final row in results) {
      counts[row.read(vehicles.model)!] = row.read(vehicles.id.count())!;
    }
    return counts;
  }

  /// Returns engine codes mapped to their distinct trims.
  Future<Map<String, List<String>>> getEngineCodesWithTrims() async {
    final query = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.engineCode, vehicles.trim])
      ..where(vehicles.engineCode.isNotNull() & vehicles.trim.isNotNull())
      ..orderBy([
        OrderingTerm(expression: vehicles.engineCode, mode: OrderingMode.asc),
        OrderingTerm(expression: vehicles.trim, mode: OrderingMode.asc),
      ]);

    final results = await query.get();

    final Map<String, List<String>> result = {};
    for (final row in results) {
      final code = row.read(vehicles.engineCode)!;
      final trim = row.read(vehicles.trim)!;
      result.putIfAbsent(code, () => []).add(trim);
    }
    return result;
  }

  /// Returns engine codes mapped to their distinct model names.
  Future<Map<String, List<String>>> getEngineCodesWithModels() async {
    final query = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.engineCode, vehicles.model])
      ..where(vehicles.engineCode.isNotNull() & vehicles.model.isNotNull())
      ..orderBy([
        OrderingTerm(expression: vehicles.engineCode, mode: OrderingMode.asc),
        OrderingTerm(expression: vehicles.model, mode: OrderingMode.asc),
      ]);

    final results = await query.get();

    final Map<String, List<String>> result = {};
    for (final row in results) {
      final code = row.read(vehicles.engineCode)!;
      final model = row.read(vehicles.model)!;
      result.putIfAbsent(code, () => []).add(model);
    }
    return result;
  }

  /// Returns a list of vehicles matching the query in model, year, or engineCode.
  Future<List<Vehicle>> searchVehicles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) {
    if (query.length > 100) return Future.value([]);

    return (select(vehicles)
          ..where(
            (tbl) =>
                tbl.model.contains(query) |
                tbl.year.cast<String>().contains(query) |
                tbl.engineCode.contains(query) |
                tbl.trim.contains(query),
          )
          ..limit(limit, offset: offset))
        .get();
  }
}
