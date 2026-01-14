import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/features/global_search/global_search_provider.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:drift/native.dart';

// Reuse or adapt Fake database logic
class FakeGlobalSearchDb extends AppDatabase {
  FakeGlobalSearchDb() : super(NativeDatabase.memory());

  int vehiclesSearchCount = 0;
  int partsSearchCount = 0;
  int specsSearchCount = 0;

  late final _vehiclesDao = _FakeVehiclesDao(this);
  @override
  VehiclesDao get vehiclesDao => _vehiclesDao;

  late final _partsDao = _FakePartsDao(this);
  @override
  PartsDao get partsDao => _partsDao;

  late final _specsDao = _FakeSpecsDao(this);
  @override
  SpecsDao get specsDao => _specsDao;
}

class _FakeVehiclesDao extends VehiclesDao {
  _FakeVehiclesDao(this.db) : super(db);
  final FakeGlobalSearchDb db;

  @override
  Future<List<Vehicle>> searchVehicles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    db.vehiclesSearchCount++;
    return [
      Vehicle(
        id: 'v1',
        year: 2004,
        make: 'Subaru',
        model: 'Impreza',
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

class _FakePartsDao extends PartsDao {
  _FakePartsDao(this.db) : super(db);
  final FakeGlobalSearchDb db;

  @override
  Future<List<Part>> searchParts(
    String query, {
    int limit = 50,
    int offset = 0,
    bool sortByOem = false,
  }) async {
    db.partsSearchCount++;
    return [
      Part(
        id: 'p1',
        name: 'Oil Filter',
        oemNumber: '123',
        aftermarketNumbers: '{}',
        fits: '[]',
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

class _FakeSpecsDao extends SpecsDao {
  _FakeSpecsDao(this.db) : super(db);
  final FakeGlobalSearchDb db;

  @override
  Future<List<Spec>> searchSpecs(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    db.specsSearchCount++;
    return [
      Spec(
        id: 's1',
        category: 'Fluids',
        title: 'Oil Capacity',
        body: '4.5L',
        tags: 'oil',
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('GlobalSearchNotifier calls all DAOs and updates state', () async {
    final db = FakeGlobalSearchDb();
    final container = ProviderContainer(
      overrides: [appDbProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(globalSearchProvider.notifier);

    // Initial state
    expect(container.read(globalSearchProvider).isLoading, false);
    expect(container.read(globalSearchProvider).hasResults, false);

    // Act
    await notifier.search('Oil');

    // Assert
    final state = container.read(globalSearchProvider);
    expect(state.isLoading, false);
    expect(state.vehicles.length, 1);
    expect(state.parts.length, 1);
    expect(state.specs.length, 1);
    expect(db.vehiclesSearchCount, 1);
    expect(db.partsSearchCount, 1);
    expect(db.specsSearchCount, 1);
    expect(state.query, 'Oil');
  });

  test('GlobalSearchNotifier clear resets state', () async {
    final db = FakeGlobalSearchDb();
    final container = ProviderContainer(
      overrides: [appDbProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(globalSearchProvider.notifier);

    await notifier.search('Test');
    notifier.clear();

    final state = container.read(globalSearchProvider);
    expect(state.query, '');
    expect(state.vehicles, isEmpty);
  });
}
