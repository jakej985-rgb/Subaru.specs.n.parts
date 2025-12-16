import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0D47A1), // Subaru Blue-ish
      secondary: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    // Removed CardTheme temporarily to resolve type mismatch in this specific Flutter environment
  );
}
