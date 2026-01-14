import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/features/part_lookup/part_search_provider.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  test('RecentPartSearchesNotifier adds items and limits size', () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    final notifier = container.read(recentPartSearchesProvider.notifier);

    // Add 1
    await notifier.add('turbo');
    expect(container.read(recentPartSearchesProvider), ['turbo']);

    // Add 2
    await notifier.add('gasket');
    expect(container.read(recentPartSearchesProvider), ['gasket', 'turbo']);

    // Add duplicate (bumps to top)
    await notifier.add('turbo');
    expect(container.read(recentPartSearchesProvider), ['turbo', 'gasket']);

    // Add many to test limit (10)
    for (int i = 0; i < 15; i++) {
      await notifier.add('part $i');
    }

    final list = container.read(recentPartSearchesProvider);
    expect(list.length, 10);
    expect(list.first, 'part 14');
  });
}
