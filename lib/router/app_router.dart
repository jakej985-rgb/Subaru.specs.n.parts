import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/home/home_page.dart';
import 'package:specsnparts/features/settings/settings_page.dart';
import 'package:specsnparts/features/part_lookup/part_lookup_page.dart';
import 'package:specsnparts/features/specs/spec_list_page.dart';
import 'package:specsnparts/features/browse_ymm/ymm_flow_page.dart';
import 'package:specsnparts/features/browse_engine/engine_flow_page.dart';
import 'package:flutter/material.dart';

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
            builder: (context, state) => const SpecListPage(),
          ),
          GoRoute(
            path: 'browse/ymm',
            builder: (context, state) => const YmmFlowPage(),
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
