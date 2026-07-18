import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('2004 WRX STI (US) Torque Specs', () {
    late List<Map<String, dynamic>> torqueSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final torqueFile = File(p.join(seedDir, 'torque_specs.json'));
      torqueSpecs = (json.decode(torqueFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has correct 2004 STI Lug Nut Torque (65.7 ft-lb)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      expect(spec, isNotEmpty, reason: 'Entry for 2004 WRX STI (US) not found');
      // The modern standard is 89 ft-lb, but 2004 STI FSM specifies 65.7 ft-lb (90 Nm).
      // We expect the specific value to be present.
      expect(
        spec['wheel_lug_nuts'],
        contains('65.7 ft-lb'),
        reason: 'Lug nut torque should reflect 2004 FSM value',
      );
      expect(
        spec['wheel_lug_nuts'],
        contains('90 N·m'),
        reason: 'Lug nut torque should reflect 2004 FSM value',
      );
    });

    test('Has correct 2004 STI Front Caliper Bolt Torque (80 ft-lb)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      // Brembo caliper mounting bolts.
      // FSM has a known error stating 114 ft-lb. Correct is ~80 ft-lb.
      expect(
        spec['brake_caliper_bracket_bolts'],
        contains('80 ft-lb'),
        reason: 'Should list corrected torque',
      );
      expect(
        spec['brake_caliper_bracket_bolts'],
        contains('108 N·m'),
        reason: 'Should list corrected torque',
      );
    });

    test('Has correct 2004 STI Bleeder Screw Torque (13.3 ft-lb)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );

      // Brembo bleeder screws are tighter than standard floating calipers.
      expect(
        spec['brake_bleeder_screws'],
        contains('13.3 ft-lb'),
        reason: 'Bleeder torque too low',
      );
      expect(
        spec['brake_bleeder_screws'],
        contains('18 N·m'),
        reason: 'Bleeder torque too low',
      );
    });
  });
}
