import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 4 (2010-2014) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;
    late List<dynamic> diffSpecs;
    late List<dynamic> plugSpecs;

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

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());
    });

    test('Has Outback Gen4 Oil Capacities (NA & 3.6R)', () {
      final naSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_outback_gen4_na',
      );
      final rSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_outback_gen4_36r',
      );
      expect(naSpec['body'], contains('4.2 Quarts'));
      expect(rSpec['body'], contains('6.9 Quarts'));
    });

    test('Has Outback Gen4 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_outback_gen4_na',
      );
      expect(spec['body'], contains('8.2 Quarts'));
    });

    test('Has Outback Gen4 Transmission Capacities (CVT & 5AT)', () {
      final cvtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_outback_gen4_cvt',
      );
      final atSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_outback_gen4_5at',
      );
      expect(cvtSpec['body'], contains('12.8'));
      expect(atSpec['body'], contains('10.4 Quarts'));
    });

    test('Has Outback Gen4 Differential Capacities', () {
      final frontSpec = diffSpecs.firstWhere(
        (s) => s['id'] == 's_diff_capacity_outback_gen4_front',
      );
      final rearSpec = diffSpecs.firstWhere(
        (s) => s['id'] == 's_diff_capacity_outback_gen4_rear',
      );
      expect(frontSpec['body'], contains('1.4 - 1.5 Quarts'));
      expect(rearSpec['body'], contains('0.8 Quarts'));
    });

    test('Has Outback Gen4 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_outback_gen4_25i',
      );
      expect(spec['body'], contains('SILZKAR7B11'));
    });
  });

  group('Outback Gen 4 (2010-2014) Wheels & Brakes Coverage', () {
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

    test('Has Outback Gen4 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_outback_gen4',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Outback Gen4 Brakes (2.5i & 3.6R)', () {
      final naSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_outback_gen4_25i',
      );
      final rSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_outback_gen4_36r',
      );
      expect(naSpec['body'], contains('294mm'));
      expect(rSpec['body'], contains('316mm'));
    });

    test('Has Outback Gen4 Battery (Group 25/35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_outback_gen4',
      );
      expect(spec['body'], contains('Group 25'));
    });
  });

  group('Outback Gen 4 (2010-2014) Maintenance & Misc Coverage', () {
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

    test('Has Outback Gen4 Oil Filter (AA11A for 3.6R)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_outback_gen4',
      );
      expect(spec['body'], contains('15208AA11A'));
    });

    test('Has Outback Gen4 Cabin Filter (AJ00A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_outback_gen4',
      );
      expect(spec['body'], contains('72880AJ00A'));
    });

    test('Has Outback Gen4 Timing Chain Note', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_outback_gen4',
      );
      expect(spec['body'], contains('Timing Chain'));
    });

    test('Has Outback Gen4 Fuel Tank (18.5 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_outback_gen4',
      );
      expect(spec['body'], contains('18.5 Gallons'));
    });

    test('Has Outback Gen4 Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_outback_gen4',
      );
      expect(spec['body'], contains('225/60R17'));
    });

    test('Has Outback Gen4 Headlight (H7)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_outback_gen4',
      );
      expect(spec['body'], contains('H7'));
    });

    test('Has Outback Gen4 Fog Light (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_fog_outback_gen4',
      );
      expect(spec['body'], contains('H11'));
    });
  });
}
