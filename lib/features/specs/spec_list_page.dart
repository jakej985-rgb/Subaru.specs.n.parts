import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';


class SpecListPage extends ConsumerStatefulWidget {
  const SpecListPage({super.key});

  @override
  ConsumerState<SpecListPage> createState() => _SpecListPageState();
}

class _SpecListPageState extends ConsumerState<SpecListPage> {
  static const int pageSize = 20;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Spec> _results = [];
  int _currentOffset = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';
  Timer? _debounce;
  int _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    // We use NotificationListener instead of _scrollController listener for better testability
    _searchController.addListener(_onSearchChanged);
    _loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Rebuild to update the suffixIcon (search vs clear)
    setState(() {});
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMore(_searchQuery);
      }
    }
    return false;
  }

  Future<void> _loadInitial() async {
    _searchGeneration++;
    final currentGen = _searchGeneration;

    setState(() {
      _results = [];
      _currentOffset = 0;
      _hasMore = true;
      _isLoading = false;
      _searchQuery = '';
    });

    await _loadMore('', generation: currentGen);
  }

  Future<void> _loadMore(String query, {int? generation}) async {
    final currentGen = generation ?? _searchGeneration;
    // If a newer search/reset has started, abort.
    if (currentGen != _searchGeneration) return;

    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final db = ref.read(appDbProvider);
    late final List<Spec> newSpecs;

    try {
      if (query.isNotEmpty) {
        newSpecs = await db.specsDao.searchSpecs(query,
            limit: pageSize, offset: _currentOffset);
      } else {
        newSpecs =
            await db.specsDao.getSpecsPaged(pageSize, offset: _currentOffset);
      }

      if (mounted) {
        // Double check generation after async call
        if (_searchGeneration != currentGen) return;

        // Double check query hasn't changed (redundant if generation logic works, but safe)
        if (_searchQuery != query) return;

        setState(() {
          _results.addAll(newSpecs);
          _currentOffset += newSpecs.length;
          if (newSpecs.length < pageSize) {
            _hasMore = false;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted && _searchGeneration == currentGen) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _searchGeneration++;
      final currentGen = _searchGeneration;

      setState(() {
        _searchQuery = query;
        _results = [];
        _currentOffset = 0;
        _hasMore = true;
        _isLoading = false;
      });

      if (query.isEmpty) {
        await _loadMore('', generation: currentGen);
        return;
      }

      await _loadMore(query, generation: currentGen);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Specs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Specs',
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: _clearSearch,
                      )
                    : const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: ListView.builder(
                controller: _scrollController,
                // Ensure list is scrollable even if items fit in viewport,
                // so tests can drag to trigger scroll events.
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _results.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _results.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final spec = _results[index];
                  return ListTile(
                    title: Text(spec.title),
                    subtitle: Text(spec.category),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(spec.title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Category: ${spec.category}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    const SizedBox(height: 8),
                                    Text(spec.body),
                                    const SizedBox(height: 8),
                                    Text('Tags: ${spec.tags}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'))
                                ],
                              ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
