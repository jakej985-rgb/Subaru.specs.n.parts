import 'package:flutter/material.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'preview_wrappers.dart';

@SubaruPreview(
  group: 'Parts',
  name: 'Part Lookup - Default',
  size: Size(390, 844),
)
Widget partLookupDefault() {
  return const PartLookupPage();
}

@SubaruPreview(
  group: 'Parts',
  name: 'Part Lookup - With Vehicle Context',
  size: Size(390, 844),
)
Widget partLookupWithContext() {
  return PartLookupPage(
    vehicle: Vehicle(
      id: '1',
      year: 2004,
      make: 'Subaru',
      model: 'Impreza',
      trim: 'WRX STI',
      engineCode: 'EJ257',
      updatedAt: DateTime(2024, 1, 1),
    ),
  );
}
