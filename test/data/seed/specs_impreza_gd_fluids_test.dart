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

    test('Has Power Steering Fluid Type (Dexron III) - s_fluid_ps_dex3', () {
      final spec = fluidsSpecs.firstWhere(
        (s) => s['id'] == 's_fluid_ps_dex3',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fluid_ps_dex3');
      expect(spec['body'], contains('Dexron III'));
      expect(spec['tags'], contains('gd'));
      expect(spec['tags'], contains('sti'));
      expect(spec['tags'], contains('2004'));
      expect(spec['verified'], isTrue);
    });

    test('Has Clutch Fluid Type (DOT 3/4) - s_fluid_clutch_dot34', () {
      final spec = fluidsSpecs.firstWhere(
        (s) => s['id'] == 's_fluid_clutch_dot34',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_fluid_clutch_dot34');
      expect(spec['body'], contains('DOT 3 or DOT 4'));
      expect(spec['tags'], contains('sti'));
      expect(spec['tags'], contains('gd'));
      expect(spec['verified'], isTrue);
    });

    test(
      'Has Intercooler Spray Tank Capacity (3.8L) - s_ic_spray_capacity_sti_gd_us',
      () {
        final spec = fluidsSpecs.firstWhere(
          (s) => s['id'] == 's_ic_spray_capacity_sti_gd_us',
          orElse: () => null,
        );
        expect(
          spec,
          isNotNull,
          reason: 'Missing s_ic_spray_capacity_sti_gd_us',
        );
        expect(spec['body'], contains('3.8 Liters'));
        expect(spec['tags'], contains('sti'));
        expect(spec['tags'], contains('2004'));
        expect(spec['verified'], isTrue);
      },
    );

    test('Has Washer Tank Capacity (4.0L) - s_washer_capacity_gd', () {
      final spec = fluidsSpecs.firstWhere(
        (s) => s['id'] == 's_washer_capacity_gd',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_washer_capacity_gd');
      expect(spec['body'], contains('4.0 Liters'));
      expect(spec['tags'], contains('gd'));
      expect(spec['verified'], isTrue);
    });

    test('Has Legacy Green Coolant Type - s_coolant_type_legacy_green', () {
      final spec = coolantSpecs.firstWhere(
        (s) => s['id'] == 's_coolant_type_legacy_green',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_coolant_type_legacy_green');
      expect(spec['body'], contains('Green'));
      // Verify scope restriction
      expect(spec['tags'], contains('gd'));
      expect(spec['tags'], contains('sti'));
      expect(spec['tags'], contains('wrx'));
      expect(spec['tags'], isNot(contains('outback'))); // Should be removed
      expect(spec['tags'], isNot(contains('legacy'))); // Should be removed
      expect(spec['tags'], isNot(contains('forester'))); // Should be removed
      expect(spec['verified'], isTrue);
    });
  });
}
