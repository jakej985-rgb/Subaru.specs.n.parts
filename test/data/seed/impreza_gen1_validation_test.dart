import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Impreza Gen 1 Validation', () {
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

    test('1993 Impreza (Gen 1 Start) exists', () {
      final has1993 = vehicles.any(
        (v) => v['year'] == 1993 && v['model'] == 'Impreza',
      );
      expect(has1993, isTrue, reason: 'Missing 1993 Impreza models');
    });

    test('2.5 RS Evolution (1998-2001)', () {
      // 1998 2.5 RS = EJ25D (DOHC)
      final rs98 = vehicles.firstWhere(
        (v) => v['trim'] == '2.5 RS (US)' && v['year'] == 1998,
      );
      expect(
        rs98['engineCode'],
        contains('EJ25D'),
        reason: '1998 2.5 RS must be DOHC EJ25D',
      );

      // 1999 2.5 RS = EJ251 (SOHC)
      final rs99 = vehicles.firstWhere(
        (v) => v['trim'] == '2.5 RS (US)' && v['year'] == 1999,
      );
      expect(
        rs99['engineCode'],
        contains('EJ251'),
        reason: '1999 2.5 RS must be SOHC EJ251',
      );

      // 2000-2001 2.5 RS Coupe/Sedan split
      final rs00Seq = vehicles.where(
        (v) => v['year'] == 2000 && v['trim'].contains('2.5 RS'),
      );
      expect(
        rs00Seq.length,
        greaterThanOrEqualTo(2),
        reason: '2000 should have Coupe and Sedan RS',
      );
    });

    test('Outback Sport exists (1995-1996)', () {
      final obs = vehicles.where((v) => v['trim'].contains('Outback Sport'));
      // We added 1995 and 1996 OBS
      expect(
        obs.length,
        greaterThanOrEqualTo(2),
        reason: 'Missing early Outback Sport models',
      );
    });
  });
}
