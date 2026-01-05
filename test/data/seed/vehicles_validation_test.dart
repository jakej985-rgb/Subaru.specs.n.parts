import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Vehicle Data Validation', () {
    late List<dynamic> vehicles;

    setUpAll(() {
      final filePath = p.join(
        Directory.current.path,
        'assets',
        'seed',
        'vehicles.json',
      );
      final file = File(filePath);

      expect(
        file.existsSync(),
        isTrue,
        reason: 'Missing vehicles.json at: $filePath',
      );

      final content = file.readAsStringSync();
      vehicles = json.decode(content);
    });

    test('No duplicate IDs found', () {
      final ids = <String>{};
      for (final v in vehicles) {
        final id = v['id'];
        expect(ids.contains(id), isFalse, reason: 'Duplicate ID found: $id');
        ids.add(id);
      }
    });

    test('No duplicate Year/Model/Trim/Engine found', () {
      final signatures = <String>{};
      for (final v in vehicles) {
        // Create a unique signature for the vehicle config
        final signature =
            "${v['year']}|${v['make']}|${v['model']}|${v['trim']}|${v['engineCode']}";
        // Ignore updated at

        expect(
          signatures.contains(signature),
          isFalse,
          reason: 'Duplicate vehicle config found: $signature (ID: ${v['id']})',
        );
        signatures.add(signature);
      }
    });

    test('2008 Impreza Models are present', () {
      final expectedTrims = [
        '2.5i (US)',
        'Outback Sport (US)',
        'WRX (US)',
        'WRX STI (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2008 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2008 Impreza trim: $trim');
      }
    });

    test('2009 Impreza Models are present', () {
      final expectedTrims = [
        '2.5i (US)',
        'Outback Sport (US)',
        'WRX (US)',
        '2.5 GT (US)',
        'WRX STI (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2009 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2009 Impreza trim: $trim');
      }
    });

    test('2010 Impreza Models are present', () {
      final expectedTrims = [
        '2.5i (US)',
        'Outback Sport (US)',
        'WRX (US)',
        '2.5 GT (US)',
        'WRX STI (US)',
        'WRX STI Special Edition (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2010 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2010 Impreza trim: $trim');
      }
    });

    test('2011 Impreza Models are present', () {
      final expectedTrims = [
        '2.5i (US)',
        'Outback Sport (US)',
        'WRX (US)',
        'WRX STI (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2011 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2011 Impreza trim: $trim');
      }
    });

    test('2012 Impreza Models are present (Split Year)', () {
      final expectedTrims = [
        '2.0i (US)',
        '2.0i Premium (US)',
        '2.0i Limited (US)',
        '2.0i Sport Premium (US)',
        '2.0i Sport Limited (US)',
        'WRX (US)',
        'WRX Premium (US)',
        'WRX Limited (US)',
        'WRX STI (US)',
        'WRX STI Limited (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2012 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2012 Impreza trim: $trim');
      }
    });

    test('2013 Impreza Models are present (Split Year + Special Editions)', () {
      final expectedTrims = [
        '2.0i (US)',
        '2.0i Premium (US)',
        '2.0i Limited (US)',
        '2.0i Sport Premium (US)',
        '2.0i Sport Limited (US)',
        'WRX (US)',
        'WRX Premium (US)',
        'WRX Limited (US)',
        'WRX Special Edition (US)',
        'WRX STI (US)',
        'WRX STI Limited (US)',
        'WRX STI Special Edition (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2013 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2013 Impreza trim: $trim');
      }
    });

    test('2014 Impreza Models are present (Last Split Year)', () {
      final expectedTrims = [
        '2.0i (US)',
        '2.0i Premium (US)',
        '2.0i Limited (US)',
        '2.0i Sport Premium (US)',
        '2.0i Sport Limited (US)',
        'WRX (US)',
        'WRX Premium (US)',
        'WRX Limited (US)',
        'WRX STI (US)',
        'WRX STI Limited (US)',
      ];

      for (final trim in expectedTrims) {
        final found = vehicles.any(
          (v) =>
              v['year'] == 2014 && v['model'] == 'Impreza' && v['trim'] == trim,
        );
        expect(found, isTrue, reason: 'Missing 2014 Impreza trim: $trim');
      }
    });
  });
}
