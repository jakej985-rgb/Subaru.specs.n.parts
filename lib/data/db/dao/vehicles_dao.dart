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
        OrderingTerm(expression: vehicles.year, mode: OrderingMode.desc)
      ]);

    return q.map((row) => row.read(vehicles.year)!).get();
  }

  Future<List<String>> getDistinctModelsByYear(int year) {
    final query = selectOnly(vehicles, distinct: true)
      ..addColumns([vehicles.model])
      ..where(vehicles.year.equals(year) & vehicles.model.isNotNull())
      ..orderBy([
        OrderingTerm(expression: vehicles.model, mode: OrderingMode.asc)
      ]);

    return query.map((row) => row.read(vehicles.model)!).get();
  }

  Future<List<Vehicle>> getVehiclesByYearAndModel(int year, String model) =>
      (select(vehicles)
            ..where((tbl) => tbl.year.equals(year) & tbl.model.equals(model)))
          .get();

  Future<void> insertVehicle(Vehicle vehicle) =>
      into(vehicles).insert(vehicle, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Vehicle> list) async {
    await batch((batch) {
      batch.insertAll(vehicles, list, mode: InsertMode.insertOrReplace);
    });
  }
}
