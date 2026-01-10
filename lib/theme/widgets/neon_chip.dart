import 'package:flutter/material.dart';
import '../tokens.dart';

class NeonChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const NeonChip({super.key, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? ThemeTokens.neonBlue : ThemeTokens.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : ThemeTokens.surface,
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
