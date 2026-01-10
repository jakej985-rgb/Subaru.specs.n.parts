import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Forester Gen 5 Validation (2019-2024)', () {
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

    test('All Gen 5 Foresters should be non-turbo (FB25)', () {
      // All Foresters between 2019 and 2024
      final gen5 = vehicles.where(
        (v) =>
            v['model'] == 'Forester' &&
            v['year'] >= 2019 &&
            v['year'] <= 2024 &&
            !(v['trim'] as String).contains('(JDM)'),
      );

      for (final v in gen5) {
        expect(
          v['engineCode'],
          contains('FB25'),
          reason:
              'Year ${v['year']} Forester ${v['trim']} should be FB25 (Non-Turbo). Found: ${v['engineCode']}',
        );
        expect(
          v['engineCode'],
          isNot(contains('Turbo')),
          reason: 'Year ${v['year']} Forester ${v['trim']} should NOT be Turbo',
        );
      }
    });

    test('Wilderness Trim Introduction (2022)', () {
      final wilderness22 = vehicles.any(
        (v) => v['year'] == 2022 && v['trim'].contains('Wilderness'),
      );
      expect(
        wilderness22,
        isTrue,
        reason: '2022 Forester should have Wilderness trim',
      );
    });

    test('Sport trim should be NA (FB25)', () {
      final sport19 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2019 &&
            v['trim'].contains('Sport') &&
            v['model'] == 'Forester',
      );
      expect(
        sport19['engineCode'],
        contains('FB25'),
        reason: '2019 Sport should be FB25 NA',
      );
    });
  });
}
