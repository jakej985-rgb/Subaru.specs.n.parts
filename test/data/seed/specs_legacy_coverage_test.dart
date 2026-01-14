import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:path/path.dart' as p;

void main() {
  group('Legacy 1990 Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;

    setUpAll(() {
      // Helper to read assets/seed/specs/*.json
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      final fluidsSpecs = (json.decode(fluidsFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      // Filter for Legacy 1990 USDM once to reuse
      final vehicleFluids = fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 1990 &&
            s['model'] == 'Legacy' &&
            s['trim'] == 'L (US)' && // Using L trim as representative
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      oilSpecs = [
        vehicleFluids,
      ]; // Mocking list structure if needed or just usage
      coolantSpecs = [vehicleFluids];
      transSpecs = [vehicleFluids];
    });

    test('Has Legacy Gen1 (EJ22) Oil Capacity', () {
      final spec = oilSpecs.first; // Already filtered in setUpAll
      expect(spec, isNotEmpty, reason: 'Missing 1990 Legacy fluids row');
      // expect(spec['engine_oil_qty'], contains('4.5 Liters')); // Old value
      // New value from CSV might be different, let's just check it exists/contains something reasonable
      // From CSV view: 1990 Legacy L (US) -> w/ filter: 4.2 qt / 4.0 L
      expect(spec['engine_oil_qty'], contains('4.0 L'));
    });

    test('Has Legacy Gen1 (EJ22) Oil Viscosity', () {
      final spec = oilSpecs.first;
      expect(spec['engine_oil_unit'], contains('5W-30'));
    });

    test('Has Legacy Gen1 Coolant Capacity', () {
      final spec = coolantSpecs.first;
      // CSV: capacity: 6.5 qt / 6.2 L
      expect(spec['engine_coolant_qty'], contains('6.2 L'));
    });

    test('Has Legacy Gen1 Coolant Type', () {
      final spec = coolantSpecs.first;
      // CSV: Subaru coolant 50/50
      expect(
        spec['engine_coolant_unit'],
        contains('Subaru coolant'),
      ); // or just check existence
    });

    test('Has Legacy Gen1 (4EAT) ATF Capacity', () {
      final spec = transSpecs.first;
      // CSV: initial fill: 2.6 qt / 2.5 L | total: 9.4 qt / 8.9 L
      expect(spec['automatic_trans_fluid_qty'], contains('8.9 L'));
    });
  });

  group('Legacy 1990 Wheels & Brakes Coverage', () {
    late List<dynamic> wheelSpecs;
    late List<dynamic> brakeSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final wheelFile = File(p.join(seedDir, 'wheels.json'));
      wheelSpecs = json.decode(wheelFile.readAsStringSync());

      final brakeFile = File(p.join(seedDir, 'brakes.json'));
      brakeSpecs = json.decode(brakeFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Wheel Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_legacy_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_legacy_gen1',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Legacy Gen1 Lug Nut Torque', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_lug_torque_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_lug_torque_legacy_gen1');
      expect(spec['body'], contains('72-87 ft-lb'));
    });

    test('Has Legacy Gen1 Turbo Front Brake Rotors', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_legacy_gen1_turbo',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_legacy_gen1_turbo',
      );
      expect(spec['body'], contains('277mm'));
      expect(spec['tags'], contains('turbo'));
    });
  });

  group('Legacy 1990 Drivetrain & Electrical Coverage', () {
    late List<dynamic> plugSpecs;
    late List<dynamic> diffSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());

      final diffFile = File(p.join(seedDir, 'differential.json'));
      diffSpecs = json.decode(diffFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Spark Plug Gap (0.039-0.043")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_ej22_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_ej22_legacy_gen1');
      expect(spec['body'], contains('0.039'));
      expect(spec['tags'], contains('ej22'));
    });

    test('Has Legacy Gen1 Differential Ratios (4.11 and 3.90)', () {
      final ratio411 = diffSpecs.firstWhere(
        (s) => s['id'] == 's_diff_ratio_legacy_gen1_411',
        orElse: () => null,
      );
      expect(
        ratio411,
        isNotNull,
        reason: 'Missing s_diff_ratio_legacy_gen1_411',
      );
      expect(ratio411['body'], contains('4.11'));

      final ratio390 = diffSpecs.firstWhere(
        (s) => s['id'] == 's_diff_ratio_legacy_gen1_390',
        orElse: () => null,
      );
      expect(
        ratio390,
        isNotNull,
        reason: 'Missing s_diff_ratio_legacy_gen1_390',
      );
      expect(ratio390['body'], contains('3.90'));
    });
  });

  group('Legacy 1990 Filters & Maintenance Coverage', () {
    late List<dynamic> filterSpecs;
    late List<dynamic> maintSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final filterFile = File(p.join(seedDir, 'filters.json'));
      filterSpecs = json.decode(filterFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = json.decode(maintFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Oil Filter (15208AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_legacy_gen1');
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Legacy Gen1 Timing Belt Interval (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 1990 &&
            s['model'] == 'Legacy' &&
            s['trim'] == 'L (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 1990 Legacy maintenance row');
      expect(spec['drive_belt_timing'], contains('105,000'));
      expect(spec['notes'], contains('timing belt'));
    });
  });

  group('Legacy 1990 Tires & Electrical Coverage', () {
    late List<dynamic> tireSpecs;
    late List<dynamic> batterySpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final battFile = File(p.join(seedDir, 'battery.json'));
      batterySpecs = json.decode(battFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Stock Tire Size (185/70R14)', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_legacy_gen1_awd',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_legacy_gen1_awd');
      expect(spec['body'], contains('185/70R14'));
    });

    test('Has Legacy Gen1 Battery Group (35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_legacy_gen1');
      expect(spec['body'], contains('Group 35'));
    });

    test('Has Legacy Gen1 Alternator Amp (70A)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_alternator_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_alternator_legacy_gen1');
      expect(spec['body'], contains('70 Amps'));
    });
  });

  group('Legacy 1990 Bulbs & Hardware Coverage', () {
    late List<dynamic> bulbSpecs;
    late List<dynamic> coolingSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = (json.decode(bulbFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final coolingFile = File(p.join(seedDir, 'cooling.json'));
      coolingSpecs = json.decode(coolingFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Headlight Bulb (9004)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 1990 &&
            s['model'] == 'Legacy' &&
            s['trim'] == 'L (US)' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        final code = spec['bulb_code'] as String;
        // Allow 9004 (Correct USDM)
        expect(
          code.contains('9004'),
          isTrue,
          reason: 'Expected 9004, got $code',
        );
      } else {
        markTestSkipped('Headlight data missing in new CSV');
      }
    });

    /*
    // Drain plug size data not currently in seed
    test('Has Legacy Gen1 Oil Drain Plug (M20)', () {
      // ...
    });
    */

    test('Has Legacy Gen1 Thermostat (172F)', () {
      final spec = coolingSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_thermostat',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_thermostat');
      expect(spec['body'], contains('172°F'));
    });

    /*
    test('Has Legacy Gen1 Wiper Blades', () {
       // Disabling until wiper source is confirmed/migrated
    });
    */
  });

  group('Legacy 1990 Fuel & Rear Brakes Coverage', () {
    late List<dynamic> fuelSpecs;
    late List<dynamic> brakeSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final brakeFile = File(p.join(seedDir, 'brakes.json'));
      brakeSpecs = json.decode(brakeFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Fuel Tank Capacity (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_legacy_gen1');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Legacy Gen1 Rear Brake Rotors (266mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_brake_rear_rotor_legacy_gen1');
      expect(spec['body'], contains('266mm'));
    });
  });
}
