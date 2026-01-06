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

  group('SpecsDao Applicability', () {
    test('getSpecsForVehicle filters by trim tags correctly', () async {
      // 1. Seed Data (Simulating updated seed)
      final specs = [
        Spec(
          id: 's_tire_size_wrx_vb_base',
          category: 'Tires',
          title: 'WRX 2022 Base Tire Size',
          body: '235/45R17',
          tags: 'tires,wrx,2022,base',
          updatedAt: DateTime.now(),
        ),
        Spec(
          id: 's_tire_size_wrx_vb_limited',
          category: 'Tires',
          title: 'WRX 2022 Limited Tire Size',
          body: '245/40R18',
          tags: 'tires,wrx,2022,limited',
          updatedAt: DateTime.now(),
        ),
        Spec(
          id: 's_generic_oil',
          category: 'Oil',
          title: 'Generic Oil',
          body: '5W-30',
          tags: 'oil,wrx,2022', // Applicable to all WRX 2022
          updatedAt: DateTime.now(),
        ),
      ];
      await db.specsDao.insertMultiple(specs);

      // 2. Define Vehicles
      final vehicleBase = Vehicle(
        id: 'v_wrx_base',
        year: 2022,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Base',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );

      final vehicleLimited = Vehicle(
        id: 'v_wrx_limited',
        year: 2022,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Limited',
        engineCode: 'FA24',
        updatedAt: DateTime.now(),
      );

      // 3. Test Base Vehicle
      final specsBase = await db.specsDao.getSpecsForVehicle(vehicleBase);

      // Should contain generic and base tire, but NOT limited tire
      expect(specsBase.any((s) => s.id == 's_generic_oil'), isTrue);
      expect(specsBase.any((s) => s.id == 's_tire_size_wrx_vb_base'), isTrue);
      expect(
        specsBase.any((s) => s.id == 's_tire_size_wrx_vb_limited'),
        isFalse,
      );

      // 4. Test Limited Vehicle
      final specsLimited = await db.specsDao.getSpecsForVehicle(vehicleLimited);

      // Should contain generic and limited tire, but NOT base tire
      expect(specsLimited.any((s) => s.id == 's_generic_oil'), isTrue);
      expect(
        specsLimited.any((s) => s.id == 's_tire_size_wrx_vb_limited'),
        isTrue,
      );
      expect(
        specsLimited.any((s) => s.id == 's_tire_size_wrx_vb_base'),
        isFalse,
      );
    });
  });
}
