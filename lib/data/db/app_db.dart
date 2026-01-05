import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:specsnparts/data/db/tables.dart';
import 'package:specsnparts/data/db/dao/parts_dao.dart';
import 'package:specsnparts/data/db/dao/specs_dao.dart';
import 'package:specsnparts/data/db/dao/vehicles_dao.dart';

part 'app_db.g.dart';

@DriftDatabase(
  tables: [Vehicles, Specs, Parts],
  daos: [VehiclesDao, SpecsDao, PartsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_db');
  }
}

final appDbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
