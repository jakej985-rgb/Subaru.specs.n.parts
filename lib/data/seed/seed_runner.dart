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
    final seeded = prefs.getBool('is_seeded') ?? false;

    if (!seeded) {
      await _seedVehicles();
      await _seedSpecs();
      await _seedParts();
      await prefs.setBool('is_seeded', true);
    }
  }

  Future<void> _seedVehicles() async {
    final String response = await rootBundle.loadString(
      'assets/seed/vehicles.json',
    );
    final List<Vehicle> vehicles = await compute<String, List<Vehicle>>(
      parseVehicles,
      response,
    );

    await db.vehiclesDao.insertMultiple(vehicles);
  }

  Future<void> _seedSpecs() async {
    final String response = await rootBundle.loadString(
      'assets/seed/specs.json',
    );
    final List<Spec> specs = await compute<String, List<Spec>>(
      parseSpecs,
      response,
    );

    await db.specsDao.insertMultiple(specs);
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
