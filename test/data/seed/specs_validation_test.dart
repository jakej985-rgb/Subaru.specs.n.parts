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
  });
}
