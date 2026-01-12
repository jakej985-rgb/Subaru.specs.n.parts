import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Vehicle makeVehicle(String id) {
    final parts = id.split('|');
    return Vehicle(
      id: id,
      year: int.parse(parts[0]),
      make: parts[1],
      model: parts[2],
      trim: parts[3],
      updatedAt: DateTime.now(),
    );
  }

  test('RecentVehiclesNotifier adds items and persists', () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    final notifier = container.read(recentVehiclesProvider.notifier);
    final v1 = makeVehicle('2022|Subaru|WRX|Premium');

    await notifier.add(v1);

    expect(container.read(recentVehiclesProvider), hasLength(1));
    expect(
      container.read(recentVehiclesProvider).first.id,
      '2022|Subaru|WRX|Premium',
    );

    // Verify Persistence
    final json = prefs.getString(kPrefsRecentVehiclesKey);
    expect(json, isNotNull);
    expect(json, contains('2022|Subaru|WRX|Premium'));
  });

  test('RecentVehiclesNotifier bumps duplicate to top', () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    final notifier = container.read(recentVehiclesProvider.notifier);
    final v1 = makeVehicle('2020|Subaru|Outback|Base');
    final v2 = makeVehicle('2022|Subaru|WRX|Premium');

    await notifier.add(v1);
    await notifier.add(v2);

    expect(
      container.read(recentVehiclesProvider).first.id,
      v2.id,
    ); // 2022 WRX first

    // Add v1 again
    await notifier.add(v1);

    final list = container.read(recentVehiclesProvider);
    expect(list, hasLength(2));
    expect(list.first.id, v1.id); // 2020 Outback bumped to top
    expect(list.last.id, v2.id);
  });

  test('RecentVehiclesNotifier respects limit', () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    final notifier = container.read(recentVehiclesProvider.notifier);

    for (int i = 0; i < 6; i++) {
      await notifier.add(makeVehicle('202$i|Subaru|Model|Trim'));
    }

    expect(container.read(recentVehiclesProvider), hasLength(5));
    // Should contain 2025 (latest added) at top
    expect(container.read(recentVehiclesProvider).first.year, 2025);
    // Should NOT contain 2020 (oldest)
    expect(
      container.read(recentVehiclesProvider).any((v) => v.year == 2020),
      isFalse,
    );
  });

  test('FavoriteVehiclesNotifier toggles correctly', () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    final notifier = container.read(favoriteVehiclesProvider.notifier);
    final v1 = makeVehicle('2022|Subaru|WRX|Premium');

    // Add
    await notifier.toggle(v1);
    expect(notifier.isFavorite(v1), isTrue);
    expect(container.read(favoriteVehiclesProvider), hasLength(1));

    // Remove
    await notifier.toggle(v1);
    expect(notifier.isFavorite(v1), isFalse);
    expect(container.read(favoriteVehiclesProvider), isEmpty);
  });
}
