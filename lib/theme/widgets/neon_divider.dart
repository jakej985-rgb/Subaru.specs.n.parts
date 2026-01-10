import 'package:flutter/material.dart';
import '../tokens.dart';

class NeonDivider extends StatelessWidget {
  final double verticalPadding;

  const NeonDivider({super.key, this.verticalPadding = 16.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ThemeTokens.divider.withValues(alpha: 0),
              ThemeTokens.neonBlue.withValues(alpha: 0.5),
              ThemeTokens.divider.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
