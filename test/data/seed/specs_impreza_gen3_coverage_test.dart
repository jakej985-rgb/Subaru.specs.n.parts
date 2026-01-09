import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 3 (2008-2011) Coverage Specs', () {
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

    test('Has Impreza Gen3 Oil Capacities (NA, WRX, STI)', () {
      final naSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_imp_gen3_na',
      );
      final wrxSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_imp_gen3_wrx',
      );
      final stiSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_imp_gen3_sti',
      );
      expect(naSpec['body'], contains('4.4 Quarts'));
      expect(wrxSpec['body'], contains('4.4 Quarts'));
      expect(stiSpec['body'], contains('4.5 Quarts'));
    });

    test('Has Impreza Gen3 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_imp_gen3',
      );
      expect(spec['body'], contains('7.2 - 7.5 Quarts'));
    });

    test('Has Impreza Gen3 Transmission Capacities (5MT & 6MT)', () {
      final mtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_imp_gen3_5mt',
      );
      final stiSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_imp_gen3_6mt',
      );
      expect(mtSpec['body'], contains('3.7 Quarts'));
      expect(stiSpec['body'], contains('4.3 Quarts'));
    });

    test('Has Impreza Gen3 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_imp_gen3_wrx',
      );
      expect(spec['body'], contains('SILFR6A'));
    });
  });

  group('Impreza Gen 3 (2008-2011) Wheels & Brakes Coverage', () {
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

    test('Has Impreza Gen3 Bolt Patterns (5x100 & 5x114.3)', () {
      final naSpec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_imp_gen3_100',
      );
      final stiSpec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_imp_gen3_114',
      );
      expect(naSpec['body'], contains('5x100'));
      expect(stiSpec['body'], contains('5x114.3'));
    });

    test('Has Impreza Gen3 Brakes (NA, WRX, STI)', () {
      final naSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_25i',
      );
      final wrxSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_wrx',
      );
      final stiSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_sti',
      );
      expect(naSpec['body'], contains('277mm'));
      expect(wrxSpec['body'], contains('294mm'));
      expect(stiSpec['body'], contains('326mm'));
    });

    test('Has Impreza Gen3 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere((s) => s['id'] == 's_battery_imp_gen3');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Impreza Gen 3 (2008-2011) Maintenance & Misc Coverage', () {
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

    test('Has Impreza Gen3 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_imp_gen3',
      );
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Impreza Gen3 Cabin Filter (FG000)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_imp_gen3',
      );
      expect(spec['body'], contains('72880FG000'));
    });

    test('Has Impreza Gen3 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_imp_gen3',
      );
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Impreza Gen3 Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_imp_gen3',
      );
      expect(spec['body'], contains('16.9 Gallons'));
    });

    test('Has Impreza Gen3 WRX Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_imp_gen3_17',
      );
      expect(spec['body'], contains('225/45R17'));
    });

    test('Has Impreza Gen3 Headlight (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_imp_gen3_low',
      );
      expect(spec['body'], contains('H11'));
    });

    test('Has Impreza Gen3 Fog Light (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_fog_imp_gen3',
      );
      expect(spec['body'], contains('H11'));
    });
  });
}
