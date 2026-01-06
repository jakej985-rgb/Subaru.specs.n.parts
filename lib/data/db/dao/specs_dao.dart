import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';

part 'specs_dao.g.dart';

@DriftAccessor(tables: [Specs])
class SpecsDao extends DatabaseAccessor<AppDatabase> with _$SpecsDaoMixin {
  SpecsDao(super.db);

  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) =>
      (select(specs)..limit(limit, offset: offset)).get();

  Future<List<Spec>> getSpecsByCategory(String category) =>
      (select(specs)..where((tbl) => tbl.category.equals(category))).get();

  Future<List<Spec>> searchSpecs(
    String query, {
    int limit = 50,
    int offset = 0,
  }) {
    // Security: Input length limit to prevent DoS via massive regex/contains checks
    if (query.length > 100) return Future.value([]);

    return (select(specs)
          ..where((tbl) => tbl.title.contains(query) | tbl.body.contains(query))
          ..limit(limit, offset: offset))
        .get();
  }

  Future<void> insertSpec(Spec spec) =>
      into(specs).insert(spec, mode: InsertMode.insertOrReplace);

  Future<void> insertMultiple(List<Spec> list) async {
    await batch((batch) {
      batch.insertAll(specs, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<Spec>> getSpecsForVehicle(
    Vehicle vehicle, {
    String? query,
  }) async {
    // 1. Broad fetch: Get specs that mention the model AND year.
    // This mimics the "inferred" logic of matching attributes to tags.
    final model = vehicle.model.toLowerCase();
    final year = vehicle.year.toString();

    final candidates = await (select(specs)..where((tbl) {
      var predicate = tbl.tags.contains(model) & tbl.tags.contains(year);
      if (query != null && query.isNotEmpty) {
        predicate &= (tbl.title.contains(query) | tbl.body.contains(query));
      }
      return predicate;
    })).get();

    // 2. Post-filter for Trim applicability
    final trim = vehicle.trim?.toLowerCase() ?? '';

    return candidates.where((spec) {
      final tags = spec.tags.toLowerCase();
      final hasBaseTag = tags.contains('base');
      final hasLimitedTag = tags.contains('limited');

      // If spec is trim-agnostic (no specific trim tags), it applies to all trims.
      if (!hasBaseTag && !hasLimitedTag) return true;

      // If spec has trim tags, vehicle must match one of them.
      // Using contains to handle "Base (US)" vs "base".
      if (hasBaseTag && trim.contains('base')) return true;
      if (hasLimitedTag && trim.contains('limited')) return true;

      // If spec is tagged for a trim but vehicle doesn't match, exclude it.
      return false;
    }).toList();
  }
}
