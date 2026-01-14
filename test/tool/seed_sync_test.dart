// Test for sync_fitment_csv_to_specs_json.dart
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('sync script runs without error (dry-run)', () async {
    final result = await Process.run('dart', [
      'tool/seed/sync_fitment_csv_to_specs_json.dart',
      '--dry-run',
    ], runInShell: true);
    expect(result.exitCode, equals(0), reason: 'Script should exit cleanly');
    // Ensure some output was produced
    expect(
      result.stdout,
      contains('Dry run output'),
      reason: 'Should print dry run header',
    );
  });
}
