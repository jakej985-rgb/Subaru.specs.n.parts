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

  group('VehiclesDao', () {
    test('getDistinctModelsByYear returns only distinct models for the given year', () async {
      final v1 = Vehicle(
        id: 'v1',
        year: 2024,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Limited',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );
      final v2 = Vehicle(
        id: 'v2',
        year: 2024,
        make: 'Subaru',
        model: 'WRX', // Same model
        trim: 'Base',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );
      final v3 = Vehicle(
        id: 'v3',
        year: 2024,
        make: 'Subaru',
        model: 'Outback', // Different model
        trim: 'Touring',
        engineCode: 'FB25',
        updatedAt: DateTime.now(),
      );
      final v4 = Vehicle(
        id: 'v4',
        year: 2023, // Different year
        make: 'Subaru',
        model: 'Legacy',
        trim: 'Sport',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );

      await db.vehiclesDao.insertMultiple([v1, v2, v3, v4]);

      final models = await db.vehiclesDao.getDistinctModelsByYear(2024);

      expect(models.length, 2);
      expect(models, containsAll(['WRX', 'Outback']));
      expect(models, isNot(contains('Legacy')));
    });

    test('getVehiclesByYearAndModel returns vehicles matching year and model', () async {
      final v1 = Vehicle(
        id: 'v1',
        year: 2024,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Limited',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );
      final v2 = Vehicle(
        id: 'v2',
        year: 2024,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Base',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );
      final v3 = Vehicle(
        id: 'v3',
        year: 2024,
        make: 'Subaru',
        model: 'Outback',
        trim: 'Touring',
        engineCode: 'FB25',
        updatedAt: DateTime.now(),
      );

      await db.vehiclesDao.insertMultiple([v1, v2, v3]);

      final vehicles = await db.vehiclesDao.getVehiclesByYearAndModel(2024, 'WRX');

      expect(vehicles.length, 2);
      expect(vehicles.map((v) => v.trim), containsAll(['Limited', 'Base']));
      expect(vehicles.map((v) => v.model), everyElement('WRX'));
    });
  });
}
