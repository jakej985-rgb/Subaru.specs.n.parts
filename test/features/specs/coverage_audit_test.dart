import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';

void main() {
  late AppDatabase db;
  late SpecsDao specsDao;
  late VehiclesDao vehiclesDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    specsDao = SpecsDao(db);
    vehiclesDao = VehiclesDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Coverage Audit: Verify fixed specs for 2022 WRX', () async {
    // 1. Seed specs (Simulating the FIX)
    await specsDao.insertMultiple([
      Spec(
        id: 's_oil_capacity_wrx_vb',
        category: 'Oil',
        title: 'WRX 2022+ Oil Capacity',
        body: '4.8 Liters (5.1 Quarts) with filter change.',
        tags: 'oil,capacity,fa24,wrx,vb,2022,2023,2024', // FIXED: Added years
        updatedAt: DateTime.now(),
      ),
      Spec(
        id: 's_wheel_bolt_pattern_wrx_vb',
        category: 'Wheels',
        title: 'Bolt Pattern (WRX 2022+)',
        body: '5x114.3',
        tags: 'wheels,bolt_pattern,wrx,vb,2022,2023,2024',
        updatedAt: DateTime.now(),
      ),
      Spec(
        id: 's_torque_lug_nut_modern',
        category: 'Torque',
        title: 'Lug Nut Torque (Modern 5-Lug)',
        body: '89 ft-lbs',
        tags: 'torque,wheels,lugs,wrx,sti', // Still missing year, should fail/be missing
        updatedAt: DateTime.now(),
      ),
    ]);

    // 2. Define 2022 WRX Vehicle
    final vehicle = Vehicle(
      id: 'v_wrx_2022_base_us',
      year: 2022,
      make: 'Subaru',
      model: 'WRX',
      trim: 'Base (US)',
      engineCode: 'FA24 Turbo',
      updatedAt: DateTime.now(),
    );

    // 3. Fetch specs
    final results = await specsDao.getSpecsForVehicle(vehicle);

    // 4. Analyze results
    final ids = results.map((s) => s.id).toList();

    print('Fetched Specs: $ids');

    // Expectations
    expect(ids, contains('s_wheel_bolt_pattern_wrx_vb'), reason: 'Already present');
    expect(ids, contains('s_oil_capacity_wrx_vb'), reason: 'Should now be present due to tag fix');
    expect(ids, isNot(contains('s_torque_lug_nut_modern')), reason: 'Still missing (scope limited to one fix)');
  });
}
