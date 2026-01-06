import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BRZ History Coverage', () {
    late List<dynamic> vehicles;

    setUpAll(() {
      final file = File('assets/seed/vehicles.json');
      final jsonString = file.readAsStringSync();
      vehicles = json.decode(jsonString);
    });

    List<dynamic> getBrzByYear(int year) {
      return vehicles
          .where((v) =>
              v['make'] == 'Subaru' &&
              v['model'] == 'BRZ' &&
              v['year'] == year &&
              (v['trim'] as String).contains('(US)'))
          .toList();
    }

    test('No 2012 BRZ models exist for USDM', () {
      final brz2012 = getBrzByYear(2012);
      expect(brz2012, isEmpty,
          reason: 'BRZ was introduced as a 2013 model in the US');
    });

    test('No 2021 BRZ models exist for USDM (Production Gap)', () {
      final brz2021 = getBrzByYear(2021);
      expect(brz2021, isEmpty,
          reason: 'There was no 2021 model year BRZ in the US');
    });

    test('Gen 1 (2013-2020) uses FA20 NA engine', () {
      for (int year = 2013; year <= 2020; year++) {
        final brzs = getBrzByYear(year);
        // Skip years if they are missing (coverage gap) but if present they must be correct
        if (brzs.isEmpty) continue;

        for (final brz in brzs) {
          expect(brz['engineCode'], 'FA20 NA',
              reason: 'Year $year BRZ should have FA20 NA engine');
        }
      }
    });

    test('Gen 2 (2022-Present) uses FA24 engine', () {
      final currentYear = DateTime.now().year + 1; // e.g. 2025/2026
      for (int year = 2022; year <= currentYear; year++) {
        final brzs = getBrzByYear(year);
        if (brzs.isEmpty) continue;

        for (final brz in brzs) {
          expect(brz['engineCode'], 'FA24',
              reason: 'Year $year BRZ should have FA24 engine');
        }
      }
    });
  });
}
