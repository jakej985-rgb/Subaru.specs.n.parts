import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/router/app_router.dart';
import 'package:specsnparts/theme/app_theme.dart';

import 'package:specsnparts/data/seed/seed_runner.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  final runner = ref.watch(seedRunnerProvider);
  await runner.runSeedIfNeeded();
});

class SubaruSpecsApp extends ConsumerWidget {
  const SubaruSpecsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitializationProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Subaru Specs & Parts',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return init.when(
          data: (_) => child!,
          loading: () => const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Updating specifications database...'),
                ],
              ),
            ),
          ),
          error: (e, st) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Critical Error initializing database:\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
