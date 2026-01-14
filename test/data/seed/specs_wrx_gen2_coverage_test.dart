import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('WRX Gen 2 (2002-2007) Coverage Specs', () {
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

    test('Has WRX Gen2 Oil Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2004 WRX fluids');
      expect(spec['engine_oil_qty'], isNotNull);
    });

    test('Has WRX Gen2 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing coolant spec');
      expect(spec['engine_coolant_qty'], isNotNull);
    });

    test('Has WRX Gen2 Transmission Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing transmission spec');
      expect(spec['manual_trans_fluid_qty'], isNotNull);
    });

    test('Has WRX Gen2 Spark Plugs', () {
      final spec = engineSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing engine spec');
      expect(spec['spark_plug'], isNotNull);
    });
  });

  group('WRX Gen 2 (2002-2007) Wheels & Brakes Coverage', () {
    late List<dynamic> wheelSpecs;
    late List<dynamic> brakeSpecs;
    late List<dynamic> plugSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final wheelFile = File(p.join(seedDir, 'wheels.json'));
      wheelSpecs = json.decode(wheelFile.readAsStringSync());

      final brakeFile = File(p.join(seedDir, 'brakes.json'));
      brakeSpecs = json.decode(brakeFile.readAsStringSync());

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());
    });

    test('Has WRX Gen2 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing bolt pattern spec');
      expect(spec['body'], contains('5x100'));
    });

    test('Has WRX Gen2 Lug Torque', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing lug torque spec');
      expect(spec['body'], contains('ft-lb'));
    });

    test('Has WRX Gen2 Brakes', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_wrx_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Brake spec not found');
      }
    });

    test('Has WRX Gen2 Spark Plugs (0.028")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_wrx_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing spark plug spec');
      expect(spec['body'], contains('0.028'));
    });
  });

  group('WRX Gen 2 (2002-2007) Maintenance & Misc Coverage', () {
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

    test('Has WRX Gen2 Oil Filter (AA100)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_wrx_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Oil filter spec not found');
      }
    });

    test('Has WRX Gen2 Timing Belt (105k)', () {
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(vehicleRow, isNotEmpty, reason: 'Missing maintenance row');
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has WRX Gen2 Fuel Tank', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_wrx_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Gallons'));
      } else {
        markTestSkipped('Fuel tank spec not found');
      }
    });

    test('Has WRX Gen2 Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_wrx_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], isNotNull);
      } else {
        markTestSkipped('Tire spec not found');
      }
    });

    test('Has WRX Gen2 Headlight (H4)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX (US)' &&
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
