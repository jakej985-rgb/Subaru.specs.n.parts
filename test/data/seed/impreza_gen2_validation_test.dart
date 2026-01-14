import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 2 Validation (2002-2007)', () {
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

    test('WRX Engine Evolution (2.0L vs 2.5L)', () {
      // 2002-2005 WRX = EJ205 (2.0L Turbo) - USDM specific
      final wrx02 = vehicles.firstWhere(
        (v) => v['year'] == 2002 && v['trim'] == 'WRX (US)',
      );
      final wrx05 = vehicles.firstWhere(
        (v) => v['year'] == 2005 && v['trim'] == 'WRX (US)',
      );

      expect(
        wrx02['engineCode'],
        contains('EJ205'),
        reason: '2002 WRX should be EJ205',
      );
      expect(
        wrx05['engineCode'],
        contains('EJ205'),
        reason: '2005 WRX should be EJ205',
      );

      // 2006+ WRX = EJ255 (2.5L Turbo)
      final wrx06 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2006 &&
            v['trim'].contains('WRX') &&
            !v['trim'].contains('STI') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        wrx06['engineCode'],
        contains('EJ255'),
        reason: '2006 WRX should be EJ255',
      );
    });

    test('STI Introduction (2004)', () {
      // Should NOT exist in 2002 or 2003
      final sti03 = vehicles.any(
        (v) =>
            v['year'] == 2003 &&
            v['trim'].contains('STI') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(sti03, isFalse, reason: 'STI did not exist in US in 2003');

      // Should exist in 2004
      final sti04 = vehicles.any(
        (v) => v['year'] == 2004 && v['trim'].contains('STI'),
      );
      expect(sti04, isTrue, reason: 'STI should be introduced in 2004');

      // Verify Engine
      final sti = vehicles.firstWhere(
        (v) =>
            v['trim'].contains('STI') &&
            v['year'] == 2004 &&
            v['model'] == 'Impreza' &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        sti['engineCode'],
        contains('EJ257'),
        reason: 'STI must use EJ257',
      );
    });

    test('Base Model Rename (RS vs 2.5i)', () {
      final hasRS05 = vehicles.any(
        (v) => v['year'] == 2005 && v['trim'].contains('RS'),
      );
      expect(hasRS05, isTrue, reason: '2005 should find "RS" trim');

      final has25i06 = vehicles.any(
        (v) => v['year'] == 2006 && v['trim'].contains('2.5i'),
      );
      expect(has25i06, isTrue, reason: '2006 should find "2.5i" trim');

      final hasRS06 = vehicles.any(
        (v) =>
            v['year'] == 2006 &&
            v['trim'].contains('RS') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        hasRS06,
        isFalse,
        reason: '2006 should NOT find "RS" trim (renamed to 2.5i)',
      );
    });
  });
}
