import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('STI 2004 Torque Specs Coverage', () {
    late List<Map<String, dynamic>> torqueSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final torqueFile = File(p.join(seedDir, 'torque_specs.json'));
      torqueSpecs = (json.decode(torqueFile.readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('Has 2004 WRX STI (US) with correct Lug Nut Torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2004 STI entry');
      expect(spec['wheel_lug_nuts'], contains('90 Nm'));
      expect(spec['wheel_lug_nuts'], contains('65.7 ft-lbs'));
    });

    test('Has 2004 WRX STI Sedan (US) with correct Lug Nut Torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['model'] == 'Impreza' &&
            s['trim'] == 'WRX STI Sedan (US)' &&
            s['market'] == 'USDM',
        orElse: () => <String, dynamic>{},
      );
      expect(spec, isNotEmpty, reason: 'Missing 2004 STI Sedan entry');
      expect(spec['wheel_lug_nuts'], contains('90 Nm'));
      expect(spec['wheel_lug_nuts'], contains('65.7 ft-lbs'));
    });

    test('Has Correct Brake Caliper Torque (Front)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['brake_caliper_bracket_bolts'], contains('80 ft-lbs'));
      expect(spec['brake_caliper_bracket_bolts'], contains('108 Nm'));
    });

    test('Has Correct Brake Caliper Torque (Rear)', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['brake_caliper_bracket_bolts'], contains('47.9 ft-lbs'));
      expect(spec['brake_caliper_bracket_bolts'], contains('65 Nm'));
    });

    test('Has Correct Bleeder Screw Torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['brake_bleeder_screws'], contains('13.3 ft-lbs'));
      expect(spec['brake_bleeder_screws'], contains('18 Nm'));
    });

    test('Has Correct Spark Plug Torque', () {
      final spec = torqueSpecs.firstWhere(
        (s) =>
            s['year'] == 2004 &&
            s['trim'] == 'WRX STI (US)',
        orElse: () => <String, dynamic>{},
      );
      expect(spec['spark_plugs'], contains('15.2 ft-lbs'));
      expect(spec['spark_plugs'], contains('21 Nm'));
    });
  });
}
