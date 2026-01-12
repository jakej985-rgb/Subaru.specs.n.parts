import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';
import 'package:specsnparts/features/specs/spec_list_controller.dart';
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

class MockAppDatabase implements AppDatabase {
  final _vehiclesDao = MockVehiclesDao();

  @override
  VehiclesDao get vehiclesDao => _vehiclesDao;

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
