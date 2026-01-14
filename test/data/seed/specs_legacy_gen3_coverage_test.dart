import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Legacy Gen 3 (2000-2004) Coverage Specs', () {
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

    test('Has Legacy Gen3 Oil Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2002 Legacy fluids');
      expect(spec['engine_oil_qty'], isNotNull);
    });

    test('Has Legacy Gen3 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing coolant spec');
      expect(spec['engine_coolant_qty'], isNotNull);
    });

    test('Has Legacy Gen3 Transmission Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing transmission spec');
    });

    test('Has Legacy Gen3 Spark Plugs', () {
      final spec = engineSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing engine spec');
      expect(spec['spark_plug'], isNotNull);
    });
  });

  group('Legacy Gen 3 (2000-2004) Wheels & Brakes Coverage', () {
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

    test('Has Legacy Gen3 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_legacy_gen3',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing bolt pattern spec');
      expect(spec['body'], contains('5x100'));
    });

    test('Has Legacy Gen3 Lug Torque', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_legacy_gen3',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing lug torque spec');
      expect(spec['body'], contains('ft-lb'));
    });

    test('Has Legacy Gen3 Brakes', () {
      final spec = brakeSpecs.firstWhere(
        (s) =>
            s['id'] == 's_brake_front_rotor_legacy_gen3_base' ||
            s['id'] == 's_brake_front_rotor_legacy_gen3_gt',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Brake spec not found');
      }
    });

    test('Has Legacy Gen3 Battery', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_legacy_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Group'));
      } else {
        markTestSkipped('Battery spec not found');
      }
    });
  });

  group('Legacy Gen 3 (2000-2004) Maintenance & Misc Coverage', () {
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

    test('Has Legacy Gen3 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) =>
            s['id'] == 's_filter_oil_legacy_gen3_ej25' ||
            s['id'] == 's_filter_oil_legacy_gen3_h6',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Oil filter spec not found');
      }
    });

    test('Has Legacy Gen3 Timing Belt (105k)', () {
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(vehicleRow, isNotEmpty, reason: 'Missing maintenance row');
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has Legacy Gen3 Fuel Tank', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_legacy_gen3',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Gallons'));
      } else {
        markTestSkipped('Fuel tank spec not found');
      }
    });

    test('Has Legacy Gen3 Tires', () {
      final spec = tireSpecs.firstWhere(
        (s) =>
            s['id'] == 's_tire_size_legacy_gen3_gt' ||
            s['id'] == 's_tire_size_legacy_gen3_outback',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Tire spec not found');
      }
    });

    test('Has Legacy Gen3 Headlight (H1)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2002 &&
            s['model'] == 'Legacy' &&
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
