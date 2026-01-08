import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 3 (2009-2013) Coverage Specs', () {
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

    test('Has Forester Gen3 Oil Capacities (EJ & FB)', () {
      final ejSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_forester_gen3_na_ej',
      );
      final fbSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_forester_gen3_na_fb',
      );
      expect(ejSpec['body'], contains('4.4 Quarts'));
      expect(fbSpec['body'], contains('5.5 Quarts'));
    });

    test('Has Forester Gen3 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_forester_gen3_ej',
      );
      expect(spec['body'], contains('8.0 Quarts'));
    });

    test('Has Forester Gen3 Transmission Capacities (5MT & 4EAT)', () {
      final mtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_forester_gen3_5mt',
      );
      final atSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_forester_gen3_4eat',
      );
      expect(mtSpec['body'], contains('3.7 Quarts'));
      expect(atSpec['body'], contains('9.8 Quarts'));
    });

    test('Has Forester Gen3 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_forester_gen3_na_fb',
      );
      expect(spec['body'], contains('SILZKAR7B11'));
    });
  });

  group('Forester Gen 3 (2009-2013) Wheels & Brakes Coverage', () {
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

    test('Has Forester Gen3 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_forester_gen3',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Forester Gen3 Brakes (Front & Rear)', () {
      final frontSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_forester_gen3',
      );
      final rearSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_forester_gen3',
      );
      expect(frontSpec['body'], contains('294mm'));
      expect(rearSpec['body'], contains('286mm'));
    });

    test('Has Forester Gen3 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_forester_gen3',
      );
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Forester Gen 3 (2009-2013) Maintenance & Misc Coverage', () {
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

    test('Has Forester Gen3 Oil Filter (AA160 for FB)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_forester_gen3',
      );
      expect(spec['body'], contains('15208AA160'));
    });

    test('Has Forester Gen3 Cabin Filter (FG000)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_forester_gen3',
      );
      expect(spec['body'], contains('72880FG000'));
    });

    test('Has Forester Gen3 Timing Belt/Chain Note', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_forester_gen3',
      );
      expect(spec['body'], contains('Timing Chain'));
    });

    test('Has Forester Gen3 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_forester_gen3',
      );
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Forester Gen3 Tires (17\")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_forester_gen3_17',
      );
      expect(spec['body'], contains('225/55R17'));
    });

    test('Has Forester Gen3 Headlight (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_forester_gen3',
      );
      expect(spec['body'], contains('H11'));
    });

    test('Has Forester Gen3 Fog Light (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_fog_forester_gen3',
      );
      expect(spec['body'], contains('H11'));
    });
  });
}
