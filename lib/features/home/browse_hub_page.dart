import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/theme/widgets/neon_outline_icons.dart';
import 'package:specsnparts/widgets/home_menu_card.dart';
import 'package:specsnparts/theme/tokens.dart';

class BrowseHubPage extends StatelessWidget {
  const BrowseHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Browse by Year/Make/Model',
        NeonOutlineIcon(
          painter: SubaruBadgePainter(color: ThemeTokens.neonBlue),
          size: 110,
        ),
        () => context.push('/browse/ymm'),
      ),
      (
        'Browse by Engine',
        NeonOutlineIcon(
          painter: BoxerEnginePainter(color: ThemeTokens.neonBlue),
          size: 110,
        ),
        () => context.push('/engines'),
      ),
      (
        'Specs by Category',
        NeonOutlineIcon(
          painter: CategoryGridPainter(color: ThemeTokens.neonBlue),
          size: 110,
        ),
        () => context.push('/specs/categories'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return HomeMenuCard(
            title: item.$1,
            customIcon: item.$2,
            onTap: item.$3,
            height: 140, // Slightly taller to accommodate description if we added it, but HomeMenuCard is simple. 
            // Actually HomeMenuCard doesn't have a description field. 
            // I'll keep it consistent with HomePage for now.
          );
        },
      ),
    );
  }
}
