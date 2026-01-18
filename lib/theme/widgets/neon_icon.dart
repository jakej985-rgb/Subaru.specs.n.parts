import 'dart:ui';
import 'package:flutter/material.dart';

class NeonIcon extends StatelessWidget {
  const NeonIcon(
    this.asset, {
    super.key,
    this.size = 40,
  });

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        // glow pass
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: ImageIcon(
            AssetImage(asset),
            size: size + 4,
            color: c.withValues(alpha: 0.85),
          ),
        ),
        // crisp pass
        ImageIcon(
          AssetImage(asset),
          size: size,
          color: c,
        ),
      ],
    );
  }
}
