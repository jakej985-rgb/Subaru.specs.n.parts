import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:specsnparts/features/specs_by_category/category_year_results_controller.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/trim_header_card.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_divider.dart';
import 'package:specsnparts/theme/tokens.dart';

class CategoryYearResultsPage extends ConsumerWidget {
  final String categoryKey;
  final int year;

  const CategoryYearResultsPage({
    super.key,
    required this.categoryKey,
    required this.year,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      categoryYearResultsControllerProvider((categoryKey, year)),
    );
    final cat = SpecCategoryKey.fromKey(categoryKey);
    final title = cat?.title ?? 'Results';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cat != null) ...[
              Icon(cat.icon, size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text('$title - $year', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, YearResultsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }
    if (state.groups.isEmpty) {
      return const Center(child: Text('No vehicles found for this year.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.groups.length,
      itemBuilder: (context, index) {
        final group = state.groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: _buildModelGroup(context, group),
        );
      },
    );
  }

  Widget _buildModelGroup(BuildContext context, VehicleGroup group) {
    return TrimHeaderCard(
      title: group.model,
      initiallyExpanded: true,
      children: group.results.map((result) {
        return _buildTrimResult(context, result);
      }).toList(),
    );
  }

  Widget _buildTrimResult(BuildContext context, VehicleResult result) {
    final hasSpecs = result.specs.isNotEmpty;
    final trimName = result.vehicle.trim ?? 'Base';
    final engine = result.vehicle.engineCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: ThemeTokens.neonBlueDeep,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                trimName.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ThemeTokens.neonBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (engine != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeTokens.textMuted.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    engine,
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeTokens.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (!hasSpecs)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Missing data for this category.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: ThemeTokens.textMuted,
              ),
            ),
          )
        else
          ...result.specs.map(
            (spec) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onLongPress: () async {
                  await Clipboard.setData(ClipboardData(text: spec.body));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied: ${spec.body}'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: CarbonSurface(
                  baseColor: ThemeTokens.surface,
                  opacity: 0.05,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.title,
                        style: const TextStyle(
                          color: ThemeTokens.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec.body,
                        style: const TextStyle(
                          color: ThemeTokens.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const NeonDivider(verticalPadding: 8),
      ],
    );
  }
}
