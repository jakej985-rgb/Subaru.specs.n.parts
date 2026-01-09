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

      final oilFile = File(p.join(seedDir, 'oil.json'));
      oilSpecs = json.decode(oilFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());

      final transFile = File(p.join(seedDir, 'transmission.json'));
      transSpecs = json.decode(transFile.readAsStringSync());
    });

    test('Has Legacy Gen1 (EJ22) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej22_legacy_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej22_legacy_gen1',
      );
      expect(spec['body'], contains('4.5 Liters'));
      expect(spec['tags'], contains('1990'));
      expect(spec['tags'], contains('ej22'));
    });

    test('Has Legacy Gen1 (EJ22) Oil Viscosity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_viscosity_ej22_legacy_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_viscosity_ej22_legacy_gen1',
      );
      expect(spec['body'], contains('10W-30'));
    });

    test('Has Legacy Gen1 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_legacy_ej22_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_coolant_capacity_legacy_ej22_gen1',
      );
      expect(spec['body'], contains('6.5 Liters'));
    });

    test('Has Legacy Gen1 Coolant Type', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_type_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_type_legacy_gen1');
      expect(spec['body'], contains('Regular Green'));
    });

    test('Has Legacy Gen1 (4EAT) ATF Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_legacy_4eat_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_trans_capacity_legacy_4eat_gen1',
      );
      expect(spec['body'], contains('9.1 Quarts'));
      expect(spec['tags'], contains('4eat'));
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

    test('Has Legacy Gen1 Timing Belt Interval (60k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_legacy_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_maint_timing_belt_legacy_gen1',
      );
      expect(spec['body'], contains('60,000 Miles'));
      expect(spec['body'], contains('Interference'));
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
    late List<dynamic> maintSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = json.decode(bulbFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = json.decode(maintFile.readAsStringSync());
    });

    test('Has Legacy Gen1 Headlight Bulb (9004)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_headlight_legacy_gen1');
      expect(spec['body'], contains('9004'));
    });

    test('Has Legacy Gen1 Oil Drain Plug (M20)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_oil_drain_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_maint_oil_drain_legacy_gen1');
      expect(spec['body'], contains('M20'));
    });

    test('Has Legacy Gen1 Thermostat (172F)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_thermostat_legacy_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_coolant_thermostat_legacy_gen1',
      );
      expect(spec['body'], contains('172°F'));
    });

    test('Has Legacy Gen1 Wiper Blades', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_wiper_legacy_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wiper_legacy_gen1');
      expect(spec['body'], contains('20"'));
      expect(spec['body'], contains('18"'));
    });
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
