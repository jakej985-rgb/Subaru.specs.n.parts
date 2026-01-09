import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Baja (2003-2006) Coverage Specs', () {
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

    test('Has Baja Oil Capacities (NA & Turbo)', () {
      final naSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_baja_na',
      );
      final turboSpec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_baja_turbo',
      );
      expect(naSpec['body'], contains('4.2 Quarts'));
      expect(turboSpec['body'], contains('4.8 Quarts'));
    });

    test('Has Baja Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_baja_na',
      );
      expect(spec['body'], contains('7.2 Quarts'));
    });

    test('Has Baja Transmission Capacities (5MT & 4EAT)', () {
      final mtSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_baja_5mt',
      );
      final atSpec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_baja_4eat',
      );
      expect(mtSpec['body'], contains('3.7 Quarts'));
      expect(atSpec['body'], contains('9.8 Quarts'));
    });

    test('Has Baja Spark Plugs (Turbo)', () {
      final spec = plugSpecs.firstWhere((s) => s['id'] == 's_plug_baja_turbo');
      expect(spec['body'], contains('SILFR6A'));
    });
  });

  group('Baja (2003-2006) Wheels & Brakes Coverage', () {
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

    test('Has Baja Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_baja',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Baja Brakes (Front & Rear)', () {
      final frontSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_baja',
      );
      final rearSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_baja',
      );
      expect(frontSpec['body'], contains('294mm'));
      expect(rearSpec['body'], contains('274mm'));
    });

    test('Has Baja Battery (Group 35)', () {
      final spec = battSpecs.firstWhere((s) => s['id'] == 's_battery_baja');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Baja (2003-2006) Maintenance & Misc Coverage', () {
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

    test('Has Baja Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_baja',
      );
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Baja Air Filter (NA)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_air_baja_na',
      );
      expect(spec['body'], contains('16546AA020'));
    });

    test('Has Baja Timing Belt (105k)', () {
      final spec = maintSpecs.firstWhere(
        (s) => s['id'] == 's_maint_timing_belt_baja',
      );
      expect(spec['body'], contains('105,000 Miles'));
    });

    test('Has Baja Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere((s) => s['id'] == 's_fuel_tank_baja');
      expect(spec['body'], contains('16.9 Gallons'));
    });

    test('Has Baja Tires (225/60R16)', () {
      final spec = tireSpecs.firstWhere((s) => s['id'] == 's_tire_size_baja');
      expect(spec['body'], contains('225/60R16'));
    });

    test('Has Baja Headlight (H1)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_baja',
      );
      expect(spec['body'], contains('H1'));
    });

    test('Has Baja Fog Light (H3)', () {
      final spec = bulbSpecs.firstWhere((s) => s['id'] == 's_bulb_fog_baja');
      expect(spec['body'], contains('H3'));
    });
  });
}
