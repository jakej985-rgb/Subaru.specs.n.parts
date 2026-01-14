import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 2 (2002-2007) Coverage Specs', () {
    late List<dynamic> oilSpecs;
    late List<dynamic> coolantSpecs;
    late List<dynamic> transSpecs;
    late List<dynamic> plugSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');

      final oilFile = File(p.join(seedDir, 'oil.json'));
      oilSpecs = json.decode(oilFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());

      final transFile = File(p.join(seedDir, 'transmission.json'));
      transSpecs = json.decode(transFile.readAsStringSync());

      final plugFile = File(p.join(seedDir, 'spark_plugs.json'));
      plugSpecs = json.decode(plugFile.readAsStringSync());
    });

    test('Has Impreza Gen2 (EJ25 NA) Oil Capacity', () {
      final spec = oilSpecs.firstWhere(
        (s) => s['id'] == 's_oil_capacity_ej25_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_oil_capacity_ej25_imp_gen2');
      expect(spec['body'], contains('4.2 Quarts'));
    });

    test('Has Impreza Gen2 Coolant Capacity', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_capacity_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_capacity_imp_gen2');
      expect(spec['body'], contains('6.3'));
    });

    test('Has Impreza Gen2 (5MT) Fluid Capacity', () {
      final spec = transSpecs.firstWhere(
        (s) => s['id'] == 's_trans_capacity_imp_gen2_5mt',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_trans_capacity_imp_gen2_5mt');
      expect(spec['body'], contains('3.5 Quarts'));
    });

    test('Has Impreza Gen2 Spark Plugs', () {
      final spec = plugSpecs.firstWhere(
        (s) => s['id'] == 's_plug_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_plug_imp_gen2');
      expect(spec['body'], contains('0.043'));
    });
  });

  group('Impreza Gen 2 (2002-2007) Wheels & Brakes Coverage', () {
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

    test('Has Impreza Gen2 Bolt Pattern (5x100)', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_bolt_pattern_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_bolt_pattern_imp_gen2');
      expect(spec['body'], contains('5x100'));
    });

    test('Has Impreza Gen2 Front Rotors (277mm)', () {
      final spec = brakeSpecs.firstWhere(
        (s) => s['id'] == 's_brake_front_rotor_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_brake_front_rotor_imp_gen2');
      expect(spec['body'], contains('277mm'));
    });

    test('Has Impreza Gen2 Battery (Group 35)', () {
      final spec = battSpecs.firstWhere(
        (s) => s['id'] == 's_battery_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_battery_imp_gen2');
      expect(spec['body'], contains('Group 35'));
    });
  });

  group('Impreza Gen 2 (2002-2007) Maintenance & Misc Coverage', () {
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

    test('Has Impreza Gen2 Oil Filter (AA100)', () {
      final spec = filterSpecs.firstWhere(
        (s) => s['id'] == 's_filter_oil_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_filter_oil_imp_gen2');
      expect(spec['body'], contains('15208AA100'));
    });

    test('Has Impreza Gen2 Timing Belt (105k)', () {
      // Maintenance.json is Wide format (one row per vehicle)
      final vehicleRow = maintSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'].toString().contains('WRX') &&
            s['market'] == 'USDM',
        orElse: () => null,
      );
      expect(
        vehicleRow,
        isNotNull,
        reason: 'Maintenance row for 2004 WRX not found in maintenance.json',
      );
      // Key is 'drive_belt_timing' in the new sync
      expect(vehicleRow['drive_belt_timing'], contains('105,000'));
    });

    test('Has Impreza Gen2 Fuel Tank (13.2 gal)', () {
      // ... existing legacy test (fuel.json not touched)
      final spec = fuelSpecs.firstWhere(
        (s) => s['id'] == 's_fuel_tank_imp_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fuel_tank_imp_gen2');
      expect(spec['body'], contains('13.2 Gallons'));
    });

    test('Has Impreza Gen2 RS Tires (16")', () {
      // ... existing legacy test (tires.json not touched)
      final spec = tireSpecs.firstWhere(
        (s) => s['id'] == 's_tire_size_imp_gen2_rs',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_tire_size_imp_gen2_rs');
      expect(spec['body'], contains('205/55R16'));
    });

    test('Has Impreza Gen2 Headlight (H4/9003)', () {
      // New format: Search by YMMT
      final spec = bulbSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'].toString().contains('WRX') &&
            s['function_key'] == 'headlight_low',
        orElse: () => null,
      );
      expect(
        spec,
        isNotNull,
        reason: 'Missing 2004 Impreza WRX headlight_low row',
      );
      expect(spec['bulb_code'], contains('H4'));
    });
  });
}
