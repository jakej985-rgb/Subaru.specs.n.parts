import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'dart:io';

void main() {
  test('Coverage: 2024 WRX Trims (USDM)', () async {
    // Expected trims for 2024 Subaru WRX in USDM market
    // Source: Subaru.com / Media Center
    final expectedTrims = {
      'Base',
      'Premium',
      'Limited',
      'TR', // New for 2024
      'GT'
    };

    final file = File('assets/seed/vehicles.json');
    final content = await file.readAsString();
    final vehicles = parseVehicles(content);

    final wrx2024 = vehicles.where((v) =>
      v.year == 2024 &&
      (v.model == 'WRX' || v.model == 'Subaru WRX') // Handle potential normalization
    ).toList();

    final foundTrims = wrx2024.map((v) => v.trim).toSet();

    final missing = expectedTrims.difference(foundTrims);

    if (missing.isNotEmpty) {
      fail('Missing expected 2024 WRX Trims: $missing. Coverage is incomplete.');
    }

    expect(foundTrims.containsAll(expectedTrims), isTrue);
  });
}
