import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/features/specs/spec_list_controller.dart';
import 'package:specsnparts/features/specs_by_category/spec_category_keys.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/theme/widgets/neon_chip.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/features/comparison/comparison_provider.dart';
import 'package:go_router/go_router.dart';

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
  bool _showScrollToTop = false;
  String? _selectedCategoryFilter;

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

    final show = pos.pixels > 500;
    if (show != _showScrollToTop) {
      setState(() {
        _showScrollToTop = show;
      });
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

  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _copyAllSpecs() async {
    final state = ref.read(specListControllerProvider);
    if (state.items.isEmpty) return;

    final buffer = StringBuffer();
    if (widget.vehicle != null) {
      buffer.writeln(
        'Specs for ${widget.vehicle!.year} ${widget.vehicle!.model} ${widget.vehicle!.trim ?? ""}',
      );
      buffer.writeln('---');
    }

    for (final spec in state.items) {
      buffer.writeln('${spec.title} (${spec.category})');
      buffer.writeln(spec.body);
      buffer.writeln('');
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All visible specs copied')));
    }
  }

  void _onCategoryFilterChanged(String? categoryKey) {
    setState(() {
      _selectedCategoryFilter = categoryKey;
    });

    final notifier = ref.read(specListControllerProvider.notifier);
    if (categoryKey == null) {
      // Clear filter (show all, or reset to widget.categories if any)
      if (widget.categories != null) {
        notifier.setCategories(widget.categories!);
      } else {
        notifier.setCategories([]);
      }
    } else {
      // Find category config by key
      final cat = SpecCategoryKey.values.firstWhere(
        (c) => c.key == categoryKey,
        orElse: () => SpecCategoryKey.maintenance,
      );
      notifier.setCategories(cat.dataCategories);
    }
  }

  Widget _buildCategoryFilter() {
    // Only show if we aren't locked to specific categories by arguments
    if (widget.categories != null) return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: SpecCategoryKey.values.length + 1, // +1 for "All"
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _selectedCategoryFilter == null;
            return ChoiceChip(
              label: const Text('All'),
              selected: isSelected,
              onSelected: (_) => _onCategoryFilterChanged(null),
              backgroundColor: ThemeTokens.surfaceRaised,
              selectedColor: ThemeTokens.neonBlue.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? ThemeTokens.neonBlue
                    : ThemeTokens.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: isSelected
                  ? const BorderSide(color: ThemeTokens.neonBlue)
                  : BorderSide.none,
            );
          }

          final cat = SpecCategoryKey.values[index - 1]; // -1 for offset
          final isSelected = _selectedCategoryFilter == cat.key;
          return ChoiceChip(
            label: Text(cat.title),
            selected: isSelected,
            onSelected: (_) => _onCategoryFilterChanged(cat.key),
            backgroundColor: ThemeTokens.surfaceRaised,
            selectedColor: ThemeTokens.neonBlue.withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected ? ThemeTokens.neonBlue : ThemeTokens.textMuted,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            side: isSelected
                ? const BorderSide(color: ThemeTokens.neonBlue)
                : BorderSide.none,
          );
        },
      ),
    );
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
      appBar: AppBar(
        title: const Text('Specs'),
        actions: [
          if (s.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy_all),
              tooltip: 'Copy all visible specs',
              onPressed: _copyAllSpecs,
            ),
          if (widget.vehicle != null)
            Consumer(
              builder: (context, ref, child) {
                final isComparing = ref
                    .watch(comparisonProvider)
                    .contains(widget.vehicle!.id);
                return IconButton(
                  icon: Icon(
                    isComparing ? Icons.compare_arrows : Icons.add_chart,
                    color: isComparing ? ThemeTokens.neonBlue : null,
                  ),
                  tooltip: isComparing
                      ? 'Remove from Comparison'
                      : 'Add to Comparison',
                  onPressed: () {
                    if (isComparing) {
                      ref
                          .read(comparisonProvider.notifier)
                          .remove(widget.vehicle!.id);
                    } else {
                      ref
                          .read(comparisonProvider.notifier)
                          .add(widget.vehicle!);
                    }
                  },
                );
              },
            ),
        ],
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              mini: true,
              backgroundColor: ThemeTokens.surfaceRaised,
              foregroundColor: ThemeTokens.neonBlue,
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
      bottomNavigationBar: _buildComparisonTray(),
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
          _buildCategoryFilter(),
          if (widget.categories == null) const SizedBox(height: 8),
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
                                  TextButton.icon(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: spec.body),
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Copied to clipboard',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.copy, size: 18),
                                    label: const Text('Copy'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: ThemeTokens.neonBlue,
                                    ),
                                  ),
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

  Widget? _buildComparisonTray() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(comparisonProvider);
        if (state.vehicles.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton.extended(
            heroTag: 'comparison_tray',
            onPressed: () => context.push('/comparison'),
            backgroundColor: ThemeTokens.surfaceRaised,
            foregroundColor: ThemeTokens.neonBlue,
            icon: Badge(
              label: Text(state.vehicles.length.toString()),
              child: const Icon(Icons.compare_arrows),
            ),
            label: const Text('Compare'),
          ),
        );
      },
    );
  }
}
