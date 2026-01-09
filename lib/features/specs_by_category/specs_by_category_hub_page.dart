import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';

class SpecsByCategoryHubPage extends StatelessWidget {
  const SpecsByCategoryHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Specs by Category')),
      body: ListView.separated(
        itemCount: SpecCategoryKey.values.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final cat = SpecCategoryKey.values[index];
          return ListTile(
            leading: Icon(cat.icon),
            title: Text(cat.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go('/specs/categories/${cat.key}/years');
            },
          );
        },
      ),
    );
  }
}
