import 'package:flutter/material.dart';
import 'package:specsnparts/theme/widgets/neon_outline_icons.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'preview_wrappers.dart';

// -----------------------------------------------------------------------------
// Neon Outline Icons Previews
// Shows all custom-painted neon icons at various sizes
// -----------------------------------------------------------------------------

// -- Subaru Badge (Year/Make/Model) --

@SubaruPreview(group: 'Neon Icons', name: 'Subaru Badge - Large (110px)')
Widget subaruBadgeLarge() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: SubaruBadgePainter(color: ThemeTokens.neonBlue),
        size: 110,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Subaru Badge - Medium (64px)')
Widget subaruBadgeMedium() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: SubaruBadgePainter(color: ThemeTokens.neonBlue),
        size: 64,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Subaru Badge - No Glow')
Widget subaruBadgeNoGlow() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: SubaruBadgePainter(color: ThemeTokens.neonBlue, glow: false),
        size: 110,
      ),
    ),
  );
}

// -- Boxer Engine (Browse by Engine) --

@SubaruPreview(group: 'Neon Icons', name: 'Boxer Engine - Large (110px)')
Widget boxerEngineLarge() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: BoxerEnginePainter(color: ThemeTokens.neonBlue),
        size: 110,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Boxer Engine - Medium (64px)')
Widget boxerEngineMedium() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: BoxerEnginePainter(color: ThemeTokens.neonBlue),
        size: 64,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Boxer Engine - No Glow')
Widget boxerEngineNoGlow() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: BoxerEnginePainter(color: ThemeTokens.neonBlue, glow: false),
        size: 110,
      ),
    ),
  );
}

// -- Category Grid (Specs by Category) --

@SubaruPreview(group: 'Neon Icons', name: 'Category Grid - Large (110px)')
Widget categoryGridLarge() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: CategoryGridPainter(color: ThemeTokens.neonBlue),
        size: 110,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Category Grid - Medium (64px)')
Widget categoryGridMedium() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: CategoryGridPainter(color: ThemeTokens.neonBlue),
        size: 64,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Category Grid - No Glow')
Widget categoryGridNoGlow() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: CategoryGridPainter(color: ThemeTokens.neonBlue, glow: false),
        size: 110,
      ),
    ),
  );
}

// -- All Icons Together (Comparison View) --

@SubaruPreview(
  group: 'Neon Icons',
  name: 'All Icons - Side by Side',
  size: Size(400, 200),
)
Widget allIconsSideBySide() {
  return Container(
    color: ThemeTokens.surface,
    padding: const EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonOutlineIcon(
              painter: SubaruBadgePainter(color: ThemeTokens.neonBlue),
              size: 110,
            ),
            const SizedBox(height: 8),
            const Text(
              'YMM',
              style: TextStyle(color: ThemeTokens.textSecondary, fontSize: 12),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonOutlineIcon(
              painter: BoxerEnginePainter(color: ThemeTokens.neonBlue),
              size: 110,
            ),
            const SizedBox(height: 8),
            const Text(
              'Engine',
              style: TextStyle(color: ThemeTokens.textSecondary, fontSize: 12),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonOutlineIcon(
              painter: CategoryGridPainter(color: ThemeTokens.neonBlue),
              size: 110,
            ),
            const SizedBox(height: 8),
            const Text(
              'Category',
              style: TextStyle(color: ThemeTokens.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}

// -- Color Variations --

@SubaruPreview(group: 'Neon Icons', name: 'Boxer Engine - Blue Deep Accent')
Widget boxerEngineBlueDeep() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: BoxerEnginePainter(color: ThemeTokens.neonBlueDeep),
        size: 110,
      ),
    ),
  );
}

@SubaruPreview(group: 'Neon Icons', name: 'Boxer Engine - White')
Widget boxerEngineWhite() {
  return Center(
    child: Container(
      color: ThemeTokens.surface,
      padding: const EdgeInsets.all(24),
      child: NeonOutlineIcon(
        painter: BoxerEnginePainter(color: Colors.white),
        size: 110,
      ),
    ),
  );
}
