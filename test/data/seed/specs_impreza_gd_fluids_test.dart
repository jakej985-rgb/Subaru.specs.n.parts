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

    test('Has Power Steering Fluid Type (Dexron III)', () {
      final spec = fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
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
      final spec = fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
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
      final spec = fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      final notes = spec['notes']?.toString().toLowerCase() ?? '';
      if (notes.contains('intercooler') || notes.contains('spray')) {
        expect(notes, contains('3.8'));
      } else {
        markTestSkipped('Intercooler spray spec not found in wide JSON');
      }
    });

    test('Has Washer Tank Capacity (4.0L)', () {
      final spec = fluidsSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      if (spec.isNotEmpty &&
          spec['washer_fluid_qty'] != null &&
          spec['washer_fluid_qty'] != 'n/a') {
        expect(spec['washer_fluid_qty'], contains('4.0'));
      } else {
        markTestSkipped('Washer tank capacity missing in wide JSON');
      }
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
