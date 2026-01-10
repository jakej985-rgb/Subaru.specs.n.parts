import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('STI 2004 Wheel Specs', () {
    late List<dynamic> wheelSpecs;

    setUpAll(() {
      final seedDir = p.join(Directory.current.path, 'assets', 'seed', 'specs');
      final wheelFile = File(p.join(seedDir, 'wheels.json'));
      wheelSpecs = json.decode(wheelFile.readAsStringSync());
    });

    test('Has STI 2004 Specific Lug Torque', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_sti_04',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_torque_sti_04');
      expect(spec['body'], contains('65.7 ft-lb'));
      expect(spec['body'], contains('90 Nm'));
      expect(spec['tags'], contains('2004'));
    });

    test('Generic STI Gen2 Torque excludes 2004', () {
      final spec = wheelSpecs.firstWhere(
        (s) => s['id'] == 's_wheel_torque_sti_gen2',
        orElse: () => null,
      );
      expect(spec, isNotNull, reason: 'Missing s_wheel_torque_sti_gen2');
      // The tags should NOT contain 2004
      expect(spec['tags'], isNot(contains('2004')));
      expect(spec['tags'], contains('2005'));
      expect(spec['tags'], contains('2006'));
      expect(spec['tags'], contains('2007'));
    });
  });
}
