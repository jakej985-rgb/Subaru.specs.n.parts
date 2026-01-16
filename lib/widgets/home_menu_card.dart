import 'package:flutter/material.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
import 'package:specsnparts/theme/tokens.dart';

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.height = 120,
    this.semanticLabel,
  });

  final String title;
  final IconData icon;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: ThemeTokens.neonBlue),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ThemeTokens.textPrimary,
                        ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
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
