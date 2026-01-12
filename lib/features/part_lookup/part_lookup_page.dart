import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/part_lookup/part_search_provider.dart';
import 'package:specsnparts/theme/tokens.dart';

class PartLookupPage extends ConsumerStatefulWidget {
  final Vehicle? vehicle;

  const PartLookupPage({super.key, this.vehicle});

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

  Vehicle? get _contextVehicle => widget.vehicle;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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

  Future<void> _fetchData(String query) async {
    final db = ref.read(appDbProvider);
    try {
      final results = await db.partsDao.searchParts(
        query,
        limit: _pageLimit,
        offset: _currentOffset,
      );

      if (query != _searchQuery) return;

      // Save valid search to history if it has results or effectively was tried
      if (results.isNotEmpty) {
        ref.read(recentPartSearchesProvider.notifier).add(query);
      }

      if (!mounted) return;

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

  Future<void> _loadMore(String query) async {
    // If the query passed to this function is not the current one, abort.
    if (query != _searchQuery) return;
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    await _fetchData(query);
  }

  void _search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchQuery = query;
          _results = [];
          _currentOffset = 0;
          _hasMore = true;
          _isLoading = false;
        });
        return;
      }

      // Optimization: Set loading state immediately to prevent empty list flash
      setState(() {
        _searchQuery = query;
        _results = [];
        _currentOffset = 0;
        _hasMore = true;
        _isLoading = true;
      });

      await _fetchData(query);
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
          if (_contextVehicle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeTokens.neonBlue.withValues(alpha: 0.1),
                  border: Border.all(
                    color: ThemeTokens.neonBlue.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tune,
                      color: ThemeTokens.neonBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Filtering for ${_contextVehicle!.year} ${_contextVehicle!.model}',
                        style: const TextStyle(
                          color: ThemeTokens.neonBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              maxLength: 100, // Security: Limit input length to prevent DoS
              decoration: InputDecoration(
                labelText: 'Search by Name or OEM Number',
                border: const OutlineInputBorder(),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return value.text.isNotEmpty
                        ? IconButton(
                            key: const Key('clear_search_button'),
                            icon: const Icon(Icons.clear),
                            tooltip: 'Clear search',
                            onPressed: _clearSearch,
                          )
                        : const Icon(Icons.search);
                  },
                ),
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
                        Icon(
                          Icons.manage_search,
                          size: 64,
                          color: Theme.of(context).hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start typing to search parts...',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 24),
                        Consumer(
                          builder: (context, ref, child) {
                            final recents = ref.watch(
                              recentPartSearchesProvider,
                            );

                            // Combine hardcoded suggestions (if no history) with actual history
                            final terms = recents.isNotEmpty
                                ? recents
                                : [
                                    'Oil Filter',
                                    'Brake Pad',
                                    'Spark Plug',
                                    'Air Filter',
                                  ];

                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                for (final term in terms)
                                  ActionChip(
                                    label: Text(term),
                                    onPressed: () {
                                      _searchController.text = term;
                                      _search(term);
                                    },
                                    avatar: Icon(
                                      recents.contains(term)
                                          ? Icons.history
                                          : Icons.search,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : _results.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No parts found for "$_searchQuery"',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Search'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
