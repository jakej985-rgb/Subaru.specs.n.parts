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

  test('Vehicles can be inserted and retrieved', () async {
    final vehicle = Vehicle(
      id: 'v1',
      year: 2024,
      make: 'Subaru',
      model: 'WRX',
      trim: 'Limited',
      engineCode: 'FA24',
      updatedAt: DateTime.now(),
    );

    await db.vehiclesDao.insertVehicle(vehicle);
    final list = await db.vehiclesDao.getAllVehicles();

    expect(list.length, 1);
    expect(list.first.model, 'WRX');
  });
}
