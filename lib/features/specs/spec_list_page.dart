import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/spec_list_controller.dart';

class SpecListPage extends ConsumerStatefulWidget {
  const SpecListPage({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  ConsumerState<SpecListPage> createState() => _SpecListPageState();
}

class _SpecListPageState extends ConsumerState<SpecListPage> {
  late final ScrollController _controller;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
    // Initialize controller with vehicle if present
    // We use a microtask to avoid building/modifying provider during build
    if (widget.vehicle != null) {
      Future.microtask(() {
        ref
            .read(specListControllerProvider.notifier)
            .setVehicle(widget.vehicle);
      });
    }
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(specListControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(specListControllerProvider.notifier).setQuery(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    ref.read(specListControllerProvider.notifier).setQuery('');
  }

  @override
  Widget build(BuildContext context) {
    // ⚡ Bolt Optimization: Use select to only watch relevant state fields.
    // This prevents unnecessary rebuilds when fields like 'query' or 'generation' change
    // in the state but don't affect the UI structure directly (since query is managed via controller).
    final s = ref.watch(
      specListControllerProvider.select(
        (state) => (
          items: state.items,
          isLoadingInitial: state.isLoadingInitial,
          isLoadingMore: state.isLoadingMore,
          query: state.query,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Specs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              key: const Key('specSearchField'),
              controller: _searchController,
              maxLength: 100, // Security: Limit input length to prevent DoS
              decoration: InputDecoration(
                labelText: 'Search Specs',
                border: const OutlineInputBorder(),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Clear search',
                            onPressed: _clearSearch,
                          )
                        : const Icon(Icons.search);
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: s.isLoadingInitial
                ? const Center(child: CircularProgressIndicator())
                : s.items.isEmpty
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
                          s.query.isNotEmpty
                              ? 'No specs found for "${s.query}"'
                              : 'No specs found',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        if (s.query.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Search'),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    key: const Key('specListView'),
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: s.items.length + (s.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= s.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final spec = s.items[index];
                      return ListTile(
                        key: Key('spec_row_${spec.id}'),
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
                                  Text(
                                    'Category: ${spec.category}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(spec.body),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tags: ${spec.tags}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
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
