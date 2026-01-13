import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_chip.dart';

class GarageView extends ConsumerWidget {
  const GarageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteVehiclesProvider);
    final recents = ref.watch(recentVehiclesProvider);

    if (favorites.isEmpty && recents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (favorites.isNotEmpty) ...[
          _SectionHeader(
            title: 'Favorites',
            icon: Icons.favorite,
            iconColor: Colors.redAccent,
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _GarageCard(vehicle: favorites[index], isFavorite: true);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (recents.isNotEmpty) ...[
          _SectionHeader(
            title: 'Recently Viewed',
            icon: Icons.history,
            trailing: TextButton(
              onPressed: () {
                ref.read(recentVehiclesProvider.notifier).clear();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: ThemeTokens.textMuted),
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: recents.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final v = recents[index];
                final isFav = ref
                    .watch(favoriteVehiclesProvider.notifier)
                    .isFavorite(v);
                return _GarageCard(vehicle: v, isFavorite: isFav);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? ThemeTokens.neonBlue),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _GarageCard extends ConsumerWidget {
  final Vehicle vehicle;
  final bool isFavorite;

  const _GarageCard({required this.vehicle, required this.isFavorite});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 240,
      child: CarbonSurface(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name + Heart
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.year.toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ThemeTokens.neonBlue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${vehicle.make} ${vehicle.model}',
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          vehicle.trim ?? 'Base',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: ThemeTokens.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (vehicle.engineCode != null) ...[
                          const SizedBox(height: 4),
                          NeonChip(label: vehicle.engineCode!),
                        ],
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref
                          .read(favoriteVehiclesProvider.notifier)
                          .toggle(vehicle);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.redAccent
                            : ThemeTokens.textMuted,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Footer: Actions
            Container(
              decoration: BoxDecoration(
                color: ThemeTokens.surface.withValues(alpha: 0.5),
                border: const Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          context.push('/specs', extra: {'vehicle': vehicle}),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'SPECS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 20, color: Colors.white10),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/parts', extra: vehicle),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'PARTS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
