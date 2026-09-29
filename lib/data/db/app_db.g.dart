// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Subaru'),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trimMeta = const VerificationMeta('trim');
  @override
  late final GeneratedColumn<String> trim = GeneratedColumn<String>(
    'trim',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineCodeMeta = const VerificationMeta(
    'engineCode',
  );
  @override
  late final GeneratedColumn<String> engineCode = GeneratedColumn<String>(
    'engine_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    make,
    model,
    trim,
    engineCode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('trim')) {
      context.handle(
        _trimMeta,
        trim.isAcceptableOrUnknown(data['trim']!, _trimMeta),
      );
    }
    if (data.containsKey('engine_code')) {
      context.handle(
        _engineCodeMeta,
        engineCode.isAcceptableOrUnknown(data['engine_code']!, _engineCodeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      trim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trim'],
      ),
      engineCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_code'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final int year;
  final String make;
  final String model;
  final String? trim;
  final String? engineCode;
  final DateTime updatedAt;
  const Vehicle({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    this.trim,
    this.engineCode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || trim != null) {
      map['trim'] = Variable<String>(trim);
    }
    if (!nullToAbsent || engineCode != null) {
      map['engine_code'] = Variable<String>(engineCode);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      year: Value(year),
      make: Value(make),
      model: Value(model),
      trim: trim == null && nullToAbsent ? const Value.absent() : Value(trim),
      engineCode: engineCode == null && nullToAbsent
          ? const Value.absent()
          : Value(engineCode),
      updatedAt: Value(updatedAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      trim: serializer.fromJson<String?>(json['trim']),
      engineCode: serializer.fromJson<String?>(json['engineCode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'trim': serializer.toJson<String?>(trim),
      'engineCode': serializer.toJson<String?>(engineCode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Vehicle copyWith({
    String? id,
    int? year,
    String? make,
    String? model,
    Value<String?> trim = const Value.absent(),
    Value<String?> engineCode = const Value.absent(),
    DateTime? updatedAt,
  }) => Vehicle(
    id: id ?? this.id,
    year: year ?? this.year,
    make: make ?? this.make,
    model: model ?? this.model,
    trim: trim.present ? trim.value : this.trim,
    engineCode: engineCode.present ? engineCode.value : this.engineCode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      trim: data.trim.present ? data.trim.value : this.trim,
      engineCode: data.engineCode.present
          ? data.engineCode.value
          : this.engineCode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('engineCode: $engineCode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, year, make, model, trim, engineCode, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.year == this.year &&
          other.make == this.make &&
          other.model == this.model &&
          other.trim == this.trim &&
          other.engineCode == this.engineCode &&
          other.updatedAt == this.updatedAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<int> year;
  final Value<String> make;
  final Value<String> model;
  final Value<String?> trim;
  final Value<String?> engineCode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.trim = const Value.absent(),
    this.engineCode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required int year,
    this.make = const Value.absent(),
    required String model,
    this.trim = const Value.absent(),
    this.engineCode = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       model = Value(model),
       updatedAt = Value(updatedAt);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? trim,
    Expression<String>? engineCode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (trim != null) 'trim': trim,
      if (engineCode != null) 'engine_code': engineCode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<String>? make,
    Value<String>? model,
    Value<String?>? trim,
    Value<String?>? engineCode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      make: make ?? this.make,
      model: model ?? this.model,
      trim: trim ?? this.trim,
      engineCode: engineCode ?? this.engineCode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (trim.present) {
      map['trim'] = Variable<String>(trim.value);
    }
    if (engineCode.present) {
      map['engine_code'] = Variable<String>(engineCode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('engineCode: $engineCode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpecsTable extends Specs with TableInfo<$SpecsTable, Spec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    title,
    body,
    tags,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'specs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Spec> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Spec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Spec(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SpecsTable createAlias(String alias) {
    return $SpecsTable(attachedDatabase, alias);
  }
}

class Spec extends DataClass implements Insertable<Spec> {
  final String id;
  final String category;
  final String title;
  final String body;
  final String tags;
  final DateTime updatedAt;
  const Spec({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.tags,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['tags'] = Variable<String>(tags);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SpecsCompanion toCompanion(bool nullToAbsent) {
    return SpecsCompanion(
      id: Value(id),
      category: Value(category),
      title: Value(title),
      body: Value(body),
      tags: Value(tags),
      updatedAt: Value(updatedAt),
    );
  }

  factory Spec.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Spec(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      tags: serializer.fromJson<String>(json['tags']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'tags': serializer.toJson<String>(tags),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Spec copyWith({
    String? id,
    String? category,
    String? title,
    String? body,
    String? tags,
    DateTime? updatedAt,
  }) => Spec(
    id: id ?? this.id,
    category: category ?? this.category,
    title: title ?? this.title,
    body: body ?? this.body,
    tags: tags ?? this.tags,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Spec copyWithCompanion(SpecsCompanion data) {
    return Spec(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      tags: data.tags.present ? data.tags.value : this.tags,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Spec(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, title, body, tags, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Spec &&
          other.id == this.id &&
          other.category == this.category &&
          other.title == this.title &&
          other.body == this.body &&
          other.tags == this.tags &&
          other.updatedAt == this.updatedAt);
}

class SpecsCompanion extends UpdateCompanion<Spec> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> title;
  final Value<String> body;
  final Value<String> tags;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SpecsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.tags = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpecsCompanion.insert({
    required String id,
    required String category,
    required String title,
    required String body,
    required String tags,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       title = Value(title),
       body = Value(body),
       tags = Value(tags),
       updatedAt = Value(updatedAt);
  static Insertable<Spec> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? tags,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (tags != null) 'tags': tags,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpecsCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String>? title,
    Value<String>? body,
    Value<String>? tags,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SpecsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpecsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oemNumberMeta = const VerificationMeta(
    'oemNumber',
  );
  @override
  late final GeneratedColumn<String> oemNumber = GeneratedColumn<String>(
    'oem_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aftermarketNumbersMeta =
      const VerificationMeta('aftermarketNumbers');
  @override
  late final GeneratedColumn<String> aftermarketNumbers =
      GeneratedColumn<String>(
        'aftermarket_numbers',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fitsMeta = const VerificationMeta('fits');
  @override
  late final GeneratedColumn<String> fits = GeneratedColumn<String>(
    'fits',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    oemNumber,
    aftermarketNumbers,
    fits,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Part> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('oem_number')) {
      context.handle(
        _oemNumberMeta,
        oemNumber.isAcceptableOrUnknown(data['oem_number']!, _oemNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_oemNumberMeta);
    }
    if (data.containsKey('aftermarket_numbers')) {
      context.handle(
        _aftermarketNumbersMeta,
        aftermarketNumbers.isAcceptableOrUnknown(
          data['aftermarket_numbers']!,
          _aftermarketNumbersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_aftermarketNumbersMeta);
    }
    if (data.containsKey('fits')) {
      context.handle(
        _fitsMeta,
        fits.isAcceptableOrUnknown(data['fits']!, _fitsMeta),
      );
    } else if (isInserting) {
      context.missing(_fitsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      oemNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oem_number'],
      )!,
      aftermarketNumbers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aftermarket_numbers'],
      )!,
      fits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fits'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final String id;
  final String name;
  final String oemNumber;
  final String aftermarketNumbers;
  final String fits;
  final String? notes;
  final DateTime updatedAt;
  const Part({
    required this.id,
    required this.name,
    required this.oemNumber,
    required this.aftermarketNumbers,
    required this.fits,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['oem_number'] = Variable<String>(oemNumber);
    map['aftermarket_numbers'] = Variable<String>(aftermarketNumbers);
    map['fits'] = Variable<String>(fits);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      name: Value(name),
      oemNumber: Value(oemNumber),
      aftermarketNumbers: Value(aftermarketNumbers),
      fits: Value(fits),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory Part.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      oemNumber: serializer.fromJson<String>(json['oemNumber']),
      aftermarketNumbers: serializer.fromJson<String>(
        json['aftermarketNumbers'],
      ),
      fits: serializer.fromJson<String>(json['fits']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'oemNumber': serializer.toJson<String>(oemNumber),
      'aftermarketNumbers': serializer.toJson<String>(aftermarketNumbers),
      'fits': serializer.toJson<String>(fits),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Part copyWith({
    String? id,
    String? name,
    String? oemNumber,
    String? aftermarketNumbers,
    String? fits,
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => Part(
    id: id ?? this.id,
    name: name ?? this.name,
    oemNumber: oemNumber ?? this.oemNumber,
    aftermarketNumbers: aftermarketNumbers ?? this.aftermarketNumbers,
    fits: fits ?? this.fits,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      oemNumber: data.oemNumber.present ? data.oemNumber.value : this.oemNumber,
      aftermarketNumbers: data.aftermarketNumbers.present
          ? data.aftermarketNumbers.value
          : this.aftermarketNumbers,
      fits: data.fits.present ? data.fits.value : this.fits,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('oemNumber: $oemNumber, ')
          ..write('aftermarketNumbers: $aftermarketNumbers, ')
          ..write('fits: $fits, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    oemNumber,
    aftermarketNumbers,
    fits,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.name == this.name &&
          other.oemNumber == this.oemNumber &&
          other.aftermarketNumbers == this.aftermarketNumbers &&
          other.fits == this.fits &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> oemNumber;
  final Value<String> aftermarketNumbers;
  final Value<String> fits;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.oemNumber = const Value.absent(),
    this.aftermarketNumbers = const Value.absent(),
    this.fits = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartsCompanion.insert({
    required String id,
    required String name,
    required String oemNumber,
    required String aftermarketNumbers,
    required String fits,
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       oemNumber = Value(oemNumber),
       aftermarketNumbers = Value(aftermarketNumbers),
       fits = Value(fits),
       updatedAt = Value(updatedAt);
  static Insertable<Part> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? oemNumber,
    Expression<String>? aftermarketNumbers,
    Expression<String>? fits,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (oemNumber != null) 'oem_number': oemNumber,
      if (aftermarketNumbers != null) 'aftermarket_numbers': aftermarketNumbers,
      if (fits != null) 'fits': fits,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? oemNumber,
    Value<String>? aftermarketNumbers,
    Value<String>? fits,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      oemNumber: oemNumber ?? this.oemNumber,
      aftermarketNumbers: aftermarketNumbers ?? this.aftermarketNumbers,
      fits: fits ?? this.fits,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (oemNumber.present) {
      map['oem_number'] = Variable<String>(oemNumber.value);
    }
    if (aftermarketNumbers.present) {
      map['aftermarket_numbers'] = Variable<String>(aftermarketNumbers.value);
    }
    if (fits.present) {
      map['fits'] = Variable<String>(fits.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('oemNumber: $oemNumber, ')
          ..write('aftermarketNumbers: $aftermarketNumbers, ')
          ..write('fits: $fits, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $SpecsTable specs = $SpecsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final VehiclesDao vehiclesDao = VehiclesDao(this as AppDatabase);
  late final SpecsDao specsDao = SpecsDao(this as AppDatabase);
  late final PartsDao partsDao = PartsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vehicles, specs, parts];
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      required int year,
      Value<String> make,
      required String model,
      Value<String?> trim,
      Value<String?> engineCode,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<int> year,
      Value<String> make,
      Value<String> model,
      Value<String?> trim,
      Value<String?> engineCode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineCode => $composableBuilder(
    column: $table.engineCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineCode => $composableBuilder(
    column: $table.engineCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get trim =>
      $composableBuilder(column: $table.trim, builder: (column) => column);

  GeneratedColumn<String> get engineCode => $composableBuilder(
    column: $table.engineCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
          Vehicle,
          PrefetchHooks Function()
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                Value<String?> engineCode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                year: year,
                make: make,
                model: model,
                trim: trim,
                engineCode: engineCode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                Value<String> make = const Value.absent(),
                required String model,
                Value<String?> trim = const Value.absent(),
                Value<String?> engineCode = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                year: year,
                make: make,
                model: model,
                trim: trim,
                engineCode: engineCode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
      Vehicle,
      PrefetchHooks Function()
    >;
typedef $$SpecsTableCreateCompanionBuilder =
    SpecsCompanion Function({
      required String id,
      required String category,
      required String title,
      required String body,
      required String tags,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SpecsTableUpdateCompanionBuilder =
    SpecsCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String> title,
      Value<String> body,
      Value<String> tags,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SpecsTableFilterComposer extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SpecsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpecsTable,
          Spec,
          $$SpecsTableFilterComposer,
          $$SpecsTableOrderingComposer,
          $$SpecsTableAnnotationComposer,
          $$SpecsTableCreateCompanionBuilder,
          $$SpecsTableUpdateCompanionBuilder,
          (Spec, BaseReferences<_$AppDatabase, $SpecsTable, Spec>),
          Spec,
          PrefetchHooks Function()
        > {
  $$SpecsTableTableManager(_$AppDatabase db, $SpecsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpecsCompanion(
                id: id,
                category: category,
                title: title,
                body: body,
                tags: tags,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required String title,
                required String body,
                required String tags,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SpecsCompanion.insert(
                id: id,
                category: category,
                title: title,
                body: body,
                tags: tags,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpecsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpecsTable,
      Spec,
      $$SpecsTableFilterComposer,
      $$SpecsTableOrderingComposer,
      $$SpecsTableAnnotationComposer,
      $$SpecsTableCreateCompanionBuilder,
      $$SpecsTableUpdateCompanionBuilder,
      (Spec, BaseReferences<_$AppDatabase, $SpecsTable, Spec>),
      Spec,
      PrefetchHooks Function()
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      required String id,
      required String name,
      required String oemNumber,
      required String aftermarketNumbers,
      required String fits,
      Value<String?> notes,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> oemNumber,
      Value<String> aftermarketNumbers,
      Value<String> fits,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oemNumber => $composableBuilder(
    column: $table.oemNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aftermarketNumbers => $composableBuilder(
    column: $table.aftermarketNumbers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fits => $composableBuilder(
    column: $table.fits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oemNumber => $composableBuilder(
    column: $table.oemNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aftermarketNumbers => $composableBuilder(
    column: $table.aftermarketNumbers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fits => $composableBuilder(
    column: $table.fits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get oemNumber =>
      $composableBuilder(column: $table.oemNumber, builder: (column) => column);

  GeneratedColumn<String> get aftermarketNumbers => $composableBuilder(
    column: $table.aftermarketNumbers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fits =>
      $composableBuilder(column: $table.fits, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartsTable,
          Part,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
          Part,
          PrefetchHooks Function()
        > {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> oemNumber = const Value.absent(),
                Value<String> aftermarketNumbers = const Value.absent(),
                Value<String> fits = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                name: name,
                oemNumber: oemNumber,
                aftermarketNumbers: aftermarketNumbers,
                fits: fits,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String oemNumber,
                required String aftermarketNumbers,
                required String fits,
                Value<String?> notes = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                name: name,
                oemNumber: oemNumber,
                aftermarketNumbers: aftermarketNumbers,
                fits: fits,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartsTable,
      Part,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
      Part,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$SpecsTableTableManager get specs =>
      $$SpecsTableTableManager(_db, _db.specs);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
}
