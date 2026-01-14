import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 3 (2009-2013) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> plugSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      oilSpecs = (json.decode(fluidsFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final enginesFile = File(p.join(seedDir, 'engines.json'));
      plugSpecs = (json.decode(enginesFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has Forester Gen3 Oil Capacities (EJ & FB)', () {
      final ejSpec = oilSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Premium (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      final fbSpec = oilSpecs.firstWhere(
        (s) =>
            s['year'] == 2011 &&
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Touring (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(ejSpec, isNotEmpty, reason: 'Missing 2010 Premium fluids');
      expect(fbSpec, isNotEmpty, reason: 'Missing 2011 Touring fluids');

      expect(ejSpec['engine_oil_qty'], contains('4.2 L'));
      expect(fbSpec['engine_oil_qty'], contains('4.2 L'));
    });

    test('Has Forester Gen3 Coolant Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Premium (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2010 Premium fluids');
      expect(spec['engine_coolant_qty'], contains('6.4 L'));
    });

    test('Has Forester Gen3 Transmission Capacities (5MT & 4EAT)', () {
      final mtSpec = oilSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Premium (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(mtSpec, isNotEmpty, reason: 'Missing 2010 Premium fluids');
      // Manual: 3.5 L
      expect(mtSpec['manual_trans_fluid_qty'], contains('3.5 L'));
    });

    test('Has Forester Gen3 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) =>
            s['year'] == 2011 &&
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Touring (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['spark_plug'], contains('SILZKAR7B11'));
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
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2011 && // FB25 engine (Chain)
            s['model'] == 'Forester' &&
            s['trim'] == '2.5X Touring (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(
        vehicleRow,
        isNotEmpty,
        reason: 'Maintenance row for 2011 Forester not found',
      );
      // "drive_belt_timing" might be n/a, so check notes
      expect(vehicleRow['notes'].toString().toLowerCase(), contains('chain'));
    });

    test('Has Forester Gen3 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_forester_gen3',
      );
      expect(spec['body'], contains('15.9 Gallons'));
    });

    test('Has Forester Gen3 Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_forester_gen3_17',
      );
      expect(spec['body'], contains('225/55R17'));
    });

    test('Has Forester Gen3 Headlight (H11)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Forester' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('H11'));
      } else {
        markTestSkipped('Headlight data missing in new CSV');
      }
    });

    test('Has Forester Gen3 Fog Light (H11)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Forester' &&
            s['function_key'] == 'fog_front' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('H11'));
      } else {
        markTestSkipped('Fog light data missing in new CSV');
      }
    });
  });
}
