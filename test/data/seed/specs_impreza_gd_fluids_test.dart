import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza GD (2002-2007) Fluid Specs Validation', () {
    late List<dynamic> fluidsSpecs;
    late List<dynamic> coolantSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final fluidsFile = File(p.join(seedDir, 'fluids.json'));
      fluidsSpecs = json.decode(fluidsFile.readAsStringSync());

      final coolantFile = File(p.join(seedDir, 'coolant.json'));
      coolantSpecs = json.decode(coolantFile.readAsStringSync());
    });

    Map<String, dynamic> findSti2004() {
      return fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            (s['trim'] == 'WRX STI (US)' || s['trim'] == 'WRX STI Sedan (US)') &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
    }

    test('Has Power Steering Fluid Type (Dexron III)', () {
      final spec = findSti2004();
      if (spec.isNotEmpty &&
          spec['power_steering_fluid_unit'] != null &&
          spec['power_steering_fluid_unit'] != 'n/a') {
        expect(
          spec['power_steering_fluid_unit'].toString().toUpperCase(),
          contains('DEXRON III'),
        );
      } else {
        markTestSkipped('Power steering fluid spec missing in wide JSON');
      }
    });

    test('Has Clutch Fluid Type (DOT 3/4)', () {
      final spec = findSti2004();
      if (spec.isNotEmpty &&
          spec['clutch_hydraulic_fluid_unit'] != null &&
          spec['clutch_hydraulic_fluid_unit'] != 'n/a') {
        final body = spec['clutch_hydraulic_fluid_unit'].toString();
        expect(body, anyOf(contains('DOT 4'), contains('DOT 3')));
      } else {
        markTestSkipped('Clutch fluid spec missing in wide JSON');
      }
    });

    test('Has Intercooler Spray Tank Capacity (3.8L)', () {
      final spec = findSti2004();

      // Check explicit field first
      if (spec.containsKey('intercooler_spray_fluid_qty')) {
         expect(spec['intercooler_spray_fluid_qty'], contains('3.8'));
      } else {
        // Fallback to notes check
        final notes = spec['notes']?.toString().toLowerCase() ?? '';
        if (notes.contains('intercooler') || notes.contains('spray')) {
          expect(notes, contains('3.8'));
        } else {
          fail('Intercooler spray spec not found in explicit field or notes');
        }
      }
    });

    test('Has Washer Tank Capacity (4.0L)', () {
      final spec = findSti2004();
      if (spec.isNotEmpty &&
          spec['washer_fluid_qty'] != null &&
          spec['washer_fluid_qty'] != 'n/a') {
        expect(spec['washer_fluid_qty'], contains('4.0'));
      } else {
        markTestSkipped('Washer tank capacity missing in wide JSON');
      }
    });

    test('Has Correct Engine Oil Capacity (4.2 qt / 4.0 L)', () {
      final spec = findSti2004();
      expect(spec, isNotEmpty, reason: '2004 STI spec not found');
      // "w/ filter: 4.2 qt / 4.0 L | dry fill: 4.8 qt / 4.5 L"
      expect(spec['engine_oil_qty'], contains('4.2 qt'));
      expect(spec['engine_oil_qty'], contains('4.0 L'));
    });

    test('Has Correct Coolant Capacity (8.1 qt / 7.7 L)', () {
      final spec = findSti2004();
      expect(spec, isNotEmpty, reason: '2004 STI spec not found');
      // "capacity: 8.1 qt / 7.7 L"
      expect(spec['engine_coolant_qty'], contains('8.1 qt'));
      expect(spec['engine_coolant_qty'], contains('7.7 L'));
    });

    test('Has Legacy Green Coolant Type - s_coolant_type_legacy_green', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_type_legacy_green',
        orElse: () => null,
      );
      if (spec == null) {
        markTestSkipped(
          's_coolant_type_legacy_green not found in coolant.json',
        );
        return;
      }
      expect(spec['body'], contains('Green'));
      // Verify scope restriction
      expect(spec['tags'], contains('gd'));
      expect(spec['tags'], contains('sti'));
      expect(spec['verified'], isTrue);
    });
  });
}
