import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('STI 2004 Torque Specs', () {
    late List<Map<String, dynamic>> torqueSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final torqueFile = File(p.join(seedDir, 'torque_specs.json'));
      torqueSpecs = (json.decode(torqueFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('2004 WRX STI (US) has correct lug nut torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );

      expect(spec, isNotEmpty, reason: 'Entry for WRX STI (US) not found');
      expect(spec['wheel_lug_nuts'], contains('65.7 ft-lb'), reason: 'Lug nut torque should be 65.7 ft-lb');
      expect(spec['wheel_lug_nuts'], contains('90 N·m'), reason: 'Lug nut torque should match 90 Nm');
    });

    test('2004 WRX STI Sedan (US) has correct lug nut torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI Sedan (US)',
        orElse: () => <String, dynamic>{},
      );

      expect(spec, isNotEmpty, reason: 'Entry for WRX STI Sedan (US) not found');
      expect(spec['wheel_lug_nuts'], contains('65.7 ft-lb'));
    });

    test('2004 WRX STI (US) has corrected caliper bracket torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );

      expect(spec['brake_caliper_bracket_bolts'], contains('80 ft-lb'), reason: 'Front caliper torque should be 80 ft-lb');
      expect(spec['brake_caliper_bracket_bolts'], contains('47.9 ft-lb'), reason: 'Rear caliper torque should be 47.9 ft-lb');
    });

    test('2004 WRX STI (US) notes warn about FSM error', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );

      expect(spec['notes'], contains('FSM error'), reason: 'Notes should warn about FSM error');
    });
  });
}
