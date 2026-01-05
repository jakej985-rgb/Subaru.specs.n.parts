import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Outback Gen 4 Validation (2010-2014)', () {
    late List<dynamic> vehicles;

    setUpAll(() {
      final filePath = p.join(Directory.current.path, 'assets', 'seed', 'vehicles.json');
      final file = File(filePath);
      vehicles = json.decode(file.readAsStringSync());
    });

    test('NA Engine Switch (EJ253 -> FB25 in 2013)', () {
       // 2010-2012 = EJ253
       final ob10 = vehicles.firstWhere((v) => v['year'] == 2010 && v['trim'].contains('2.5i'));
       expect(ob10['engineCode'], contains('EJ253'), reason: '2010 Outback should be EJ253');
       
       final ob12 = vehicles.firstWhere((v) => v['year'] == 2012 && v['trim'].contains('2.5i'));
       expect(ob12['engineCode'], contains('EJ253'), reason: '2012 Outback should be EJ253');

       // 2013+ = FB25
       final ob13 = vehicles.firstWhere((v) => v['year'] == 2013 && v['trim'].contains('2.5i'));
       expect(ob13['engineCode'], contains('FB25'), reason: '2013 Outback should switch to FB25');
    });

    test('XT Discontinued, replaced by 3.6R', () {
       // Ensure no Turbo models in 2010+
       final turboGen4 = vehicles.any((v) => 
           v['year'] >= 2010 && 
           v['year'] <= 2014 && 
           v['trim'].contains('XT')
       );
       expect(turboGen4, isFalse, reason: 'Gen 4 Outback should NOT have XT/Turbo');

       // Ensure 3.6R exists
       final h6Gen4 = vehicles.any((v) => 
           v['year'] == 2010 && 
           v['trim'].contains('3.6R') && 
           v['engineCode'].contains('EZ36')
       );
       expect(h6Gen4, isTrue, reason: 'Gen 4 Outback should have 3.6R (EZ36)');
    });
  });
}
