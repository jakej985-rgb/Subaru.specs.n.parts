import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('WRX Gen 2 (2002-2005) Coverage Specs', () {
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

    test('Has WRX Gen2 (EJ205) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej205_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_oil_capacity_ej205_wrx_gen2');
      expect(spec['body'], contains('4.8 Quarts'));
      expect(spec['tags'], contains('ej205'));
    });

    test('Has WRX Gen2 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_capacity_wrx_gen2');
      expect(spec['body'], contains('7.7 Quarts'));
    });

    test('Has WRX Gen2 (4EAT) ATF Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_wrx_4eat_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_trans_capacity_wrx_4eat_gen2');
      expect(spec['body'], contains('10.0 Quarts'));
    });
  });

  group('WRX Gen 2 (2002-2005) Wheels & Brakes Coverage', () {
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

    test('Has WRX Gen2 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_bolt_pattern_wrx_gen2');
      expect(spec['body'], contains('5x100'));
    });

    test('Has WRX Gen2 Front Rotors (294mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_brake_front_rotor_wrx_gen2');
      expect(spec['body'], contains('294mm'));
    });

    test('Has WRX Gen2 Spark Plugs (0.028")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_wrx_gen2');
      expect(spec['body'], contains('0.028'));
    });
  });

  group('WRX Gen 2 (2002-2005) Maintenance & Electrical Coverage', () {
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

    test('Has WRX Gen2 Oil Filter (15208AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_wrx_gen2');
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has WRX Gen2 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_maint_timing_belt_wrx_gen2');
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has WRX Gen2 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_wrx_gen2');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('WRX Gen 2 (2002-2005) Lighting & Fuel Coverage', () {
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

    test('Has WRX Gen2 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_wrx_gen2');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has WRX Gen2 Stock Tire (16")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_wrx_gen2');
      expect(spec['body'], contains('205/55R16'));
    });

    test('Has WRX Gen2 Headlight (Bugeye 9007)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_wrx_gen2_bugeye',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_bulb_headlight_wrx_gen2_bugeye',
      );
      expect(spec['body'], contains('9007'));
    });

    test('Has WRX Gen2 Headlight (Blobeye H1/9005)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_wrx_gen2_blobeye',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_bulb_headlight_wrx_gen2_blobeye',
      );
      expect(spec['body'], contains('H1'));
    });
  });
}
