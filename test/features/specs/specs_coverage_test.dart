import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';

void main() {
  group('Specs Coverage & Parsing', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('SpecsDao finds 2004 WRX spec despite implicit tags', () async {
      final oilJson = '''
      [
        {
          "id": "s_oil_capacity_wrx_gd",
          "category": "Oil",
          "title": "WRX 2002-2005 Oil Capacity",
          "body": "4.5 Liters",
          "tags": "oil,capacity,ej205,wrx,gd",
          "updatedAt": "2024-01-01T00:00:00Z"
        }
      ]
      ''';
      final specs = parseSpecs(oilJson);
      // Verify tags expanded
      expect(specs.first.tags, contains('2004'));

      await db.specsDao.insertMultiple(specs);

      final vehicle = Vehicle(
        id: 'v_imp_2004_wrx',
        year: 2004,
        make: 'Subaru',
        model: 'Impreza',
        trim: 'WRX Sedan (US)',
        engineCode: 'EJ205',
        updatedAt: DateTime.now(),
      );

      final results = await db.specsDao.getSpecsForVehicle(vehicle);
      expect(
        results,
        isNotEmpty,
        reason: 'Should find spec for 2004 Impreza WRX',
      );
      expect(results.first.title, contains('WRX 2002-2005'));
    });

    test('SpecsDao finds 2018 STI spec (VA generation)', () async {
      final oilJson = '''
      [
        {
          "id": "s_oil_capacity_sti_va",
          "category": "Oil",
          "title": "STI 2015-2021 Oil Capacity",
          "body": "4.3 Liters",
          "tags": "oil,capacity,ej257,sti,va",
          "updatedAt": "2024-01-01T00:00:00Z"
        }
      ]
      ''';
      final specs = parseSpecs(oilJson);
      expect(specs.first.tags, contains('2018'));

      await db.specsDao.insertMultiple(specs);

      final vehicle = Vehicle(
        id: 'v_wrx_2018_sti',
        year: 2018,
        make: 'Subaru',
        model: 'WRX', // Model is WRX for VA generation
        trim: 'STI Limited (US)',
        engineCode: 'EJ257',
        updatedAt: DateTime.now(),
      );

      final results = await db.specsDao.getSpecsForVehicle(vehicle);
      expect(results, isNotEmpty, reason: 'Should find spec for 2018 WRX STI');
      expect(results.first.title, contains('STI 2015-2021'));
    });

    testWidgets('Asset bundle includes critical seed files', (tester) async {
      await expectLater(
        rootBundle.loadString('assets/seed/specs/oil.json'),
        completion(isNotEmpty),
      );
      await expectLater(
        rootBundle.loadString('assets/seed/specs/torque.json'),
        completion(isNotEmpty),
      );
    });
  });
}
