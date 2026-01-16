import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/carbon_surface.dart';
import 'package:specsnparts/features/global_search/global_search_provider.dart';
import 'package:specsnparts/features/part_lookup/widgets/part_dialog.dart';

class GlobalSearchOverlay extends ConsumerStatefulWidget {
  const GlobalSearchOverlay({super.key});

  @override
  ConsumerState<GlobalSearchOverlay> createState() =>
      _GlobalSearchOverlayState();
}

class _GlobalSearchOverlayState extends ConsumerState<GlobalSearchOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(globalSearchProvider);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: ThemeTokens.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search models, parts, or specs...',
                        hintStyle: const TextStyle(
                          color: ThemeTokens.textMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ThemeTokens.neonBlue,
                        ),
                        filled: true,
                        fillColor: ThemeTokens.surfaceRaised,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ThemeTokens.neonBlue,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ThemeTokens.neonBlue,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ThemeTokens.neonBlue,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: ThemeTokens.textMuted,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  ref
                                      .read(globalSearchProvider.notifier)
                                      .clear();
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) =>
                          ref.read(globalSearchProvider.notifier).search(val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: ThemeTokens.neonBlue),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ThemeTokens.neonBlue,
                      ),
                    )
                  : state.isEmpty
                      ? _buildEmptyState()
                      : _buildResults(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 64, color: ThemeTokens.textMuted),
          const SizedBox(height: 16),
          Text(
            'No matches for "${_controller.text}"',
            style: const TextStyle(color: ThemeTokens.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(GlobalSearchState state) {
    if (!state.hasResults && _controller.text.isEmpty) {
      return const SizedBox();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (state.vehicles.isNotEmpty) ...[
          _buildHeader('MODELS'),
          ...state.vehicles.map((v) => _buildVehicleTile(v)),
        ],
        if (state.parts.isNotEmpty) ...[
          _buildHeader('PARTS'),
          ...state.parts.map((p) => _buildPartTile(p)),
        ],
        if (state.specs.isNotEmpty) ...[
          _buildHeader('SPECS'),
          ...state.specs.map((s) => _buildSpecTile(s)),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: ThemeTokens.neonBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildVehicleTile(dynamic vehicle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CarbonSurface(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(
            '${vehicle.year} ${vehicle.model}',
            style: const TextStyle(color: ThemeTokens.textPrimary),
          ),
          subtitle: Text(
            vehicle.trim ?? vehicle.engineCode ?? '',
            style: const TextStyle(color: ThemeTokens.textMuted),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: ThemeTokens.textMuted,
          ),
          onTap: () {
            context.pop();
            context.push('/specs', extra: vehicle);
          },
        ),
      ),
    );
  }

  Widget _buildPartTile(dynamic part) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CarbonSurface(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(
            part.name,
            style: const TextStyle(color: ThemeTokens.textPrimary),
          ),
          subtitle: Text(
            'OEM: ${part.oemNumber}',
            style: const TextStyle(color: ThemeTokens.textMuted),
          ),
          trailing: const Icon(Icons.info_outline, color: ThemeTokens.neonBlue),
          onTap: () {
            // Open part details dialog
            showDialog(
              context: context,
              builder: (context) => PartDialog(part: part),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecTile(dynamic spec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CarbonSurface(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(
            spec.title,
            style: const TextStyle(color: ThemeTokens.textPrimary),
          ),
          subtitle: Text(
            spec.category,
            style: const TextStyle(color: ThemeTokens.textMuted),
          ),
          trailing: const Icon(
            Icons.description_outlined,
            color: ThemeTokens.textMuted,
          ),
          onTap: () {
            // Navigate to spec list... but we need a vehicle context.
            // For alpha, we just show a snackbar or navigate to general specs.
            // Actually, many specs are tagged with years/models.
            // Ideally we'd find a matching vehicle or just show the spec details.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Navigation to specific spec context coming soon',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
