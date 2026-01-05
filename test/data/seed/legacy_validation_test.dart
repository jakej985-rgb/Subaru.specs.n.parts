import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Legacy Gen 1 Validation', () {
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

    test('1990 Legacy items are present', () {
      final has1990 = vehicles.any(
        (v) => v['year'] == 1990 && v['model'] == 'Legacy',
      );
      expect(has1990, isTrue, reason: 'Missing 1990 Legacy models');
    });

    test('EJ22T Turbo models exist (1991-1994)', () {
      // Check for Sport Sedan or Touring Wagon with EJ22T
      final turbos = vehicles
          .where(
            (v) =>
                v['model'] == 'Legacy' &&
                (v['trim'].contains('Sport Sedan') ||
                    v['trim'].contains('Touring Wagon')) &&
                v['engineCode'].contains('EJ22T'),
          )
          .toList();

      // We added 1991 SS, 1992 SS/TW, 1993 SS/TW, 1994 SS/TW = 7 items
      expect(
        turbos.length,
        7,
        reason:
            'Expected 7 EJ22T turbo Legacy entries (1991-1994). Found ${turbos.length}',
      );
    });

    test('Legacy GT exists for 1994', () {
      final gt = vehicles.any(
        (v) => v['year'] == 1994 && v['trim'] == 'GT (US)',
      );
      expect(gt, isTrue, reason: 'Missing 1994 Legacy GT');
    });

    test('Gen 2 Legacy includes Outback trim (1995-1999)', () {
      // Outback started as a trim level of the Legacy
      final outbackTrim = vehicles.any(
        (v) =>
            v['model'] == 'Legacy' &&
            v['year'] == 1995 &&
            v['trim'].contains('Outback'),
      );
      expect(outbackTrim, isTrue, reason: 'Missing 1995 Legacy Outback trim');
    });

    test('Gen 2 GT uses EJ25D (1996+)', () {
      final gt96 = vehicles.firstWhere(
        (v) =>
            v['model'] == 'Legacy' &&
            v['year'] == 1996 &&
            v['trim'] == 'GT (US)',
      );
      expect(
        gt96['engineCode'],
        contains('EJ25D'),
        reason: '1996 Legacy GT should use EJ25D',
      );
    });

    test('1999 30th Anniversary Editions exist', () {
      final anniv = vehicles.where(
        (v) => v['year'] == 1999 && v['trim'].contains('30th Anniversary'),
      );
      expect(
        anniv.length,
        greaterThanOrEqualTo(3),
        reason: 'Missing 1999 30th Anniversary editions',
      );
    });

    test('Gen 3 Legacy exists (2000-2004)', () {
      final has2000 = vehicles.any(
        (v) =>
            v['year'] == 2000 &&
            v['make'] == 'Subaru' &&
            v['model'] == 'Legacy',
      );
      expect(
        has2000,
        isTrue,
        reason: 'Missing 2000 Legacy models (Gen 3 Start)',
      );

      final has2004Anniv = vehicles.any(
        (v) => v['year'] == 2004 && v['trim'].contains('35th Anniversary'),
      );
      expect(
        has2004Anniv,
        isTrue,
        reason: 'Missing 2004 35th Anniversary Legacy',
      );
    });

    test('Gen 4 Legacy Turbo returns (2005+)', () {
      // GT is back to turbo (EJ255)
      final gt05 = vehicles.firstWhere(
        (v) => v['year'] == 2005 && v['trim'] == 'GT (US)',
      );
      expect(
        gt05['engineCode'],
        contains('EJ255'),
        reason: '2005 Legacy GT must be Turbo (EJ255)',
      );
    });

    test('spec.B exists (2006-2007)', () {
      final specB = vehicles.where(
        (v) => v['model'] == 'Legacy' && v['trim'].contains('spec.B'),
      );
      expect(
        specB.length,
        greaterThanOrEqualTo(2),
        reason: 'Missing spec.B models',
      );
    });

    test('H6 3.0R models exist (2008-2009)', () {
      final h6 = vehicles.where((v) => v['engineCode'].contains('EZ30'));
      expect(
        h6.length,
        greaterThanOrEqualTo(2),
        reason: 'Missing 3.0R H6 models',
      );
    });

    test('Gen 5 Legacy GT availability (2010-2012)', () {
      final gt10 = vehicles.any(
        (v) => v['year'] == 2010 && v['trim'].contains('2.5GT'),
      );
      final gt12 = vehicles.any(
        (v) => v['year'] == 2012 && v['trim'].contains('2.5GT'),
      );
      final gt13 = vehicles.any(
        (v) => v['year'] == 2013 && v['trim'].contains('2.5GT'),
      );

      expect(gt10, isTrue, reason: '2010 should have 2.5GT');
      expect(gt12, isTrue, reason: '2012 should have 2.5GT');
      expect(
        gt13,
        isFalse,
        reason: '2013 should NOT have 2.5GT (Discontinued)',
      );
    });

    test('Gen 5 3.6R H6 upgrade (2010-2014)', () {
      final ez36 = vehicles.where(
        (v) =>
            v['year'] >= 2010 &&
            v['year'] <= 2014 &&
            v['model'] == 'Legacy' &&
            v['engineCode'].contains('EZ36'),
      );
      expect(
        ez36.length,
        greaterThanOrEqualTo(3),
        reason: 'Missing EZ36 3.6R models spread across Gen 5',
      );
    });

    test('Gen 6 Legacy 50th Anniversary (2019)', () {
      final anniv50 = vehicles.any(
        (v) => v['year'] == 2019 && v['trim'].contains('50th Anniversary'),
      );
      expect(anniv50, isTrue, reason: 'Missing 2019 50th Anniversary Legacy');
    });

    test('Gen 6 Legacy Turbo Absence (2015-2019)', () {
      final hasTurbo = vehicles.any(
        (v) =>
            v['year'] >= 2015 &&
            v['year'] <= 2019 &&
            v['model'] == 'Legacy' &&
            (v['trim'].contains('GT') || v['engineCode'].contains('Turbo')),
      );
      expect(
        hasTurbo,
        isFalse,
        reason: 'Gen 6 Legacy should NOT have any turbo models',
      );
    });

    test('Gen 7 Legacy Turbo Returns (2020+)', () {
      // FA24 Turbo intro
      final xt2020 = vehicles.where(
        (v) =>
            v['year'] == 2020 &&
            v['trim'].contains('XT') &&
            v['engineCode'].contains('FA24'),
      );
      expect(
        xt2020.length,
        greaterThanOrEqualTo(2),
        reason: '2020 Should have Limited XT and Touring XT (FA24)',
      );
    });

    test('Legacy Sport trim evolution', () {
      // 2021 Sport is NA (FB25)
      final sport21 = vehicles.firstWhere(
        (v) => v['year'] == 2021 && v['trim'] == 'Sport (US)',
      );
      expect(
        sport21['engineCode'],
        contains('FB25'),
        reason: '2021 Sport should be NA',
      );

      // 2023 Sport upgraded to Turbo (FA24)
      final sport23 = vehicles.firstWhere(
        (v) => v['year'] == 2023 && v['trim'] == 'Sport (US)',
      );
      expect(
        sport23['engineCode'],
        contains('FA24'),
        reason: '2023 Sport should be FA24 Turbo',
      );
    });
  });
}
