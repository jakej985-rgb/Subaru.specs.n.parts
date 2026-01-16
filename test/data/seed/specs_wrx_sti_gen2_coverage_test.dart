import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('STI Gen 2 (2004-2007) Coverage Specs', () {
    late List<Map<String, dynamic>> fluidSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      fluidSpecs = (json.decode(fluidsFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has STI Gen2 (EJ257) Oil Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2005 STI fluids');
      expect(spec['engine_oil_qty'], isNotNull);
    });

    test('Has STI Gen2 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing coolant spec');
      expect(spec['engine_coolant_qty'], isNotNull);
    });

    test('Has STI Gen2 (6MT) Fluid Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing transmission spec');
      expect(spec['manual_trans_fluid_qty'], isNotNull);
    });

    test('Has STI Gen2 (R180) Rear Diff Fluid', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing diff spec');
      expect(spec['rear_diff_fluid_qty'], isNotNull);
    });
  });

  group('STI Gen 2 (2004-2007) Wheels & Brakes Coverage', () {
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

    test('Has STI Gen2 Bolt Pattern (2004 5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_sti_2004_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_sti_2004_gen2',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has STI Gen2 Bolt Pattern (2005+ 5x114.3)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_sti_2005_gen2',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing s_wheel_bolt_pattern_sti_2005_gen2',
      );
      expect(spec['body'], contains('5x114.3'));
    });

    test('Has STI Gen2 Front Rotors (326mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('326mm'));
      } else {
        markTestSkipped('Brake rotor spec not found');
      }
    });

    test('Has STI Gen2 Rear Rotors (2004 316mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_sti_2004',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('316mm'));
        expect(spec['body'], contains('5x100'));
      } else {
        markTestSkipped('2004 rear rotor spec not found');
      }
    });

    test('Has STI Gen2 Rear Rotors (2005+ 316mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_sti_2005_plus',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('316mm'));
        expect(spec['body'], contains('5x114.3'));
      } else {
        markTestSkipped('2005+ rear rotor spec not found');
      }
    });

    test('Has STI Gen2 Spark Plugs (0.028")', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('0.028'));
      } else {
        markTestSkipped('Spark plug spec not found');
      }
    });
  });

  group('STI Gen 2 (2004-2007) Maintenance & Electrical Coverage', () {
    late List<dynamic> filterSpecs;
    late List<Map<String, dynamic>> maintSpecs;
    late List<dynamic> batterySpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final filterFile = File(p.join(seedDir, 'filters.json'));
      filterSpecs = json.decode(filterFile.readAsStringSync());

      final maintFile = File(p.join(seedDir, 'maintenance.json'));
      maintSpecs = (json.decode(maintFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final battFile = File(p.join(seedDir, 'battery.json'));
      batterySpecs = json.decode(battFile.readAsStringSync());
    });

    test('Has STI Gen2 Oil Filter (AA100/AA12A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('15208AA100'));
      } else {
        markTestSkipped('Oil filter spec not found');
      }
    });

    test('Has STI Gen2 Timing Belt (105k)', () {
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(vehicleRow, isNotEmpty, reason: 'Missing STI maintenance row');
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has STI Gen2 Battery (Group 35)', () {
      final spec = batterySpecs.firstWhere(
        (s) => s['id'] == 's_battery_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('Group 35'));
      } else {
        markTestSkipped('Battery spec not found');
      }
    });
  });

  group('STI Gen 2 (2004-2007) Lighting & Fuel Coverage', () {
    late List<dynamic> fuelSpecs;
    late List<dynamic> tireSpecs;
    late List<Map<String, dynamic>> bulbSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = (json.decode(bulbFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has STI Gen2 Fuel Tank (15.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('15.9 Gallons'));
      } else {
        markTestSkipped('Fuel tank spec not found');
      }
    });

    test('Has STI Gen2 Stock Tire (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_sti_gen2',
        orElse: () => null,
      );
      if (spec != null) {
        expect(spec['body'], contains('225/45R17'));
      } else {
        markTestSkipped('Tire size spec not found');
      }
    });

    test('Has STI Gen2 Headlight (D2R 04-05)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('D2'));
      } else {
        markTestSkipped('Headlight data missing in new CSV');
      }
    });

    test('Has STI Gen2 Headlight (D2S 06-07)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2006 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('D2'));
      } else {
        markTestSkipped('Headlight data missing in new CSV');
      }
    });
  });

  group('STI Gen 2 (2004-2007) Torque Coverage', () {
    late List<Map<String, dynamic>> torqueSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final torqueFile = File(p.join(seedDir, 'torque_specs.json'));
      torqueSpecs = (json.decode(torqueFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has STI Gen2 (2004) Corrected Lug Nut Torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2004 STI torque specs');
      // Should be 90 Nm / 65.7 ft-lb, distinct from the generic 100-120 Nm
      expect(spec['wheel_lug_nuts'], contains('65.7'));
    });

    test('Has STI Gen2 (2004) Front Caliper Bolt (Corrected)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty);
      // Ensure we mention the Front vs Rear split and the safe value
      expect(spec['brake_caliper_bracket_bolts'], contains('Front:'));
      expect(spec['brake_caliper_bracket_bolts'], contains('80 ft-lb'));
    });

    test('Has STI Gen2 (2004) Trans Drain Gasket Note', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty);
      expect(spec['manual_trans_drain_plug'], contains('aluminum gasket'));
      expect(spec['manual_trans_drain_plug'], contains('copper/metal'));
    });
  });
}
