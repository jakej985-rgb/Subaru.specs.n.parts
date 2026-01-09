import 'package:flutter/material.dart';

enum SpecCategoryKey {
  fluids(
    'fluids',
    'Lubrication & Fluids',
    Icons.water_drop,
    ['Oil', 'Fluids', 'Coolant'],
  ),
  lights(
    'lights',
    'Lighting (Bulbs)',
    Icons.lightbulb,
    ['Bulbs'],
  ),
  maintenance(
    'maintenance',
    'Maintenance & Service Intervals',
    Icons.build,
    ['Maintenance', 'Maintenance Intervals', 'Spark Plugs', 'Cooling', 'Belts'],
  ),
  torque(
    'torque',
    'Torque Specifications',
    Icons.rotate_right,
    ['Torque'],
  ),
  engine(
    'engine',
    'Engine Specifications',
    Icons.engineering,
    ['Engine'],
  ),
  drivetrain(
    'drivetrain',
    'Drivetrain & Transmission',
    Icons.settings_input_component,
    ['Transmission', 'Differential', 'Drivetrain'],
  ),
  dimensions(
    'dimensions',
    'Capacities & Dimensions',
    Icons.aspect_ratio,
    ['Dimensions', 'Capacities', 'Wheels', 'Tires'],
  ),
  filters(
    'filters',
    'Filters & Wear Items',
    Icons.filter_alt,
    ['Filters'],
  ),
  notes(
    'notes',
    'Notes & Warnings',
    Icons.warning,
    ['Notes', 'Swap Rules'],
  );

  final String key;
  final String title;
  final IconData icon;
  final List<String> dataCategories;

  const SpecCategoryKey(this.key, this.title, this.icon, this.dataCategories);

  static SpecCategoryKey? fromKey(String key) {
    try {
      return values.firstWhere((e) => e.key == key);
    } catch (_) {
      return null;
    }
  }
}
