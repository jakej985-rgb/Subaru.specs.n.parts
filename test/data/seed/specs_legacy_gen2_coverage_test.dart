import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Legacy Gen 2 (1995-1999) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final oilFile = File(p.join(seedDir, 'oil.json'));
      oilSpecs = json.decode(oilFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());

      final transFile = File(p.join(seedDir, 'transmission.json'));
      transSpecs = json.decode(transFile.readAsStringSync());
    });

    test('Has Legacy Gen2 (EJ22) Oil Capacity (1995-1999)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej22_legacy_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej22_legacy_gen2',
      );
      expect(spec['body'], contains('4.2 Quarts'));
      expect(spec['tags'], contains('ej22'));
    });

    test('Has Legacy Gen2 (EJ25D) Oil Capacity (1996-1999)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej25d_legacy_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej25d_legacy_gen2',
      );
      expect(spec['body'], contains('4.8 Quarts'));
      expect(spec['tags'], contains('ej25d'));
    });

    test('Has Legacy Gen2 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_capacity_legacy_gen2');
      expect(spec['body'], contains('6.0 Liters'));
    });

    test('Has Legacy Gen2 (4EAT) ATF Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_legacy_4eat_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_trans_capacity_legacy_4eat_gen2',
      );
      expect(spec['body'], contains('10.0 Quarts'));
    });
  });

  group('Legacy Gen 2 (1995-1999) Wheels & Brakes Coverage', () {
    late List<dynamic> wheelSpecs;
    late List<dynamic> brakeSpecs;
    late List<dynamic> plugSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final wheelFile = File(p.join(seedDir, 'wheels.json'));
      wheelSpecs = json.decode(wheelFile.readAsStringSync());

      final brakeFile = File(p.join(seedDir, 'brakes.json'));
      brakeSpecs = json.decode(brakeFile.readAsStringSync());

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());
    });

    test('Has Legacy Gen2 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_legacy_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_legacy_gen2',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Legacy Gen2 Front Rotors (260mm NA)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_legacy_gen2_260',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_legacy_gen2_260',
      );
      expect(spec['body'], contains('260mm'));
    });

    test('Has Legacy Gen2 Front Rotors (277mm GT)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_legacy_gen2_277',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_legacy_gen2_277',
      );
      expect(spec['body'], contains('277mm'));
    });

    test('Has Legacy Gen2 Spark Plugs (0.039")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_legacy_gen2');
      expect(spec['body'], contains('0.039'));
    });
  });

  group('Legacy Gen 2 (1995-1999) Maintenance & Electrical Coverage', () {
    late List<dynamic> filterSpecs;
    late List<dynamic> maintSpecs;
    late List<dynamic> batterySpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final filterFile = File(p.join(seedDir, 'filters.json'));
      filterSpecs = json.decode(filterFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = json.decode(maintFile.readAsStringSync());

      final battFile = File(p.join(seedDir, 'battery.json'));
      batterySpecs = json.decode(battFile.readAsStringSync());
    });

    test('Has Legacy Gen2 Oil Filter (15208AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_legacy_gen2');
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Legacy Gen2 Timing Belt (60k/105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_legacy_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_maint_timing_belt_legacy_gen2',
      );
      expect(spec['body'], contains('60,000 Miles'));
    });

    test('Has Legacy Gen2 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_legacy_gen2');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Legacy Gen 2 (1995-1999) Lighting & Fuel Coverage', () {
    late List<dynamic> fuelSpecs;
    late List<dynamic> tireSpecs;
    late List<dynamic> bulbSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = json.decode(bulbFile.readAsStringSync());
    });

    test('Has Legacy Gen2 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_legacy_gen2');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Legacy Gen2 Stock Tire (14")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_legacy_gen2_14',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_legacy_gen2_14');
      expect(spec['body'], contains('185/70R14'));
    });

    test('Has Legacy Gen2 Headlight Bulb (9003/H4)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_legacy_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_headlight_legacy_gen2');
      expect(spec['body'], contains('9003'));
    });
  });
}
