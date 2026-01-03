import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Spec Data Validation', () {
    late List<dynamic> specs;

    setUpAll(() {
      final file = File('assets/seed/specs.json');
      final content = file.readAsStringSync();
      specs = json.decode(content);
    });

    test('Fluid capacities must follow standard format', () {
      final fluidPattern = RegExp(r'^[\d\.\s-]+ Liters \([\d\.\s-]+ Quarts\).*');
      final fluidCategories = ['Oil', 'Coolant', 'Transmission', 'Fluids'];

      for (final spec in specs) {
        final category = spec['category'];
        final title = spec['title'];
        final body = spec['body'];

        if (fluidCategories.contains(category) && title.contains('Capacity')) {
          expect(
            fluidPattern.hasMatch(body),
            isTrue,
            reason: 'Invalid Fluid Format for ID ${spec['id']} ($title): "$body". Expected "X.X Liters (Y.Y Quarts)..."',
          );
        }
      }
    });

    test('Torque specs must follow standard format', () {
      final torquePattern = RegExp(r'^[\d\.\s-]+ ft-lbs \([\d\.\s-]+ Nm\).*');

      for (final spec in specs) {
        final category = spec['category'];
        final title = spec['title'];
        final body = spec['body'];

        if (category == 'Torque') {
          expect(
            torquePattern.hasMatch(body),
            isTrue,
            reason: 'Invalid Torque Format for ID ${spec['id']} ($title): "$body". Expected "X.X ft-lbs (Y.Y Nm)..."',
          );
        }
      }
    });

    test('Key platforms must have Oil Capacity specs', () {
      bool hasGd = false;
      bool hasVa = false;
      bool hasVb = false;

      for (final spec in specs) {
        final tags = (spec['tags'] as String).toLowerCase();
        if (tags.contains('oil') && tags.contains('capacity')) {
          if (tags.contains('gd') || tags.contains('ej205') || tags.contains('ej257')) hasGd = true;
          if (tags.contains('va') || tags.contains('fa20')) hasVa = true;
          if (tags.contains('vb') || tags.contains('fa24')) hasVb = true;
        }
      }

      expect(hasGd, isTrue, reason: 'Missing Oil Capacity spec for GD platform');
      expect(hasVa, isTrue, reason: 'Missing Oil Capacity spec for VA platform');
      expect(hasVb, isTrue, reason: 'Missing Oil Capacity spec for VB platform');
    });

    test('Key platforms must have Bolt Pattern specs', () {
      bool hasGd = false;
      bool hasVa = false;
      bool hasVb = false;
      bool hasGdSti04 = false;

      for (final spec in specs) {
        final tags = (spec['tags'] as String).toLowerCase();
        final title = (spec['title'] as String);

        if (tags.contains('bolt_pattern')) {
          if (tags.contains('gd') && tags.contains('wrx')) hasGd = true;
          if (tags.contains('va') && (tags.contains('wrx') || tags.contains('sti'))) hasVa = true;
          if (tags.contains('vb') && tags.contains('wrx')) hasVb = true;

          // Specific check for the 2004 STI exception
          if (tags.contains('gd') && tags.contains('sti') && tags.contains('2004')) {
             if (spec['body'] == '5x100') hasGdSti04 = true;
          }
        }
      }

      expect(hasGd, isTrue, reason: 'Missing Bolt Pattern spec for GD WRX');
      expect(hasVa, isTrue, reason: 'Missing Bolt Pattern spec for VA WRX/STI');
      expect(hasVb, isTrue, reason: 'Missing Bolt Pattern spec for VB WRX');
      expect(hasGdSti04, isTrue, reason: 'Missing 2004 STI specific Bolt Pattern (5x100)');
    });

    test('Specs with "Capacity" in title must have "capacity" tag', () {
      for (final spec in specs) {
        final title = (spec['title'] as String);
        final tags = (spec['tags'] as String).toLowerCase();

        if (title.toLowerCase().contains('capacity')) {
          expect(tags.contains('capacity'), isTrue,
              reason: 'Spec "${spec['id']}" with title "$title" is missing "capacity" tag');
        }
      }
    });
  });
}
