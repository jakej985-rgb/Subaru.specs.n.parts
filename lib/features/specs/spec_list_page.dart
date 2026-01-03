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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Spec> _results = [];
  int _currentOffset = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _results = [];
      _currentOffset = 0;
      _hasMore = true;
      _isLoading = false;
      _searchQuery = '';
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final db = ref.read(appDbProvider);
    late final List<Spec> newSpecs;

    if (_searchQuery.isNotEmpty) {
      newSpecs = await db.specsDao.searchSpecs(_searchQuery,
          limit: pageSize, offset: _currentOffset);
    } else {
      newSpecs =
          await db.specsDao.getSpecsPaged(pageSize, offset: _currentOffset);
    }

    if (mounted) {
      setState(() {
        _results.addAll(newSpecs);
        _currentOffset += newSpecs.length;
        if (newSpecs.length < pageSize) {
          _hasMore = false;
        }
        _isLoading = false;
      });
    }
  }

  void _search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        _loadInitial();
        return;
      }

      setState(() {
        _searchQuery = query;
        _results = [];
        _currentOffset = 0;
        _hasMore = true;
        _isLoading = false;
      });

      await _loadMore();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    // Cancel any pending search debounce
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Immediately reload initial data
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
            child: ListView.builder(
              controller: _scrollController,
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
                    // Show detail dialog or page
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
        ],
      ),
    );
  }
}
