import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/tokens.dart';

// Provider to get years with vehicle counts
final yearsWithCountsProvider = FutureProvider<Map<int, int>>((ref) async {
  final db = ref.watch(appDbProvider);
  return db.vehiclesDao.getVehicleCountsByYear();
});

class CategoryYearPickerPage extends ConsumerStatefulWidget {
  final String categoryKey;

  const CategoryYearPickerPage({super.key, required this.categoryKey});

  @override
  ConsumerState<CategoryYearPickerPage> createState() =>
      _CategoryYearPickerPageState();
}

class _CategoryYearPickerPageState
    extends ConsumerState<CategoryYearPickerPage> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    final cat = SpecCategoryKey.fromKey(widget.categoryKey);
    if (cat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid Category')),
        body: const Center(child: Text('Category not found')),
      );
    }

    final yearsAsync = ref.watch(yearsWithCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${cat.title} - Select Year'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
            tooltip: _isGrid ? 'Switch to List' : 'Switch to Grid',
          ),
        ],
      ),
      body: yearsAsync.when(
        data: (yearCounts) {
          if (yearCounts.isEmpty) {
            return const Center(child: Text('No vehicle data available'));
          }
          final years = yearCounts.keys.toList();

          if (_isGrid) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final count = yearCounts[year] ?? 0;
                return InkWell(
                  onTap: () => context.push(
                    '/specs/categories/${widget.categoryKey}/$year',
                  ),
                  borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                  child: CarbonSurface(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          year.toString(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: ThemeTokens.neonBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$count',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ThemeTokens.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: years.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final year = years[index];
              final count = yearCounts[year] ?? 0;
              return InkWell(
                onTap: () => context.push(
                  '/specs/categories/${widget.categoryKey}/$year',
                ),
                borderRadius: BorderRadius.circular(ThemeTokens.radiusMedium),
                child: CarbonSurface(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            year.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '$count vehicles',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: ThemeTokens.textMuted),
                          ),
                        ],
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
