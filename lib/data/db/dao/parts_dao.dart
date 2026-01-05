import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';

part 'parts_dao.g.dart';

@DriftAccessor(tables: [Parts])
class PartsDao extends DatabaseAccessor<AppDatabase> with _$PartsDaoMixin {
  PartsDao(super.db);

  Future<List<Part>> getAllParts() => select(parts).get();

  Future<List<Part>> searchParts(String query,
      {int limit = 50, int offset = 0}) {
    return (select(parts)
          ..where(
            (tbl) => tbl.name.contains(query) | tbl.oemNumber.contains(query),
          )
          ..limit(limit, offset: offset))
        .get();
  }

  Future<void> insertPart(Part part) =>
      into(parts).insert(part, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Part> list) async {
    await batch((batch) {
      batch.insertAll(parts, list, mode: InsertMode.insertOrReplace);
    });
  }
}
