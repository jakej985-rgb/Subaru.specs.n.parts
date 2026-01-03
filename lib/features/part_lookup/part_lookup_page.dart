import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';

class PartLookupPage extends ConsumerStatefulWidget {
  const PartLookupPage({super.key});

  @override
  ConsumerState<PartLookupPage> createState() => _PartLookupPageState();
}

class _PartLookupPageState extends ConsumerState<PartLookupPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Part> _results = [];
  Timer? _debounce;
  int _currentOffset = 0;
  final int _pageLimit = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchControllerChanged() {
    // Rebuild to update the clear button visibility state
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore &&
        _searchQuery.isNotEmpty) {
      _loadMore(_searchQuery);
    }
  }

  Future<void> _loadMore(String query) async {
    // If the query passed to this function is not the current one, abort.
    if (query != _searchQuery) return;
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final db = ref.read(appDbProvider);
    try {
      final results = await db.partsDao.searchParts(
        query,
        limit: _pageLimit,
        offset: _currentOffset,
      );

      if (!mounted) return;

      // Check again if the query has changed while we were waiting
      if (query != _searchQuery) return;

      setState(() {
        _results.addAll(results);
        _currentOffset += results.length;
        if (results.length < _pageLimit) {
          _hasMore = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (mounted && query == _searchQuery) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // If the query is effectively empty (or unchanged from a logic perspective, though UI handles that), reset.

      setState(() {
        _searchQuery = query;
        _results = [];
        _currentOffset = 0;
        _hasMore = true;
        _isLoading = false;
      });

      if (query.isEmpty) {
        return;
      }

      await _loadMore(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _searchQuery = '';
      _results = [];
      _currentOffset = 0;
      _hasMore = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Part Lookup')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or OEM Number',
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
            child: _searchQuery.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.manage_search, size: 64, color: Theme.of(context).hintColor),
                        const SizedBox(height: 16),
                        Text(
                          'Start typing to search parts...',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                      ],
                    ),
                  )
                : _results.isEmpty && !_isLoading
                    ? const Center(child: Text('No parts found.'))
                    : ListView.builder(
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
                      final part = _results[index];
                      return ListTile(
                        title: Text(part.name),
                        subtitle: Text('OEM: ${part.oemNumber}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(part.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('OEM: ${part.oemNumber}'),
                                  if (part.notes != null) ...[
                                    const SizedBox(height: 8),
                                    Text(part.notes!),
                                  ],
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
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
