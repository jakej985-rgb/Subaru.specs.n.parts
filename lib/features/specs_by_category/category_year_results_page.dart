import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:specsnparts/features/specs_by_category/category_year_results_controller.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';

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
    final state = ref.watch(categoryYearResultsControllerProvider((categoryKey, year)));
    final cat = SpecCategoryKey.fromKey(categoryKey);
    final title = cat?.title ?? 'Results';

    return Scaffold(
      appBar: AppBar(title: Text('$title - $year')),
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
      itemCount: state.groups.length,
      itemBuilder: (context, index) {
        final group = state.groups[index];
        return _buildModelGroup(context, group);
      },
    );
  }

  Widget _buildModelGroup(BuildContext context, VehicleGroup group) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(group.model, style: Theme.of(context).textTheme.titleLarge),
        children: group.results.map((result) {
          return _buildTrimResult(context, result);
        }).toList(),
      ),
    );
  }

  Widget _buildTrimResult(BuildContext context, VehicleResult result) {
    final hasSpecs = result.specs.isNotEmpty;
    final trimName = result.vehicle.trim ?? 'Base';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey.shade200,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            trimName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (!hasSpecs)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Missing data for this category.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          )
        else
          ...result.specs.map((spec) => ListTile(
                title: Text(spec.title),
                subtitle: Text(spec.body),
                dense: true,
              )),
      ],
    );
  }
}
