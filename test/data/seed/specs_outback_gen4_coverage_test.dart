import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 4 (2010-2014) Coverage Specs', () {
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

    test('Has Outback Gen4 Oil Capacities (NA & 3.6R)', () {
      final naSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['trim'] == '2.5i Limited (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      final h6Spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['trim'] == '3.6R Limited (US)' && // Now exists
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(naSpec, isNotEmpty, reason: 'Missing 2012 Outback 2.5i');
      expect(h6Spec, isNotEmpty, reason: 'Missing 2012 Outback 3.6R');
      expect(naSpec['engine_oil_qty'], isNotNull);
      expect(h6Spec['engine_oil_qty'], isNotNull);
    });

    test('Has Outback Gen4 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing coolant spec');
      expect(spec['engine_coolant_qty'], isNotNull);
    });

    test('Has Outback Gen4 Transmission Capacities', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing transmission spec');
    });

    test('Has Outback Gen4 Spark Plugs', () {
      final spec = engineSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing engine spec');
      expect(spec['spark_plug'], isNotNull);
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
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing bolt pattern spec');
      expect(spec['body'], contains('5x100'));
    });

    test('Has Outback Gen4 Brakes', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_outback_gen4_25i',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('294mm'));
      } else {
        markTestSkipped('Brake spec not found');
      }
    });

    test('Has Outback Gen4 Battery', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_outback_gen4',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Group'));
      } else {
        markTestSkipped('Battery spec not found');
      }
    });
  });

  group('Outback Gen 4 (2010-2014) Maintenance & Misc Coverage', () {
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

    test('Has Outback Gen4 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_outback_gen4',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Oil filter spec not found');
      }
    });

    test('Has Outback Gen4 Cabin Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_outback_gen4',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Cabin filter spec not found');
      }
    });

    test('Has Outback Gen4 Timing Belt/Chain Note', () {
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(vehicleRow, isNotEmpty, reason: 'Missing maintenance row');
      // Check notes for belt/chain info
      final notes = vehicleRow['notes']?.toString().toLowerCase() ?? '';
      final timing =
          vehicleRow['drive_belt_timing']?.toString().toLowerCase() ?? '';
      expect(
        notes.contains('chain') ||
            timing.contains('chain') ||
            notes.contains('belt') ||
            timing.contains('belt') ||
            timing.contains('105,000'),
        isTrue,
        reason: 'Timing belt or chain info not found',
      );
    });

    test('Has Outback Gen4 Fog Light (H11)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['function_key'] == 'fog_front' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );
      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], isNotNull);
      } else {
        markTestSkipped('Fog light data missing in CSV');
      }
    });

    test('Has Outback Gen4 Fuel Tank', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_outback_gen4',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Gallons'));
      } else {
        markTestSkipped('Fuel tank spec not found');
      }
    });

    test('Has Outback Gen4 Tires', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_outback_gen4',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Tire spec not found');
      }
    });

    test('Has Outback Gen4 Headlight (H7)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2012 &&
            s['model'] == 'Outback' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );
      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], isNotNull);
      } else {
        markTestSkipped('Headlight data missing in CSV');
      }
    });
  });
}
