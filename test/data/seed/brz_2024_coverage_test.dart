import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('2024 BRZ coverage is complete and correct', () {
    final file = File('assets/seed/vehicles.json');
    final jsonString = file.readAsStringSync();
    final List<dynamic> vehicles = json.decode(jsonString);

    final brz2024 = vehicles.where(
      (v) => v['year'] == 2024 && v['make'] == 'Subaru' && v['model'] == 'BRZ',
    );

    // Normalize trims by removing " (US)" suffix
    final trims = brz2024
        .map((v) => (v['trim'] as String).replaceAll(RegExp(r'\s*\(US\)'), ''))
        .toSet();
    final engineCodes = brz2024.map((v) => v['engineCode']).toSet();

    // Verify all expected trims are present
    expect(trims, containsAll({'Premium', 'Limited', 'tS'}));
    // expect(trims.length, 3); // Base is also present

    // Verify normalization
    expect(trims.contains('TS'), isFalse, reason: 'Should use "tS" not "TS"');

    // Verify engine code
    expect(engineCodes, {'FA24'});
  });
}
