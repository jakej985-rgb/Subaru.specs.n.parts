import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/tokens.dart';

// Simple provider to avoid redundant calls
final distinctYearsProvider = FutureProvider<List<int>>((ref) async {
  final db = ref.watch(appDbProvider);
  return db.vehiclesDao.getDistinctYears();
});

class CategoryYearPickerPage extends ConsumerWidget {
  final String categoryKey;

  const CategoryYearPickerPage({super.key, required this.categoryKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = SpecCategoryKey.fromKey(categoryKey);
    if (cat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid Category')),
        body: const Center(child: Text('Category not found')),
      );
    }

    final yearsAsync = ref.watch(distinctYearsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('${cat.title} - Select Year')),
      body: yearsAsync.when(
        data: (years) {
          if (years.isEmpty) {
            return const Center(child: Text('No vehicle data available'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: years.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final year = years[index];
              return InkWell(
                onTap: () =>
                    context.push('/specs/categories/$categoryKey/$year'),
                borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                child: CarbonSurface(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        year.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: ThemeTokens.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
