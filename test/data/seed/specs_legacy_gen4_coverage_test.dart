import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Legacy Gen 4 (2005-2009) Coverage Specs', () {
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

    test('Has Legacy Gen4 Oil Capacities (NA, GT, H6)', () {
      final naSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_leg_gen4_na',
      );
      final gtSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_leg_gen4_gt',
      );
      final h6Spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_leg_gen4_30r',
      );
      expect(naSpec['body'], contains('4.2 Quarts'));
      expect(gtSpec['body'], contains('4.5 Quarts'));
      expect(h6Spec['body'], contains('6.0 Quarts'));
    });

    test('Has Legacy Gen4 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_leg_gen4_na',
      );
      expect(spec['body'], contains('7.2 Quarts'));
    });

    test('Has Legacy Gen4 Transmission Capacities (5MT, 6MT, 5AT)', () {
      final mtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_leg_gen4_5mt',
      );
      final stiSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_leg_gen4_6mt',
      );
      final atSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_leg_gen4_5at',
      );
      expect(mtSpec['body'], contains('3.7 Quarts'));
      expect(stiSpec['body'], contains('4.3 Quarts'));
      expect(atSpec['body'], contains('10.4 Quarts'));
    });

    test('Has Legacy Gen4 Spark Plugs (GT)', () {
      final spec = plugSpecs.firstWhere((s) => s['id'] == 's_plug_leg_gen4_gt');
      expect(spec['body'], contains('SILFR6A'));
    });
  });

  group('Legacy Gen 4 (2005-2009) Wheels & Brakes Coverage', () {
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

    test('Has Legacy Gen4 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_leg_gen4',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Legacy Gen4 Brakes (NA & GT)', () {
      final naSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_leg_gen4_25i',
      );
      final gtSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_leg_gen4_gt',
      );
      expect(naSpec['body'], contains('277mm'));
      expect(gtSpec['body'], contains('316mm'));
    });

    test('Has Legacy Gen4 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere((s) => s['id'] == 's_battery_leg_gen4');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Legacy Gen 4 (2005-2009) Maintenance & Misc Coverage', () {
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

    test('Has Legacy Gen4 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_leg_gen4',
      );
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Legacy Gen4 Cabin Filter (AG00A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_leg_gen4',
      );
      expect(spec['body'], contains('72880AG00A'));
    });

    test('Has Legacy Gen4 Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_leg_gen4',
      );
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Legacy Gen4 Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_leg_gen4',
      );
      expect(spec['body'], contains('16.9 Gallons'));
    });

    test('Has Legacy Gen4 GT Tires (17\")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_leg_gen4_17',
      );
      expect(spec['body'], contains('215/45R17'));
    });

    test('Has Legacy Gen4 Headlight (H7)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_leg_gen4_low',
      );
      expect(spec['body'], contains('H7'));
    });

    test('Has Legacy Gen4 Fog Light (9006)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_fog_leg_gen4',
      );
      expect(spec['body'], contains('9006'));
    });
  });
}
