import 'package:flutter/material.dart';
import '../tokens.dart';
import 'carbon_surface.dart';

class TrimHeaderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool initiallyExpanded;
  final List<Widget>? children;

  const TrimHeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.initiallyExpanded = false,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    // If no children, just render the header plate
    if (children == null || children!.isEmpty) {
      return _buildHeader(context);
    }

    // Otherwise, use ExpansionTile styling
    return CarbonSurface(
      baseColor: ThemeTokens.surfaceRaised,
      opacity: ThemeTokens.opacityHeader,
      border: Border(left: BorderSide(color: ThemeTokens.neonBlue, width: 3.0)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ThemeTokens.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ThemeTokens.neonSoft),
                )
              : null,
          trailing: trailing,
          children: [
            if (children != null)
              ...children!.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: c,
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CarbonSurface(
      baseColor: ThemeTokens.surfaceRaised,
      opacity: ThemeTokens.opacityHeader,
      border: Border(left: BorderSide(color: ThemeTokens.neonBlue, width: 3.0)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ThemeTokens.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ThemeTokens.neonSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
