import 'package:flutter/material.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';
import 'preview_wrappers.dart';

@SubaruPreview(
  group: 'Specs',
  name: 'Spec List - Default',
  size: Size(390, 844),
)
Widget specListDefault() {
  return const SpecListPage();
}

@SubaruPreview(
  group: 'Specs',
  name: 'Spec List - With Vehicle',
  size: Size(390, 844),
)
Widget specListWithVehicle() {
  // We pass a dummy vehicle; the mock controller handles the list items
  return SpecListPage(
    vehicle: Vehicle(
      id: '1',
      year: 2004,
      make: 'Subaru',
      model: 'Impreza',
      trim: 'WRX STI',
      engineCode: 'EJ257',
      updatedAt: DateTime(2024),
    ),
  );
}
