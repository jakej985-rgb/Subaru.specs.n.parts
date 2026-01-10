import 'package:flutter/material.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ThemeTokens.bg,
      primaryColor: ThemeTokens.neonBlue,
      canvasColor: ThemeTokens.bg,

      colorScheme: const ColorScheme.dark(
        primary: ThemeTokens.neonBlue,
        secondary: ThemeTokens.neonBlueDeep,
        surface: ThemeTokens.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ThemeTokens.textPrimary,
        outline: ThemeTokens.divider,
      ),

      dividerTheme: const DividerThemeData(
        color: ThemeTokens.divider,
        thickness: 1,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeTokens.surfaceRaised,
        foregroundColor: ThemeTokens.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        color: ThemeTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
          side: const BorderSide(color: ThemeTokens.divider, width: 1),
        ),
      ),

      textTheme: const TextTheme(
        // Screen titles
        titleLarge: TextStyle(
          color: ThemeTokens.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        // Model headers
        titleMedium: TextStyle(
          color: ThemeTokens.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        // Standard body
        bodyMedium: TextStyle(
          color: ThemeTokens.textSecondary,
          fontSize: 14,
          height: 1.4,
        ),
        // Small labels / caps
        labelSmall: TextStyle(
          color: ThemeTokens.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),

      iconTheme: const IconThemeData(
        color: ThemeTokens.textSecondary,
        size: 24,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeTokens.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
          borderSide: const BorderSide(color: ThemeTokens.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
          borderSide: const BorderSide(color: ThemeTokens.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
          borderSide: const BorderSide(color: ThemeTokens.neonBlue),
        ),
        hintStyle: const TextStyle(color: ThemeTokens.textMuted),
        prefixIconColor: ThemeTokens.textMuted,
      ),
    );
  }
}
