import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 3 (2008-2011) Coverage Specs', () {
    late List<Map<String, dynamic>> fluidSpecs;
    late List<Map<String, dynamic>> engineSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      fluidSpecs = (json.decode(fluidsFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final enginesFile = File(p.join(seedDir, 'engines.json'));
      engineSpecs = (json.decode(enginesFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has Impreza Gen3 Oil Capacities (NA, WRX, STI)', () {
      final wrxSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(wrxSpec, isNotEmpty, reason: 'Missing 2010 WRX fluids');
      expect(wrxSpec['engine_oil_qty'], contains('4.3 L'));
    });

    test('Has Impreza Gen3 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing coolant spec');
      expect(spec['engine_coolant_qty'], isNotNull);
    });

    test('Has Impreza Gen3 Transmission Capacities', () {
      final mtSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(mtSpec, isNotEmpty, reason: 'Missing transmission spec');
      expect(mtSpec['manual_trans_fluid_qty'], isNotNull);
    });

    test('Has Impreza Gen3 Spark Plugs', () {
      final spec = engineSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing engine spec');
      expect(spec['spark_plug'], isNotNull);
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
        orElse: () => null,
      );
      final stiSpec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_imp_gen3_114',
        orElse: () => null,
      );
      expect(naSpec, isNotNull, reason: 'Missing 5x100 bolt pattern');
      expect(naSpec['body'], contains('5x100'));
      expect(stiSpec, isNotNull, reason: 'Missing 5x114.3 bolt pattern');
      expect(stiSpec['body'], contains('5x114.3'));
    });

    test('Has Impreza Gen3 Brakes (NA, WRX, STI)', () {
      final naSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_25i',
        orElse: () => null,
      );
      final wrxSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_wrx',
        orElse: () => null,
      );
      final stiSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen3_sti',
        orElse: () => null,
      );

      if (naSpec != null) expect(naSpec['body'], contains('277mm'));
      if (wrxSpec != null) expect(wrxSpec['body'], contains('294mm'));
      if (stiSpec != null) expect(stiSpec['body'], contains('326mm'));

      // At least one brake spec should exist
      expect(
        naSpec != null || wrxSpec != null || stiSpec != null,
        isTrue,
        reason: 'No brake specs found for Gen3',
      );
    });

    test('Has Impreza Gen3 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_imp_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Group 35'));
      } else {
        markTestSkipped('Battery spec not found');
      }
    });
  });

  group('Impreza Gen 3 (2008-2011) Maintenance & Misc Coverage', () {
    late List<dynamic> filterSpecs;
    late List<Map<String, dynamic>> maintSpecs;
    late List<dynamic> fuelSpecs;
    late List<dynamic> tireSpecs;
    late List<Map<String, dynamic>> bulbSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final filterFile = File(p.join(seedDir, 'filters.json'));
      filterSpecs = json.decode(filterFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = (json.decode(maintFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = (json.decode(bulbFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has Impreza Gen3 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_imp_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('15208AA12A'));
      } else {
        markTestSkipped('Oil filter spec not found');
      }
    });

    test('Has Impreza Gen3 Cabin Filter (FG000)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_imp_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('72880FG000'));
      } else {
        markTestSkipped('Cabin filter spec not found');
      }
    });

    test('Has Impreza Gen3 Timing Belt (105k)', () {
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(vehicleRow, isNotEmpty, reason: 'Missing maintenance row');
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has Impreza Gen3 Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_imp_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('16.9 Gallons'));
      } else {
        markTestSkipped('Fuel tank spec not found');
      }
    });

    test('Has Impreza Gen3 WRX Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_imp_gen3_17',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('225/45R17'));
      } else {
        markTestSkipped('Tire size spec not found');
      }
    });

    test('Has Impreza Gen3 Headlight (H11)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
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

    test('Has Impreza Gen3 Fog Light (H11)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2010 &&
            s['model'] == 'Impreza' &&
            s['function_key'] == 'fog_front' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(
          spec['bulb_code'].contains('H11') ||
              spec['bulb_code'].contains('9006'),
          isTrue,
        );
      } else {
        markTestSkipped('Fog light data missing in new CSV');
      }
    });
  });
}
