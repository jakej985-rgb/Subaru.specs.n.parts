import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subaru Specs & Parts')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _HomeTile(
            title: 'Browse by Year/Make/Model',
            icon: Icons.directions_car,
            onTap: () => context.go('/browse/ymm'),
          ),
          const SizedBox(height: 16),
          _HomeTile(
            title: 'Browse by Engine',
            icon: Icons.engineering,
            onTap: () => context.go('/browse/engine'),
          ),
          const SizedBox(height: 16),
          _HomeTile(
            title: 'Part Lookup',
            icon: Icons.search,
            onTap: () => context.go('/parts'),
          ),
          const SizedBox(height: 16),
          _HomeTile(
            title: 'Just Specs',
            icon: Icons.list_alt,
            onTap: () => context.go('/specs'),
          ),
          const SizedBox(height: 16),
          _HomeTile(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeTile({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
