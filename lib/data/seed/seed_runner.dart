import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/domain/fitment/fitment_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const int kCurrentSeedVersion = 18;
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
      final String manifestContent = await rootBundle.loadString(
        'AssetManifest.json',
      );
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final specFiles = manifestMap.keys
          .where(
            (key) =>
                key.startsWith('assets/seed/specs/') && key.endsWith('.json'),
          )
          .toList();

      if (specFiles.isEmpty) {
        debugPrint('Warning: No spec files found in assets/seed/specs/');
        return;
      }

      final List<Spec> allSpecs = [];
      for (final file in specFiles) {
        final String response = await rootBundle.loadString(file);
        final List<Spec> specs = await compute<String, List<Spec>>(
          parseSpecs,
          response,
        );
        allSpecs.addAll(specs);
      }

      await db.specsDao.insertMultiple(allSpecs);
      debugPrint(
        'Seeded ${allSpecs.length} specs from ${specFiles.length} files.',
      );
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
