import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 2 (2003-2008) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;
    late List<dynamic> plugSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final oilFile = File(p.join(seedDir, 'oil.json'));
      oilSpecs = json.decode(oilFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());

      final transFile = File(p.join(seedDir, 'transmission.json'));
      transSpecs = json.decode(transFile.readAsStringSync());

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());
    });

    test('Has Forester Gen2 (EJ25 NA) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej25_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_oil_capacity_ej25_for_gen2');
      expect(spec['body'], contains('4.2 Quarts'));
    });

    test('Has Forester Gen2 (XT) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej255_for_gen2_xt',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_oil_capacity_ej255_for_gen2_xt',
      );
      expect(spec['body'], contains('5.0 Quarts'));
    });

    test('Has Forester Gen2 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_ej25_for_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_coolant_capacity_ej25_for_gen2',
      );
      expect(spec['body'], contains('6.4 Quarts'));
    });

    test('Has Forester Gen2 (5MT) Fluid Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_for_gen2_5mt',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_trans_capacity_for_gen2_5mt');
      expect(spec['body'], contains('3.7 Quarts'));
    });

    test('Has Forester Gen2 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_for_gen2');
      expect(spec['body'], contains('0.043'));
    });
  });

  group('Forester Gen 2 (2003-2008) Wheels & Brakes Coverage', () {
    late List<dynamic> wheelSpecs;
    late List<dynamic> brakeSpecs;
    late List<dynamic> battSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final wheelFile = File(p.join(seedDir, 'wheels.json'));
      wheelSpecs = json.decode(wheelFile.readAsStringSync());

      final brakeFile = File(p.join(seedDir, 'brakes.json'));
      brakeSpecs = json.decode(brakeFile.readAsStringSync());

      final battFile = File(p.join(seedDir, 'battery.json'));
      battSpecs = json.decode(battFile.readAsStringSync());
    });

    test('Has Forester Gen2 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_bolt_pattern_for_gen2');
      expect(spec['body'], contains('5x100'));
    });

    test('Has Forester Gen2 XT Front Rotors (294mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_for_gen2_xt',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_brake_front_rotor_for_gen2_xt',
      );
      expect(spec['body'], contains('294mm'));
    });

    test('Has Forester Gen2 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_for_gen2');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Forester Gen 2 (2003-2008) Maintenance & Misc Coverage', () {
    late List<dynamic> filterSpecs;
    late List<dynamic> maintSpecs;
    late List<dynamic> fuelSpecs;
    late List<dynamic> tireSpecs;
    late List<dynamic> bulbSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final filterFile = File(p.join(seedDir, 'filters.json'));
      filterSpecs = json.decode(filterFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = json.decode(maintFile.readAsStringSync());

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = json.decode(bulbFile.readAsStringSync());
    });

    test('Has Forester Gen2 Oil Filter (AA100)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_for_gen2');
      expect(spec['body'], contains('15208AA100'));
    });

    test('Has Forester Gen2 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_maint_timing_belt_for_gen2');
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Forester Gen2 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_for_gen2');
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Forester Gen2 X/XS Tires (16")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_for_gen2_x',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_for_gen2_x');
      expect(spec['body'], contains('215/60R16'));
    });

    test('Has Forester Gen2 Headlight (H1)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_for_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_bulb_headlight_for_gen2');
      expect(spec['body'], contains('H1'));
    });
  });
}
