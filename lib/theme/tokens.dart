import 'package:flutter/material.dart';

class ThemeTokens {
  // Brand Palette
  static const Color bg = Color(0xFF0B0F14); // blue-black
  static const Color surface = Color(0xFF111824);
  static const Color surfaceRaised = Color(0xFF0E1622);
  static const Color divider = Color(0xFF253247); // subtle blue-gray

  // Neon Accents
  static const Color neonBlue = Color(0xFF1E88FF);
  static const Color neonBlueDeep = Color(0xFF0B4DFF);

  static Color get neonSoft => neonBlue.withValues(alpha: 0.75); // 70-85%

  // Text
  static const Color textPrimary = Color(0xFFEAF2FF);
  static const Color textSecondary = Color(0xFFA9B7D0);
  static const Color textMuted = Color(0xFF7E8FA8);

  // Texture
  static const String carbonTexture = 'assets/textures/carbon.png';

  // Opacity constants for overlay
  static const double opacityBackground = 0.05;
  static const double opacityCard = 0.10;
  static const double opacityHeader = 0.12;

  // Spacing & Radii
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
}
