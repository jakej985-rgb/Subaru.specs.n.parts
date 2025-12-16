import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart'; // for Value
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';
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
    final String response = await rootBundle.loadString('assets/seed/vehicles.json');
    final List<dynamic> data = json.decode(response);
    final List<Vehicle> vehicles = data.map((json) => Vehicle(
      id: json['id'],
      year: json['year'],
      make: json['make'],
      model: json['model'],
      trim: json['trim'],
      engineCode: json['engineCode'],
      updatedAt: DateTime.parse(json['updatedAt']),
    )).toList();

    await db.vehiclesDao.insertMultiple(vehicles);
  }

  Future<void> _seedSpecs() async {
    final String response = await rootBundle.loadString('assets/seed/specs.json');
    final List<dynamic> data = json.decode(response);
    final List<Spec> specs = data.map((json) => Spec(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      body: json['body'],
      tags: json['tags'],
      updatedAt: DateTime.parse(json['updatedAt']),
    )).toList();

    await db.specsDao.insertMultiple(specs);
  }

  Future<void> _seedParts() async {
    final String response = await rootBundle.loadString('assets/seed/parts.json');
    final List<dynamic> data = json.decode(response);
    final List<Part> parts = data.map((json) => Part(
      id: json['id'],
      name: json['name'],
      oemNumber: json['oemNumber'],
      aftermarketNumbers: json['aftermarketNumbers'],
      fits: json['fits'],
      notes: json['notes'],
      updatedAt: DateTime.parse(json['updatedAt']),
    )).toList();

    await db.partsDao.insertMultiple(parts);
  }
}
