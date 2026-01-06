import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:specsnparts/data/db/app_db.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('SpecsDao', () {
    test('getSpecsPaged respects limit and offset', () async {
      // Create test data
      final specs = List.generate(
        10,
        (i) => Spec(
          id: 'spec_$i',
          title: 'Spec $i',
          category: 'General',
          body: 'Body of spec $i',
          tags: 'tag',
          updatedAt: DateTime.now(),
        ),
      );

      await db.specsDao.insertMultiple(specs);

      // Test Limit
      final paged1 = await db.specsDao.getSpecsPaged(3);
      expect(paged1.length, 3);
      expect(paged1.map((s) => s.id), ['spec_0', 'spec_1', 'spec_2']);

      // Test Offset
      final paged2 = await db.specsDao.getSpecsPaged(3, offset: 3);
      expect(paged2.length, 3);
      expect(paged2.map((s) => s.id), ['spec_3', 'spec_4', 'spec_5']);

      // Test Limit > Remaining
      final paged3 = await db.specsDao.getSpecsPaged(5, offset: 8);
      expect(paged3.length, 2);
      expect(paged3.map((s) => s.id), ['spec_8', 'spec_9']);
    });

    test('getSpecsForVehicle filters by tags and query', () async {
      final specs = [
        Spec(
          id: 'spec_1',
          title: 'Oil Capacity',
          category: 'Fluid',
          body: '4.4 Quarts',
          tags: 'outback,2022,base',
          updatedAt: DateTime.now(),
        ),
        Spec(
          id: 'spec_2',
          title: 'Tire Pressure',
          category: 'Wheels',
          body: '35 PSI',
          tags: 'outback,2022',
          updatedAt: DateTime.now(),
        ),
        Spec(
          id: 'spec_3',
          title: 'Oil Capacity',
          category: 'Fluid',
          body: '5.1 Quarts',
          tags: 'forester,2022',
          updatedAt: DateTime.now(),
        ),
      ];

      await db.specsDao.insertMultiple(specs);

      final vehicle = Vehicle(
        id: 'v1',
        year: 2022,
        make: 'Subaru',
        model: 'Outback',
        trim: 'Base',
        updatedAt: DateTime.now(),
      );

      // Test without query
      final results = await db.specsDao.getSpecsForVehicle(vehicle);
      expect(results.length, 2);
      expect(results.map((s) => s.id), containsAll(['spec_1', 'spec_2']));

      // Test with query
      final filteredResults = await db.specsDao.getSpecsForVehicle(
        vehicle,
        query: 'Oil',
      );
      expect(filteredResults.length, 1);
      expect(filteredResults.first.id, 'spec_1');
    });
  });
}
