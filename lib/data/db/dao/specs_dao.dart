import 'package:drift/drift.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/data/db/tables.dart';
import 'package:specsnparts/domain/fitment/fitment_key.dart';

part 'specs_dao.g.dart';

@DriftAccessor(tables: [Specs])
class SpecsDao extends DatabaseAccessor<AppDatabase> with _$SpecsDaoMixin {
  SpecsDao(super.db);

  Future<List<Spec>> getSpecsPaged(int limit, {int offset = 0}) =>
      (select(specs)..limit(limit, offset: offset)).get();

  Future<List<Spec>> getSpecsByCategory(String category) =>
      (select(specs)..where((tbl) => tbl.category.equals(category))).get();

  Future<List<Spec>> getSpecsByCategoriesResult(List<String> categories) =>
      (select(specs)..where((tbl) => tbl.category.isIn(categories))).get();

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
    // 1. Broad fetch: Get specs that mention the model OR applicable trim keywords AND year.
    final model = FitmentKey.norm(vehicle.model);
    final year = vehicle.year.toString();
    final trim = vehicle.trim != null ? FitmentKey.norm(vehicle.trim!) : '';

    // Heuristic: Extract model-like keywords from Trim to handle cases like "Impreza WRX"
    // where spec might be tagged "wrx" but not "impreza".
    final List<String> aliases = [];
    if (trim.contains('wrx')) aliases.add('wrx');
    if (trim.contains('sti')) aliases.add('sti');
    if (trim.contains('outback')) aliases.add('outback');
    if (trim.contains('crosstrek')) aliases.add('crosstrek');
    if (trim.contains('baja')) aliases.add('baja');

    final candidates =
        await (select(specs)..where((tbl) {
              // Must match YEAR
              Expression<bool> predicate = tbl.tags.contains(year);

              // Must match Model OR any Alias
              Expression<bool> modelMatch = tbl.tags.contains(model);
              for (final alias in aliases) {
                modelMatch = modelMatch | tbl.tags.contains(alias);
              }
              predicate &= modelMatch;

              if (query != null && query.isNotEmpty) {
                predicate &=
                    (tbl.title.contains(query) | tbl.body.contains(query));
              }
              return predicate;
            }))
            .get();

    // 2. Post-filter for Trim applicability
    // This logic ensures that if a spec is specific to a trim (e.g. tagged "base" only),
    // it doesn't show up for "limited".
    final filtered = candidates.where((spec) {
      final tagList = spec.tags
          .toLowerCase()
          .split(',')
          .map((e) => e.trim())
          .toSet();

      // Known trim tags to check against
      final knownTrims = [
        'base',
        'premium',
        'limited',
        'touring',
        'sport',
        'wilderness',
        'ts',
        'gt',
        'rs',
        'xt',
        'l',
        's',
        'xs',
        'ls',
        'lsi',
        'brighton',
        'gl',
        'dl',
      ];

      for (final t in knownTrims) {
        if (tagList.contains(t)) {
          // If spec has this trim tag, vehicle trim MUST also contain it.
          if (!trim.contains(t)) {
            // Special case below...
            // Here we are concerned with "Limited", "Base", etc.
            // If spec says "Limited" and trim is "Base", return false.
            // But if spec says "WRX" and trim is "WRX Limited", we should keep it.
            // So we strictly filter negative matches on standard trim levels.
            return false;
          }
        }
      }

      // If spec is NOT specific to any of the standard trim levels we check,
      // or if we passed the check above, keep it.
      return true;
    }).toList();

    // 3. Sort specs according to SpecHarvester rules
    filtered.sort(_specComparator);

    return filtered;
  }

  int _specComparator(Spec a, Spec b) {
    final catOrder = {
      'Oil': 0,
      'Fluids': 1,
      'Filters': 2,
      'Spark Plugs': 3,
      'Cooling': 4,
      'Brakes': 5,
      'Wheels': 6,
      'Suspension': 7,
      'Drivetrain': 8,
      'Electrical': 9,
      'Torque': 10,
    };

    final indexA = catOrder[a.category] ?? 999;
    final indexB = catOrder[b.category] ?? 999;

    if (indexA != indexB) {
      return indexA.compareTo(indexB);
    }

    return a.title.compareTo(b.title);
  }
}
