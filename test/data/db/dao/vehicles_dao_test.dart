import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';
// ignore: unused_import
import 'package:specsnparts/data/db/tables.dart';

void main() {
  late AppDatabase db;
  late VehiclesDao vehiclesDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    vehiclesDao = db.vehiclesDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('VehiclesDao', () {
    test('getDistinctYears returns years sorted descending', () async {
      final v1 = Vehicle(
        id: '1',
        year: 2020,
        make: 'Subaru',
        model: 'Outback',
        updatedAt: DateTime.now(),
      );
      final v2 = Vehicle(
        id: '2',
        year: 2021,
        make: 'Subaru',
        model: 'Forester',
        updatedAt: DateTime.now(),
      );
      final v3 = Vehicle(
        id: '3',
        year: 2020,
        make: 'Subaru',
        model: 'Impreza',
        updatedAt: DateTime.now(),
      );

      await vehiclesDao.insertMultiple([v1, v2, v3]);

      final years = await vehiclesDao.getDistinctYears();

      expect(years, [2021, 2020]);
    });

    test(
      'getDistinctModelsByYear returns distinct models sorted alphabetically',
      () async {
        final v1 = Vehicle(
          id: '1',
          year: 2020,
          make: 'Subaru',
          model: 'Outback',
          updatedAt: DateTime.now(),
        );
        final v2 = Vehicle(
          id: '2',
          year: 2020,
          make: 'Subaru',
          model: 'Forester',
          updatedAt: DateTime.now(),
        );
        final v3 = Vehicle(
          id: '3',
          year: 2020,
          make: 'Subaru',
          model: 'Outback',
          updatedAt: DateTime.now(),
        );
        final v4 = Vehicle(
          id: '4',
          year: 2020,
          make: 'Subaru',
          model: 'Crosstrek',
          updatedAt: DateTime.now(),
        );

        await vehiclesDao.insertMultiple([v1, v2, v3, v4]);

        final models = await vehiclesDao.getDistinctModelsByYear(2020);

        expect(models, ['Crosstrek', 'Forester', 'Outback']);
      },
    );
  });
}
