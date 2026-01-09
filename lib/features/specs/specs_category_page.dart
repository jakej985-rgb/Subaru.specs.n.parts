import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SpecsCategory {
  fluids('Lubrication & Fluids', Icons.water_drop, [
    'Oil',
    'Fluids',
    'Coolant',
  ]),
  lighting('Lighting (Bulbs)', Icons.lightbulb, ['Bulbs']),
  maintenance('Maintenance & Service', Icons.build, [
    'Maintenance',
    'Maintenance Intervals',
    'Spark Plugs',
    'Cooling',
  ]),
  torque('Torque Specifications', Icons.rotate_right, ['Torque']),
  engine('Engine Specifications', Icons.engineering, ['Engine']),
  drivetrain('Drivetrain & Transmission', Icons.settings_input_component, [
    'Transmission',
    'Differential',
  ]),
  capacities('Capacities & Dimensions', Icons.aspect_ratio, [
    'Dimensions',
    'Wheels',
    'Tires',
  ]),
  filters('Filters & Wear Items', Icons.filter_alt, ['Filters']),
  notes('Notes & Warnings', Icons.warning, ['Swap Rules', 'Notes']);

  final String label;
  final IconData icon;
  final List<String> dataCategories;

  const SpecsCategory(this.label, this.icon, this.dataCategories);
}

class SpecsCategoryPage extends StatelessWidget {
  const SpecsCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Specs by Category')),
      body: ListView.separated(
        itemCount: SpecsCategory.values.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final cat = SpecsCategory.values[index];
          return ListTile(
            leading: Icon(cat.icon),
            title: Text(cat.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to YMM Flow, passing the selected category data keys (List<String>)
              // The YMM Flow page handles the "Ask Year -> Model -> Trim" flow.
              // We pass the filter so it can be forwarded to the final Specs List.
              context.push(
                '/browse/ymm',
                extra: {'categories': cat.dataCategories},
              );
            },
          );
        },
      ),
    );
  }
}
