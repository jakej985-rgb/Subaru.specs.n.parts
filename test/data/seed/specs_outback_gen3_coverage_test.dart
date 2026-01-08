import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 3 (2005-2009) Coverage Specs', () {
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

    test('Has Outback Gen3 Oil Capacities (NA & XT)', () {
      final naSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_outback_gen3_na',
      );
      final xtSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_outback_gen3_xt',
      );
      expect(naSpec['body'], contains('4.2 Quarts'));
      expect(xtSpec['body'], contains('4.5 Quarts'));
    });

    test('Has Outback Gen3 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_outback_gen3_na',
      );
      expect(spec['body'], contains('7.2 Quarts'));
    });

    test('Has Outback Gen3 Transmission Capacities (5MT & 4EAT)', () {
      final mtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_outback_gen3_5mt',
      );
      final atSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_outback_gen3_4eat',
      );
      expect(mtSpec['body'], contains('3.7 Quarts'));
      expect(atSpec['body'], contains('9.8 Quarts'));
    });

    test('Has Outback Gen3 Spark Plugs (XT)', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_outback_gen3_xt',
      );
      expect(spec['body'], contains('ILFR6B'));
    });
  });

  group('Outback Gen 3 (2005-2009) Wheels & Brakes Coverage', () {
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

    test('Has Outback Gen3 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_outback_gen3',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Outback Gen3 Brakes (Front & Rear)', () {
      final frontSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_outback_gen3',
      );
      final rearSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_outback_gen3',
      );
      expect(frontSpec['body'], contains('294mm'));
      expect(rearSpec['body'], contains('274mm'));
    });

    test('Has Outback Gen3 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_outback_gen3',
      );
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Outback Gen 3 (2005-2009) Maintenance & Misc Coverage', () {
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

    test('Has Outback Gen3 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_outback_gen3',
      );
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Outback Gen3 Cabin Filter (AG00A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_outback_gen3',
      );
      expect(spec['body'], contains('72880AG00A'));
    });

    test('Has Outback Gen3 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_outback_gen3',
      );
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Outback Gen3 Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_outback_gen3',
      );
      expect(spec['body'], contains('16.9 Gallons'));
    });

    test('Has Outback Gen3 XT Tires (17\")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_outback_gen3_xt',
      );
      expect(spec['body'], contains('225/55R17'));
    });

    test('Has Outback Gen3 Headlight (H7)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_outback_gen3',
      );
      expect(spec['body'], contains('H7'));
    });

    test('Has Outback Gen3 Fog Light (9006)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_fog_outback_gen3',
      );
      expect(spec['body'], contains('9006'));
    });
  });
}
