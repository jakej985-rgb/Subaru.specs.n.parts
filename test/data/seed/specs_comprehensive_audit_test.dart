import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group(
    'Subaru Comprehensive Audit (Tribeca, Ascent & Crosstrek) Coverage Specs',
    () {
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
        final seedDir = p.join(
          Directory.current.path,
          'assets',
          'seed',
          'specs',
        );

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

      // Tribeca Coverage
      test('Has Tribeca EZ36 Oil Capacity (6.9 Qt)', () {
        final spec = oilSpecs.firstWhere(
          (s) => s['id'] == 's_oil_capacity_ez36_tribeca',
        );
        expect(spec['body'], contains('6.9 Quarts'));
      });

      test('Has Tribeca EZ36 Coolant Capacity (10.1 Qt)', () {
        final spec = coolantSpecs.firstWhere(
          (s) => s['id'] == 's_coolant_capacity_tribeca_ez36',
        );
        expect(spec['body'], contains('10.1 Quarts'));
      });

      test('Has Tribeca 5AT Fluid Specs (10.4 Qt)', () {
        final spec = transSpecs.firstWhere(
          (s) => s['id'] == 's_trans_capacity_tribeca_5at',
        );
        expect(spec['body'], contains('10.4 Quarts'));
      });

      test('Has Tribeca Front Rotors (316mm)', () {
        final spec = brakeSpecs.firstWhere(
          (s) => s['id'] == 's_brake_front_rotor_tribeca',
        );
        expect(spec['body'], contains('316mm'));
      });

      test('Has Tribeca Rear Rotors (320mm)', () {
        final spec = brakeSpecs.firstWhere(
          (s) => s['id'] == 's_brake_rear_rotor_tribeca',
        );
        expect(spec['body'], contains('320mm'));
      });

      test('Has Tribeca EZ36 Spark Plugs (SILFR6A)', () {
        final spec = plugSpecs.firstWhere((s) => s['id'] == 's_plug_ez36');
        expect(spec['body'], contains('SILFR6A'));
      });

      test('Has Tribeca Tire Size (255/55R18)', () {
        final spec = tireSpecs.firstWhere(
          (s) => s['id'] == 's_tire_size_tribeca',
        );
        expect(spec['body'], contains('255/55R18'));
      });

      test('Has Tribeca Fuel Tank (16.9 gal)', () {
        final spec = fuelSpecs.firstWhere(
          (s) => s['id'] == 's_fuel_tank_tribeca',
        );
        expect(spec['body'], contains('16.9 Gallons'));
      });

      // Ascent Coverage
      test('Has Ascent Front Rotors (333mm)', () {
        final spec = brakeSpecs.firstWhere(
          (s) => s['id'] == 's_brake_front_rotor_ascent',
        );
        expect(spec['body'], contains('333mm'));
      });

      test('Has Ascent Fuel Tank (19.3 gal)', () {
        final spec = fuelSpecs.firstWhere(
          (s) => s['id'] == 's_fuel_tank_ascent',
        );
        expect(spec['body'], contains('19.3 Gallons'));
      });

      // Crosstrek Coverage
      test('Has Crosstrek Front Rotors (294mm)', () {
        final spec = brakeSpecs.firstWhere(
          (s) => s['id'] == 's_brake_front_rotor_crosstrek',
        );
        expect(spec['body'], contains('294mm'));
      });

      test('Has Crosstrek GP Bulb Specs (PSX24W)', () {
        final spec = bulbSpecs.firstWhere(
          (s) => s['id'] == 's_bulb_fog_crosstrek_gp',
        );
        expect(spec['body'], contains('PSX24W'));
      });

      // Legacy Gen 5 Gap
      test('Has Legacy Gen 5 FB Oil Capacity (5.1 Qt)', () {
        final spec = oilSpecs.firstWhere(
          (s) => s['id'] == 's_oil_capacity_leg_gen5_fb',
        );
        expect(spec['body'], contains('5.1 Quarts'));
      });
    },
  );
}
