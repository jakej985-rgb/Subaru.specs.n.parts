import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Separation Validation (2000-2009)', () {
    late List<dynamic> vehicles;

    setUpAll(() {
      final filePath = p.join(
        Directory.current.path,
        'assets',
        'seed',
        'vehicles.json',
      );
      final file = File(filePath);
      vehicles = json.decode(file.readAsStringSync());
    });

    test('1999 and earlier should be Legacy Outback', () {
      // Check 1999
      final ob99 = vehicles.where(
        (v) => v['year'] == 1999 && v['trim'].contains('Outback'),
      );

      for (final v in ob99) {
        expect(
          v['model'],
          equals('Legacy'),
          reason: '1999 Outback is a Legacy trim',
        );
      }
    });

    test('2000+ should be Model: Outback', () {
      // Verify we have entries with model='Outback'
      final outbacks = vehicles.where(
        (v) => v['year'] == 2000 && v['model'] == 'Outback',
      );

      expect(
        outbacks,
        isNotEmpty,
        reason: '2000 Outback must exist as a standalone model',
      );
    });

    test('Legacy Outback should disappear in 2000 (become standalone)', () {
      // Ensure no Legacy models have 'Outback' in trim for 2000
      final legacyOutbacks = vehicles.where(
        (v) =>
            v['year'] == 2000 &&
            v['model'] == 'Legacy' &&
            v['trim'].contains('Outback'),
      );
      expect(
        legacyOutbacks,
        isEmpty,
        reason:
            'Legacy should not have Outback trims in 2000 (moved to separate model)',
      );
    });

    test('H6 Introduction (2001+)', () {
      final h6 = vehicles.firstWhere(
        (v) => v['year'] == 2001 && v['trim'].contains('H6-3.0'),
      );
      expect(
        h6['engineCode'],
        contains('EZ30'),
        reason: '2001 H6 must be EZ30',
      );
    });

    test('XT Turbo Introduction (2005+)', () {
      final xt05 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2005 &&
            v['trim'].contains('XT') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        xt05['engineCode'],
        contains('EJ255'),
        reason: '2005 XT must be EJ255 Turbo',
      );
    });
  });
}
