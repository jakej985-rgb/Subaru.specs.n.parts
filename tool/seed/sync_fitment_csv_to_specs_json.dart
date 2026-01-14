// Dart script: Sync Fitment CSV files to Specs JSON with bulb completion
// Usage: dart tool/seed/sync_fitment_csv_to_specs_json.dart [--only bulbs] [--dry-run] [--strict]

import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';

final _log = Logger('SyncFitment');

/// Simple CSV parser that handles commas inside double quotes.
List<Map<String, String>> parseCsv(File file) {
  final lines = file.readAsLinesSync();
  if (lines.isEmpty) return [];
  final header = _splitCsvLine(lines.first);
  final rows = <Map<String, String>>[];
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    final values = _splitCsvLine(line);
    final map = <String, String>{};
    for (var j = 0; j < header.length; j++) {
      final key = header[j];
      final value = j < values.length ? values[j] : '';
      map[key] = value;
    }
    rows.add(map);
  }
  return rows;
}

List<String> _splitCsvLine(String line) {
  final result = <String>[];
  final buffer = StringBuffer();
  bool inQuotes = false;
  for (int i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      // toggle quote state, but handle escaped double quotes ""
      if (i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++; // skip escaped quote
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      result.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  result.add(buffer.toString());
  return result;
}

String _defaultLocationHint(String functionKey) {
  const mapping = {
    'license_plate': 'License Plate Lamp',
    'headlight_low': 'Low Beam Headlight',
    'headlight_high': 'High Beam Headlight',
    'parking_light': 'Parking Light',
    'turn_signal_front': 'Front Turn Signal',
    'turn_signal_rear': 'Rear Turn Signal',
    'side_marker_front': 'Front Side Marker',
    'side_marker_rear': 'Rear Side Marker',
    'brake': 'Brake Light',
    'tail': 'Tail Lamp',
    'reverse': 'Reverse Light',
    'center_high_mount_stop': 'Center High Mount Stop',
    'fog_light': 'Fog Light',
    'drl': 'Daytime Running Light',
    'map_light_front': 'Front Map Light',
    'dome_front': 'Front Dome Light',
    'dome_rear': 'Rear Dome Light',
    'cargo': 'Cargo Light',
    'glove_box': 'Glove Box Light',
    'vanity_mirror': 'Vanity Mirror Light',
    'door_courtesy': 'Door Courtesy Light',
    'footwell': 'Footwell Light',
  };
  if (mapping.containsKey(functionKey)) return mapping[functionKey]!;
  // fallback: replace underscores with spaces and title case
  return functionKey
      .split('_')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

String _secondaryKey(Map<String, String> row) {
  if (row.containsKey('function_key')) return row['function_key']!;
  if (row.containsKey('spec_key')) return row['spec_key']!;
  if (row.containsKey('part_key')) return row['part_key']!;
  return 'row';
}

String _rowKey(Map<String, dynamic> row) {
  final parts = [
    row['year'].toString(),
    row['make'] ?? '',
    row['model'] ?? '',
    row['trim'] ?? '',
    row['body'] ?? '',
    row['market'] ?? '',
    _secondaryKey(row.map((k, v) => MapEntry(k, v.toString()))),
  ];
  return parts.join('|');
}

Map<String, dynamic> _normalizeRow(Map<String, String> raw) {
  final map = <String, dynamic>{};
  raw.forEach((k, v) {
    var value = v.trim();
    if (value.isEmpty) value = 'n/a';
    if (k == 'year') {
      map[k] = int.tryParse(value) ?? 0;
    } else if (k == 'qty') {
      final qty = int.tryParse(value);
      map[k] = qty?.toString() ?? 'n/a';
    } else if (k == 'serviceable') {
      if (value.toLowerCase() == 'true') {
        map[k] = true;
      } else if (value.toLowerCase() == 'false') {
        map[k] = false;
      } else {
        // default handling later
        map[k] = null;
      }
    } else {
      map[k] = value;
    }
  });
  // Apply defaults for missing serviceable
  if (!map.containsKey('serviceable') || map['serviceable'] == null) {
    if (raw.containsKey('function_key') &&
        raw['function_key']!.contains('bulb')) {
      map['serviceable'] = true;
    } else {
      map['serviceable'] = false;
    }
  }
  return map;
}

Future<void> _processFile(
  File csvFile,
  Directory jsonDir, {
  bool dryRun = false,
  bool strict = false,
}) async {
  final name = csvFile.uri.pathSegments.last.split('.').first; // e.g., bulbs
  final jsonFile = File('${jsonDir.path}/$name.json');

  // Parse CSV rows
  final csvRows = parseCsv(csvFile);
  final normalizedRows = csvRows.map(_normalizeRow).toList();

  // Load existing JSON if present
  List<dynamic> existing = [];
  if (await jsonFile.exists()) {
    final content = await jsonFile.readAsString();
    try {
      final decoded = json.decode(content);
      if (decoded is List) {
        existing = decoded;
      } else {
        // backup legacy
        final backup = File('${jsonFile.path}.legacy.json');
        await backup.writeAsString(content);
        existing = [];
      }
    } catch (_) {
      // malformed JSON, backup and start fresh
      final backup = File('${jsonFile.path}.legacy.json');
      await backup.writeAsString(content);
      existing = [];
    }
  }

  // Build map of existing rows by key for merge
  final existingMap = <String, Map<String, dynamic>>{};
  for (var e in existing) {
    if (e is Map<String, dynamic>) {
      final key = _rowKey(e);
      existingMap[key] = e;
    }
  }

  // Merge CSV rows (update or insert)
  for (var row in normalizedRows) {
    final key = _rowKey(row);
    existingMap[key] = row;
  }

  // Special handling for bulbs: ensure full coverage
  if (name == 'bulbs') {
    await _ensureBulbCoverage(existingMap);
  }

  // Convert map back to list and sort
  final finalList = existingMap.values.toList();
  finalList.sort((a, b) {
    int cmp;
    cmp = (a['year'] as int? ?? 0) - (b['year'] as int? ?? 0);
    if (cmp != 0) return cmp;
    cmp = (a['make'] ?? '').compareTo(b['make'] ?? '');
    if (cmp != 0) return cmp;
    cmp = (a['model'] ?? '').compareTo(b['model'] ?? '');
    if (cmp != 0) return cmp;
    cmp = (a['trim'] ?? '').compareTo(b['trim'] ?? '');
    if (cmp != 0) return cmp;
    cmp = (a['body'] ?? '').compareTo(b['body'] ?? '');
    if (cmp != 0) return cmp;
    cmp = (a['market'] ?? '').compareTo(b['market'] ?? '');
    if (cmp != 0) return cmp;
    cmp = (a['function_key'] ?? '').compareTo(b['function_key'] ?? '');
    return cmp;
  });

  final jsonString = JsonEncoder.withIndent('  ').convert(finalList);
  if (dryRun) {
    _log.info('--- Dry run output for $name.json ---');
    _log.info(jsonString);
  } else {
    await jsonFile.writeAsString(jsonString);
    _log.info('Wrote ${jsonFile.path} (${finalList.length} rows)');
  }
}

Future<void> _ensureBulbCoverage(Map<String, Map<String, dynamic>> map) async {
  // Load vehicles list
  final vehiclesFile = File('assets/seed/vehicles.json');
  if (!await vehiclesFile.exists()) return; // nothing to do
  final vehiclesContent = await vehiclesFile.readAsString();
  final vehicles = json.decode(vehiclesContent) as List<dynamic>;

  // Required function keys list
  const requiredFunctions = [
    // Exterior
    'headlight_low',
    'headlight_high',
    'parking_light',
    'turn_signal_front',
    'turn_signal_rear',
    'side_marker_front',
    'side_marker_rear',
    'brake',
    'tail',
    'reverse',
    'license_plate',
    'center_high_mount_stop',
    'fog_light',
    'drl',
    // Interior
    'map_light_front',
    'dome_front',
    'dome_rear',
    'cargo',
    'glove_box',
    'vanity_mirror',
    'door_courtesy',
    'footwell',
  ];

  for (var v in vehicles) {
    final vehicle = v as Map<String, dynamic>;
    final year = vehicle['year'];
    final make = vehicle['make'];
    final model = vehicle['model'];
    final trim = vehicle['trim'];
    final body = vehicle['body'] ?? 'n/a';
    final market = vehicle['market'] ?? 'n/a';

    for (var func in requiredFunctions) {
      final key = [year, make, model, trim, body, market, func].join('|');
      if (!map.containsKey(key)) {
        // create placeholder row
        final placeholder = {
          'year': year,
          'make': make,
          'model': model,
          'trim': trim,
          'body': body,
          'market': market,
          'function_key': func,
          'location_hint': _defaultLocationHint(func),
          'tech': 'bulb',
          'bulb_code': 'n/a',
          'base': 'n/a',
          'qty': 'n/a',
          'serviceable': true,
          'notes': 'n/a',
          'source_1': 'n/a',
          'source_2': 'n/a',
          'confidence': 'n/a',
        };
        map[key] = placeholder;
      }
    }
  }
}

void main(List<String> args) async {
  final onlyBulbs = args.contains('--only') && args.contains('bulbs');
  final dryRun = args.contains('--dry-run');
  final strict = args.contains('--strict');

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    stdout.writeln('${record.level.name}: ${record.message}');
  });

  final csvDir = Directory('assets/seed/specs/fitment');
  final jsonDir = Directory('assets/seed/specs');

  if (!await csvDir.exists()) {
    _log.severe('CSV directory not found: ${csvDir.path}');
    exit(1);
  }
  if (!await jsonDir.exists()) await jsonDir.create(recursive: true);

  final csvFiles = csvDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.csv'))
      .toList();

  for (var csvFile in csvFiles) {
    final name = csvFile.uri.pathSegments.last.split('.').first;
    if (onlyBulbs && name != 'bulbs') continue;
    await _processFile(csvFile, jsonDir, dryRun: dryRun, strict: strict);
  }
}
