import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/domain/engines/engine_parse.dart';

void main() {
  group('parseEngineKey', () {
    test('parses standard engine code with NA suffix', () {
      final key = parseEngineKey('EA71 NA');
      expect(key.family, 'EA');
      expect(key.motor, 'EA71');
    });

    test('parses turbocharged engine code', () {
      final key = parseEngineKey('EJ205 Turbo');
      expect(key.family, 'EJ');
      expect(key.motor, 'EJ205');
    });

    test('parses engine code with T suffix (turbo variant)', () {
      final key = parseEngineKey('EJ22T Turbo');
      expect(key.family, 'EJ');
      expect(key.motor, 'EJ22T');
    });

    test('parses modern FA engine without suffix', () {
      final key = parseEngineKey('FA24F');
      expect(key.family, 'FA');
      expect(key.motor, 'FA24F');
    });

    test('parses flat-6 engine code', () {
      final key = parseEngineKey('ER27 NA');
      expect(key.family, 'ER');
      expect(key.motor, 'ER27');
    });

    test('parses EZ series flat-6', () {
      final key = parseEngineKey('EZ30R');
      expect(key.family, 'EZ');
      expect(key.motor, 'EZ30R');
    });

    test('parses kei car engine with EN prefix', () {
      final key = parseEngineKey('EN07 NA');
      expect(key.family, 'EN');
      expect(key.motor, 'EN07');
    });

    test('parses small engine with EF prefix', () {
      final key = parseEngineKey('EF12 NA');
      expect(key.family, 'EF');
      expect(key.motor, 'EF12');
    });

    test('handles supercharged designation', () {
      final key = parseEngineKey('EF12 Supercharged');
      expect(key.family, 'EF');
      expect(key.motor, 'EF12');
    });

    test('handles dash-separated input', () {
      final key = parseEngineKey('EJ25-SOHC');
      expect(key.family, 'EJ');
      expect(key.motor, 'EJ25');
    });

    test('handles comma-separated input', () {
      final key = parseEngineKey('FB25, 2.5L');
      expect(key.family, 'FB');
      expect(key.motor, 'FB25');
    });

    test('returns UNK for null input', () {
      final key = parseEngineKey(null);
      expect(key.family, 'UNK');
      expect(key.motor, 'Unknown');
    });

    test('returns UNK for empty input', () {
      final key = parseEngineKey('');
      expect(key.family, 'UNK');
      expect(key.motor, 'Unknown');
    });

    test('returns UNK for whitespace-only input', () {
      final key = parseEngineKey('   ');
      expect(key.family, 'UNK');
      expect(key.motor, 'Unknown');
    });

    test('handles lowercase input (converts to uppercase)', () {
      final key = parseEngineKey('ej205 turbo');
      expect(key.family, 'EJ');
      expect(key.motor, 'EJ205');
    });

    test('handles numeric-only input (assigns UNK family)', () {
      final key = parseEngineKey('205');
      expect(key.family, 'UNK');
      expect(key.motor, '205');
    });
  });

  group('compareFamilies', () {
    test('prioritizes EA before EJ', () {
      expect(compareFamilies('EA', 'EJ'), lessThan(0));
    });

    test('prioritizes EJ before FA', () {
      expect(compareFamilies('EJ', 'FA'), lessThan(0));
    });

    test('prioritizes FA before FB', () {
      expect(compareFamilies('FA', 'FB'), lessThan(0));
    });

    test('prioritizes priority families before unknown families', () {
      expect(compareFamilies('EJ', 'ZZ'), lessThan(0));
      expect(compareFamilies('FA', 'XY'), lessThan(0));
    });

    test('sorts unknown families alphabetically', () {
      expect(compareFamilies('XX', 'YY'), lessThan(0));
      expect(compareFamilies('ZZ', 'AA'), greaterThan(0));
    });

    test('returns 0 for same family', () {
      expect(compareFamilies('EJ', 'EJ'), equals(0));
    });
  });

  group('compareMotors', () {
    test('sorts by numeric part within same prefix', () {
      expect(compareMotors('EJ18', 'EJ22'), lessThan(0));
      expect(compareMotors('EJ22', 'EJ25'), lessThan(0));
    });

    test('sorts 2-digit codes before 3-digit codes', () {
      expect(compareMotors('EJ25', 'EJ205'), lessThan(0));
      expect(compareMotors('EJ22', 'EJ255'), lessThan(0));
    });

    test('sorts 3-digit codes correctly', () {
      expect(compareMotors('EJ205', 'EJ207'), lessThan(0));
      expect(compareMotors('EJ207', 'EJ255'), lessThan(0));
      expect(compareMotors('EJ255', 'EJ257'), lessThan(0));
    });

    test('sorts T suffix variants after base', () {
      expect(compareMotors('EJ22', 'EJ22T'), lessThan(0));
    });

    test('sorts FA variants correctly', () {
      expect(compareMotors('FA20', 'FA20F'), lessThan(0));
      expect(compareMotors('FA20F', 'FA24'), lessThan(0));
      expect(compareMotors('FA24', 'FA24F'), lessThan(0));
    });

    test('handles EA series sorting', () {
      expect(compareMotors('EA71', 'EA81'), lessThan(0));
      expect(compareMotors('EA81', 'EA82'), lessThan(0));
    });
  });

  group('EngineKey', () {
    test('equality works correctly', () {
      const key1 = EngineKey(family: 'EJ', motor: 'EJ205');
      const key2 = EngineKey(family: 'EJ', motor: 'EJ205');
      const key3 = EngineKey(family: 'EJ', motor: 'EJ207');

      expect(key1, equals(key2));
      expect(key1, isNot(equals(key3)));
    });

    test('hashCode is consistent', () {
      const key1 = EngineKey(family: 'EJ', motor: 'EJ205');
      const key2 = EngineKey(family: 'EJ', motor: 'EJ205');

      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('toString returns readable format', () {
      const key = EngineKey(family: 'EJ', motor: 'EJ205');
      expect(key.toString(), contains('EJ'));
      expect(key.toString(), contains('EJ205'));
    });
  });

  group('Engine grouping integration', () {
    test('groups multiple engine codes by family correctly', () {
      final engineCodes = [
        'EJ205 Turbo',
        'EJ207 Turbo',
        'EJ22 NA',
        'FA24F',
        'FA20F',
        'EA81 NA',
        'FB25',
      ];

      final Map<String, Set<String>> familyToMotors = {};

      for (final code in engineCodes) {
        final key = parseEngineKey(code);
        familyToMotors.putIfAbsent(key.family, () => <String>{}).add(key.motor);
      }

      expect(
        familyToMotors.keys.toSet(),
        containsAll(['EA', 'EJ', 'FA', 'FB']),
      );
      expect(familyToMotors['EJ'], containsAll(['EJ205', 'EJ207', 'EJ22']));
      expect(familyToMotors['FA'], containsAll(['FA24F', 'FA20F']));
      expect(familyToMotors['EA'], contains('EA81'));
      expect(familyToMotors['FB'], contains('FB25'));
    });

    test('sorted families follow priority order', () {
      final families = ['FB', 'EJ', 'FA', 'EA', 'EN'];
      families.sort(compareFamilies);

      expect(families, orderedEquals(['EA', 'EJ', 'FA', 'FB', 'EN']));
    });

    test('sorted motors within family follow natural order', () {
      final ejMotors = ['EJ257', 'EJ18', 'EJ205', 'EJ25', 'EJ22', 'EJ207'];
      ejMotors.sort(compareMotors);

      expect(
        ejMotors,
        orderedEquals(['EJ18', 'EJ22', 'EJ25', 'EJ205', 'EJ207', 'EJ257']),
      );
    });
  });
}
