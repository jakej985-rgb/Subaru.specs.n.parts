import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  late AppDatabase db;
  late List<Spec> allSpecs;
  late List<Vehicle> allVehicles;

  setUpAll(() async {
    // 1. Load Seed Data
    final vehiclesJson = await File(
      p.join('assets', 'seed', 'vehicles.json'),
    ).readAsString();
    final oilJson = await File(
      p.join('assets', 'seed', 'specs', 'oil.json'),
    ).readAsString();
    final transJson = await File(
      p.join('assets', 'seed', 'specs', 'transmission.json'),
    ).readAsString();
    final diffJson = await File(
      p.join('assets', 'seed', 'specs', 'differential.json'),
    ).readAsString();
    final coolantJson = await File(
      p.join('assets', 'seed', 'specs', 'coolant.json'),
    ).readAsString();

    // 2. Parse Data
    allVehicles = parseVehicles(vehiclesJson);
    final oilSpecs = parseSpecs(oilJson);
    final transSpecs = parseSpecs(transJson);
    final diffSpecs = parseSpecs(diffJson);
    final coolantSpecs = parseSpecs(coolantJson);

    allSpecs = [...oilSpecs, ...transSpecs, ...diffSpecs, ...coolantSpecs];

    // 3. Setup In-Memory DB for testing filtering logic (if needed, but here we just check raw match)
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() async {
    await db.close();
  });

  test('2022 BRZ Limited should match new Fluid specs', () {
    // Target Vehicle
    final brz2022 = allVehicles.firstWhere(
      (v) => v.id == 'v_brz_2022_limited_us',
    );
    expect(brz2022, isNotNull);

    // Helper to find spec matching the vehicle
    List<Spec> findSpecsForVehicle(Vehicle v, String category) {
      return allSpecs.where((s) {
        if (s.category != category) return false;
        final tags = s.tags
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .toList();

        // Basic matching logic mimicking SpecsDao roughly for this test
        // In real app, it's SQL based. Here we check if tags match key vehicle attributes.

        bool matchesModel = tags.contains('brz');
        bool matchesYear = tags.contains(v.year.toString());
        bool matchesEngine = tags.contains('fa24'); // BRZ 2022 is FA24

        // Return true if it matches model AND (year OR engine)
        // This is a simplified check to verify the DATA exists and is tagged correctly.
        return matchesModel && (matchesYear || matchesEngine);
      }).toList();
    }

    // 1. Check Oil Specs
    final oilSpecs = findSpecsForVehicle(brz2022, 'Oil');
    final oilCapacity = oilSpecs.firstWhere(
      (s) => s.title.contains('Capacity') && s.tags.contains('fa24'),
      orElse: () => throw Exception('Oil Capacity missing'),
    );
    final oilViscosity = oilSpecs.firstWhere(
      (s) => s.title.contains('Viscosity') && s.tags.contains('fa24'),
      orElse: () => throw Exception('Oil Viscosity missing'),
    );

    expect(oilCapacity.body, contains('5.0 Liters'));
    expect(oilViscosity.body, contains('0W-20'));

    // 2. Check Transmission Specs (MT and AT both exist, verifying existence)
    final transSpecs = findSpecsForVehicle(brz2022, 'Transmission');
    final mtTrans = transSpecs.firstWhere(
      (s) =>
          s.title.contains('Manual Trans Fluid Capacity') &&
          s.tags.contains('fa24'),
      orElse: () => throw Exception('MT Fluid missing'),
    );
    expect(mtTrans.body, contains('2.2 Liters'));
    expect(mtTrans.body, contains('GL-4'));

    // 3. Check Diff Specs
    final diffSpecs = findSpecsForVehicle(brz2022, 'Differential');
    final diffCap = diffSpecs.firstWhere(
      (s) =>
          s.title.contains('Rear Differential Capacity') &&
          s.tags.contains('fa24'),
      orElse: () => throw Exception('Diff Capacity missing'),
    );
    expect(diffCap.body, contains('1.15 Liters'));
    expect(diffCap.body, contains('75W-85')); // New spec

    // 4. Check Coolant Specs
    final coolantSpecs = findSpecsForVehicle(brz2022, 'Coolant');
    final mtCoolant = coolantSpecs.firstWhere(
      (s) =>
          s.title.contains('Coolant Capacity (MT') && s.tags.contains('fa24'),
      orElse: () => throw Exception('MT Coolant missing'),
    );
    expect(mtCoolant.body, contains('7.4 Liters'));
  });
}
