import 'package:drift/drift.dart';

class Vehicles extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  TextColumn get make => text().withDefault(const Constant('Subaru'))();
  TextColumn get model => text()();
  TextColumn get trim => text().nullable()();
  TextColumn get engineCode => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Specs extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get tags => text()(); // JSON string or comma string
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Parts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get oemNumber => text()();
  TextColumn get aftermarketNumbers => text()(); // JSON string
  TextColumn get fits => text()(); // JSON string list
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
