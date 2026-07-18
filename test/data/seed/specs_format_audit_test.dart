import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Spec Auditor: Comprehensive Format Consistency', () {
    late List<dynamic> specs;

    setUpAll(() {
      final specsDir = Directory(
        p.join(Directory.current.path, 'assets', 'seed', 'specs'),
      );
      if (!specsDir.existsSync()) {
        throw Exception('Specs directory not found at ${specsDir.path}');
      }

      specs = [];
      final excludeFiles = {
        'index.json',
        'fluids.json',
        'maintenance.json',
        'engines.json',
        'bulbs.json',
        'bulbs_temp.json',
        'bulbs.json.legacy.json',
        'torque_specs.json',
      };
      final files = specsDir.listSync().whereType<File>().where(
            (f) =>
                f.path.endsWith('.json') &&
                !excludeFiles.contains(p.basename(f.path)),
          );

      for (final file in files) {
        final content = file.readAsStringSync();
        final List<dynamic> fileSpecs = json.decode(content);
        specs.addAll(fileSpecs);
      }
    });

    // 1. TORQUE: "X ft-lbs (Y Nm)..."
    test('Torque specs: strict "X ft-lbs (Y Nm)" format', () {
      final torquePattern = RegExp(r'^[\d\.\s-]+ ft-lbs \([\d\.\s-]+ Nm\).*');
      final torqueSpecs = specs.where((s) => s['category'] == 'Torque');

      for (final spec in torqueSpecs) {
        if (spec['body'] == null) continue;
        expect(
          torquePattern.hasMatch(spec['body']),
          isTrue,
          reason: '[${spec['id']}] Torque format fail: "${spec['body']}"',
        );
      }
    });

    // 2. OIL CAPACITY: "X.X Liters (Y.Y Quarts)..."
    test('Oil Capacity specs: strict "X Liters (Y Quarts)" format', () {
      final fluidPattern = RegExp(
        r'^[\d\.\s-]+ Liters \([\d\.\s-]+ Quarts\).*',
      );
      final oilSpecs = specs.where(
        (s) =>
            s['category'] == 'Oil' &&
            s['title'].toString().contains('Capacity'),
      );

      for (final spec in oilSpecs) {
        if (spec['body'] == null) continue;
        expect(
          fluidPattern.hasMatch(spec['body']),
          isTrue,
          reason: '[${spec['id']}] Oil Capacity format fail: "${spec['body']}"',
        );
      }
    });

    // 3. WIPER BLADES: "Driver: X". Passenger: Y"."
    test('Wiper specs: dot-separated sentence format', () {
      final wiperSpecs = specs.where(
        (s) => s['title'].toString().contains('Wiper'),
      );

      for (final spec in wiperSpecs) {
        if (spec['body'] == null) continue;
        // Should use periods, not pipes
        expect(
          spec['body'].toString().contains('|'),
          isFalse,
          reason:
              '[${spec['id']}] Wiper uses pipe separator: "${spec['body']}"',
        );
        // Should start with "Driver:"
        expect(
          spec['body'].toString().startsWith('Driver:'),
          isTrue,
          reason:
              '[${spec['id']}] Wiper should start with "Driver:": "${spec['body']}"',
        );
      }
    });

    // 4. SPARK PLUGS: Gap must have metric conversion "(X.Xmm)"
    test('Spark Plug specs: Gap must include metric', () {
      final plugSpecs = specs.where(
        (s) =>
            s['category'] == 'Spark Plugs' ||
            (s['title'].toString().contains('Spark Plug') &&
                s['body'].toString().contains('Gap:')),
      );

      for (final spec in plugSpecs) {
        if (spec['body'] == null) continue;
        if (!spec['body'].toString().contains('Gap:')) continue;

        expect(
          spec['body'].toString().contains('mm'),
          isTrue,
          reason:
              '[${spec['id']}] Spark Plug Gap missing metric (mm): "${spec['body']}"',
        );
      }
    });

    // 5. ALIGNMENT: Degrees must use "°" symbol
    test('Alignment specs: Degrees must use ° symbol', () {
      final alignSpecs = specs.where((s) => s['category'] == 'Alignment');

      for (final spec in alignSpecs) {
        if (spec['body'] == null) continue;
        // If it mentions degrees, it should use the symbol
        if (spec['body'].toString().contains('degree')) {
          fail(
            '[${spec['id']}] Alignment uses "degree" word instead of °: "${spec['body']}"',
          );
        }
      }
    });

    // 6. BOLT PATTERN: Must be in "5x100" or "5x114.3" format
    test('Bolt Pattern specs: consistent X×Y format', () {
      final wheelSpecs = specs.where(
        (s) => s['title'].toString().contains('Bolt Pattern'),
      );

      final boltPattern = RegExp(r'^\d+x\d+(\.\d+)?');
      for (final spec in wheelSpecs) {
        if (spec['body'] == null) continue;
        expect(
          boltPattern.hasMatch(spec['body']),
          isTrue,
          reason: '[${spec['id']}] Bolt Pattern format fail: "${spec['body']}"',
        );
      }
    });

    // 7. NO TRAILING WHITESPACE in body
    test('No trailing whitespace in spec bodies', () {
      for (final spec in specs) {
        if (spec['body'] == null) continue;
        final body = spec['body'].toString();
        expect(
          body.trim() == body,
          isTrue,
          reason:
              '[${spec['id']}] Trailing/leading whitespace: "${spec['body']}"',
        );
      }
    });

    // 8. ALL SPECS HAVE REQUIRED FIELDS
    test('All specs have required fields (id, category, title, body)', () {
      for (final spec in specs) {
        expect(spec['id'], isNotNull, reason: 'Spec missing id');
        expect(
          spec['category'],
          isNotNull,
          reason: '[${spec['id']}] missing category',
        );
        expect(
          spec['title'],
          isNotNull,
          reason: '[${spec['id']}] missing title',
        );
        expect(spec['body'], isNotNull, reason: '[${spec['id']}] missing body');
      }
    });

    // 9. NO DUPLICATE IDs
    test('No duplicate spec IDs', () {
      final ids = <String>{};
      for (final spec in specs) {
        final id = spec['id'].toString();
        expect(ids.contains(id), isFalse, reason: 'Duplicate spec ID: $id');
        ids.add(id);
      }
    });

    // 10. ALL IDs ARE DESCRIPTIVE (not just "sNN")
    test('All spec IDs are descriptive (not just sNN)', () {
      final numericPattern = RegExp(r'^s\d+$');
      for (final spec in specs) {
        final id = spec['id'].toString();
        expect(
          numericPattern.hasMatch(id),
          isFalse,
          reason:
              'Non-descriptive ID found: $id (title: ${spec['title']}). IDs should follow s_category_descriptor pattern.',
        );
      }
    });

    // 11. CATEGORY NAMES DON'T HAVE UNDERSCORES
    test('Category names use spaces, not underscores', () {
      for (final spec in specs) {
        final category = spec['category'].toString();
        expect(
          category.contains('_'),
          isFalse,
          reason: 'Category "$category" uses underscore. Use spaces instead.',
        );
      }
    });

    // 12. TAGS DON'T HAVE SPACES AFTER COMMAS
    test('Tags use comma-only separation (no spaces)', () {
      final badTagPattern = RegExp(r',\s+');
      for (final spec in specs) {
        if (spec['tags'] == null) continue;
        final tags = spec['tags'].toString();
        expect(
          badTagPattern.hasMatch(tags),
          isFalse,
          reason: 'Spec [${spec['id']}] has tags with spaces: "$tags"',
        );
        // Also check for trailing commas
        expect(
          tags.endsWith(','),
          isFalse,
          reason: 'Spec [${spec['id']}] has trailing comma in tags: "$tags"',
        );
      }
    });

    // 13. DATE FORMAT IS ISO 8601 WITH Z SUFFIX (no microseconds)
    test('Dates use ISO 8601 format with Z suffix', () {
      // Valid: 2025-12-16T16:27:05Z
      // Invalid: 2025-12-16T16:27:05.198660
      final validDatePattern = RegExp(
        r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$',
      );
      for (final spec in specs) {
        if (spec['updatedAt'] == null) continue;
        final date = spec['updatedAt'].toString();
        expect(
          validDatePattern.hasMatch(date),
          isTrue,
          reason:
              'Spec [${spec['id']}] has invalid date format: "$date". Expected YYYY-MM-DDTHH:MM:SSZ',
        );
      }
    });

    // 14. ALL IDs START WITH s_ PREFIX
    test('All spec IDs start with s_ prefix', () {
      for (final spec in specs) {
        final id = spec['id'].toString();
        expect(
          id.startsWith('s_'),
          isTrue,
          reason: 'Spec ID "$id" does not start with s_ prefix',
        );
      }
    });

    // 15. NO DOUBLE SPACES IN BODY TEXT
    test('No double spaces in body text', () {
      for (final spec in specs) {
        if (spec['body'] == null) continue;
        final body = spec['body'].toString();
        expect(
          body.contains('  '),
          isFalse,
          reason: 'Spec [${spec['id']}] has double spaces in body',
        );
      }
    });

    // 16. TITLES START WITH UPPERCASE
    test('All titles start with uppercase letter', () {
      final uppercaseStart = RegExp(r'^[A-Z0-9]');
      for (final spec in specs) {
        final title = spec['title'].toString();
        expect(
          uppercaseStart.hasMatch(title),
          isTrue,
          reason:
              'Spec [${spec['id']}] title does not start with uppercase: "$title"',
        );
      }
    });

    // 17. TAGS ARE NOT EMPTY
    test('All specs have at least one tag', () {
      for (final spec in specs) {
        final tags = spec['tags']?.toString() ?? '';
        expect(
          tags.isNotEmpty,
          isTrue,
          reason: 'Spec [${spec['id']}] has empty tags',
        );
        expect(
          tags.split(',').where((t) => t.isNotEmpty).isNotEmpty,
          isTrue,
          reason: 'Spec [${spec['id']}] has no valid tags',
        );
      }
    });
  });
}
