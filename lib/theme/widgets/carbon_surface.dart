import 'package:flutter/material.dart';
import '../tokens.dart';

class CarbonSurface extends StatelessWidget {
  final Widget child;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? baseColor;
  final BoxBorder? border;

  const CarbonSurface({
    super.key,
    required this.child,
    this.opacity = ThemeTokens.opacityCard,
    this.borderRadius,
    this.padding,
    this.baseColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: baseColor ?? ThemeTokens.surface,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ThemeTokens.radiusMedium),
        border: border,
      ),
      child: ClipRRect(
        borderRadius:
            borderRadius ?? BorderRadius.circular(ThemeTokens.radiusMedium),
        child: Stack(
          children: [
            // Carbon Texture Overlay
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Image.asset(
                  ThemeTokens.carbonTexture,
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.none,
                  filterQuality: FilterQuality.low, // performance
                ),
              ),
            ),
            // Content
            Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }
}
