import 'package:flutter/material.dart';

class AdaptiveScroll extends StatelessWidget {
  const AdaptiveScroll({
    super.key,
    required this.child,
    required this.estimatedContentHeight,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double estimatedContentHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxHeight;
        final needsScroll = estimatedContentHeight > available;

        final content = Padding(
          padding: padding,
          child: child,
        );

        if (!needsScroll) return content;

        return SingleChildScrollView(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
