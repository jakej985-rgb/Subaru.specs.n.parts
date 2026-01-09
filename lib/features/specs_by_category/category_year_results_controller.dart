import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';

import 'package:specsnparts/domain/fitment/fitment_key.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';

class YearResultsState {
  final List<VehicleGroup> groups;
  final bool isLoading;
  final String? error;

  YearResultsState({
    this.groups = const [],
    this.isLoading = false,
    this.error,
  });
}

class VehicleGroup {
  final String model;
  final List<VehicleResult> results;

  VehicleGroup({required this.model, required this.results});
}

class VehicleResult {
  final Vehicle vehicle;
  final List<Spec> specs;

  VehicleResult({required this.vehicle, required this.specs});
}

final categoryYearResultsControllerProvider =
    StateNotifierProvider.family<CategoryYearResultsController, YearResultsState, (String, int)>(
  (ref, args) {
    final (categoryKey, year) = args;
    return CategoryYearResultsController(ref, categoryKey, year);
  },
);

class CategoryYearResultsController extends StateNotifier<YearResultsState> {
  final Ref ref;
  final String categoryKey;
  final int year;

  CategoryYearResultsController(this.ref, this.categoryKey, this.year)
      : super(YearResultsState(isLoading: true)) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      state = YearResultsState(isLoading: true);

      final db = ref.read(appDbProvider);
      final cat = SpecCategoryKey.fromKey(categoryKey);

      if (cat == null) {
        state = YearResultsState(error: 'Invalid Category');
        return;
      }

      // 1. Fetch Values
      final vehicles = await db.vehiclesDao.getVehiclesByYear(year);
      if (vehicles.isEmpty) {
        state = YearResultsState(groups: []); // Empty state handled by UI
        return;
      }

      // 2. Fetch Specs for Category (all years/models to filter in memory)
      // Optimization: Could filter by Year tag in SQL if we trust tag format consistently.
      // For now, fetch all for category is safest.
      final allSpecs = await db.specsDao.getSpecsByCategoriesResult(cat.dataCategories);

      // 3. Match
      final results = <VehicleResult>[];
      for (final v in vehicles) {
        final specs = _matchSpecs(v, allSpecs);
        results.add(VehicleResult(vehicle: v, specs: specs));
      }

      // 4. Group by Model
      final Map<String, List<VehicleResult>> grouped = {};
      for (final r in results) {
        final model = r.vehicle.model;
        grouped.putIfAbsent(model, () => []).add(r);
      }

      final groups = grouped.entries
          .map((e) => VehicleGroup(model: e.key, results: e.value))
          .toList();
      
      // Sort groups by Model Name
      groups.sort((a, b) => a.model.compareTo(b.model));

      state = YearResultsState(groups: groups);
    } catch (e) {
      state = YearResultsState(error: e.toString());
    }
  }

  List<Spec> _matchSpecs(Vehicle v, List<Spec> candidates) {
    final yearStr = v.year.toString();
    final modelNorm = FitmentKey.norm(v.model);
    // final trimNorm = v.trim != null ? FitmentKey.norm(v.trim!) : '';

    return candidates.where((s) {
      // 1. Year Match (Tag)
      // Tags are comma separated string.
      if (!s.tags.contains(yearStr)) return false;

      // 2. Model Match
      // Check if ANY model alias is present
      // Aliases logic from SpecsDao
      bool modelMatch = s.tags.contains(modelNorm);
      if (!modelMatch) {
         if (modelNorm.contains('wrx') && s.tags.contains('wrx')) modelMatch = true;
         if (modelNorm.contains('sti') && s.tags.contains('sti')) modelMatch = true;
         if (modelNorm.contains('outback') && s.tags.contains('outback')) modelMatch = true;
         // Add other aliases as needed
      }
      if (!modelMatch) return false;

      // 3. Trim Filtering (Negative match)
      // If spec is tagged "limited" but vehicle is "base", exclude.
      // Logic: If tags contain any KNOWN TRIM key, check if vehicle has it.
      // This is simplified. SpecDao has complex logic.
      // For now, accept broad matches to avoid hiding data (better false positive than false negative?).
      // User requested "Group by trim".
      
      return true;
    }).toList();
  }
}
