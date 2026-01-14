import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
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
  final List<String>? categories;

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
    this.categories,
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
    List<String>? categories,
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
    categories: categories ?? this.categories,
  );
}

final specListControllerProvider =
    NotifierProvider.autoDispose<SpecListController, SpecListState>(
      SpecListController.new,
    );

class SpecListController extends Notifier<SpecListState> {
  late final SpecsDao _dao;

  @override
  SpecListState build() {
    _dao = ref.read(appDbProvider).specsDao;
    Future.microtask(() => loadInitial());
    return const SpecListState();
  }

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

      // Filter by categories if present
      if (state.categories != null && state.categories!.isNotEmpty) {
        final cats = state.categories!;
        results.retainWhere((s) => cats.contains(s.category));
      }

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

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoadingInitial) return;
    if (state.vehicle != null) return; // Vehicle mode doesn't paginate yet

    state = state.copyWith(isLoadingMore: true);
    final gen = state.generation;

    final newItems = state.query.isNotEmpty
        ? await _dao.searchSpecs(
            state.query,
            limit: state.limit,
            offset: state.offset,
          )
        : await _dao.getSpecsPaged(state.limit, offset: state.offset);

    if (state.generation != gen) return;

    state = state.copyWith(
      isLoadingMore: false,
      items: [...state.items, ...newItems],
      offset: state.offset + newItems.length,
      hasMore: newItems.length == state.limit,
    );
  }

  void setQuery(String query) {
    if (state.query == query) return;
    state = state.copyWith(query: query);
    loadInitial();
  }

  void setVehicle(Vehicle? vehicle) {
    if (state.vehicle == vehicle) return;
    state = state.copyWith(vehicle: vehicle);
    loadInitial();
  }

  void setCategories(List<String> categories) {
    // Basic equality check for list to avoid reload
    // Assuming clean immutable lists or just always reloading is safer.
    // If list content is identical, skip? To simplify, just set.
    state = state.copyWith(categories: categories);
    loadInitial();
  }
}
