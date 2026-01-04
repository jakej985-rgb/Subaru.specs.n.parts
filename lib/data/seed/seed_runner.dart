import 'dart:convert';

import 'package:flutter/services.dart';
// for Value
import 'package:specsnparts/data/db/app_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedRunner {
  final AppDatabase db;

  SeedRunner(this.db);

  Future<void> runSeedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    // Version 1: Initial seed
    // Version 2: Added Impreza CSV data
    const int kCurrentSeedVersion = 2;
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
    final String response = await rootBundle.loadString(
      'assets/seed/vehicles.json',
    );
    final List<dynamic> data = json.decode(response);
    final List<Vehicle> vehicles = data
        .map(
          (json) => Vehicle(
            id: json['id'],
            year: json['year'],
            make: json['make'],
            model: json['model'],
            trim: json['trim'],
            engineCode: json['engineCode'],
            updatedAt: DateTime.parse(json['updatedAt']),
          ),
        )
        .toList();

    await db.vehiclesDao.insertMultiple(vehicles);
  }

  Future<void> _seedSpecs() async {
    final String response = await rootBundle.loadString(
      'assets/seed/specs.json',
    );
    final List<dynamic> data = json.decode(response);
    final List<Spec> specs = data
        .map(
          (json) => Spec(
            id: json['id'],
            category: json['category'],
            title: json['title'],
            body: json['body'],
            tags: json['tags'],
            updatedAt: DateTime.parse(json['updatedAt']),
          ),
        )
        .toList();

    await db.specsDao.insertMultiple(specs);
  }

  Future<void> _seedParts() async {
    final String response = await rootBundle.loadString(
      'assets/seed/parts.json',
    );
    final List<dynamic> data = json.decode(response);
    final List<Part> parts = data
        .map(
          (json) => Part(
            id: json['id'],
            name: json['name'],
            oemNumber: json['oemNumber'],
            aftermarketNumbers: json['aftermarketNumbers'],
            fits: json['fits'],
            notes: json['notes'],
            updatedAt: DateTime.parse(json['updatedAt']),
          ),
        )
        .toList();

    await db.partsDao.insertMultiple(parts);
  }
}
