import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';

class SpecListState {
  final List<Spec> items;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool hasMore;
  final int offset;
  final int limit;
  final String query;
  final int generation;
  final Vehicle? vehicle;

  const SpecListState({
    this.items = const [],
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.query = '',
    this.generation = 0,
    this.vehicle,
  });

  SpecListState copyWith({
    List<Spec>? items,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? hasMore,
    int? offset,
    int? limit,
    String? query,
    int? generation,
    Vehicle? vehicle,
  }) => SpecListState(
    items: items ?? this.items,
    isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasMore: hasMore ?? this.hasMore,
    offset: offset ?? this.offset,
    limit: limit ?? this.limit,
    query: query ?? this.query,
    generation: generation ?? this.generation,
    vehicle: vehicle ?? this.vehicle,
  );
}

class SpecListController extends StateNotifier<SpecListState> {
  SpecListController(this._dao) : super(const SpecListState()) {
    loadInitial();
  }

  final SpecsDao _dao;

  Future<void> loadInitial() async {
    final gen = state.generation + 1;
    state = state.copyWith(
      generation: gen,
      isLoadingInitial: true,
      isLoadingMore: false,
      hasMore: true,
      offset: 0,
      items: const [],
    );

    late final List<Spec> results;
    if (state.vehicle != null) {
      // Vehicle-specific specs fetch (currently returns all matches, no pagination support in this method yet)
      results = await _dao.getSpecsForVehicle(state.vehicle!);
      // Filter by query if present (in-memory since getSpecsForVehicle doesn't support query yet)
      if (state.query.isNotEmpty) {
        final q = state.query.toLowerCase();
        results.retainWhere(
          (s) =>
              s.title.toLowerCase().contains(q) ||
              s.body.toLowerCase().contains(q),
        );
      }
    } else if (state.query.isNotEmpty) {
      results = await _dao.searchSpecs(
        state.query,
        limit: state.limit,
        offset: 0,
      );
    } else {
      results = await _dao.getSpecsPaged(state.limit, offset: 0);
    }

    // ignore stale
    if (state.generation != gen) return;

    state = state.copyWith(
      isLoadingInitial: false,
      items: results,
      offset: results.length,
      // Disable load more for vehicle mode since we fetch all
      hasMore: state.vehicle != null ? false : results.length == state.limit,
    );
  }

  Future<void> setQuery(String query) async {
    state = state.copyWith(query: query);
    await loadInitial();
  }

  Future<void> setVehicle(Vehicle? vehicle) async {
    // Only reload if vehicle actually changes
    if (state.vehicle == vehicle) return;
    state = state.copyWith(vehicle: vehicle);
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (state.isLoadingInitial || state.isLoadingMore || !state.hasMore) return;

    // No load more for vehicle mode (as we fetch all at once currently)
    if (state.vehicle != null) return;

    final gen = state.generation;
    state = state.copyWith(isLoadingMore: true);

    late final List<Spec> results;
    if (state.query.isNotEmpty) {
      results = await _dao.searchSpecs(
        state.query,
        limit: state.limit,
        offset: state.items.length,
      );
    } else {
      results = await _dao.getSpecsPaged(
        state.limit,
        offset: state.items.length,
      );
    }

    if (state.generation != gen) return;

    final merged = [...state.items, ...results];

    state = state.copyWith(
      isLoadingMore: false,
      items: merged,
      offset: merged.length,
      hasMore: results.length == state.limit,
    );
  }
}

final specListControllerProvider =
    StateNotifierProvider<SpecListController, SpecListState>((ref) {
      final db = ref.watch(appDbProvider);
      return SpecListController(db.specsDao);
    });
