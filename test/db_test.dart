import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:specsnparts/data/db/app_db.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Vehicles can be inserted and retrieved', () async {
    final vehicle = Vehicle(
      id: 'v1',
      year: 2024,
      make: 'Subaru',
      model: 'WRX',
      trim: 'Limited',
      engineCode: 'FA24',
      updatedAt: DateTime.now(),
    );

    await db.vehiclesDao.insertVehicle(vehicle);
    final list = await db.vehiclesDao.getAllVehicles();

    expect(list.length, 1);
    expect(list.first.model, 'WRX');
  });

  test('getDistinctYears returns sorted unique years', () async {
    final v1 = Vehicle(
      id: 'v1',
      year: 2020,
      make: 'Subaru',
      model: 'Impreza',
      updatedAt: DateTime.now(),
    );
    final v2 = Vehicle(
      id: 'v2',
      year: 2022,
      make: 'Subaru',
      model: 'WRX',
      updatedAt: DateTime.now(),
    );
    final v3 = Vehicle(
      id: 'v3',
      year: 2020,
      make: 'Subaru',
      model: 'Crosstrek',
      updatedAt: DateTime.now(),
    );

    await db.vehiclesDao.insertMultiple([v1, v2, v3]);

    final years = await db.vehiclesDao.getDistinctYears();

    expect(years, [2022, 2020]);
  });
}
