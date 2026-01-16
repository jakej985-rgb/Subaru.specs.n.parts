// Engine code parsing utilities for Subaru engine families.
//
// Subaru engine codes follow patterns like:
// - "EA71 NA" → family: EA, motor: EA71
// - "EJ205 Turbo" → family: EJ, motor: EJ205
// - "FA24F" → family: FA, motor: FA24F

/// Represents a parsed engine key with family and specific motor code.
class EngineKey {
  /// Engine family prefix (e.g., "EA", "EJ", "FA", "FB", "EZ", "EN").
  final String family;

  /// Full motor code (e.g., "EA71", "EJ205", "FA24F").
  final String motor;

  const EngineKey({required this.family, required this.motor});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EngineKey &&
          runtimeType == other.runtimeType &&
          family == other.family &&
          motor == other.motor;

  @override
  int get hashCode => family.hashCode ^ motor.hashCode;

  @override
  String toString() => 'EngineKey(family: $family, motor: $motor)';
}

/// Common Subaru engine family order for sorting.
/// Unknown families go to the end.
const List<String> _familyPriority = [
  'EA', // Classic flat-4 (1966–1994)
  'EJ', // Iconic flat-4 (1989–2020+)
  'EG', // Rare early variants
  'ER', // Flat-6 (ER27)
  'EZ', // Flat-6 (modern)
  'FA', // Modern turbo flat-4
  'FB', // Modern NA flat-4
  'EE', // Early kei engines
  'EF', // Small displacement (Justy)
  'EN', // Kei engines
];

/// Parse an engine code string into an [EngineKey].
///
/// Examples:
/// - "EJ22 NA" → EngineKey(family: "EJ", motor: "EJ22")
/// - "EJ22T Turbo" → EngineKey(family: "EJ", motor: "EJ22T")
/// - "FA24F" → EngineKey(family: "FA", motor: "FA24F")
/// - "ER27 NA" → EngineKey(family: "ER", motor: "ER27")
/// - "" or null → EngineKey(family: "UNK", motor: "Unknown")
EngineKey parseEngineKey(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const EngineKey(family: 'UNK', motor: 'Unknown');
  }

  // Split on whitespace, dash, or comma and take first chunk
  final parts = raw.trim().split(RegExp(r'[\s\-,]+'));
  if (parts.isEmpty) {
    return const EngineKey(family: 'UNK', motor: 'Unknown');
  }

  final token = parts.first.toUpperCase();
  if (token.isEmpty) {
    return const EngineKey(family: 'UNK', motor: 'Unknown');
  }

  // Extract family: leading letters until first digit
  String family = '';
  for (int i = 0; i < token.length; i++) {
    final char = token[i];
    if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
      // A-Z
      family += char;
    } else {
      break;
    }
  }

  if (family.isEmpty) {
    return EngineKey(family: 'UNK', motor: token);
  }

  return EngineKey(family: family, motor: token);
}

/// Compare two engine families for sorting.
/// Priority families come first, then alphabetical.
int compareFamilies(String a, String b) {
  final aIndex = _familyPriority.indexOf(a);
  final bIndex = _familyPriority.indexOf(b);

  if (aIndex >= 0 && bIndex >= 0) {
    return aIndex.compareTo(bIndex);
  }
  if (aIndex >= 0) return -1; // a is priority, b is not
  if (bIndex >= 0) return 1; // b is priority, a is not

  return a.compareTo(b); // Both non-priority: alphabetical
}

/// Compare two motor codes for "natural-ish" sorting.
///
/// Examples: EA71, EA81, EA82 < EJ18, EJ20, EJ22, EJ25 < EJ205, EJ207, EJ255, EJ257
int compareMotors(String a, String b) {
  // Extract numeric parts for comparison
  final numA = _extractNumeric(a);
  final numB = _extractNumeric(b);

  // If same prefix, compare numbers
  if (numA != null && numB != null) {
    final prefixA = a.replaceAll(RegExp(r'[0-9]+'), '');
    final prefixB = b.replaceAll(RegExp(r'[0-9]+'), '');
    if (prefixA == prefixB) {
      final cmp = numA.compareTo(numB);
      if (cmp != 0) return cmp;
      // Numbers equal, compare suffix (e.g., EJ25 vs EJ25T)
      final suffixA = a.substring(prefixA.length + numA.toString().length);
      final suffixB = b.substring(prefixB.length + numB.toString().length);
      return suffixA.compareTo(suffixB);
    }
  }

  return a.compareTo(b);
}

/// Extract the first numeric sequence from a string.
int? _extractNumeric(String s) {
  final match = RegExp(r'(\d+)').firstMatch(s);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}
