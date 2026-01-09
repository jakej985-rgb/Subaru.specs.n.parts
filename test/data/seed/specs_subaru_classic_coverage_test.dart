import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Subaru Classic, Justy & SVX (1970s-1990s) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;
    late List<dynamic> wheelSpecs;
    late List<dynamic> brakeSpecs;
    late List<dynamic> plugSpecs;
    late List<dynamic> filterSpecs;
    late List<dynamic> battSpecs;
    late List<dynamic> fuelSpecs;
    late List<dynamic> tireSpecs;
    late List<dynamic> bulbSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      oilSpecs = json.decode(
        File(p.join(seedDir, 'oil.json')).readAsStringSync(),
      );
      coolantSpecs = json.decode(
        File(p.join(seedDir, 'coolant.json')).readAsStringSync(),
      );
      transSpecs = json.decode(
        File(p.join(seedDir, 'transmission.json')).readAsStringSync(),
      );
      wheelSpecs = json.decode(
        File(p.join(seedDir, 'wheels.json')).readAsStringSync(),
      );
      brakeSpecs = json.decode(
        File(p.join(seedDir, 'brakes.json')).readAsStringSync(),
      );
      plugSpecs = json.decode(
        File(p.join(seedDir, 'spark_plugs.json')).readAsStringSync(),
      );
      filterSpecs = json.decode(
        File(p.join(seedDir, 'filters.json')).readAsStringSync(),
      );
      battSpecs = json.decode(
        File(p.join(seedDir, 'battery.json')).readAsStringSync(),
      );
      fuelSpecs = json.decode(
        File(p.join(seedDir, 'fuel.json')).readAsStringSync(),
      );
      tireSpecs = json.decode(
        File(p.join(seedDir, 'tires.json')).readAsStringSync(),
      );
      bulbSpecs = json.decode(
        File(p.join(seedDir, 'bulbs.json')).readAsStringSync(),
      );
    });

    test('Has EA71 Oil Capacity', () {
      final spec = oilSpecs.firstWhere((s) => s['id'] == 's_oil_capacity_ea71');
      expect(spec['body'], contains('3.7 Quarts'));
    });

    test('Has Justy Oil Capacity', () {
      final spec = oilSpecs.firstWhere((s) => s['id'] == 's_oil_EF12');
      expect(spec['body'], contains('3.2 Quarts'));
    });

    test('Has EA Classic Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_ea_classic',
      );
      expect(spec['body'], contains('6.3 Quarts'));
    });

    test('Has Justy Transmission Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_justy_5mt',
      );
      expect(spec['body'], contains('2.4 Quarts'));
    });

    test('Has SVX Bolt Pattern (5x114.3)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_svx',
      );
      expect(spec['body'], contains('5x114.3'));
    });

    test('Has Classic Bolt Pattern (4x140)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_ea',
      );
      expect(spec['body'], contains('4x140'));
    });

    test('Has Gen 2 Brake Specs (242mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_ea81_82',
      );
      expect(spec['body'], contains('242mm'));
    });

    test('Has EA71/81 Spark Plugs (BP6ES)', () {
      final spec = plugSpecs.firstWhere((s) => s['id'] == 's_plug_ea71_81');
      expect(spec['body'], contains('BP6ES'));
    });

    test('Has SVX Battery (Group 35)', () {
      final spec = battSpecs.firstWhere((s) => s['id'] == 's_battery_svx');
      expect(spec['body'], contains('Group 35'));
    });

    test('Has Classic Oil Filter (AA100)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_ea_classic',
      );
      expect(spec['body'], contains('15208AA100'));
    });

    test('Has Justy Tire Size (165/65R13)', () {
      final spec = tireSpecs.firstWhere((s) => s['id'] == 's_tire_size_justy');
      expect(spec['body'], contains('165/65R13'));
    });

    test('Has SVX Bulb Specs (9006)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_svx',
      );
      expect(spec['body'], contains('9006'));
    });

    test('Has Classic Fuel Tank (13.2 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_ea_classic',
      );
      expect(spec['body'], contains('13.2 Gallons'));
    });
  });
}
