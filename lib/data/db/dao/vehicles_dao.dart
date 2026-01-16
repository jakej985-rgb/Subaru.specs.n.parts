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
      )..where((tbl) => tbl.year.equals(year) & tbl.model.equals(model)))
          .get();

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
      )..where((tbl) => tbl.engineCode.equals(engineCode)))
          .get();

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
