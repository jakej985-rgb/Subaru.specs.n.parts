import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';

void main() {
  late AppDatabase db;
  late SpecsDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = SpecsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('getSpecsForVehicle works with non-nullable model', () async {
    // Create a vehicle. The generated Vehicle class should require 'model' to be non-null.
    final vehicle = Vehicle(
      id: 'v1',
      year: 2022,
      make: 'Subaru',
      model: 'WRX',
      trim: 'Limited',
      engineCode: 'FA24',
      updatedAt: DateTime.now(),
    );

    // Insert a matching spec
    await dao.insertSpec(
      Spec(
        id: 's1',
        category: 'Engine',
        title: 'Oil Capacity',
        body: '4.8 Liters',
        tags: 'wrx,2022,limited',
        updatedAt: DateTime.now(),
      ),
    );

    final specs = await dao.getSpecsForVehicle(vehicle);

    expect(specs.length, 1);
    expect(specs.first.id, 's1');
  });
}
