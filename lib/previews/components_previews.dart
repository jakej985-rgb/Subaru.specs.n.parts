import 'package:flutter/material.dart';
import 'package:specsnparts/widgets/home_menu_card.dart';
import 'package:specsnparts/theme/widgets/neon_chip.dart';
import 'package:specsnparts/theme/widgets/neon_plate.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'preview_wrappers.dart';

// -- Home Menu Card --

@SubaruPreview(group: 'Components', name: 'HomeMenuCard')
Widget homeMenuCardPreview() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: HomeMenuCard(
      title: 'Browse Items',
      icon: Icons.search,
      onTap: () {},
      height: 120,
    ),
  );
}

// -- Neon Chip --

@SubaruPreview(group: 'Components', name: 'NeonChip - Active')
Widget neonChipActive() {
  return const Center(child: NeonChip(label: 'Engine', isActive: true));
}

@SubaruPreview(group: 'Components', name: 'NeonChip - Inactive')
Widget neonChipInactive() {
  return const Center(child: NeonChip(label: 'Suspension', isActive: false));
}

// -- Neon Plate --

@SubaruPreview(group: 'Components', name: 'NeonPlate')
Widget neonPlatePreview() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: NeonPlate(
      onTap: () {},
      child: const Row(
        children: [
          Icon(Icons.star, color: ThemeTokens.neonBlue),
          SizedBox(width: 16),
          Text(
            'Premium Feature',
            style: TextStyle(
              color: ThemeTokens.neonBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

// -- Carbon Surface --

@SubaruPreview(group: 'Components', name: 'CarbonSurface')
Widget carbonSurfacePreview() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CarbonSurface(
      child: Text(
        'This is a carbon surface container used for grouping content.',
        style: TextStyle(color: ThemeTokens.textPrimary),
      ),
    ),
  );
}
