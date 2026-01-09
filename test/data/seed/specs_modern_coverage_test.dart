import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Subaru Modern Era (2014-Present) Coverage Specs', () {
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

    test('Has Forester Gen 4 Oil Capacity (5.1 Qt)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_forester_gen4_na',
      );
      expect(spec['body'], contains('5.1 Quarts'));
    });

    test('Has WRX VA Oil Capacity (5.4 Qt)', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_wrx_va',
      );
      expect(spec['body'], contains('5.4 Quarts'));
    });

    test('Has Forester Gen 4 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_forester_gen4',
      );
      expect(spec['body'], contains('8.0 Quarts'));
    });

    test('Has TR580 CVT Fluid Specs', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_tr580_cvt',
      );
      expect(spec['body'], contains('8.3 Quarts'));
    });

    test('Has TR690 High Torque CVT Fluid Specs', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_tr690_cvt',
      );
      expect(spec['body'], contains('13.1 Quarts'));
    });

    test('Has 2014+ Lug Torque (89 ft-lb)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_2014_plus',
      );
      expect(spec['body'], contains('89 ft-lb'));
    });

    test('Has WRX VA Front Rotors (316mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_wrx_va',
      );
      expect(spec['body'], contains('316mm'));
    });

    test('Has FB Engine Spark Plugs (SILZKAR7B11)', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_fb_engine_na',
      );
      expect(spec['body'], contains('SILZKAR7B11'));
    });

    test('Has WRX VA Spark Plugs (ILKAR8H6)', () {
      final spec = plugSpecs.firstWhere((s) => s['id'] == 's_plug_wrx_va');
      expect(spec['body'], contains('ILKAR8H6'));
    });

    test('Has FB Engine Oil Filter (AA15A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_fb_engine',
      );
      expect(spec['body'], contains('15208AA15A'));
    });

    test('Has Modern Battery Specs (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_group_35_modern',
      );
      expect(spec['body'], contains('Group 35'));
    });

    test('Has Forester SJ Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_forester_sj',
      );
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has WRX VA Tire Size (235/45R17)', () {
      final spec = tireSpecs.firstWhere((s) => s['id'] == 's_tire_size_wrx_va');
      expect(spec['body'], contains('235/45R17'));
    });

    test('Has WRX VA Bulb Specs (H11)', () {
      final spec = bulbSpecs.firstWhere(
        (s) => s['id'] == 's_bulb_headlight_low_wrx_va',
      );
      expect(spec['body'], contains('H11'));
    });
  });
}
