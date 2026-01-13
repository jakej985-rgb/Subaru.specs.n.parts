import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';
import 'package:specsnparts/features/specs/spec_list_controller.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/features/part_lookup/part_search_provider.dart';
import 'package:specsnparts/features/home/garage_providers.dart';
import 'package:specsnparts/features/specs_by_category/category_year_results_controller.dart';
import 'package:specsnparts/theme/app_theme.dart';

// -----------------------------------------------------------------------------
// 1. Mock Data & DAOs (Stubs for DB/Network)
// -----------------------------------------------------------------------------

final _mockVehicles = [
  Vehicle(
    id: '1',
    year: 2004,
    make: 'Subaru',
    model: 'Impreza',
    trim: 'WRX STI',
    engineCode: 'EJ257',
    updatedAt: DateTime(2024, 1, 1),
  ),
  Vehicle(
    id: '2',
    year: 2004,
    make: 'Subaru',
    model: 'Impreza',
    trim: 'WRX',
    engineCode: 'EJ205',
    updatedAt: DateTime(2024, 1, 1),
  ),
  Vehicle(
    id: '3',
    year: 2024,
    make: 'Subaru',
    model: 'BRZ',
    trim: 'tS',
    engineCode: 'FA24',
    updatedAt: DateTime(2024, 1, 1),
  ),
];

class MockVehiclesDao implements VehiclesDao {
  @override
  Future<List<int>> getDistinctYears() async {
    final years = _mockVehicles.map((v) => v.year).toSet().toList();
    years.sort((a, b) => b.compareTo(a));
    return years;
  }

  @override
  Future<List<String>> getDistinctModelsByYear(int year) async {
    final models = _mockVehicles
        .where((v) => v.year == year)
        .map((v) => v.model)
        .toSet()
        .toList();
    models.sort();
    return models;
  }

  @override
  Future<List<Vehicle>> getVehiclesByYearAndModel(
    int year,
    String model,
  ) async {
    return _mockVehicles
        .where((v) => v.year == year && v.model == model)
        .toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mocks for Part Lookup

final _mockParts = [
  Part(
    id: 'p1',
    name: 'Oil Filter',
    oemNumber: '15208AA12A',
    aftermarketNumbers: '[]',
    fits: '[]',
    notes: 'Common filter',
    updatedAt: DateTime(2024),
  ),
  Part(
    id: 'p2',
    name: 'Brake Pad Set',
    oemNumber: '26296FE081',
    aftermarketNumbers: '[]',
    fits: '[]',
    notes: 'Front pads',
    updatedAt: DateTime(2024),
  ),
];

class MockPartsDao implements PartsDao {
  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
    bool sortByOem = false,
  }) async {
    final q = query.toLowerCase();
    return _mockParts
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.oemNumber.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRecentPartSearchesNotifier extends RecentPartSearchesNotifier {
  @override
  List<String> build() {
    return ['Oil Filter', 'Brake Pad', 'Turbo'];
  }

  @override
  Future<void> add(String query) async {} // No-op
  @override
  Future<void> clear() async {} // No-op
  @override
  Future<void> remove(String query) async {} // No-op
}

// Mocks for Settings / Garage

class MockRecentVehiclesNotifier extends RecentVehiclesNotifier {
  @override
  List<Vehicle> build() {
    return [
      Vehicle(
        id: '1',
        year: 2022,
        make: 'Subaru',
        model: 'WRX',
        trim: 'Premium',
        engineCode: 'FA24',
        updatedAt: DateTime(2024),
      ),
      Vehicle(
        id: '2',
        year: 2004,
        make: 'Subaru',
        model: 'Impreza',
        trim: 'WRX STI',
        engineCode: 'EJ257',
        updatedAt: DateTime(2024),
      ),
    ];
  }

  @override
  Future<void> add(Vehicle vehicle) async {} // No-op
  @override
  Future<void> clear() async {} // No-op
}

class MockFavoriteVehiclesNotifier extends FavoriteVehiclesNotifier {
  @override
  List<Vehicle> build() {
    return [
      Vehicle(
        id: 'fav1',
        year: 1998,
        make: 'Subaru',
        model: 'Impreza',
        trim: '22B',
        engineCode: 'EJ22',
        updatedAt: DateTime(2024),
      ),
    ];
  }

  @override
  bool isFavorite(Vehicle vehicle) => true;

  @override
  Future<void> toggle(Vehicle vehicle) async {} // No-op
}

// Mocks for Specs By Category

class MockCategoryYearResultsController extends CategoryYearResultsController {
  MockCategoryYearResultsController(super.arg);

  @override
  YearResultsState build() {
    // Generate dummy data based on year/category
    final year = arg.$2;
    return YearResultsState(
      groups: [
        VehicleGroup(
          model: 'Impreza',
          results: [
            VehicleResult(
              vehicle: Vehicle(
                id: 'v1',
                year: year,
                make: 'Subaru',
                model: 'Impreza',
                trim: 'WRX',
                engineCode: 'EJ205',
                updatedAt: DateTime(2024),
              ),
              specs: [
                Spec(
                  id: 's1',
                  category: 'Engine',
                  title: 'Displacement',
                  body: '2.0L',
                  tags: 'engine',
                  updatedAt: DateTime(2024),
                ),
              ],
            ),
          ],
        ),
      ],
      isLoading: false,
    );
  }

  @override
  Future<void> loadData() async {} // No-op
}

class MockAppDatabase implements AppDatabase {
  final _vehiclesDao = MockVehiclesDao();
  final _partsDao = MockPartsDao();

  @override
  VehiclesDao get vehiclesDao => _vehiclesDao;

  @override
  PartsDao get partsDao => _partsDao;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockSpecListController extends SpecListController {
  @override
  SpecListState build() {
    return SpecListState(
      items: [
        Spec(
          id: 's1',
          category: 'Engine',
          title: 'Horsepower',
          body: '300 hp @ 6000 rpm',
          tags: 'power,hp',
          updatedAt: DateTime(2024),
        ),
        Spec(
          id: 's2',
          category: 'Engine',
          title: 'Torque',
          body: '300 lb-ft @ 4000 rpm',
          tags: 'torque',
          updatedAt: DateTime(2024),
        ),
        Spec(
          id: 's3',
          category: 'Chassis',
          title: 'Curb Weight',
          body: '3,263 lbs',
          tags: 'weight',
          updatedAt: DateTime(2024),
        ),
      ],
      isLoadingInitial: false,
      hasMore: false,
    );
  }

  @override
  Future<void> loadMore() async {}
  @override
  void setQuery(String query) {}
  @override
  void setVehicle(Vehicle? vehicle) {}
  @override
  void setCategories(List<String> categories) {}
}

// -----------------------------------------------------------------------------
// 2. Overrides & Wrapper
// -----------------------------------------------------------------------------

final subaruPreviewOverrides = [
  appDbProvider.overrideWithValue(MockAppDatabase()),
  specListControllerProvider.overrideWith(() => MockSpecListController()),
  recentPartSearchesProvider.overrideWith(MockRecentPartSearchesNotifier.new),
  recentVehiclesProvider.overrideWith(MockRecentVehiclesNotifier.new),
  favoriteVehiclesProvider.overrideWith(MockFavoriteVehiclesNotifier.new),
  categoryYearResultsControllerProvider.overrideWith(
    () => MockCategoryYearResultsController(('mock', 2024)),
  ),
];

Widget subaruPreviewWrapper(Widget child) {
  return ProviderScope(
    overrides: subaruPreviewOverrides,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme, // Force dark for now as app is dark-only
      home: Scaffold(body: child),
    ),
  );
}

PreviewThemeData subaruPreviewTheme() {
  return PreviewThemeData(
    materialLight: AppTheme.darkTheme,
    materialDark: AppTheme.darkTheme,
  );
}

// -----------------------------------------------------------------------------
// 3. Custom Annotation
// -----------------------------------------------------------------------------

final class SubaruPreview extends Preview {
  const SubaruPreview({
    super.name,
    super.group,
    super.size,
    super.textScaleFactor,
    super.brightness,
  }) : super(wrapper: subaruPreviewWrapper, theme: subaruPreviewTheme);
}
