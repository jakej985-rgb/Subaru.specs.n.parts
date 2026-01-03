import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';

part 'specs_dao.g.dart';

@DriftAccessor(tables: [Specs])
class SpecsDao extends DatabaseAccessor<AppDatabase> with _$SpecsDaoMixin {
  SpecsDao(super.db);

  Future<List<Spec>> getAllSpecs() => select(specs).get();

  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) =>
      (select(specs)..limit(limit, offset: offset)).get();

  Future<List<Spec>> getSpecsByCategory(String category) =>
      (select(specs)..where((tbl) => tbl.category.equals(category))).get();

  Future<List<Spec>> searchSpecs(String query) {
    return (select(
          specs,
        )..where((tbl) => tbl.title.contains(query) | tbl.body.contains(query)))
        .get();
  }

  Future<void> insertSpec(Spec spec) =>
      into(specs).insert(spec, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Spec> list) async {
    await batch((batch) {
      batch.insertAll(specs, list, mode: InsertMode.insertOrReplace);
    });
  }
}
