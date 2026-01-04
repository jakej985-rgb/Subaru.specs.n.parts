import 'package:flutter_riverpod/legacy.dart';
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

  const SpecListState({
    this.items = const [],
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.query = '',
    this.generation = 0,
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
  }) =>
      SpecListState(
        items: items ?? this.items,
        isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
        query: query ?? this.query,
        generation: generation ?? this.generation,
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
    if (state.query.isNotEmpty) {
      results = await _dao.searchSpecs(state.query,
          limit: state.limit, offset: 0);
    } else {
      results = await _dao.getSpecsPaged(state.limit, offset: 0);
    }

    // ignore stale
    if (state.generation != gen) return;

    state = state.copyWith(
      isLoadingInitial: false,
      items: results,
      offset: results.length,
      hasMore: results.length == state.limit,
    );
  }

  Future<void> setQuery(String query) async {
    state = state.copyWith(query: query);
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (state.isLoadingInitial || state.isLoadingMore || !state.hasMore) return;

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
