import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/router/app_router.dart';
import 'package:specsnparts/theme/app_theme.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';

class SubaruSpecsApp extends ConsumerStatefulWidget {
  const SubaruSpecsApp({super.key});

  @override
  ConsumerState<SubaruSpecsApp> createState() => _SubaruSpecsAppState();
}

class _SubaruSpecsAppState extends ConsumerState<SubaruSpecsApp> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final db = ref.read(appDbProvider);
    final runner = SeedRunner(db);
    await runner.runSeedIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Subaru Specs & Parts',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
