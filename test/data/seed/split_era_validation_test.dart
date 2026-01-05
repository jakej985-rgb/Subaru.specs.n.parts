import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('The Great Split (2015-2024) Validation', () {
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

    test('2015+ Impreza should use FB20', () {
      final imp15 = vehicles.firstWhere(
        (v) => v['year'] == 2015 && v['model'] == 'Impreza',
      );
      expect(
        imp15['engineCode'],
        contains('FB20'),
        reason: 'Gen 4 Impreza must use FB20',
      );

      final imp17 = vehicles.firstWhere(
        (v) => v['year'] == 2017 && v['model'] == 'Impreza',
      );
      expect(
        imp17['engineCode'],
        contains('FB20'),
        reason: 'Gen 5 Impreza must use FB20',
      );
    });

    test('2015+ WRX should use FA20 (VA Chassis)', () {
      // Note model is 'WRX', not 'Impreza'
      final wrx15 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2015 &&
            v['model'] == 'WRX' &&
            !v['trim'].contains('STI'),
      );
      expect(
        wrx15['engineCode'],
        contains('FA20'),
        reason: 'VA WRX must use FA20 Turbo',
      );
    });

    test('2015+ STI should still use EJ257', () {
      final sti15 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2015 &&
            v['model'] == 'WRX' &&
            v['trim'].contains('STI'),
      );
      expect(
        sti15['engineCode'],
        contains('EJ257'),
        reason: 'VA STI must retain EJ257',
      );

      final sti21 = vehicles.firstWhere(
        (v) => v['year'] == 2021 && v['trim'].contains('STI'),
      );
      expect(
        sti21['engineCode'],
        contains('EJ257'),
        reason: 'Final STI must use EJ257',
      );
    });

    test('2022+ WRX should use FA24 (VB Chassis)', () {
      final wrx22 = vehicles.firstWhere(
        (v) => v['year'] == 2022 && v['model'] == 'WRX',
      );
      expect(
        wrx22['engineCode'],
        contains('FA24'),
        reason: 'VB WRX must use FA24 Turbo',
      );
    });

    test('2024 Impreza RS Returns (FB25)', () {
      final rs24 = vehicles.firstWhere(
        (v) =>
            v['year'] == 2024 &&
            v['model'] == 'Impreza' &&
            v['trim'].contains('RS'),
      );
      expect(
        rs24['engineCode'],
        contains('FB25'),
        reason: '2024 RS must use 2.5L FB25',
      );
    });
  });
}
