import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/spec_list_controller.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_chip.dart';
import 'package:specsnparts/theme/tokens.dart';

class SpecListPage extends ConsumerStatefulWidget {
  const SpecListPage({super.key, this.vehicle, this.categories});

  final Vehicle? vehicle;
  final List<String>? categories;

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
    if (widget.vehicle != null || widget.categories != null) {
      Future.microtask(() {
        final notifier = ref.read(specListControllerProvider.notifier);
        if (widget.vehicle != null) notifier.setVehicle(widget.vehicle);
        if (widget.categories != null) {
          notifier.setCategories(widget.categories!);
        }
      });
    }
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final ScrollPosition pos = _controller.position;
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
                        if (widget.vehicle != null && s.query.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Debug: No matches for ${widget.vehicle!.year} ${widget.vehicle!.model} ${widget.vehicle!.trim ?? ""}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                        if (s.query.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Search'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ThemeTokens.neonBlue,
                              side: const BorderSide(
                                color: ThemeTokens.neonBlue,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.separated(
                    key: const Key('specListView'),
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: s.items.length + (s.isLoadingMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index >= s.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final spec = s.items[index];
                      return CarbonSurface(
                        key: Key('spec_row_${spec.id}'),
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: ThemeTokens.surfaceRaised,
                                title: Text(
                                  spec.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NeonChip(
                                      label: spec.category,
                                      isActive: true,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      spec.body,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tags: ${spec.tags}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: ThemeTokens.textMuted,
                                          ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                        color: ThemeTokens.neonBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        spec.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    NeonChip(
                                      label: spec.category,
                                      isActive: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  spec.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
