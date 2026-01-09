import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 1 (1998-2002) Coverage Specs', () {
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

    test('Has Forester Gen1 (EJ25D) Oil Capacity (1998)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej25d_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej25d_forester_gen1',
      );
      expect(spec['body'], contains('4.8 Quarts'));
      expect(spec['tags'], contains('1998'));
    });

    test('Has Forester Gen1 (EJ251) Oil Capacity (1999-2002)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej251_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej251_forester_gen1',
      );
      expect(spec['body'], contains('4.2 Quarts'));
      expect(spec['tags'], contains('2002'));
    });

    test('Has Forester Gen1 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_coolant_capacity_forester_gen1',
      );
      expect(spec['body'], contains('6.4 Liters'));
    });

    test('Has Forester Gen1 (4EAT) ATF Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_forester_4eat_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_trans_capacity_forester_4eat_gen1',
      );
      expect(spec['body'], contains('9.8 Quarts'));
    });
  });

  group('Forester Gen 1 (1998-2002) Wheels & Brakes Coverage', () {
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

    test('Has Forester Gen1 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_forester_gen1',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Forester Gen1 Front Rotors (277mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_forester_gen1',
      );
      expect(spec['body'], contains('277mm'));
    });

    test('Has Forester Gen1 Spark Plugs (0.044")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_forester_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_forester_gen1');
      expect(spec['body'], contains('0.044'));
    });
  });

  group('Forester Gen 1 (1998-2002) Maintenance & Electrical Coverage', () {
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

    test('Has Forester Gen1 Oil Filter (15208AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_forester_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_forester_gen1');
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Forester Gen1 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_forester_gen1',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_maint_timing_belt_forester_gen1',
      );
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Forester Gen1 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_forester_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_forester_gen1');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Forester Gen 1 (1998-2002) Lighting & Fuel Coverage', () {
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

    test('Has Forester Gen1 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_forester_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_forester_gen1');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Forester Gen1 Stock Tire (15")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_forester_gen1_15',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_forester_gen1_15');
      expect(spec['body'], contains('205/70R15'));
    });

    test('Has Forester Gen1 Headlight Bulb (H4)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_forester_gen1',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_headlight_forester_gen1');
      expect(spec['body'], contains('H4'));
    });
  });
}
