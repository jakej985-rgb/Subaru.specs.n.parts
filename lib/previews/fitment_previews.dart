import 'package:flutter/material.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';
import 'preview_wrappers.dart';

@SubaruPreview(
  group: 'Fitment',
  name: 'YMM Flow - Default',
  size: Size(390, 844), // iPhone 14-ish
)
Widget ymmFlowDefault() {
  return const YmmFlowPage();
}

@SubaruPreview(
  group: 'Fitment',
  name: 'YMM Flow - Categories Pre-selected',
  size: Size(390, 844),
)
Widget ymmFlowWithIds() {
  return const YmmFlowPage(initialCategories: ['engine', 'brakes']);
}
