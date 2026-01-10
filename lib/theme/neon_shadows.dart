import 'package:flutter/material.dart';
import 'tokens.dart';

class NeonShadows {
  static List<BoxShadow> get glow => [
    BoxShadow(
      color: ThemeTokens.neonBlue.withOpacity(0.25),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: ThemeTokens.neonBlueDeep.withOpacity(0.12),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get glowSoft => [
    BoxShadow(
      color: ThemeTokens.neonBlue.withOpacity(0.15),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get glowStrong => [
    BoxShadow(
      color: ThemeTokens.neonBlue.withOpacity(0.40),
      blurRadius: 10,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: ThemeTokens.neonBlueDeep.withOpacity(0.20),
      blurRadius: 20,
      spreadRadius: 4,
    ),
  ];
}
