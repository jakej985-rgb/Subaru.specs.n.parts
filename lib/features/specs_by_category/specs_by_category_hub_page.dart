import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
import 'package:specsnparts/theme/tokens.dart';

class SpecsByCategoryHubPage extends StatelessWidget {
  const SpecsByCategoryHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Specs by Category')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: SpecCategoryKey.values.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = SpecCategoryKey.values[index];
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
                  child: Text(
                    cat.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.chevron_right, color: ThemeTokens.textMuted),
              ],
            ),
          );
        },
      ),
    );
  }
}
