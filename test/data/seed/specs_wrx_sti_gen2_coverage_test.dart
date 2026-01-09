import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('STI Gen 2 (2004-2007) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;
    late List<dynamic> diffSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final oilFile = File(p.join(seedDir, 'oil.json'));
      oilSpecs = json.decode(oilFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());

      final transFile = File(p.join(seedDir, 'transmission.json'));
      transSpecs = json.decode(transFile.readAsStringSync());

      final diffFile = File(p.join(seedDir, 'differential.json'));
      diffSpecs = json.decode(diffFile.readAsStringSync());
    });

    test('Has STI Gen2 (EJ257) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej257_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_oil_capacity_ej257_sti_gen2');
      expect(spec['body'], contains('4.8 Quarts'));
    });

    test('Has STI Gen2 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_capacity_sti_gen2');
      expect(spec['body'], contains('8.1 Quarts'));
    });

    test('Has STI Gen2 (6MT) Fluid Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_sti_6mt_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_trans_capacity_sti_6mt_gen2');
      expect(spec['body'], contains('4.3 Quarts'));
    });

    test('Has STI Gen2 (R180) Rear Diff Fluid', () {
      final spec = diffSpecs.firstWhere(
        (s) => s['id'] == 's_diff_capacity_sti_r180_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_diff_capacity_sti_r180_gen2');
      expect(spec['body'], contains('1.1 Quarts'));
    });
  });

  group('STI Gen 2 (2004-2007) Wheels & Brakes Coverage', () {
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

    test('Has STI Gen2 Bolt Pattern (2004 5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_sti_2004_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_sti_2004_gen2',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has STI Gen2 Bolt Pattern (2005+ 5x114.3)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_sti_2005_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_sti_2005_gen2',
      );
      expect(spec['body'], contains('5x114.3'));
    });

    test('Has STI Gen2 Front Rotors (326mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_brake_front_rotor_sti_gen2');
      expect(spec['body'], contains('326mm'));
    });

    test('Has STI Gen2 Rear Rotors (2004 316mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_sti_2004',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_brake_rear_rotor_sti_2004');
      expect(spec['body'], contains('316mm'));
      expect(spec['body'], contains('5x100'));
    });

    test('Has STI Gen2 Rear Rotors (2005+ 316mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_sti_2005_plus',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_rear_rotor_sti_2005_plus',
      );
      expect(spec['body'], contains('316mm'));
      expect(spec['body'], contains('5x114.3'));
    });

    test('Has STI Gen2 Spark Plugs (0.028")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_sti_gen2');
      expect(spec['body'], contains('0.028'));
    });
  });

  group('STI Gen 2 (2004-2007) Maintenance & Electrical Coverage', () {
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

    test('Has STI Gen2 Oil Filter (AA100/AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_sti_gen2');
      expect(spec['body'], contains('15208AA100'));
    });

    test('Has STI Gen2 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_maint_timing_belt_sti_gen2');
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has STI Gen2 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_sti_gen2');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('STI Gen 2 (2004-2007) Lighting & Fuel Coverage', () {
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

    test('Has STI Gen2 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_sti_gen2');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has STI Gen2 Stock Tire (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_sti_gen2');
      expect(spec['body'], contains('225/45R17'));
    });

    test('Has STI Gen2 Headlight (D2R 04-05)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_sti_gen2_04_05',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_bulb_headlight_sti_gen2_04_05',
      );
      expect(spec['body'], contains('D2R'));
    });

    test('Has STI Gen2 Headlight (D2S 06-07)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_sti_gen2_06_07',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_bulb_headlight_sti_gen2_06_07',
      );
      expect(spec['body'], contains('D2S'));
    });
  });
}
