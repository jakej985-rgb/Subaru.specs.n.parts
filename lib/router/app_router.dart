import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/home_page.dart';
import 'package:specsnparts/features/settings/settings_page.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';
import 'package:specsnparts/features/browse_engine/engine_flow_page.dart';
import 'package:flutter/material.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/specs_category_page.dart';

// Placeholder Pages (will be replaced by actual implementations)
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title - Coming Soon')),
    );
  }
}

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
            builder: (context, state) => const PartLookupPage(),
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
            builder: (context, state) => const SpecsCategoryPage(),
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
        ],
      ),
    ],
  );
});
