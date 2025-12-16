import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';

part 'vehicles_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehiclesDao extends DatabaseAccessor<AppDatabase> with _$VehiclesDaoMixin {
  VehiclesDao(AppDatabase db) : super(db);

  Future<List<Vehicle>> getAllVehicles() => select(vehicles).get();

  Future<List<Vehicle>> getVehiclesByYear(int year) =>
    (select(vehicles)..where((tbl) => tbl.year.equals(year))).get();

  Future<void> insertVehicle(Vehicle vehicle) => into(vehicles).insert(vehicle, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Vehicle> list) async {
    await batch((batch) {
      batch.insertAll(vehicles, list, mode: InsertMode.insertOrReplace);
    });
  }
}
