import 'package:flutter/material.dart';
import 'package:specsnparts/theme/tokens.dart';

/// Market regions for Subaru vehicles.
enum MarketRegion {
  usdm, // US Domestic Market
  jdm, // Japanese Domestic Market
  eudm, // European Domestic Market
  audm, // Australian Domestic Market
  unknown, // Unknown or unspecified
}

/// Infer market region from vehicle trim string.
/// Looks for patterns like "(JDM)", "(US)", "(USDM)", etc.
MarketRegion inferMarketFromTrim(String? trim) {
  if (trim == null || trim.isEmpty) {
    return MarketRegion.unknown;
  }

  final upperTrim = trim.toUpperCase();

  if (upperTrim.contains('JDM') || upperTrim.contains('JAPAN')) {
    return MarketRegion.jdm;
  }
  if (upperTrim.contains('USDM') ||
      upperTrim.contains('(US)') ||
      upperTrim.contains('US)') ||
      upperTrim.contains('(US ')) {
    return MarketRegion.usdm;
  }
  if (upperTrim.contains('EUDM') ||
      upperTrim.contains('(EU)') ||
      upperTrim.contains('EURO')) {
    return MarketRegion.eudm;
  }
  if (upperTrim.contains('AUDM') ||
      upperTrim.contains('(AU)') ||
      upperTrim.contains('AUS')) {
    return MarketRegion.audm;
  }

  // Default to USDM for trims without explicit market indicators
  return MarketRegion.usdm;
}

/// Get all unique markets from a list of trim strings.
Set<MarketRegion> getMarketsFromTrims(Iterable<String?> trims) {
  final markets = <MarketRegion>{};
  for (final trim in trims) {
    final market = inferMarketFromTrim(trim);
    if (market != MarketRegion.unknown) {
      markets.add(market);
    }
  }
  // If no markets found, return USDM as default
  if (markets.isEmpty) {
    markets.add(MarketRegion.usdm);
  }
  return markets;
}

/// A glowing market region badge widget.
/// Shows USDM (blue), JDM (red), or MULTI (gradient) indicator.
class MarketBadge extends StatelessWidget {
  final Set<MarketRegion> markets;
  final bool compact;
  final bool showLabel;

  const MarketBadge({
    super.key,
    required this.markets,
    this.compact = false,
    this.showLabel = true,
  });

  /// Create a badge from a single market.
  factory MarketBadge.single(
    MarketRegion market, {
    bool compact = false,
    bool showLabel = true,
  }) {
    return MarketBadge(
      markets: {market},
      compact: compact,
      showLabel: showLabel,
    );
  }

  /// Create a badge from a list of trim strings.
  factory MarketBadge.fromTrims(
    Iterable<String?> trims, {
    bool compact = false,
    bool showLabel = true,
  }) {
    return MarketBadge(
      markets: getMarketsFromTrims(trims),
      compact: compact,
      showLabel: showLabel,
    );
  }

  Color _getPrimaryColor() {
    if (markets.length > 1) {
      return Colors.purpleAccent; // Multi-market
    }
    final market = markets.first;
    switch (market) {
      case MarketRegion.jdm:
        return const Color(0xFFFF4757); // Red for JDM
      case MarketRegion.usdm:
        return ThemeTokens.neonBlue; // Blue for USDM
      case MarketRegion.eudm:
        return const Color(0xFF2ED573); // Green for EUDM
      case MarketRegion.audm:
        return const Color(0xFFFFA502); // Orange for AUDM
      case MarketRegion.unknown:
        return ThemeTokens.textMuted;
    }
  }

  String _getLabel() {
    if (markets.length > 1) {
      // Show combined label
      final labels = markets.map((m) => _getSingleLabel(m)).toList()..sort();
      return labels.join('/');
    }
    return _getSingleLabel(markets.first);
  }

  String _getSingleLabel(MarketRegion market) {
    switch (market) {
      case MarketRegion.jdm:
        return 'JDM';
      case MarketRegion.usdm:
        return 'USDM';
      case MarketRegion.eudm:
        return 'EUDM';
      case MarketRegion.audm:
        return 'AUDM';
      case MarketRegion.unknown:
        return '?';
    }
  }

  String _getEmoji() {
    if (markets.length > 1) {
      return '🌐'; // Multi-market globe
    }
    final market = markets.first;
    switch (market) {
      case MarketRegion.jdm:
        return '🇯🇵';
      case MarketRegion.usdm:
        return '🇺🇸';
      case MarketRegion.eudm:
        return '🇪🇺';
      case MarketRegion.audm:
        return '🇦🇺';
      case MarketRegion.unknown:
        return '🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPrimaryColor();
    final label = _getLabel();

    if (compact) {
      return _buildCompactBadge(color, label);
    }

    return _buildFullBadge(context, color, label);
  }

  Widget _buildCompactBadge(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        showLabel ? label : _getEmoji(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFullBadge(BuildContext context, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getEmoji(), style: const TextStyle(fontSize: 12)),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
