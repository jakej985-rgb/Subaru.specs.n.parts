import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final file = File('assets/seed/specs.json');
  if (!await file.exists()) {
    print('specs.json not found');
    exit(1);
  }

  final content = await file.readAsString();
  final List<dynamic> specs = jsonDecode(content);

  final Map<String, List<dynamic>> byCategory = {};

  for (final spec in specs) {
    if (spec is Map<String, dynamic> && spec.containsKey('category')) {
      final category = spec['category'].toString();
      if (!byCategory.containsKey(category)) {
        byCategory[category] = [];
      }
      byCategory[category]!.add(spec);
    }
  }

  final outputDir = Directory('assets/seed/specs');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  final encoder = JsonEncoder.withIndent('  ');

  for (final category in byCategory.keys) {
    final filename = '${category.toLowerCase().replaceAll(' ', '_')}.json';
    final outputFile = File('${outputDir.path}/$filename');
    await outputFile.writeAsString(encoder.convert(byCategory[category]));
    print('Created $filename (${byCategory[category]!.length} specs)');
  }
}
