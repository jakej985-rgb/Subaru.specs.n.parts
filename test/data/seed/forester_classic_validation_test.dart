import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 1 & 2 Validation (1998-2008)', () {
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

    test('1998 Forester (Gen 1 Launch) exists', () {
      final f98 = vehicles.any(
        (v) => v['year'] == 1998 && v['model'] == 'Forester',
      );
      expect(f98, isTrue, reason: 'Missing 1998 Forester');
    });

    test('Forester XT Turbo Introduction (2004)', () {
      // Should not exist in 2003
      final xt03 = vehicles.any(
        (v) =>
            v['year'] == 2003 &&
            v['model'] == 'Forester' &&
            v['trim'].contains('XT') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(xt03, isFalse, reason: 'Forester XT did not exist in 2003 (USDM)');

      // Should exist in 2004 with Turbo
      final xt04 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2004 &&
            v['trim'].contains('XT') &&
            !(v['trim'] as String).contains('(JDM)'),
      );
      expect(
        xt04['engineCode'],
        contains('EJ255'),
        reason: '2004 Forester XT must be EJ255 Turbo',
      );
    });

    test('Sports 2.5 XT exists (2007-2008)', () {
      // The "STI-look" Forester
      final sportsXT = vehicles.where(
        (v) => v['model'] == 'Forester' && v['trim'].contains('Sports 2.5 XT'),
      );
      expect(
        sportsXT.length,
        greaterThanOrEqualTo(2),
        reason: 'Missing Sports 2.5 XT (2007-2008)',
      );
    });
  });
}
