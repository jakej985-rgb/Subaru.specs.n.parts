import 'package:flutter/material.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
import 'package:specsnparts/theme/tokens.dart';

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({
    super.key,
    required this.title,
    this.icon,
    this.customIcon,
    required this.onTap,
    this.height = 120,
    this.semanticLabel,
  }) : assert(
         icon != null || customIcon != null,
         'Either icon or customIcon must be provided',
       );

  final String title;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onTap;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Semantics(
        container: true,
        button: true,
        label: semanticLabel ?? title,
        onTap: onTap,
        child: ExcludeSemantics(
          child: NeonPlate(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Ensure vertical centering
              children: [
                if (customIcon != null)
                  customIcon!
                else
                  Icon(
                    icon,
                    size: 48,
                    color: ThemeTokens.neonBlue,
                  ), // Larger fallback
                const SizedBox(width: 32), // Bigger gap
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ThemeTokens.textPrimary,
                      fontSize: 22, // Ensure good size
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 32, // Larger chevron
                  color: ThemeTokens.neonBlueDeep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
