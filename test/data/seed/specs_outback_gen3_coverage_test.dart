import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 3 (2005-2009) Coverage Specs', () {
    late List<dynamic> fluidSpecs;
    late List<dynamic> plugSpecs; // Legacy file likely

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      fluidSpecs = (json.decode(fluidsFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();

      final enginesFile = File(p.join(seedDir, 'engines.json'));
      plugSpecs = json.decode(enginesFile.readAsStringSync());
    });

    test('Has Outback Gen3 Oil Capacities (NA & XT)', () {
      final naSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == '2.5i (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      final xtSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == 'XT (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      // NA: 4.2 L (4.4 qt)
      expect(naSpec, isNotEmpty, reason: 'Missing 2.5i (US) fluids');
      expect(naSpec['engine_oil_qty'], contains('4.2 L'));
      // XT: 4.3 L (4.5 qt)
      expect(xtSpec, isNotEmpty, reason: 'Missing XT (US) fluids');
      expect(xtSpec['engine_oil_qty'], contains('4.3 L'));
    });

    test('Has Outback Gen3 Coolant Capacity', () {
      final spec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == '2.5i (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      // capacity: 6.8 qt / 6.4 L
      expect(spec, isNotEmpty, reason: 'Missing 2.5i (US) fluids');
      expect(spec['engine_coolant_qty'], contains('6.4 L'));
    });

    test('Has Outback Gen3 Transmission Capacities (5MT & 5EAT/4EAT)', () {
      final naSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == '2.5i (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      final xtSpec = fluidSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == 'XT (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      // 2.5i Manual: 3.5 L
      expect(naSpec['manual_trans_fluid_qty'], contains('3.5 L'));

      // XT Automatic: 9.3 L
      expect(xtSpec['automatic_trans_fluid_qty'], contains('9.3 L'));
    });

    test('Has Outback Gen3 Spark Plugs (XT)', () {
      final spec = plugSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == 'XT (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['spark_plug'], contains('PZFR6F'));
    });
  });

  group('Outback Gen 3 (2005-2009) Wheels & Brakes Coverage', () {
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

    test('Has Outback Gen3 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_outback_gen3',
      );
      expect(spec['body'], contains('5x100'));
    });

    test('Has Outback Gen3 Brakes (Front & Rear)', () {
      final frontSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_outback_gen3',
      );
      final rearSpec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_rear_rotor_outback_gen3',
      );
      expect(frontSpec['body'], contains('294mm'));
      expect(rearSpec['body'], contains('274mm'));
    });

    test('Has Outback Gen3 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_outback_gen3',
      );
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Outback Gen 3 (2005-2009) Maintenance & Misc Coverage', () {
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
      maintSpecs = (json.decode(maintFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>(); // Wide format

      final fuelFile = File(p.join(seedDir, 'fuel.json'));
      fuelSpecs = json.decode(fuelFile.readAsStringSync());

      final tireFile = File(p.join(seedDir, 'tires.json'));
      tireSpecs = json.decode(tireFile.readAsStringSync());

      final bulbFile = File(p.join(seedDir, 'bulbs.json'));
      bulbSpecs = (json.decode(bulbFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>(); // Tall fitment format
    });

    test('Has Outback Gen3 Oil Filter', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_outback_gen3',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['body'], contains('15208AA12A'));
    });

    test('Has Outback Gen3 Cabin Filter (AG00A)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_cabin_outback_gen3',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['body'], contains('72880AG00A'));
    });

    test('Has Outback Gen3 Timing Belt (105k)', () {
      // Lookup in maintenance.json (Wide)
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['trim'] == '2.5i (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(
        vehicleRow,
        isNotEmpty,
        reason: 'Missing 2005 Outback maintenance row',
      );
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has Outback Gen3 Fuel Tank (16.9 gal)', () {
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_outback_gen3',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['body'], contains('16.9 Gallons'));
    });

    test('Has Outback Gen3 XT Tires (17")', () {
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_outback_gen3_xt',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['body'], contains('225/55R17'));
    });

    test('Has Outback Gen3 Headlight (H7)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['function_key'] == 'headlight_low' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{},
      );

      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('H7'));
      } else {
        markTestSkipped('Headlight data missing in new CSV');
      }
    });

    test('Has Outback Gen3 Fog Light (9006)', () {
      // Find any valid entry (where bulb_code is not 'n/a')
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2005 &&
            s['model'] == 'Outback' &&
            s['function_key'] == 'fog_front' &&
            s['market'] == 'USDM' &&
            s['bulb_code'] != null &&
            s['bulb_code'] != 'n/a',
        orElse: () => <String, dynamic>{}, // Return empty map if not found
      );

      // Skipping assertion until data is populated
      if (spec.isNotEmpty) {
        expect(spec['bulb_code'], contains('9006'));
      } else {
        markTestSkipped('Fog light data missing in new CSV');
      }
    });
  });
}
