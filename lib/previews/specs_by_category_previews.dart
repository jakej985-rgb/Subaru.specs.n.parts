import 'package:flutter/material.dart';
import 'package:specsnparts/features/specs_by_category/category_year_picker_page.dart';
import 'package:specsnparts/features/specs_by_category/category_year_results_page.dart';
import 'package:specsnparts/features/specs_by_category/specs_by_category_hub_page.dart';
import 'preview_wrappers.dart';

@SubaruPreview(
  group: 'Specs By Category',
  name: 'Hub Page',
  size: Size(390, 844),
)
Widget specsByCategoryHubPreview() {
  return const SpecsByCategoryHubPage();
}

@SubaruPreview(
  group: 'Specs By Category',
  name: 'Year Picker (Engine)',
  size: Size(390, 844),
)
Widget categoryYearPickerPreview() {
  return const CategoryYearPickerPage(categoryKey: 'engine');
}

@SubaruPreview(
  group: 'Specs By Category',
  name: 'Results Page (Engine 2024)',
  size: Size(390, 844),
)
Widget categoryYearResultsPreview() {
  return const CategoryYearResultsPage(categoryKey: 'engine', year: 2024);
}
