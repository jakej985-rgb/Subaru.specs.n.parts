import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/data/seed/seed_runner.dart';

void main() {
  group('Seed Parsing', () {
    test('parseVehicles parses valid JSON correctly', () {
      const jsonString = '''
      [
        {
          "id": "v1",
          "year": 2024,
          "make": "Subaru",
          "model": "WRX",
          "trim": "Limited",
          "engineCode": "FA24",
          "updatedAt": "2024-01-01T00:00:00Z"
        }
      ]
      ''';

      final vehicles = parseVehicles(jsonString);

      expect(vehicles.length, 1);
      expect(vehicles[0].id, 'v1');
      expect(vehicles[0].year, 2024);
      expect(vehicles[0].make, 'Subaru');
      expect(vehicles[0].model, 'WRX');
      expect(vehicles[0].trim, 'Limited');
      expect(vehicles[0].engineCode, 'FA24');
      expect(vehicles[0].updatedAt, DateTime.utc(2024, 1, 1));
    });

    test('parseSpecs parses valid JSON correctly', () {
      const jsonString = '''
      [
        {
          "id": "s1",
          "category": "Oil",
          "title": "WRX 2022+ Oil Capacity",
          "body": "4.8 Liters",
          "tags": "oil,capacity",
          "updatedAt": "2024-01-01T00:00:00Z"
        }
      ]
      ''';

      final specs = parseSpecs(jsonString);

      expect(specs.length, 1);
      expect(specs[0].id, 's1');
      expect(specs[0].category, 'Oil');
      expect(specs[0].title, 'WRX 2022+ Oil Capacity');
      expect(specs[0].body, '4.8 Liters');
      expect(specs[0].tags, 'oil,capacity,2022,2023,2024,2025,2026');
      expect(specs[0].updatedAt, DateTime.utc(2024, 1, 1));
    });

    test('parseParts parses valid JSON correctly', () {
      const jsonString = '''
      [
        {
          "id": "p1",
          "name": "Oil Filter",
          "oemNumber": "15208AA170",
          "aftermarketNumbers": "{\\"Wix\\": \\"57055\\"}",
          "fits": "[\\"FA20\\", \\"FA24\\"]",
          "notes": "Standard black filter",
          "updatedAt": "2024-01-01T00:00:00Z"
        }
      ]
      ''';

      final parts = parseParts(jsonString);

      expect(parts.length, 1);
      expect(parts[0].id, 'p1');
      expect(parts[0].name, 'Oil Filter');
      expect(parts[0].oemNumber, '15208AA170');
      // Verify that nested JSON strings are preserved as strings
      expect(parts[0].aftermarketNumbers, '{"Wix": "57055"}');
      expect(parts[0].fits, '["FA20", "FA24"]');
      expect(parts[0].notes, 'Standard black filter');
      expect(parts[0].updatedAt, DateTime.utc(2024, 1, 1));
    });
  });
}
