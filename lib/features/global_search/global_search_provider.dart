import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/vin_wizard/vin_decoder.dart';

class GlobalSearchState {
  final List<Vehicle> vehicles;
  final List<Part> parts;
  final List<Spec> specs;
  final bool isLoading;
  final String query;
  final String? error;

  GlobalSearchState({
    this.vehicles = const [],
    this.parts = const [],
    this.specs = const [],
    this.isLoading = false,
    this.query = '',
    this.error,
  });

  bool get isEmpty =>
      vehicles.isEmpty && parts.isEmpty && specs.isEmpty && query.isNotEmpty;
  bool get hasResults =>
      vehicles.isNotEmpty || parts.isNotEmpty || specs.isNotEmpty;

  GlobalSearchState copyWith({
    List<Vehicle>? vehicles,
    List<Part>? parts,
    List<Spec>? specs,
    bool? isLoading,
    String? query,
    String? error,
  }) {
    return GlobalSearchState(
      vehicles: vehicles ?? this.vehicles,
      parts: parts ?? this.parts,
      specs: specs ?? this.specs,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      error: error ?? this.error,
    );
  }
}

final globalSearchProvider =
    NotifierProvider<GlobalSearchNotifier, GlobalSearchState>(
      GlobalSearchNotifier.new,
    );

class GlobalSearchNotifier extends Notifier<GlobalSearchState> {
  @override
  GlobalSearchState build() {
    return GlobalSearchState();
  }

  Future<void> search(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      state = GlobalSearchState();
      return;
    }

    if (cleanQuery == state.query) return;

    state = state.copyWith(isLoading: true, query: cleanQuery, error: null);

    try {
      final db = ref.read(appDbProvider);

      List<Vehicle> vinVehicles = [];
      if (cleanQuery.length == 17) {
        final vinResult = VinDecoder.decode(cleanQuery);
        if (vinResult.isValid) {
          vinVehicles = await db.vehiclesDao.getVehiclesByYearAndModel(
            vinResult.year!,
            vinResult.model!,
          );
        }
      }

      // Parallel fetch from all DAOs
      final results = await Future.wait([
        db.vehiclesDao.searchVehicles(cleanQuery, limit: 10),
        db.partsDao.searchParts(cleanQuery, limit: 10),
        db.specsDao.searchSpecs(cleanQuery, limit: 10),
      ]);

      if (state.query != cleanQuery) return; // Debounce/Race condition check

      final searchVehicles = results[0] as List<Vehicle>;

      // Combine VIN results with search results, avoiding duplicates
      final combinedVehicles = <String, Vehicle>{};
      for (final v in vinVehicles) {
        combinedVehicles[v.id] = v;
      }
      for (final v in searchVehicles) {
        combinedVehicles[v.id] = v;
      }

      state = state.copyWith(
        vehicles: combinedVehicles.values.toList(),
        parts: results[1] as List<Part>,
        specs: results[2] as List<Spec>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = GlobalSearchState();
  }
}
