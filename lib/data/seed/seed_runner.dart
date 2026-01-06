import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:specsnparts/data/db/app_db.dart';
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
    const int kCurrentSeedVersion = 17;
    final int lastSeedVersion = prefs.getInt('seed_version') ?? 0;

    // Check old flag for legacy migration (if user had v1 but tracking was bool)
    final bool legacySeeded = prefs.getBool('is_seeded') ?? false;
    int effectiveVersion = lastSeedVersion;
    if (legacySeeded && lastSeedVersion == 0) {
      effectiveVersion = 1;
    }

    if (effectiveVersion < kCurrentSeedVersion) {
      await _seedVehicles();
      await _seedSpecs();
      await _seedParts();

      await prefs.setInt('seed_version', kCurrentSeedVersion);
      // Keep legacy flag for compatibility or remove it? Keeping it true won't hurt.
      await prefs.setBool('is_seeded', true);
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
    } catch (e) {
      debugPrint('Error loading vehicles.json: $e');
    }
  }

  Future<void> _seedSpecs() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
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
    } catch (e) {
      debugPrint('Error loading specs from split files: $e');
    }
  }

  Future<void> _seedParts() async {
    final String response = await rootBundle.loadString(
      'assets/seed/parts.json',
    );
    final List<Part> parts = await compute<String, List<Part>>(
      parseParts,
      response,
    );

    await db.partsDao.insertMultiple(parts);
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
    return Spec(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      body: map['body'],
      tags: map['tags'],
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }).toList();
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
