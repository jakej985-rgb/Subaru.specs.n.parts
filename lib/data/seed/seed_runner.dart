import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/domain/fitment/fitment_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final seedRunnerProvider = Provider<SeedRunner>((ref) {
  final db = ref.watch(appDbProvider);
  return SeedRunner(db);
});

class SeedRunner {
  final AppDatabase db;

  SeedRunner(this.db);

  Future<void> runSeedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    // Version 1: Initial seed
    // Version 2: Added Impreza CSV data
    // Version 12: Modern Era (GR/GV, BRZ, VA, Ascent, FA Series)
    // Version 17: Spec Cleanup (IDs, Units, Categories, Validation)
    // Version 18: Dynamic Tag Expansion (Years from Title)
    const int kCurrentSeedVersion = 20;
    final int lastSeedVersion = prefs.getInt('seed_version') ?? 0;

    // Check old flag for legacy migration
    final bool legacySeeded = prefs.getBool('is_seeded') ?? false;
    int effectiveVersion = lastSeedVersion;
    if (legacySeeded && lastSeedVersion == 0) {
      effectiveVersion = 1;
    }

    if (effectiveVersion < kCurrentSeedVersion) {
      debugPrint(
        'Starting seed process (v$effectiveVersion -> v$kCurrentSeedVersion)...',
      );
      await _seedVehicles();
      await _seedSpecs();
      await _seedParts();

      await prefs.setInt('seed_version', kCurrentSeedVersion);
      await prefs.setBool('is_seeded', true);
      debugPrint('Seeding complete.');
    } else {
      debugPrint('Seed already up to date (v$effectiveVersion).');
    }
  }

  Future<void> _seedVehicles() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/seed/vehicles.json',
      );
      final List<Vehicle> vehicles = await compute<String, List<Vehicle>>(
        parseVehicles,
        response,
      );
      await db.vehiclesDao.insertMultiple(vehicles);
      debugPrint('Seeded ${vehicles.length} vehicles.');
    } catch (e) {
      debugPrint('Error loading vehicles.json: $e');
    }
  }

  Future<void> _seedSpecs() async {
    try {
      final String manifestRaw = await rootBundle.loadString(
        'assets/seed/specs/index.json',
      );
      final manifest = jsonDecode(manifestRaw) as Map<String, dynamic>;
      final files = (manifest['files'] as List).cast<String>();

      if (files.isEmpty) {
        debugPrint('Warning: index.json listed 0 files.');
        return;
      }

      for (final file in files) {
        try {
          final String response = await rootBundle.loadString(
            'assets/seed/specs/$file',
          );
          final List<Spec> specs = await compute<String, List<Spec>>(
            parseSpecs,
            response,
          );
          await db.specsDao.insertMultiple(specs);
          debugPrint('Seeded ${specs.length} specs from $file.');
        } catch (e) {
          debugPrint('Error seeding $file: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading specs from split files: $e');
    }
  }

  Future<void> _seedParts() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/seed/parts.json',
      );
      final List<Part> parts = await compute<String, List<Part>>(
        parseParts,
        response,
      );

      await db.partsDao.insertMultiple(parts);
      debugPrint('Seeded ${parts.length} parts.');
    } catch (e) {
      debugPrint('Error loading parts.json: $e');
    }
  }
}

List<Vehicle> parseVehicles(String response) {
  final List<dynamic> data = json.decode(response);
  return data.map((json) {
    final map = json as Map<String, dynamic>;
    return Vehicle(
      id: map['id'],
      year: map['year'],
      make: map['make'],
      model: map['model'],
      trim: map['trim'],
      engineCode: map['engineCode'],
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }).toList();
}

List<Spec> parseSpecs(String response) {
  final List<dynamic> data = json.decode(response);
  if (data.isEmpty) return [];

  // Detect format: Fitment Row vs Legacy Spec
  final first = data.first as Map<String, dynamic>;
  if (first.containsKey('function_key') || first.containsKey('year')) {
    // New csv-synced format
    return _parseFitmentRows(data);
  }

  // Legacy format
  return data.map((json) {
    final map = json as Map<String, dynamic>;

    // Normalize and Expand Tags with Years
    String tags = map['tags'] ?? '';
    final String title = map['title'] ?? '';
    tags = _enrichTagsWithYears(tags, title);

    return Spec(
      id: map['id'],
      category: map['category'],
      title: title,
      body: map['body'],
      tags: tags,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }).toList();
}

List<Spec> _parseFitmentRows(List<dynamic> data) {
  final List<Spec> specs = [];

  for (final json in data) {
    final map = json as Map<String, dynamic>;

    if (map.containsKey('function_key')) {
      // Tall format (Bulbs, etc.)
      specs.add(_parseTallRow(map));
    } else {
      // Wide format (Fluids, Maintenance, etc.)
      specs.addAll(_parseWideRow(map));
    }
  }
  return specs;
}

Spec _parseTallRow(Map<String, dynamic> map) {
  // Construct a unique ID
  final String compositeKey = [
    map['year'],
    map['make'],
    map['model'],
    map['trim'],
    map['body'],
    map['market'],
    map['function_key'],
    map['location_hint'],
  ].join('|');

  final id = 'fit_${compositeKey.hashCode}';

  String body = 'n/a';
  String category = 'Fitment';

  if (map.containsKey('bulb_code')) {
    category = 'Bulbs';
    body = map['bulb_code'].toString();
    if (map['tech'] != null && map['tech'] != 'n/a') {
      body += ' (${map['tech']})';
    }
  } else if (map.containsKey('capacity')) {
    category = 'Fluids';
    body = map['capacity'].toString();
  } else if (map.containsKey('value')) {
    body = map['value'].toString();
  } else {
    body = map.values
        .firstWhere((v) => v != null, orElse: () => 'n/a')
        .toString();
  }

  final String title =
      map['function_key']?.toString().replaceAll('_', ' ').toUpperCase() ??
      'UNKNOWN';
  final String sub = map['location_hint'] ?? '';
  final String displayTitle = sub.isNotEmpty ? '$title - $sub' : title;
  final tags = _buildTags(map);

  return Spec(
    id: id,
    category: category,
    title: displayTitle,
    body: body,
    tags: tags,
    updatedAt: DateTime.now(),
  );
}

List<Spec> _parseWideRow(Map<String, dynamic> map) {
  final List<Spec> rowSpecs = [];
  final ignoreKeys = {
    'year',
    'make',
    'model',
    'trim',
    'body',
    'market',
    'id',
    'updatedAt',
    'notes',
    'source_1',
    'source_2',
    'confidence',
    'interval_schedule',
    'function_key',
    'location_hint',
  };

  final year = map['year'];
  final make = map['make'];
  final model = map['model'];
  final trim = map['trim'];
  final bodyAttr = map['body'];
  final market = map['market'];
  final tags = _buildTags(map);

  for (final entry in map.entries) {
    if (ignoreKeys.contains(entry.key)) continue;
    if (entry.value == null || entry.value == 'n/a') continue;

    final key = entry.key;
    final value = entry.value.toString();

    final uniqueString = '$year|$make|$model|$trim|$bodyAttr|$market|$key';
    final id = 'wide_${uniqueString.hashCode}';

    String category = 'Specs';
    String title = key.replaceAll('_', ' ').toUpperCase();

    if (key == 'power' || key == 'torque') {
      category = 'Engine';
    } else if (key.contains('torque') ||
        key.contains('_plug') ||
        key.contains('_bolt') ||
        key.contains('lug_nut')) {
      category = 'Torque';
    } else if (key.contains('oil') ||
        key.contains('fluid') ||
        key.contains('coolant')) {
      category = 'Fluids';
    } else if (key.contains('filter') ||
        key.contains('belt') ||
        key.contains('spark_plug') ||
        key.contains('plug_gap') ||
        key.contains('brake_')) {
      category = 'Maintenance';
    } else if (key.contains('trans_') ||
        key.contains('clutch_') ||
        key.contains('cvt_')) {
      category = 'Transmission';
    } else if (key.contains('diff_')) {
      category = 'Differential';
    } else if (key.contains('wheel_') || key.contains('tire_')) {
      category = 'Wheels';
    } else if (key.contains('compression') ||
        key.contains('displacement') ||
        key.contains('bore') ||
        key.contains('stroke') ||
        key.contains('engine_') ||
        key.contains('fuel_') ||
        key.contains('valve_') ||
        key.contains('cylinders')) {
      category = 'Engine';
    } else if (key.contains('weight') ||
        key.contains('length') ||
        key.contains('width') ||
        key.contains('height') ||
        key.contains('ground_clearance') ||
        key.contains('wheelbase')) {
      category = 'Dimensions';
    }

    rowSpecs.add(
      Spec(
        id: id,
        category: category,
        title: title,
        body: value,
        tags: tags,
        updatedAt: DateTime.now(),
      ),
    );
  }
  return rowSpecs;
}

String _buildTags(Map<String, dynamic> map) {
  return [map['year'], map['make'], map['model'], map['trim'], map['market']]
      .where((e) => e != null && e != 'n/a')
      .map((e) => FitmentKey.norm(e.toString()))
      .join(',');
}

String _enrichTagsWithYears(String currentTags, String title) {
  final Set<String> tagSet = currentTags
      .split(',')
      .map((e) => FitmentKey.norm(e))
      .where((e) => e.isNotEmpty)
      .toSet();

  // Extract years from title to fill gaps in tags
  // Matches: "2002-2005", "2022+", "2004"
  final rangeRegex = RegExp(r'\b(\d{4})\s*-\s*(\d{4})\b');
  final plusRegex = RegExp(r'\b(\d{4})\+');
  final singleYearRegex = RegExp(r'\b(\d{4})\b');

  bool foundRange = false;

  // 1. Range: "2002-2005"
  final rangeMatch = rangeRegex.firstMatch(title);
  if (rangeMatch != null) {
    int start = int.parse(rangeMatch.group(1)!);
    int end = int.parse(rangeMatch.group(2)!);
    if (start <= end && start > 1900 && end < 2100) {
      for (int y = start; y <= end; y++) {
        tagSet.add(y.toString());
      }
      foundRange = true;
    }
  }

  // 2. Plus: "2022+"
  if (!foundRange) {
    final plusMatch = plusRegex.firstMatch(title);
    if (plusMatch != null) {
      int start = int.parse(plusMatch.group(1)!);
      if (start > 1900 && start < 2100) {
        // Expand forward a reasonable amount for "current" gens
        for (int y = start; y <= 2026; y++) {
          tagSet.add(y.toString());
        }
        foundRange = true;
      }
    }
  }

  // 3. Single Year: "2004" (Always check for single years too)
  final matches = singleYearRegex.allMatches(title);
  for (final m in matches) {
    int y = int.parse(m.group(1)!);
    if (y > 1900 && y < 2100) {
      tagSet.add(y.toString());
    }
  }

  return tagSet.join(',');
}

List<Part> parseParts(String response) {
  final List<dynamic> data = json.decode(response);
  return data.map((json) {
    final map = json as Map<String, dynamic>;
    return Part(
      id: map['id'],
      name: map['name'],
      oemNumber: map['oemNumber'],
      aftermarketNumbers: map['aftermarketNumbers'],
      fits: map['fits'],
      notes: map['notes'],
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }).toList();
}
