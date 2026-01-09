import 'dart:convert';
import 'dart:io';

const specDir = 'assets/seed/specs';

// Known trim keywords (matching SpecsDao + extras)
const knownTrims = {
  "base", "premium", "limited", "touring", "sport", "wilderness", "ts", "gt", "rs",
  "sti", "gl", "dl", "l", "s", "xt", "wrx", "type", "outback", "turbo", "h6"
};

// Helper: Normalize trim tag keyword from a given spec title or description
Set<String> extractTrimKeywords(String text) {
  final lowerText = text.toLowerCase();
  // Using explicit word boundary check to avoid partial matches (e.g. "base" in "database")
  // But simplistic "contains" is used in the python example, so we'll stick to regex word boundaries for safety.
  final foundTrims = <String>{};
  
  for (final trim in knownTrims) {
    // Regex for word boundary: \bTRIM\b
    // Handles "Sport" matching "Sport" but not "Passport".
    if (RegExp(r'\b' + RegExp.escape(trim) + r'\b').hasMatch(lowerText)) {
      foundTrims.add(trim);
    }
  }
  return foundTrims;
}

// Helper: Extract years from spec title like "2002-2005" or "2018"
Set<String> extractYearsFromTitle(String title) {
  final years = <String>{};
  // Matches 1990-2000 or 1999
  // Groups: 1=StartYear, 3=EndYear (optional)
  final regex = RegExp(r'(19|20)(\d{2})(?:\s*[-–]\s*(?:19|20)?(\d{2}))?');
  
  final matches = regex.allMatches(title);
  
  for (final match in matches) {
    final startPrefix = match.group(1)!;
    final startSuffix = match.group(2)!;
    final startYear = int.parse(startPrefix + startSuffix);
    
    int endYear = startYear;
    final endSuffix = match.group(3);
    
    if (endSuffix != null) {
      // Reconstruct end year. If suffix is 2 digits (e.g. 05), use prefix from start or assume logic?
      // The python script logic was start[0]+start[1]... actually Python regex was a bit loose.
      // Standard logic: if "2002-05", end is 2005. If "1999-2001", end is 2001.
      // For safety, let's assume fully qualified years usually, but handle 2-digit abbreviation if valid.
      // The regex above doesn't fully capture "20" prefix for the second part if omitted in text like "2002-05".
      // Let's rely on parsing what we caught.
      // Actually the python script `(19|20)\d{2}(?:[–-](19|20)?\d{2})?` expects full 4 digits usually.
      // Let's look for explicit 4-digit years first.
    }
  }
  
  // Simpler regex for explicit 4-digit years to match Python script's intent:
  // Find all YYYY
  final simpleYearRegex = RegExp(r'\b(19|20)\d{2}\b');
  final allYears = simpleYearRegex.allMatches(title).map((m) => int.parse(m.group(0)!)).toList();
  
  if (allYears.isNotEmpty) {
      if (title.contains('-') || title.contains('–')) {
           // Range logic: simplistic approach, verify ranges?
           // The user python script extracted ranges. Let's do a robust range parse.
           final rangeRegex = RegExp(r'(\d{4})\s*[-–]\s*(\d{4})');
           for (final m in rangeRegex.allMatches(title)) {
               final start = int.parse(m.group(1)!);
               final end = int.parse(m.group(2)!);
               if (start <= end && start > 1950 && end < 2030) {
                   for (var y = start; y <= end; y++) years.add(y.toString());
               }
           }
      }
      // Also add individual years found effectively
      for (var y in allYears) years.add(y.toString());
  }

  return years;
}

void main() async {
  final dir = Directory(specDir);
  if (!await dir.exists()) {
    print('Directory $specDir not found.');
    return;
  }

  await for (final entity in dir.list()) {
    if (entity is File && entity.path.endsWith('.json')) {
      final content = await entity.readAsString();
      try {
        final List<dynamic> specs = jsonDecode(content);
        bool modified = false;

        for (var spec in specs) {
          final String title = spec['title'] ?? '';
          final String body = spec['body'] ?? '';
          final String originalTags = spec['tags'] ?? '';
          
          final currentTags = originalTags
              .toLowerCase()
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toSet();

          // 1. Extract years from title
          // (Improving year extraction to match Python logic: ranges)
          // Simplified regex for range: (19|20)\d{2}[-–](19|20)\d{2} OR (19|20)\d{2}
          final rangeMatches = RegExp(r'\b((?:19|20)\d{2})\s*[-–]\s*((?:19|20)\d{2})\b').allMatches(title);
          for (final m in rangeMatches) {
             int start = int.parse(m.group(1)!);
             int end = int.parse(m.group(2)!);
             for(int y=start; y<=end; y++) currentTags.add(y.toString());
          }
          
          // Also simpler single years if not caught in range
          final singleYears = RegExp(r'\b(19|20)\d{2}\b').allMatches(title);
          for (final m in singleYears) {
             currentTags.add(m.group(0)!);
          }

          // 2. Extract trim keywords from title + body
          final textToScan = '$title $body';
          final foundTrims = extractTrimKeywords(textToScan);
          currentTags.addAll(foundTrims);

          // Rebuild tag string
          final newTagsList = currentTags.toList()..sort();
          final newTagsString = newTagsList.join(',');

          if (newTagsString != (spec['tags']?.toLowerCase() ?? '')) {
             spec['tags'] = newTagsString;
             modified = true;
          }
        }

        if (modified) {
          await entity.writeAsString(jsonEncode(specs)); // jsonEncode default is tight, we want indent
          // Dart's default jsonEncode doesn't pretty print safely simply.
          // Let's use JsonEncoder.withIndent
          final encoder = JsonEncoder.withIndent('  ');
          await entity.writeAsString(encoder.convert(specs));
          print('Updated tags in ${entity.path.split(Platform.pathSeparator).last}');
        }

      } catch (e) {
        print('Error processing ${entity.path}: $e');
      }
    }
  }
}
