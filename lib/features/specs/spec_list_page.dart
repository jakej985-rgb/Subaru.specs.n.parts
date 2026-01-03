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
  final ScrollController _scrollController = ScrollController();
  List<Spec> _results = [];
  int _currentOffset = 0;
  final int _pageLimit = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore &&
        !_isSearching) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _results = [];
      _currentOffset = 0;
      _hasMore = true;
      _isLoading = false;
      _isSearching = false;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final db = ref.read(appDbProvider);
    final newSpecs =
        await db.specsDao.getSpecsPaged(_pageLimit, offset: _currentOffset);

    if (mounted) {
      setState(() {
        _results.addAll(newSpecs);
        _currentOffset += newSpecs.length;
        if (newSpecs.length < _pageLimit) {
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
        _isSearching = true;
      });

      final db = ref.read(appDbProvider);
      final results = await db.specsDao.searchSpecs(query);

      if (mounted) {
        setState(() => _results = results);
      }
    });
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
              decoration: const InputDecoration(
                labelText: 'Search Specs',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
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
