import 'package:flutter/material.dart';
import '../tokens.dart';
import '../neon_shadows.dart';
import 'carbon_surface.dart';

class NeonPlate extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isInteractive;

  const NeonPlate({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
        boxShadow: isInteractive ? NeonShadows.glow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
          child: CarbonSurface(
            opacity: ThemeTokens.opacityHeader,
            baseColor: ThemeTokens.surfaceRaised,
            padding: padding ?? const EdgeInsets.all(12),
            border: Border.all(
              color: ThemeTokens.neonBlue.withOpacity(0.5),
              width: 1.5,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
