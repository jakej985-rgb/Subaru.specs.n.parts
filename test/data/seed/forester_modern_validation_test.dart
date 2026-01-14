import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 3 & 4 Validation (2009-2018)', () {
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

    test('Forester XT Engine Transition (EJ255 -> FA20DIT)', () {
      // 2013 XT = EJ255
      final xt13 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2013 &&
            v['trim'].contains('XT') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        xt13['engineCode'],
        contains('EJ255'),
        reason: '2013 XT should be the final EJ255',
      );

      // 2014 XT = FA20DIT (First year of SJ)
      final xt14 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2014 &&
            v['trim'].contains('XT') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        xt14['engineCode'],
        contains('FA20'),
        reason: '2014 XT should be FA20 Turbo',
      );
    });

    test('NA Engine Transition (EJ253 -> FB25)', () {
      // 2010 2.5X = EJ253
      final na10 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2010 &&
            v['trim'].contains('2.5X Premium') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        na10['engineCode'],
        contains('EJ253'),
        reason: '2010 should be EJ253',
      );

      // 2011 2.5X = FB25 (First year of FB)
      final na11 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2011 &&
            v['trim'].contains('2.5X Touring') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        na11['engineCode'],
        contains('FB25'),
        reason: '2011 should satisfy the FB25 switch',
      );
    });

    test('2018 Black Edition exists', () {
      final blackEd = vehicles.any(
        (v) => v['year'] == 2018 && v['trim'].contains('Black Edition'),
      );
      expect(blackEd, isTrue, reason: 'Missing 2018 Black Edition Forester');
    });
  });
}
