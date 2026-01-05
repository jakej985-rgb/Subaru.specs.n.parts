import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 5 & 6 Validation (2015-2024)', () {
    late List<dynamic> vehicles;

    setUpAll(() {
      final filePath = p.join(Directory.current.path, 'assets', 'seed', 'vehicles.json');
      final file = File(filePath);
      vehicles = json.decode(file.readAsStringSync());
    });

    test('All Gen 5 Outbacks should be Non-Turbo (2015-2019)', () {
       // All Outbacks between 2015 and 2019
       final gen5 = vehicles.where((v) => 
         v['model'] == 'Outback' && 
         v['year'] >= 2015 && 
         v['year'] <= 2019
       );

       for (final v in gen5) {
         expect(
           v['engineCode'], 
           isNot(contains('Turbo')), 
           reason: 'Year ${v['year']} Outback ${v['trim']} should NOT be Turbo (Gen 5)'
         );
       }
    });

    test('Turbo (XT) Return in 2020', () {
       // Should find XT models with FA24 Turbo
       final xt20 = vehicles.where((v) => 
         v['year'] == 2020 && 
         v['trim'].contains('XT')
       );
       expect(xt20.length, greaterThanOrEqualTo(1), reason: '2020 Outback should have XT models');

       for (final v in xt20) {
         expect(v['engineCode'], contains('FA24 Turbo'), reason: '2020 XT should be FA24 Turbo');
       }
    });

    test('3.6R Discontinued in 2020', () {
       final ez36 = vehicles.any((v) => 
          v['year'] >= 2020 && 
          v['engineCode'].contains('EZ36')
       );
       expect(ez36, isFalse, reason: '3.6R (EZ36) should not exist in 2020+');
    });

    test('Wilderness Trim Existence (2022+)', () {
       final wilderness = vehicles.where((v) => v['trim'].contains('Wilderness') && v['model'] == 'Outback');
       expect(wilderness.length, greaterThanOrEqualTo(2), reason: 'Should have at least 2 years of Wilderness Outbacks');
       
       for (final v in wilderness) {
         expect(v['engineCode'], contains('FA24 Turbo'), reason: 'Outback Wilderness is always FA24 Turbo');
       }
    });
  });
}
