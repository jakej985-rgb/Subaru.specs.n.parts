// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  // 1. Get Known Trims from code (hardcoded for duplicate check)
  final knownTrims = {
    'base',
    'premium',
    'limited',
    'touring',
    'sport',
    'wilderness',
    'ts',
    'gt',
    'rs',
    'xt',
    'l',
    's',
    'xs',
    'ls',
    'lsi',
    'brighton',
    'gl',
    'dl',
  };

  // 2. Load Vehicles to get actual used trims
  final vehiclesFile = File('assets/seed/vehicles.json');
  final vehiclesJson = jsonDecode(await vehiclesFile.readAsString()) as List;
  final allVehicleTrims = <String>{};

  for (var v in vehiclesJson) {
    if (v['trim'] != null) {
      allVehicleTrims.add(v['trim'].toString().toLowerCase());
    }
  }

  // 3. Load Specs to get used tags
  final specDir = Directory('assets/seed/specs');
  final specFiles = await specDir
      .list()
      .where((e) => e.path.endsWith('.json'))
      .toList();

  final allSpecTags = <String>{};
  final tagsToFiles = <String, List<String>>{};

  for (var file in specFiles) {
    if (file is File) {
      final content = await file.readAsString();
      try {
        final specs = jsonDecode(content) as List;
        for (var s in specs) {
          if (s['tags'] != null) {
            final tags = s['tags'].toString().toLowerCase().split(',');
            for (var t in tags) {
              final cleanTag = t.trim();
              if (cleanTag.isNotEmpty) {
                allSpecTags.add(cleanTag);
                tagsToFiles
                    .putIfAbsent(cleanTag, () => [])
                    .add(file.path.split(Platform.pathSeparator).last);
              }
            }
          }
        }
      } catch (e) {
        print('Error parsing ${file.path}: $e');
      }
    }
  }

  // 4. Analysis
  // Find tags that appear in vehicle trims (as whole words) but are NOT in knownTrims.
  // This implies they might be trim-specific tags that are currently leaking to other trims.

  print('--- Potentially Missing Trim Tags ---');
  print(
    '(Tags found in specs that match vehicle trim words, but are NOT in knownTrims)',
  );

  final potentialTrims = <String>{};

  for (var tag in allSpecTags) {
    if (knownTrims.contains(tag)) continue;

    // Check if this tag appears as a distinct word in any vehicle trim
    // e.g. tag "onyx" matches trim "Onyx Edition"
    bool isTrimWord = false;
    for (var vTrim in allVehicleTrims) {
      // Simple check: is the tag present as a word?
      final words = vTrim.split(RegExp(r'[^a-z0-9]'));
      if (words.contains(tag)) {
        isTrimWord = true;
        break;
      }
    }

    if (isTrimWord) {
      potentialTrims.add(tag);
      print('  - "$tag" (Files: ${tagsToFiles[tag]?.take(3).join(', ')}...)');
    }
  }

  if (potentialTrims.isEmpty) {
    print('None found.');
  }

  print('\n--- Known Trims Coverage ---');
  for (var t in knownTrims) {
    if (!allSpecTags.contains(t)) {
      print('  - "$t" is in knownTrims but NOT used in any spec tags.');
    }
  }
}
