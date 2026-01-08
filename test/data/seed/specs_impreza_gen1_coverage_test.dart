import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 1 (1993-2001) Coverage Specs', () {
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

    test('Has Impreza Gen1 (EJ18) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej18_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej18_impreza_gen1',
      );
      expect(spec['body'], contains('4.2 Quarts'));
      expect(spec['tags'], contains('ej18'));
    });

    test('Has Impreza Gen1 (EJ22) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej22_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej22_impreza_gen1',
      );
      expect(spec['body'], contains('4.8 Quarts'));
      expect(spec['tags'], contains('ej22'));
    });

    test('Has Impreza Gen1 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_coolant_capacity_impreza_gen1',
      );
      expect(spec['body'], contains('6.5 Liters'));
    });

    test('Has Impreza Gen1 (4EAT) ATF Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_impreza_4eat_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_trans_capacity_impreza_4eat_gen1',
      );
      expect(spec['body'], contains('7.9 Quarts'));
    });
  });

  group('Impreza Gen 1 (1993-2001) Wheels & Hardware Coverage', () {
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

    test('Has Impreza Gen1 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_impreza_gen1',
      );
      expect(spec['body'], contains('5x100'));
      expect(spec['body'], contains('56.1mm'));
    });

    test('Has Impreza Gen1 Lug Nut Torque', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_torque_impreza_gen1');
      expect(spec['body'], contains('58-72 ft-lb'));
    });

    test('Has Impreza Gen1 Front Brake Rotors (260mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_impreza_gen1',
      );
      expect(spec['body'], contains('260mm'));
    });

    test('Has Impreza Gen1 Spark Plug Gap', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_impreza_gen1');
      expect(spec['body'], contains('0.039'));
    });
  });

  group('Impreza Gen 1 (1993-2001) Maintenance & Electrical Coverage', () {
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

    test('Has Impreza Gen1 Oil Filter (15208AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_impreza_gen1');
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Impreza Gen1 Air Filter (16546AA150)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_air_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_air_impreza_gen1');
      expect(spec['body'], contains('16546AA150'));
    });

    test('Has Impreza Gen1 Timing Belt (60k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_impreza_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_maint_timing_belt_impreza_gen1',
      );
      expect(spec['body'], contains('60,000 Miles'));
      expect(spec['body'], contains('Interference'));
    });

    test('Has Impreza Gen1 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_impreza_gen1');
      expect(spec['body'], contains('Group 35'));
    });

    test('Has Impreza Gen1 Alternator (80A)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_alternator_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_alternator_impreza_gen1');
      expect(spec['body'], contains('80 Amps'));
    });
  });

  group('Impreza Gen 1 (1993-2001) Lighting & Fuel Coverage', () {
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

    test('Has Impreza Gen1 Fuel Tank (13.2 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_impreza_gen1');
      expect(spec['body'], contains('13.2 Gallons'));
    });

    test('Has Impreza Gen1 Stock Tire Size (13")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_impreza_gen1_fwd',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_impreza_gen1_fwd');
      expect(spec['body'], contains('165/80R13'));
    });

    test('Has Impreza Gen1 Headlight Bulb (H4)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_headlight_impreza_gen1');
      expect(spec['body'], contains('H4'));
    });

    test('Has Impreza Gen1 Tail Light Bulb (1157)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_tail_impreza_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_tail_impreza_gen1');
      expect(spec['body'], contains('1157'));
    });
  });
}
