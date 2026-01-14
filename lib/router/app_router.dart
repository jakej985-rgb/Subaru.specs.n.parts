import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/home_page.dart';
import 'package:specsnparts/features/settings/settings_page.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';
import 'package:specsnparts/features/browse_engine/engine_flow_page.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs_by_category/specs_by_category_hub_page.dart';
import 'package:specsnparts/features/specs_by_category/category_year_picker_page.dart';
import 'package:specsnparts/features/specs_by_category/category_year_results_page.dart';
import 'package:specsnparts/features/global_search/global_search_overlay.dart';
import 'package:specsnparts/features/comparison/comparison_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: 'parts',
            builder: (context, state) {
              Vehicle? vehicle;
              if (state.extra is Vehicle) {
                vehicle = state.extra as Vehicle;
              }
              return PartLookupPage(vehicle: vehicle);
            },
          ),
          GoRoute(
            path: 'specs',
            builder: (context, state) {
              Vehicle? vehicle;
              List<String>? categories;

              if (state.extra is Vehicle) {
                vehicle = state.extra as Vehicle;
              } else if (state.extra is Map<String, dynamic>) {
                final map = state.extra as Map<String, dynamic>;
                vehicle = map['vehicle'] as Vehicle?;
                categories = (map['categories'] as List<dynamic>?)
                    ?.cast<String>();
              }

              return SpecListPage(vehicle: vehicle, categories: categories);
            },
          ),
          GoRoute(
            path: 'specs/categories',
            builder: (context, state) => const SpecsByCategoryHubPage(),
            routes: [
              GoRoute(
                path: ':categoryKey/years',
                builder: (context, state) {
                  final key = state.pathParameters['categoryKey']!;
                  return CategoryYearPickerPage(categoryKey: key);
                },
              ),
              GoRoute(
                path: ':categoryKey/:year',
                builder: (context, state) {
                  final key = state.pathParameters['categoryKey']!;
                  final yearStr = state.pathParameters['year']!;
                  final year = int.tryParse(yearStr) ?? 0;
                  return CategoryYearResultsPage(categoryKey: key, year: year);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'browse/ymm',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final categories = (extra?['categories'] as List<dynamic>?)
                  ?.cast<String>();
              return YmmFlowPage(initialCategories: categories);
            },
          ),
          GoRoute(
            path: 'browse/engine',
            builder: (context, state) => const EngineFlowPage(),
          ),
          GoRoute(
            path: 'global-search',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const GlobalSearchOverlay(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ),
          GoRoute(
            path: 'comparison',
            builder: (context, state) => const ComparisonPage(),
          ),
        ],
      ),
    ],
  );
});
