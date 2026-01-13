import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
import 'package:specsnparts/theme/tokens.dart';

// Provider to fetch spec counts by category
final specCountsByCategoryProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final db = ref.watch(appDbProvider);
  return db.specsDao.getSpecCountsByCategory();
});

class SpecsByCategoryHubPage extends ConsumerWidget {
  const SpecsByCategoryHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countsAsync = ref.watch(specCountsByCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Specs by Category')),
      body: countsAsync.when(
        data: (counts) => ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: SpecCategoryKey.values.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cat = SpecCategoryKey.values[index];
            // Sum counts for all categories this key covers
            final count = cat.dataCategories.fold<int>(
              0,
              (sum, c) => sum + (counts[c] ?? 0),
            );
            return NeonPlate(
              onTap: () {
                context.go('/specs/categories/${cat.key}/years');
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeTokens.neonBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(cat.icon, color: ThemeTokens.neonBlue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (count > 0)
                          Text(
                            '$count specs',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: ThemeTokens.textMuted),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: ThemeTokens.textMuted),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
