import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
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

final categoryYearResultsControllerProvider = NotifierProvider.family<
    CategoryYearResultsController,
    YearResultsState,
    (String, int)>(CategoryYearResultsController.new);

class CategoryYearResultsController extends Notifier<YearResultsState> {
  final (String, int) arg;

  CategoryYearResultsController(this.arg);

  @override
  YearResultsState build() {
    Future.microtask(() => loadData());
    return YearResultsState(isLoading: true);
  }

  String get categoryKey => arg.$1;
  int get year => arg.$2;

  Future<void> loadData() async {
    try {
      state = YearResultsState(isLoading: true);

      final db = ref.read(appDbProvider);
      final cat = SpecCategoryKey.fromKey(categoryKey);

      if (cat == null) {
        state = YearResultsState(error: 'Invalid Category');
        return;
      }

      final vehicles = await db.vehiclesDao.getVehiclesByYear(year);
      if (vehicles.isEmpty) {
        state = YearResultsState(groups: []);
        return;
      }

      final allSpecs = await db.specsDao.getSpecsByCategoriesResult(
        cat.dataCategories,
      );

      final results = <VehicleResult>[];
      for (final v in vehicles) {
        final specs = _matchSpecs(v, allSpecs);
        results.add(VehicleResult(vehicle: v, specs: specs));
      }

      final Map<String, List<VehicleResult>> grouped = {};
      for (final r in results) {
        final model = r.vehicle.model;
        grouped.putIfAbsent(model, () => []).add(r);
      }

      final groups = grouped.entries
          .map((e) => VehicleGroup(model: e.key, results: e.value))
          .toList();

      groups.sort((a, b) => a.model.compareTo(b.model));

      state = YearResultsState(groups: groups);
    } catch (e) {
      state = YearResultsState(error: e.toString());
    }
  }

  List<Spec> _matchSpecs(Vehicle v, List<Spec> candidates) {
    final yearStr = v.year.toString();
    final modelNorm = FitmentKey.norm(v.model);

    return candidates.where((s) {
      if (!s.tags.contains(yearStr)) return false;

      bool modelMatch = s.tags.contains(modelNorm);
      if (!modelMatch) {
        if (modelNorm.contains('wrx') && s.tags.contains('wrx')) {
          modelMatch = true;
        }
        if (modelNorm.contains('sti') && s.tags.contains('sti')) {
          modelMatch = true;
        }
        if (modelNorm.contains('outback') && s.tags.contains('outback')) {
          modelMatch = true;
        }
      }
      if (!modelMatch) return false;

      return true;
    }).toList();
  }
}
