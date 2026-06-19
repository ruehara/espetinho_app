// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isInternalUseMeta = const VerificationMeta(
    'isInternalUse',
  );
  @override
  late final GeneratedColumn<bool> isInternalUse = GeneratedColumn<bool>(
    'is_internal_use',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_internal_use" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    photo,
    isInternalUse,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('is_internal_use')) {
      context.handle(
        _isInternalUseMeta,
        isInternalUse.isAcceptableOrUnknown(
          data['is_internal_use']!,
          _isInternalUseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}photo'],
      ),
      isInternalUse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_internal_use'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final String? description;
  final Uint8List? photo;
  final bool isInternalUse;
  const CategoryRow({
    required this.id,
    required this.name,
    this.description,
    this.photo,
    required this.isInternalUse,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    map['is_internal_use'] = Variable<bool>(isInternalUse);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      isInternalUse: Value(isInternalUse),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      isInternalUse: serializer.fromJson<bool>(json['isInternalUse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'photo': serializer.toJson<Uint8List?>(photo),
      'isInternalUse': serializer.toJson<bool>(isInternalUse),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<Uint8List?> photo = const Value.absent(),
    bool? isInternalUse,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    photo: photo.present ? photo.value : this.photo,
    isInternalUse: isInternalUse ?? this.isInternalUse,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      photo: data.photo.present ? data.photo.value : this.photo,
      isInternalUse: data.isInternalUse.present
          ? data.isInternalUse.value
          : this.isInternalUse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('photo: $photo, ')
          ..write('isInternalUse: $isInternalUse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    $driftBlobEquality.hash(photo),
    isInternalUse,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          $driftBlobEquality.equals(other.photo, this.photo) &&
          other.isInternalUse == this.isInternalUse);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<Uint8List?> photo;
  final Value<bool> isInternalUse;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.photo = const Value.absent(),
    this.isInternalUse = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.photo = const Value.absent(),
    this.isInternalUse = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<Uint8List>? photo,
    Expression<bool>? isInternalUse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (photo != null) 'photo': photo,
      if (isInternalUse != null) 'is_internal_use': isInternalUse,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<Uint8List?>? photo,
    Value<bool>? isInternalUse,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      isInternalUse: isInternalUse ?? this.isInternalUse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    if (isInternalUse.present) {
      map['is_internal_use'] = Variable<bool>(isInternalUse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('photo: $photo, ')
          ..write('isInternalUse: $isInternalUse')
          ..write(')'))
        .toString();
  }
}

class $GroupProductsTable extends GroupProducts
    with TableInfo<$GroupProductsTable, GroupProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $GroupProductsTable createAlias(String alias) {
    return $GroupProductsTable(attachedDatabase, alias);
  }
}

class GroupProductRow extends DataClass implements Insertable<GroupProductRow> {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  const GroupProductRow({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  GroupProductsCompanion toCompanion(bool nullToAbsent) {
    return GroupProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: Value(categoryId),
    );
  }

  factory GroupProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupProductRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  GroupProductRow copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? categoryId,
  }) => GroupProductRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    categoryId: categoryId ?? this.categoryId,
  );
  GroupProductRow copyWithCompanion(GroupProductsCompanion data) {
    return GroupProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.categoryId == this.categoryId);
}

class GroupProductsCompanion extends UpdateCompanion<GroupProductRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> categoryId;
  const GroupProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  GroupProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int categoryId,
  }) : name = Value(name),
       categoryId = Value(categoryId);
  static Insertable<GroupProductRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  GroupProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? categoryId,
  }) {
    return GroupProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES group_products (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
    'cost_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isInternalUseMeta = const VerificationMeta(
    'isInternalUse',
  );
  @override
  late final GeneratedColumn<bool> isInternalUse = GeneratedColumn<bool>(
    'is_internal_use',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_internal_use" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stockQuantityMeta = const VerificationMeta(
    'stockQuantity',
  );
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
    'stock_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _minStockMeta = const VerificationMeta(
    'minStock',
  );
  @override
  late final GeneratedColumn<double> minStock = GeneratedColumn<double>(
    'min_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isCompositeMeta = const VerificationMeta(
    'isComposite',
  );
  @override
  late final GeneratedColumn<bool> isComposite = GeneratedColumn<bool>(
    'is_composite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_composite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _preparationLocationMeta =
      const VerificationMeta('preparationLocation');
  @override
  late final GeneratedColumn<String> preparationLocation =
      GeneratedColumn<String>(
        'preparation_location',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('kitchen'),
      );
  static const VerificationMeta _trackStockMeta = const VerificationMeta(
    'trackStock',
  );
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
    'track_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("track_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    photoPath,
    groupId,
    costPrice,
    salePrice,
    isInternalUse,
    stockQuantity,
    minStock,
    isComposite,
    isActive,
    preparationLocation,
    trackStock,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    }
    if (data.containsKey('is_internal_use')) {
      context.handle(
        _isInternalUseMeta,
        isInternalUse.isAcceptableOrUnknown(
          data['is_internal_use']!,
          _isInternalUseMeta,
        ),
      );
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
        _stockQuantityMeta,
        stockQuantity.isAcceptableOrUnknown(
          data['stock_quantity']!,
          _stockQuantityMeta,
        ),
      );
    }
    if (data.containsKey('min_stock')) {
      context.handle(
        _minStockMeta,
        minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta),
      );
    }
    if (data.containsKey('is_composite')) {
      context.handle(
        _isCompositeMeta,
        isComposite.isAcceptableOrUnknown(
          data['is_composite']!,
          _isCompositeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('preparation_location')) {
      context.handle(
        _preparationLocationMeta,
        preparationLocation.isAcceptableOrUnknown(
          data['preparation_location']!,
          _preparationLocationMeta,
        ),
      );
    }
    if (data.containsKey('track_stock')) {
      context.handle(
        _trackStockMeta,
        trackStock.isAcceptableOrUnknown(data['track_stock']!, _trackStockMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_price'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      ),
      isInternalUse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_internal_use'],
      )!,
      stockQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_quantity'],
      )!,
      minStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_stock'],
      )!,
      isComposite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_composite'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      preparationLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparation_location'],
      )!,
      trackStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}track_stock'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final int id;
  final String name;
  final String? description;
  final String? photoPath;
  final int groupId;
  final double costPrice;
  final double? salePrice;
  final bool isInternalUse;
  final double stockQuantity;
  final double minStock;
  final bool isComposite;
  final bool isActive;

  /// 'kitchen' | 'hall' | 'both' — onde o produto é preparado, usado para
  /// separar a impressão das comandas por local.
  final String preparationLocation;

  /// Quando falso, o estoque deste produto não é validado nem abatido nas
  /// vendas — usado para insumos sem controle de estoque preciso (ex.:
  /// molhos, saladas, temperos servidos a gosto).
  final bool trackStock;
  final DateTime createdAt;
  const ProductRow({
    required this.id,
    required this.name,
    this.description,
    this.photoPath,
    required this.groupId,
    required this.costPrice,
    this.salePrice,
    required this.isInternalUse,
    required this.stockQuantity,
    required this.minStock,
    required this.isComposite,
    required this.isActive,
    required this.preparationLocation,
    required this.trackStock,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['group_id'] = Variable<int>(groupId);
    map['cost_price'] = Variable<double>(costPrice);
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<double>(salePrice);
    }
    map['is_internal_use'] = Variable<bool>(isInternalUse);
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['min_stock'] = Variable<double>(minStock);
    map['is_composite'] = Variable<bool>(isComposite);
    map['is_active'] = Variable<bool>(isActive);
    map['preparation_location'] = Variable<String>(preparationLocation);
    map['track_stock'] = Variable<bool>(trackStock);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      groupId: Value(groupId),
      costPrice: Value(costPrice),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      isInternalUse: Value(isInternalUse),
      stockQuantity: Value(stockQuantity),
      minStock: Value(minStock),
      isComposite: Value(isComposite),
      isActive: Value(isActive),
      preparationLocation: Value(preparationLocation),
      trackStock: Value(trackStock),
      createdAt: Value(createdAt),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      groupId: serializer.fromJson<int>(json['groupId']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      salePrice: serializer.fromJson<double?>(json['salePrice']),
      isInternalUse: serializer.fromJson<bool>(json['isInternalUse']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      minStock: serializer.fromJson<double>(json['minStock']),
      isComposite: serializer.fromJson<bool>(json['isComposite']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      preparationLocation: serializer.fromJson<String>(
        json['preparationLocation'],
      ),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'photoPath': serializer.toJson<String?>(photoPath),
      'groupId': serializer.toJson<int>(groupId),
      'costPrice': serializer.toJson<double>(costPrice),
      'salePrice': serializer.toJson<double?>(salePrice),
      'isInternalUse': serializer.toJson<bool>(isInternalUse),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'minStock': serializer.toJson<double>(minStock),
      'isComposite': serializer.toJson<bool>(isComposite),
      'isActive': serializer.toJson<bool>(isActive),
      'preparationLocation': serializer.toJson<String>(preparationLocation),
      'trackStock': serializer.toJson<bool>(trackStock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductRow copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    int? groupId,
    double? costPrice,
    Value<double?> salePrice = const Value.absent(),
    bool? isInternalUse,
    double? stockQuantity,
    double? minStock,
    bool? isComposite,
    bool? isActive,
    String? preparationLocation,
    bool? trackStock,
    DateTime? createdAt,
  }) => ProductRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    groupId: groupId ?? this.groupId,
    costPrice: costPrice ?? this.costPrice,
    salePrice: salePrice.present ? salePrice.value : this.salePrice,
    isInternalUse: isInternalUse ?? this.isInternalUse,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    minStock: minStock ?? this.minStock,
    isComposite: isComposite ?? this.isComposite,
    isActive: isActive ?? this.isActive,
    preparationLocation: preparationLocation ?? this.preparationLocation,
    trackStock: trackStock ?? this.trackStock,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      isInternalUse: data.isInternalUse.present
          ? data.isInternalUse.value
          : this.isInternalUse,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      isComposite: data.isComposite.present
          ? data.isComposite.value
          : this.isComposite,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      preparationLocation: data.preparationLocation.present
          ? data.preparationLocation.value
          : this.preparationLocation,
      trackStock: data.trackStock.present
          ? data.trackStock.value
          : this.trackStock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('photoPath: $photoPath, ')
          ..write('groupId: $groupId, ')
          ..write('costPrice: $costPrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('isInternalUse: $isInternalUse, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('minStock: $minStock, ')
          ..write('isComposite: $isComposite, ')
          ..write('isActive: $isActive, ')
          ..write('preparationLocation: $preparationLocation, ')
          ..write('trackStock: $trackStock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    photoPath,
    groupId,
    costPrice,
    salePrice,
    isInternalUse,
    stockQuantity,
    minStock,
    isComposite,
    isActive,
    preparationLocation,
    trackStock,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.photoPath == this.photoPath &&
          other.groupId == this.groupId &&
          other.costPrice == this.costPrice &&
          other.salePrice == this.salePrice &&
          other.isInternalUse == this.isInternalUse &&
          other.stockQuantity == this.stockQuantity &&
          other.minStock == this.minStock &&
          other.isComposite == this.isComposite &&
          other.isActive == this.isActive &&
          other.preparationLocation == this.preparationLocation &&
          other.trackStock == this.trackStock &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> photoPath;
  final Value<int> groupId;
  final Value<double> costPrice;
  final Value<double?> salePrice;
  final Value<bool> isInternalUse;
  final Value<double> stockQuantity;
  final Value<double> minStock;
  final Value<bool> isComposite;
  final Value<bool> isActive;
  final Value<String> preparationLocation;
  final Value<bool> trackStock;
  final Value<DateTime> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.groupId = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.isInternalUse = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.minStock = const Value.absent(),
    this.isComposite = const Value.absent(),
    this.isActive = const Value.absent(),
    this.preparationLocation = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.photoPath = const Value.absent(),
    required int groupId,
    this.costPrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.isInternalUse = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.minStock = const Value.absent(),
    this.isComposite = const Value.absent(),
    this.isActive = const Value.absent(),
    this.preparationLocation = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       groupId = Value(groupId);
  static Insertable<ProductRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? photoPath,
    Expression<int>? groupId,
    Expression<double>? costPrice,
    Expression<double>? salePrice,
    Expression<bool>? isInternalUse,
    Expression<double>? stockQuantity,
    Expression<double>? minStock,
    Expression<bool>? isComposite,
    Expression<bool>? isActive,
    Expression<String>? preparationLocation,
    Expression<bool>? trackStock,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (photoPath != null) 'photo_path': photoPath,
      if (groupId != null) 'group_id': groupId,
      if (costPrice != null) 'cost_price': costPrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (isInternalUse != null) 'is_internal_use': isInternalUse,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (minStock != null) 'min_stock': minStock,
      if (isComposite != null) 'is_composite': isComposite,
      if (isActive != null) 'is_active': isActive,
      if (preparationLocation != null)
        'preparation_location': preparationLocation,
      if (trackStock != null) 'track_stock': trackStock,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? photoPath,
    Value<int>? groupId,
    Value<double>? costPrice,
    Value<double?>? salePrice,
    Value<bool>? isInternalUse,
    Value<double>? stockQuantity,
    Value<double>? minStock,
    Value<bool>? isComposite,
    Value<bool>? isActive,
    Value<String>? preparationLocation,
    Value<bool>? trackStock,
    Value<DateTime>? createdAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      groupId: groupId ?? this.groupId,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      isInternalUse: isInternalUse ?? this.isInternalUse,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStock: minStock ?? this.minStock,
      isComposite: isComposite ?? this.isComposite,
      isActive: isActive ?? this.isActive,
      preparationLocation: preparationLocation ?? this.preparationLocation,
      trackStock: trackStock ?? this.trackStock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (isInternalUse.present) {
      map['is_internal_use'] = Variable<bool>(isInternalUse.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<double>(minStock.value);
    }
    if (isComposite.present) {
      map['is_composite'] = Variable<bool>(isComposite.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (preparationLocation.present) {
      map['preparation_location'] = Variable<String>(preparationLocation.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('photoPath: $photoPath, ')
          ..write('groupId: $groupId, ')
          ..write('costPrice: $costPrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('isInternalUse: $isInternalUse, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('minStock: $minStock, ')
          ..write('isComposite: $isComposite, ')
          ..write('isActive: $isActive, ')
          ..write('preparationLocation: $preparationLocation, ')
          ..write('trackStock: $trackStock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOptionalMeta = const VerificationMeta(
    'isOptional',
  );
  @override
  late final GeneratedColumn<bool> isOptional = GeneratedColumn<bool>(
    'is_optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    ingredientId,
    quantity,
    isOptional,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('is_optional')) {
      context.handle(
        _isOptionalMeta,
        isOptional.isAcceptableOrUnknown(data['is_optional']!, _isOptionalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      isOptional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional'],
      )!,
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }
}

class RecipeItemRow extends DataClass implements Insertable<RecipeItemRow> {
  final int id;
  final int productId;
  final int ingredientId;
  final double quantity;
  final bool isOptional;
  const RecipeItemRow({
    required this.id,
    required this.productId,
    required this.ingredientId,
    required this.quantity,
    required this.isOptional,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity'] = Variable<double>(quantity);
    map['is_optional'] = Variable<bool>(isOptional);
    return map;
  }

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      ingredientId: Value(ingredientId),
      quantity: Value(quantity),
      isOptional: Value(isOptional),
    );
  }

  factory RecipeItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItemRow(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      isOptional: serializer.fromJson<bool>(json['isOptional']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantity': serializer.toJson<double>(quantity),
      'isOptional': serializer.toJson<bool>(isOptional),
    };
  }

  RecipeItemRow copyWith({
    int? id,
    int? productId,
    int? ingredientId,
    double? quantity,
    bool? isOptional,
  }) => RecipeItemRow(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantity: quantity ?? this.quantity,
    isOptional: isOptional ?? this.isOptional,
  );
  RecipeItemRow copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItemRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isOptional: data.isOptional.present
          ? data.isOptional.value
          : this.isOptional,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('isOptional: $isOptional')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, ingredientId, quantity, isOptional);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItemRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.ingredientId == this.ingredientId &&
          other.quantity == this.quantity &&
          other.isOptional == this.isOptional);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItemRow> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> ingredientId;
  final Value<double> quantity;
  final Value<bool> isOptional;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isOptional = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int ingredientId,
    required double quantity,
    this.isOptional = const Value.absent(),
  }) : productId = Value(productId),
       ingredientId = Value(ingredientId),
       quantity = Value(quantity);
  static Insertable<RecipeItemRow> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? ingredientId,
    Expression<double>? quantity,
    Expression<bool>? isOptional,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantity != null) 'quantity': quantity,
      if (isOptional != null) 'is_optional': isOptional,
    });
  }

  RecipeItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? ingredientId,
    Value<double>? quantity,
    Value<bool>? isOptional,
  }) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (isOptional.present) {
      map['is_optional'] = Variable<bool>(isOptional.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('isOptional: $isOptional')
          ..write(')'))
        .toString();
  }
}

class $RecipeChoiceGroupsTable extends RecipeChoiceGroups
    with TableInfo<$RecipeChoiceGroupsTable, ChoiceGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeChoiceGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _sourceGroupIdMeta = const VerificationMeta(
    'sourceGroupId',
  );
  @override
  late final GeneratedColumn<int> sourceGroupId = GeneratedColumn<int>(
    'source_group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES group_products (id)',
    ),
  );
  static const VerificationMeta _minSelectionsMeta = const VerificationMeta(
    'minSelections',
  );
  @override
  late final GeneratedColumn<int> minSelections = GeneratedColumn<int>(
    'min_selections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxSelectionsMeta = const VerificationMeta(
    'maxSelections',
  );
  @override
  late final GeneratedColumn<int> maxSelections = GeneratedColumn<int>(
    'max_selections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('optional'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    sourceGroupId,
    minSelections,
    maxSelections,
    displayOrder,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_choice_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoiceGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_group_id')) {
      context.handle(
        _sourceGroupIdMeta,
        sourceGroupId.isAcceptableOrUnknown(
          data['source_group_id']!,
          _sourceGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('min_selections')) {
      context.handle(
        _minSelectionsMeta,
        minSelections.isAcceptableOrUnknown(
          data['min_selections']!,
          _minSelectionsMeta,
        ),
      );
    }
    if (data.containsKey('max_selections')) {
      context.handle(
        _maxSelectionsMeta,
        maxSelections.isAcceptableOrUnknown(
          data['max_selections']!,
          _maxSelectionsMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChoiceGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoiceGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_group_id'],
      ),
      minSelections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_selections'],
      )!,
      maxSelections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_selections'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $RecipeChoiceGroupsTable createAlias(String alias) {
    return $RecipeChoiceGroupsTable(attachedDatabase, alias);
  }
}

class ChoiceGroupRow extends DataClass implements Insertable<ChoiceGroupRow> {
  final int id;
  final int productId;
  final String name;
  final int? sourceGroupId;
  final int minSelections;
  final int maxSelections;
  final int displayOrder;

  /// 'optional' (padrão, ex.: sabor/molho) | 'additional' (ex.: bacon
  /// extra — cada opção deve ter priceAddition > 0). Grupos existentes
  /// antes desta coluna são tratados como 'optional'.
  final String kind;
  const ChoiceGroupRow({
    required this.id,
    required this.productId,
    required this.name,
    this.sourceGroupId,
    required this.minSelections,
    required this.maxSelections,
    required this.displayOrder,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sourceGroupId != null) {
      map['source_group_id'] = Variable<int>(sourceGroupId);
    }
    map['min_selections'] = Variable<int>(minSelections);
    map['max_selections'] = Variable<int>(maxSelections);
    map['display_order'] = Variable<int>(displayOrder);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  RecipeChoiceGroupsCompanion toCompanion(bool nullToAbsent) {
    return RecipeChoiceGroupsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      sourceGroupId: sourceGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceGroupId),
      minSelections: Value(minSelections),
      maxSelections: Value(maxSelections),
      displayOrder: Value(displayOrder),
      kind: Value(kind),
    );
  }

  factory ChoiceGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoiceGroupRow(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      sourceGroupId: serializer.fromJson<int?>(json['sourceGroupId']),
      minSelections: serializer.fromJson<int>(json['minSelections']),
      maxSelections: serializer.fromJson<int>(json['maxSelections']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'name': serializer.toJson<String>(name),
      'sourceGroupId': serializer.toJson<int?>(sourceGroupId),
      'minSelections': serializer.toJson<int>(minSelections),
      'maxSelections': serializer.toJson<int>(maxSelections),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'kind': serializer.toJson<String>(kind),
    };
  }

  ChoiceGroupRow copyWith({
    int? id,
    int? productId,
    String? name,
    Value<int?> sourceGroupId = const Value.absent(),
    int? minSelections,
    int? maxSelections,
    int? displayOrder,
    String? kind,
  }) => ChoiceGroupRow(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    sourceGroupId: sourceGroupId.present
        ? sourceGroupId.value
        : this.sourceGroupId,
    minSelections: minSelections ?? this.minSelections,
    maxSelections: maxSelections ?? this.maxSelections,
    displayOrder: displayOrder ?? this.displayOrder,
    kind: kind ?? this.kind,
  );
  ChoiceGroupRow copyWithCompanion(RecipeChoiceGroupsCompanion data) {
    return ChoiceGroupRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      sourceGroupId: data.sourceGroupId.present
          ? data.sourceGroupId.value
          : this.sourceGroupId,
      minSelections: data.minSelections.present
          ? data.minSelections.value
          : this.minSelections,
      maxSelections: data.maxSelections.present
          ? data.maxSelections.value
          : this.maxSelections,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceGroupRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('sourceGroupId: $sourceGroupId, ')
          ..write('minSelections: $minSelections, ')
          ..write('maxSelections: $maxSelections, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    sourceGroupId,
    minSelections,
    maxSelections,
    displayOrder,
    kind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoiceGroupRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.sourceGroupId == this.sourceGroupId &&
          other.minSelections == this.minSelections &&
          other.maxSelections == this.maxSelections &&
          other.displayOrder == this.displayOrder &&
          other.kind == this.kind);
}

class RecipeChoiceGroupsCompanion extends UpdateCompanion<ChoiceGroupRow> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> name;
  final Value<int?> sourceGroupId;
  final Value<int> minSelections;
  final Value<int> maxSelections;
  final Value<int> displayOrder;
  final Value<String> kind;
  const RecipeChoiceGroupsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceGroupId = const Value.absent(),
    this.minSelections = const Value.absent(),
    this.maxSelections = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.kind = const Value.absent(),
  });
  RecipeChoiceGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String name,
    this.sourceGroupId = const Value.absent(),
    this.minSelections = const Value.absent(),
    this.maxSelections = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.kind = const Value.absent(),
  }) : productId = Value(productId),
       name = Value(name);
  static Insertable<ChoiceGroupRow> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<int>? sourceGroupId,
    Expression<int>? minSelections,
    Expression<int>? maxSelections,
    Expression<int>? displayOrder,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (sourceGroupId != null) 'source_group_id': sourceGroupId,
      if (minSelections != null) 'min_selections': minSelections,
      if (maxSelections != null) 'max_selections': maxSelections,
      if (displayOrder != null) 'display_order': displayOrder,
      if (kind != null) 'kind': kind,
    });
  }

  RecipeChoiceGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? name,
    Value<int?>? sourceGroupId,
    Value<int>? minSelections,
    Value<int>? maxSelections,
    Value<int>? displayOrder,
    Value<String>? kind,
  }) {
    return RecipeChoiceGroupsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      sourceGroupId: sourceGroupId ?? this.sourceGroupId,
      minSelections: minSelections ?? this.minSelections,
      maxSelections: maxSelections ?? this.maxSelections,
      displayOrder: displayOrder ?? this.displayOrder,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sourceGroupId.present) {
      map['source_group_id'] = Variable<int>(sourceGroupId.value);
    }
    if (minSelections.present) {
      map['min_selections'] = Variable<int>(minSelections.value);
    }
    if (maxSelections.present) {
      map['max_selections'] = Variable<int>(maxSelections.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeChoiceGroupsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('sourceGroupId: $sourceGroupId, ')
          ..write('minSelections: $minSelections, ')
          ..write('maxSelections: $maxSelections, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $RecipeChoiceGroupSourcesTable extends RecipeChoiceGroupSources
    with TableInfo<$RecipeChoiceGroupSourcesTable, ChoiceGroupSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeChoiceGroupSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipe_choice_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceGroupIdMeta = const VerificationMeta(
    'sourceGroupId',
  );
  @override
  late final GeneratedColumn<int> sourceGroupId = GeneratedColumn<int>(
    'source_group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES group_products (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, sourceGroupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_choice_group_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoiceGroupSourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('source_group_id')) {
      context.handle(
        _sourceGroupIdMeta,
        sourceGroupId.isAcceptableOrUnknown(
          data['source_group_id']!,
          _sourceGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceGroupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, sourceGroupId},
  ];
  @override
  ChoiceGroupSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoiceGroupSourceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      sourceGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_group_id'],
      )!,
    );
  }

  @override
  $RecipeChoiceGroupSourcesTable createAlias(String alias) {
    return $RecipeChoiceGroupSourcesTable(attachedDatabase, alias);
  }
}

class ChoiceGroupSourceRow extends DataClass
    implements Insertable<ChoiceGroupSourceRow> {
  final int id;
  final int groupId;
  final int sourceGroupId;
  const ChoiceGroupSourceRow({
    required this.id,
    required this.groupId,
    required this.sourceGroupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['source_group_id'] = Variable<int>(sourceGroupId);
    return map;
  }

  RecipeChoiceGroupSourcesCompanion toCompanion(bool nullToAbsent) {
    return RecipeChoiceGroupSourcesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      sourceGroupId: Value(sourceGroupId),
    );
  }

  factory ChoiceGroupSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoiceGroupSourceRow(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      sourceGroupId: serializer.fromJson<int>(json['sourceGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'sourceGroupId': serializer.toJson<int>(sourceGroupId),
    };
  }

  ChoiceGroupSourceRow copyWith({int? id, int? groupId, int? sourceGroupId}) =>
      ChoiceGroupSourceRow(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        sourceGroupId: sourceGroupId ?? this.sourceGroupId,
      );
  ChoiceGroupSourceRow copyWithCompanion(
    RecipeChoiceGroupSourcesCompanion data,
  ) {
    return ChoiceGroupSourceRow(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sourceGroupId: data.sourceGroupId.present
          ? data.sourceGroupId.value
          : this.sourceGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceGroupSourceRow(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('sourceGroupId: $sourceGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, sourceGroupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoiceGroupSourceRow &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.sourceGroupId == this.sourceGroupId);
}

class RecipeChoiceGroupSourcesCompanion
    extends UpdateCompanion<ChoiceGroupSourceRow> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> sourceGroupId;
  const RecipeChoiceGroupSourcesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sourceGroupId = const Value.absent(),
  });
  RecipeChoiceGroupSourcesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int sourceGroupId,
  }) : groupId = Value(groupId),
       sourceGroupId = Value(sourceGroupId);
  static Insertable<ChoiceGroupSourceRow> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? sourceGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (sourceGroupId != null) 'source_group_id': sourceGroupId,
    });
  }

  RecipeChoiceGroupSourcesCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? sourceGroupId,
  }) {
    return RecipeChoiceGroupSourcesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      sourceGroupId: sourceGroupId ?? this.sourceGroupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (sourceGroupId.present) {
      map['source_group_id'] = Variable<int>(sourceGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeChoiceGroupSourcesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('sourceGroupId: $sourceGroupId')
          ..write(')'))
        .toString();
  }
}

class $RecipeChoiceOptionsTable extends RecipeChoiceOptions
    with TableInfo<$RecipeChoiceOptionsTable, ChoiceOptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeChoiceOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipe_choice_groups (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _componentProductIdMeta =
      const VerificationMeta('componentProductId');
  @override
  late final GeneratedColumn<int> componentProductId = GeneratedColumn<int>(
    'component_product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceAdditionMeta = const VerificationMeta(
    'priceAddition',
  );
  @override
  late final GeneratedColumn<double> priceAddition = GeneratedColumn<double>(
    'price_addition',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    componentProductId,
    quantity,
    priceAddition,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_choice_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoiceOptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('component_product_id')) {
      context.handle(
        _componentProductIdMeta,
        componentProductId.isAcceptableOrUnknown(
          data['component_product_id']!,
          _componentProductIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('price_addition')) {
      context.handle(
        _priceAdditionMeta,
        priceAddition.isAcceptableOrUnknown(
          data['price_addition']!,
          _priceAdditionMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, name},
  ];
  @override
  ChoiceOptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoiceOptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      componentProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}component_product_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      priceAddition: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_addition'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $RecipeChoiceOptionsTable createAlias(String alias) {
    return $RecipeChoiceOptionsTable(attachedDatabase, alias);
  }
}

class ChoiceOptionRow extends DataClass implements Insertable<ChoiceOptionRow> {
  final int id;
  final int groupId;
  final String name;
  final int? componentProductId;
  final double? quantity;
  final double priceAddition;
  final int displayOrder;
  const ChoiceOptionRow({
    required this.id,
    required this.groupId,
    required this.name,
    this.componentProductId,
    this.quantity,
    required this.priceAddition,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || componentProductId != null) {
      map['component_product_id'] = Variable<int>(componentProductId);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    map['price_addition'] = Variable<double>(priceAddition);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  RecipeChoiceOptionsCompanion toCompanion(bool nullToAbsent) {
    return RecipeChoiceOptionsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      componentProductId: componentProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(componentProductId),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      priceAddition: Value(priceAddition),
      displayOrder: Value(displayOrder),
    );
  }

  factory ChoiceOptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoiceOptionRow(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      componentProductId: serializer.fromJson<int?>(json['componentProductId']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      priceAddition: serializer.fromJson<double>(json['priceAddition']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'componentProductId': serializer.toJson<int?>(componentProductId),
      'quantity': serializer.toJson<double?>(quantity),
      'priceAddition': serializer.toJson<double>(priceAddition),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  ChoiceOptionRow copyWith({
    int? id,
    int? groupId,
    String? name,
    Value<int?> componentProductId = const Value.absent(),
    Value<double?> quantity = const Value.absent(),
    double? priceAddition,
    int? displayOrder,
  }) => ChoiceOptionRow(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    componentProductId: componentProductId.present
        ? componentProductId.value
        : this.componentProductId,
    quantity: quantity.present ? quantity.value : this.quantity,
    priceAddition: priceAddition ?? this.priceAddition,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  ChoiceOptionRow copyWithCompanion(RecipeChoiceOptionsCompanion data) {
    return ChoiceOptionRow(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      componentProductId: data.componentProductId.present
          ? data.componentProductId.value
          : this.componentProductId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceAddition: data.priceAddition.present
          ? data.priceAddition.value
          : this.priceAddition,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceOptionRow(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('componentProductId: $componentProductId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAddition: $priceAddition, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    name,
    componentProductId,
    quantity,
    priceAddition,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoiceOptionRow &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.componentProductId == this.componentProductId &&
          other.quantity == this.quantity &&
          other.priceAddition == this.priceAddition &&
          other.displayOrder == this.displayOrder);
}

class RecipeChoiceOptionsCompanion extends UpdateCompanion<ChoiceOptionRow> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> name;
  final Value<int?> componentProductId;
  final Value<double?> quantity;
  final Value<double> priceAddition;
  final Value<int> displayOrder;
  const RecipeChoiceOptionsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.componentProductId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAddition = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  RecipeChoiceOptionsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String name,
    this.componentProductId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAddition = const Value.absent(),
    this.displayOrder = const Value.absent(),
  }) : groupId = Value(groupId),
       name = Value(name);
  static Insertable<ChoiceOptionRow> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<int>? componentProductId,
    Expression<double>? quantity,
    Expression<double>? priceAddition,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (componentProductId != null)
        'component_product_id': componentProductId,
      if (quantity != null) 'quantity': quantity,
      if (priceAddition != null) 'price_addition': priceAddition,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  RecipeChoiceOptionsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<String>? name,
    Value<int?>? componentProductId,
    Value<double?>? quantity,
    Value<double>? priceAddition,
    Value<int>? displayOrder,
  }) {
    return RecipeChoiceOptionsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      componentProductId: componentProductId ?? this.componentProductId,
      quantity: quantity ?? this.quantity,
      priceAddition: priceAddition ?? this.priceAddition,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (componentProductId.present) {
      map['component_product_id'] = Variable<int>(componentProductId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceAddition.present) {
      map['price_addition'] = Variable<double>(priceAddition.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeChoiceOptionsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('componentProductId: $componentProductId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAddition: $priceAddition, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, OrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
    'discount_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockDeductedMeta = const VerificationMeta(
    'stockDeducted',
  );
  @override
  late final GeneratedColumn<bool> stockDeducted = GeneratedColumn<bool>(
    'stock_deducted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stock_deducted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    status,
    openedAt,
    closedAt,
    total,
    discountPercent,
    stockDeducted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('stock_deducted')) {
      context.handle(
        _stockDeductedMeta,
        stockDeducted.isAcceptableOrUnknown(
          data['stock_deducted']!,
          _stockDeductedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percent'],
      )!,
      stockDeducted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stock_deducted'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class OrderRow extends DataClass implements Insertable<OrderRow> {
  final int id;
  final String customerName;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double total;
  final int discountPercent;
  final bool stockDeducted;
  const OrderRow({
    required this.id,
    required this.customerName,
    required this.status,
    required this.openedAt,
    this.closedAt,
    required this.total,
    required this.discountPercent,
    required this.stockDeducted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['status'] = Variable<String>(status);
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['total'] = Variable<double>(total);
    map['discount_percent'] = Variable<int>(discountPercent);
    map['stock_deducted'] = Variable<bool>(stockDeducted);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      customerName: Value(customerName),
      status: Value(status),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      total: Value(total),
      discountPercent: Value(discountPercent),
      stockDeducted: Value(stockDeducted),
    );
  }

  factory OrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderRow(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      status: serializer.fromJson<String>(json['status']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      total: serializer.fromJson<double>(json['total']),
      discountPercent: serializer.fromJson<int>(json['discountPercent']),
      stockDeducted: serializer.fromJson<bool>(json['stockDeducted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'status': serializer.toJson<String>(status),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'total': serializer.toJson<double>(total),
      'discountPercent': serializer.toJson<int>(discountPercent),
      'stockDeducted': serializer.toJson<bool>(stockDeducted),
    };
  }

  OrderRow copyWith({
    int? id,
    String? customerName,
    String? status,
    DateTime? openedAt,
    Value<DateTime?> closedAt = const Value.absent(),
    double? total,
    int? discountPercent,
    bool? stockDeducted,
  }) => OrderRow(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    status: status ?? this.status,
    openedAt: openedAt ?? this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    total: total ?? this.total,
    discountPercent: discountPercent ?? this.discountPercent,
    stockDeducted: stockDeducted ?? this.stockDeducted,
  );
  OrderRow copyWithCompanion(OrdersCompanion data) {
    return OrderRow(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      total: data.total.present ? data.total.value : this.total,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      stockDeducted: data.stockDeducted.present
          ? data.stockDeducted.value
          : this.stockDeducted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderRow(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('total: $total, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('stockDeducted: $stockDeducted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    status,
    openedAt,
    closedAt,
    total,
    discountPercent,
    stockDeducted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderRow &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.total == this.total &&
          other.discountPercent == this.discountPercent &&
          other.stockDeducted == this.stockDeducted);
}

class OrdersCompanion extends UpdateCompanion<OrderRow> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String> status;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<double> total;
  final Value<int> discountPercent;
  final Value<bool> stockDeducted;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.stockDeducted = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.stockDeducted = const Value.absent(),
  }) : customerName = Value(customerName);
  static Insertable<OrderRow> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? status,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<double>? total,
    Expression<int>? discountPercent,
    Expression<bool>? stockDeducted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (total != null) 'total': total,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (stockDeducted != null) 'stock_deducted': stockDeducted,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? customerName,
    Value<String>? status,
    Value<DateTime>? openedAt,
    Value<DateTime?>? closedAt,
    Value<double>? total,
    Value<int>? discountPercent,
    Value<bool>? stockDeducted,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      total: total ?? this.total,
      discountPercent: discountPercent ?? this.discountPercent,
      stockDeducted: stockDeducted ?? this.stockDeducted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (stockDeducted.present) {
      map['stock_deducted'] = Variable<bool>(stockDeducted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('total: $total, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('stockDeducted: $stockDeducted')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
    'unit_cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    productName,
    unitPrice,
    quantity,
    notes,
    unitCost,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cost'],
      ),
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItemRow extends DataClass implements Insertable<OrderItemRow> {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final double unitPrice;
  final double quantity;
  final String? notes;

  /// Custo unitário no momento da venda (nulo em pedidos antigos, antes desta coluna existir).
  final double? unitCost;
  const OrderItemRow({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.notes,
    this.unitCost,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['unit_price'] = Variable<double>(unitPrice);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || unitCost != null) {
      map['unit_cost'] = Variable<double>(unitCost);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      productName: Value(productName),
      unitPrice: Value(unitPrice),
      quantity: Value(quantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      unitCost: unitCost == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCost),
    );
  }

  factory OrderItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemRow(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      quantity: serializer.fromJson<double>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      unitCost: serializer.fromJson<double?>(json['unitCost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'quantity': serializer.toJson<double>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'unitCost': serializer.toJson<double?>(unitCost),
    };
  }

  OrderItemRow copyWith({
    int? id,
    int? orderId,
    int? productId,
    String? productName,
    double? unitPrice,
    double? quantity,
    Value<String?> notes = const Value.absent(),
    Value<double?> unitCost = const Value.absent(),
  }) => OrderItemRow(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    unitPrice: unitPrice ?? this.unitPrice,
    quantity: quantity ?? this.quantity,
    notes: notes.present ? notes.value : this.notes,
    unitCost: unitCost.present ? unitCost.value : this.unitCost,
  );
  OrderItemRow copyWithCompanion(OrderItemsCompanion data) {
    return OrderItemRow(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemRow(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('unitCost: $unitCost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    productName,
    unitPrice,
    quantity,
    notes,
    unitCost,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemRow &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.unitPrice == this.unitPrice &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.unitCost == this.unitCost);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItemRow> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> unitPrice;
  final Value<double> quantity;
  final Value<String?> notes;
  final Value<double?> unitCost;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.unitCost = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int productId,
    required String productName,
    required double unitPrice,
    required double quantity,
    this.notes = const Value.absent(),
    this.unitCost = const Value.absent(),
  }) : orderId = Value(orderId),
       productId = Value(productId),
       productName = Value(productName),
       unitPrice = Value(unitPrice),
       quantity = Value(quantity);
  static Insertable<OrderItemRow> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? unitPrice,
    Expression<double>? quantity,
    Expression<String>? notes,
    Expression<double>? unitCost,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (unitCost != null) 'unit_cost': unitCost,
    });
  }

  OrderItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? productId,
    Value<String>? productName,
    Value<double>? unitPrice,
    Value<double>? quantity,
    Value<String?>? notes,
    Value<double?>? unitCost,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      unitCost: unitCost ?? this.unitCost,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('unitCost: $unitCost')
          ..write(')'))
        .toString();
  }
}

class $OrderItemChoicesTable extends OrderItemChoices
    with TableInfo<$OrderItemChoicesTable, OrderItemChoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemChoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderItemIdMeta = const VerificationMeta(
    'orderItemId',
  );
  @override
  late final GeneratedColumn<int> orderItemId = GeneratedColumn<int>(
    'order_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _choiceTypeMeta = const VerificationMeta(
    'choiceType',
  );
  @override
  late final GeneratedColumn<String> choiceType = GeneratedColumn<String>(
    'choice_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('option'),
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedProductIdMeta = const VerificationMeta(
    'selectedProductId',
  );
  @override
  late final GeneratedColumn<int> selectedProductId = GeneratedColumn<int>(
    'selected_product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _selectedProductNameMeta =
      const VerificationMeta('selectedProductName');
  @override
  late final GeneratedColumn<String> selectedProductName =
      GeneratedColumn<String>(
        'selected_product_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceAdditionMeta = const VerificationMeta(
    'priceAddition',
  );
  @override
  late final GeneratedColumn<double> priceAddition = GeneratedColumn<double>(
    'price_addition',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _costAdditionMeta = const VerificationMeta(
    'costAddition',
  );
  @override
  late final GeneratedColumn<double> costAddition = GeneratedColumn<double>(
    'cost_addition',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparationLocationMeta =
      const VerificationMeta('preparationLocation');
  @override
  late final GeneratedColumn<String> preparationLocation =
      GeneratedColumn<String>(
        'preparation_location',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderItemId,
    choiceType,
    groupName,
    selectedProductId,
    selectedProductName,
    quantity,
    priceAddition,
    costAddition,
    preparationLocation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_item_choices';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemChoiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_item_id')) {
      context.handle(
        _orderItemIdMeta,
        orderItemId.isAcceptableOrUnknown(
          data['order_item_id']!,
          _orderItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderItemIdMeta);
    }
    if (data.containsKey('choice_type')) {
      context.handle(
        _choiceTypeMeta,
        choiceType.isAcceptableOrUnknown(data['choice_type']!, _choiceTypeMeta),
      );
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('selected_product_id')) {
      context.handle(
        _selectedProductIdMeta,
        selectedProductId.isAcceptableOrUnknown(
          data['selected_product_id']!,
          _selectedProductIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_product_name')) {
      context.handle(
        _selectedProductNameMeta,
        selectedProductName.isAcceptableOrUnknown(
          data['selected_product_name']!,
          _selectedProductNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedProductNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_addition')) {
      context.handle(
        _priceAdditionMeta,
        priceAddition.isAcceptableOrUnknown(
          data['price_addition']!,
          _priceAdditionMeta,
        ),
      );
    }
    if (data.containsKey('cost_addition')) {
      context.handle(
        _costAdditionMeta,
        costAddition.isAcceptableOrUnknown(
          data['cost_addition']!,
          _costAdditionMeta,
        ),
      );
    }
    if (data.containsKey('preparation_location')) {
      context.handle(
        _preparationLocationMeta,
        preparationLocation.isAcceptableOrUnknown(
          data['preparation_location']!,
          _preparationLocationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemChoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemChoiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_item_id'],
      )!,
      choiceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice_type'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      ),
      selectedProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_product_id'],
      ),
      selectedProductName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      priceAddition: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_addition'],
      )!,
      costAddition: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_addition'],
      ),
      preparationLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparation_location'],
      ),
    );
  }

  @override
  $OrderItemChoicesTable createAlias(String alias) {
    return $OrderItemChoicesTable(attachedDatabase, alias);
  }
}

class OrderItemChoiceRow extends DataClass
    implements Insertable<OrderItemChoiceRow> {
  final int id;
  final int orderItemId;
  final String choiceType;
  final String? groupName;
  final int? selectedProductId;
  final String selectedProductName;
  final double quantity;
  final double priceAddition;

  /// Custo unitário acrescentado por esta escolha (nulo em pedidos antigos).
  final double? costAddition;

  /// Local de preparo do produto selecionado nesta escolha ('kitchen' |
  /// 'hall' | 'both'), usado para destacar itens (ex.: bebida de um combo)
  /// na comanda do destino correto mesmo quando o produto pai pertence a
  /// outro local. Nulo em escolhas registradas antes desta coluna existir.
  final String? preparationLocation;
  const OrderItemChoiceRow({
    required this.id,
    required this.orderItemId,
    required this.choiceType,
    this.groupName,
    this.selectedProductId,
    required this.selectedProductName,
    required this.quantity,
    required this.priceAddition,
    this.costAddition,
    this.preparationLocation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_item_id'] = Variable<int>(orderItemId);
    map['choice_type'] = Variable<String>(choiceType);
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    if (!nullToAbsent || selectedProductId != null) {
      map['selected_product_id'] = Variable<int>(selectedProductId);
    }
    map['selected_product_name'] = Variable<String>(selectedProductName);
    map['quantity'] = Variable<double>(quantity);
    map['price_addition'] = Variable<double>(priceAddition);
    if (!nullToAbsent || costAddition != null) {
      map['cost_addition'] = Variable<double>(costAddition);
    }
    if (!nullToAbsent || preparationLocation != null) {
      map['preparation_location'] = Variable<String>(preparationLocation);
    }
    return map;
  }

  OrderItemChoicesCompanion toCompanion(bool nullToAbsent) {
    return OrderItemChoicesCompanion(
      id: Value(id),
      orderItemId: Value(orderItemId),
      choiceType: Value(choiceType),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      selectedProductId: selectedProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedProductId),
      selectedProductName: Value(selectedProductName),
      quantity: Value(quantity),
      priceAddition: Value(priceAddition),
      costAddition: costAddition == null && nullToAbsent
          ? const Value.absent()
          : Value(costAddition),
      preparationLocation: preparationLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(preparationLocation),
    );
  }

  factory OrderItemChoiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemChoiceRow(
      id: serializer.fromJson<int>(json['id']),
      orderItemId: serializer.fromJson<int>(json['orderItemId']),
      choiceType: serializer.fromJson<String>(json['choiceType']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      selectedProductId: serializer.fromJson<int?>(json['selectedProductId']),
      selectedProductName: serializer.fromJson<String>(
        json['selectedProductName'],
      ),
      quantity: serializer.fromJson<double>(json['quantity']),
      priceAddition: serializer.fromJson<double>(json['priceAddition']),
      costAddition: serializer.fromJson<double?>(json['costAddition']),
      preparationLocation: serializer.fromJson<String?>(
        json['preparationLocation'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderItemId': serializer.toJson<int>(orderItemId),
      'choiceType': serializer.toJson<String>(choiceType),
      'groupName': serializer.toJson<String?>(groupName),
      'selectedProductId': serializer.toJson<int?>(selectedProductId),
      'selectedProductName': serializer.toJson<String>(selectedProductName),
      'quantity': serializer.toJson<double>(quantity),
      'priceAddition': serializer.toJson<double>(priceAddition),
      'costAddition': serializer.toJson<double?>(costAddition),
      'preparationLocation': serializer.toJson<String?>(preparationLocation),
    };
  }

  OrderItemChoiceRow copyWith({
    int? id,
    int? orderItemId,
    String? choiceType,
    Value<String?> groupName = const Value.absent(),
    Value<int?> selectedProductId = const Value.absent(),
    String? selectedProductName,
    double? quantity,
    double? priceAddition,
    Value<double?> costAddition = const Value.absent(),
    Value<String?> preparationLocation = const Value.absent(),
  }) => OrderItemChoiceRow(
    id: id ?? this.id,
    orderItemId: orderItemId ?? this.orderItemId,
    choiceType: choiceType ?? this.choiceType,
    groupName: groupName.present ? groupName.value : this.groupName,
    selectedProductId: selectedProductId.present
        ? selectedProductId.value
        : this.selectedProductId,
    selectedProductName: selectedProductName ?? this.selectedProductName,
    quantity: quantity ?? this.quantity,
    priceAddition: priceAddition ?? this.priceAddition,
    costAddition: costAddition.present ? costAddition.value : this.costAddition,
    preparationLocation: preparationLocation.present
        ? preparationLocation.value
        : this.preparationLocation,
  );
  OrderItemChoiceRow copyWithCompanion(OrderItemChoicesCompanion data) {
    return OrderItemChoiceRow(
      id: data.id.present ? data.id.value : this.id,
      orderItemId: data.orderItemId.present
          ? data.orderItemId.value
          : this.orderItemId,
      choiceType: data.choiceType.present
          ? data.choiceType.value
          : this.choiceType,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      selectedProductId: data.selectedProductId.present
          ? data.selectedProductId.value
          : this.selectedProductId,
      selectedProductName: data.selectedProductName.present
          ? data.selectedProductName.value
          : this.selectedProductName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceAddition: data.priceAddition.present
          ? data.priceAddition.value
          : this.priceAddition,
      costAddition: data.costAddition.present
          ? data.costAddition.value
          : this.costAddition,
      preparationLocation: data.preparationLocation.present
          ? data.preparationLocation.value
          : this.preparationLocation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemChoiceRow(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('choiceType: $choiceType, ')
          ..write('groupName: $groupName, ')
          ..write('selectedProductId: $selectedProductId, ')
          ..write('selectedProductName: $selectedProductName, ')
          ..write('quantity: $quantity, ')
          ..write('priceAddition: $priceAddition, ')
          ..write('costAddition: $costAddition, ')
          ..write('preparationLocation: $preparationLocation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderItemId,
    choiceType,
    groupName,
    selectedProductId,
    selectedProductName,
    quantity,
    priceAddition,
    costAddition,
    preparationLocation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemChoiceRow &&
          other.id == this.id &&
          other.orderItemId == this.orderItemId &&
          other.choiceType == this.choiceType &&
          other.groupName == this.groupName &&
          other.selectedProductId == this.selectedProductId &&
          other.selectedProductName == this.selectedProductName &&
          other.quantity == this.quantity &&
          other.priceAddition == this.priceAddition &&
          other.costAddition == this.costAddition &&
          other.preparationLocation == this.preparationLocation);
}

class OrderItemChoicesCompanion extends UpdateCompanion<OrderItemChoiceRow> {
  final Value<int> id;
  final Value<int> orderItemId;
  final Value<String> choiceType;
  final Value<String?> groupName;
  final Value<int?> selectedProductId;
  final Value<String> selectedProductName;
  final Value<double> quantity;
  final Value<double> priceAddition;
  final Value<double?> costAddition;
  final Value<String?> preparationLocation;
  const OrderItemChoicesCompanion({
    this.id = const Value.absent(),
    this.orderItemId = const Value.absent(),
    this.choiceType = const Value.absent(),
    this.groupName = const Value.absent(),
    this.selectedProductId = const Value.absent(),
    this.selectedProductName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAddition = const Value.absent(),
    this.costAddition = const Value.absent(),
    this.preparationLocation = const Value.absent(),
  });
  OrderItemChoicesCompanion.insert({
    this.id = const Value.absent(),
    required int orderItemId,
    this.choiceType = const Value.absent(),
    this.groupName = const Value.absent(),
    this.selectedProductId = const Value.absent(),
    required String selectedProductName,
    required double quantity,
    this.priceAddition = const Value.absent(),
    this.costAddition = const Value.absent(),
    this.preparationLocation = const Value.absent(),
  }) : orderItemId = Value(orderItemId),
       selectedProductName = Value(selectedProductName),
       quantity = Value(quantity);
  static Insertable<OrderItemChoiceRow> custom({
    Expression<int>? id,
    Expression<int>? orderItemId,
    Expression<String>? choiceType,
    Expression<String>? groupName,
    Expression<int>? selectedProductId,
    Expression<String>? selectedProductName,
    Expression<double>? quantity,
    Expression<double>? priceAddition,
    Expression<double>? costAddition,
    Expression<String>? preparationLocation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderItemId != null) 'order_item_id': orderItemId,
      if (choiceType != null) 'choice_type': choiceType,
      if (groupName != null) 'group_name': groupName,
      if (selectedProductId != null) 'selected_product_id': selectedProductId,
      if (selectedProductName != null)
        'selected_product_name': selectedProductName,
      if (quantity != null) 'quantity': quantity,
      if (priceAddition != null) 'price_addition': priceAddition,
      if (costAddition != null) 'cost_addition': costAddition,
      if (preparationLocation != null)
        'preparation_location': preparationLocation,
    });
  }

  OrderItemChoicesCompanion copyWith({
    Value<int>? id,
    Value<int>? orderItemId,
    Value<String>? choiceType,
    Value<String?>? groupName,
    Value<int?>? selectedProductId,
    Value<String>? selectedProductName,
    Value<double>? quantity,
    Value<double>? priceAddition,
    Value<double?>? costAddition,
    Value<String?>? preparationLocation,
  }) {
    return OrderItemChoicesCompanion(
      id: id ?? this.id,
      orderItemId: orderItemId ?? this.orderItemId,
      choiceType: choiceType ?? this.choiceType,
      groupName: groupName ?? this.groupName,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      selectedProductName: selectedProductName ?? this.selectedProductName,
      quantity: quantity ?? this.quantity,
      priceAddition: priceAddition ?? this.priceAddition,
      costAddition: costAddition ?? this.costAddition,
      preparationLocation: preparationLocation ?? this.preparationLocation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderItemId.present) {
      map['order_item_id'] = Variable<int>(orderItemId.value);
    }
    if (choiceType.present) {
      map['choice_type'] = Variable<String>(choiceType.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (selectedProductId.present) {
      map['selected_product_id'] = Variable<int>(selectedProductId.value);
    }
    if (selectedProductName.present) {
      map['selected_product_name'] = Variable<String>(
        selectedProductName.value,
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceAddition.present) {
      map['price_addition'] = Variable<double>(priceAddition.value);
    }
    if (costAddition.present) {
      map['cost_addition'] = Variable<double>(costAddition.value);
    }
    if (preparationLocation.present) {
      map['preparation_location'] = Variable<String>(preparationLocation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemChoicesCompanion(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('choiceType: $choiceType, ')
          ..write('groupName: $groupName, ')
          ..write('selectedProductId: $selectedProductId, ')
          ..write('selectedProductName: $selectedProductName, ')
          ..write('quantity: $quantity, ')
          ..write('priceAddition: $priceAddition, ')
          ..write('costAddition: $costAddition, ')
          ..write('preparationLocation: $preparationLocation')
          ..write(')'))
        .toString();
  }
}

class $OrderPrintLogsTable extends OrderPrintLogs
    with TableInfo<$OrderPrintLogsTable, OrderPrintLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderPrintLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
    'signature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _printedQuantityMeta = const VerificationMeta(
    'printedQuantity',
  );
  @override
  late final GeneratedColumn<double> printedQuantity = GeneratedColumn<double>(
    'printed_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    kind,
    signature,
    productId,
    productName,
    choicesJson,
    printedQuantity,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_print_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderPrintLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    } else if (isInserting) {
      context.missing(_signatureMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    }
    if (data.containsKey('printed_quantity')) {
      context.handle(
        _printedQuantityMeta,
        printedQuantity.isAcceptableOrUnknown(
          data['printed_quantity']!,
          _printedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_printedQuantityMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {orderId, kind, signature},
  ];
  @override
  OrderPrintLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderPrintLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      )!,
      printedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}printed_quantity'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrderPrintLogsTable createAlias(String alias) {
    return $OrderPrintLogsTable(attachedDatabase, alias);
  }
}

class OrderPrintLogRow extends DataClass
    implements Insertable<OrderPrintLogRow> {
  final int id;
  final int orderId;

  /// 'kitchen' (única usada por ora; comanda do salão não rastreia impressão).
  final String kind;
  final String signature;
  final int productId;
  final String productName;

  /// Escolhas serializadas em JSON, para reimprimir o detalhe (ex.: "sem
  /// cebola") no aviso de cancelamento mesmo que o item já tenha sido
  /// totalmente removido do pedido atual.
  final String choicesJson;
  final double printedQuantity;
  final DateTime updatedAt;
  const OrderPrintLogRow({
    required this.id,
    required this.orderId,
    required this.kind,
    required this.signature,
    required this.productId,
    required this.productName,
    required this.choicesJson,
    required this.printedQuantity,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['kind'] = Variable<String>(kind);
    map['signature'] = Variable<String>(signature);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['choices_json'] = Variable<String>(choicesJson);
    map['printed_quantity'] = Variable<double>(printedQuantity);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrderPrintLogsCompanion toCompanion(bool nullToAbsent) {
    return OrderPrintLogsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      kind: Value(kind),
      signature: Value(signature),
      productId: Value(productId),
      productName: Value(productName),
      choicesJson: Value(choicesJson),
      printedQuantity: Value(printedQuantity),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrderPrintLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderPrintLogRow(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      kind: serializer.fromJson<String>(json['kind']),
      signature: serializer.fromJson<String>(json['signature']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      choicesJson: serializer.fromJson<String>(json['choicesJson']),
      printedQuantity: serializer.fromJson<double>(json['printedQuantity']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'kind': serializer.toJson<String>(kind),
      'signature': serializer.toJson<String>(signature),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'choicesJson': serializer.toJson<String>(choicesJson),
      'printedQuantity': serializer.toJson<double>(printedQuantity),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrderPrintLogRow copyWith({
    int? id,
    int? orderId,
    String? kind,
    String? signature,
    int? productId,
    String? productName,
    String? choicesJson,
    double? printedQuantity,
    DateTime? updatedAt,
  }) => OrderPrintLogRow(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    kind: kind ?? this.kind,
    signature: signature ?? this.signature,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    choicesJson: choicesJson ?? this.choicesJson,
    printedQuantity: printedQuantity ?? this.printedQuantity,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrderPrintLogRow copyWithCompanion(OrderPrintLogsCompanion data) {
    return OrderPrintLogRow(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      kind: data.kind.present ? data.kind.value : this.kind,
      signature: data.signature.present ? data.signature.value : this.signature,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      printedQuantity: data.printedQuantity.present
          ? data.printedQuantity.value
          : this.printedQuantity,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderPrintLogRow(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kind: $kind, ')
          ..write('signature: $signature, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('printedQuantity: $printedQuantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    kind,
    signature,
    productId,
    productName,
    choicesJson,
    printedQuantity,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderPrintLogRow &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.kind == this.kind &&
          other.signature == this.signature &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.choicesJson == this.choicesJson &&
          other.printedQuantity == this.printedQuantity &&
          other.updatedAt == this.updatedAt);
}

class OrderPrintLogsCompanion extends UpdateCompanion<OrderPrintLogRow> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String> kind;
  final Value<String> signature;
  final Value<int> productId;
  final Value<String> productName;
  final Value<String> choicesJson;
  final Value<double> printedQuantity;
  final Value<DateTime> updatedAt;
  const OrderPrintLogsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.kind = const Value.absent(),
    this.signature = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.printedQuantity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrderPrintLogsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required String kind,
    required String signature,
    required int productId,
    required String productName,
    this.choicesJson = const Value.absent(),
    required double printedQuantity,
    this.updatedAt = const Value.absent(),
  }) : orderId = Value(orderId),
       kind = Value(kind),
       signature = Value(signature),
       productId = Value(productId),
       productName = Value(productName),
       printedQuantity = Value(printedQuantity);
  static Insertable<OrderPrintLogRow> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? kind,
    Expression<String>? signature,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<String>? choicesJson,
    Expression<double>? printedQuantity,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (kind != null) 'kind': kind,
      if (signature != null) 'signature': signature,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (printedQuantity != null) 'printed_quantity': printedQuantity,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrderPrintLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<String>? kind,
    Value<String>? signature,
    Value<int>? productId,
    Value<String>? productName,
    Value<String>? choicesJson,
    Value<double>? printedQuantity,
    Value<DateTime>? updatedAt,
  }) {
    return OrderPrintLogsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      kind: kind ?? this.kind,
      signature: signature ?? this.signature,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      choicesJson: choicesJson ?? this.choicesJson,
      printedQuantity: printedQuantity ?? this.printedQuantity,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (printedQuantity.present) {
      map['printed_quantity'] = Variable<double>(printedQuantity.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderPrintLogsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kind: $kind, ')
          ..write('signature: $signature, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('printedQuantity: $printedQuantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    passwordHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final DateTime createdAt;
  const UserRow({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserRow copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
  }) => UserRow(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    createdAt: createdAt ?? this.createdAt,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, passwordHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String passwordHash,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       email = Value(email),
       passwordHash = Value(passwordHash);
  static Insertable<UserRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<DateTime>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, PurchaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    productName,
    quantity,
    unitCost,
    purchasedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cost'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class PurchaseRow extends DataClass implements Insertable<PurchaseRow> {
  final int id;
  final int productId;
  final String productName;
  final double quantity;
  final double unitCost;
  final DateTime purchasedAt;
  final String? note;
  const PurchaseRow({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitCost,
    required this.purchasedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['unit_cost'] = Variable<double>(unitCost);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitCost: Value(unitCost),
      purchasedAt: Value(purchasedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PurchaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseRow(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'unitCost': serializer.toJson<double>(unitCost),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  PurchaseRow copyWith({
    int? id,
    int? productId,
    String? productName,
    double? quantity,
    double? unitCost,
    DateTime? purchasedAt,
    Value<String?> note = const Value.absent(),
  }) => PurchaseRow(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitCost: unitCost ?? this.unitCost,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    note: note.present ? note.value : this.note,
  );
  PurchaseRow copyWithCompanion(PurchasesCompanion data) {
    return PurchaseRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    productName,
    quantity,
    unitCost,
    purchasedAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitCost == this.unitCost &&
          other.purchasedAt == this.purchasedAt &&
          other.note == this.note);
}

class PurchasesCompanion extends UpdateCompanion<PurchaseRow> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> unitCost;
  final Value<DateTime> purchasedAt;
  final Value<String?> note;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String productName,
    required double quantity,
    required double unitCost,
    this.purchasedAt = const Value.absent(),
    this.note = const Value.absent(),
  }) : productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       unitCost = Value(unitCost);
  static Insertable<PurchaseRow> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? unitCost,
    Expression<DateTime>? purchasedAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitCost != null) 'unit_cost': unitCost,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (note != null) 'note': note,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? productName,
    Value<double>? quantity,
    Value<double>? unitCost,
    Value<DateTime>? purchasedAt,
    Value<String?>? note,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $GroupProductsTable groupProducts = $GroupProductsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $RecipeChoiceGroupsTable recipeChoiceGroups =
      $RecipeChoiceGroupsTable(this);
  late final $RecipeChoiceGroupSourcesTable recipeChoiceGroupSources =
      $RecipeChoiceGroupSourcesTable(this);
  late final $RecipeChoiceOptionsTable recipeChoiceOptions =
      $RecipeChoiceOptionsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $OrderItemChoicesTable orderItemChoices = $OrderItemChoicesTable(
    this,
  );
  late final $OrderPrintLogsTable orderPrintLogs = $OrderPrintLogsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final MenuDao menuDao = MenuDao(this as AppDatabase);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final StockDao stockDao = StockDao(this as AppDatabase);
  late final OrderDao orderDao = OrderDao(this as AppDatabase);
  late final ReportDao reportDao = ReportDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    groupProducts,
    products,
    recipeItems,
    recipeChoiceGroups,
    recipeChoiceGroupSources,
    recipeChoiceOptions,
    orders,
    orderItems,
    orderItemChoices,
    orderPrintLogs,
    users,
    purchases,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'group_products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('products', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_choice_groups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipe_choice_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('recipe_choice_group_sources', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipe_choice_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_choice_options', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'order_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_item_choices', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_print_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<Uint8List?> photo,
      Value<bool> isInternalUse,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<Uint8List?> photo,
      Value<bool> isInternalUse,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupProductsTable, List<GroupProductRow>>
  _groupProductsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupProducts,
    aliasName: 'category__id__group_products__category_id',
  );

  $$GroupProductsTableProcessedTableManager get groupProductsRefs {
    final manager = $$GroupProductsTableTableManager(
      $_db,
      $_db.groupProducts,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupProductsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupProductsRefs(
    Expression<bool> Function($$GroupProductsTableFilterComposer f) f,
  ) {
    final $$GroupProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableFilterComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => column,
  );

  Expression<T> groupProductsRefs<T extends Object>(
    Expression<T> Function($$GroupProductsTableAnnotationComposer a) f,
  ) {
    final $$GroupProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool groupProductsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<bool> isInternalUse = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                description: description,
                photo: photo,
                isInternalUse: isInternalUse,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<bool> isInternalUse = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                photo: photo,
                isInternalUse: isInternalUse,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupProductsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupProductsRefs) db.groupProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupProductsRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      GroupProductRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._groupProductsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).groupProductsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool groupProductsRefs})
    >;
typedef $$GroupProductsTableCreateCompanionBuilder =
    GroupProductsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required int categoryId,
    });
typedef $$GroupProductsTableUpdateCompanionBuilder =
    GroupProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> categoryId,
    });

final class $$GroupProductsTableReferences
    extends
        BaseReferences<_$AppDatabase, $GroupProductsTable, GroupProductRow> {
  $$GroupProductsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('group_products__category_id__category__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<ProductRow>>
  _productsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'group_products__id__products__group_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeChoiceGroupsTable, List<ChoiceGroupRow>>
  _recipeChoiceGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceGroups,
        aliasName: 'group_products__id__recipe_choice_groups__source_group_id',
      );

  $$RecipeChoiceGroupsTableProcessedTableManager get recipeChoiceGroupsRefs {
    final manager = $$RecipeChoiceGroupsTableTableManager(
      $_db,
      $_db.recipeChoiceGroups,
    ).filter((f) => f.sourceGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecipeChoiceGroupSourcesTable,
    List<ChoiceGroupSourceRow>
  >
  _recipeChoiceGroupSourcesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceGroupSources,
        aliasName:
            'group_products__id__recipe_choice_group_sources__source_group_id',
      );

  $$RecipeChoiceGroupSourcesTableProcessedTableManager
  get recipeChoiceGroupSourcesRefs {
    final manager = $$RecipeChoiceGroupSourcesTableTableManager(
      $_db,
      $_db.recipeChoiceGroupSources,
    ).filter((f) => f.sourceGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceGroupSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupProductsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupProductsTable> {
  $$GroupProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeChoiceGroupsRefs(
    Expression<bool> Function($$RecipeChoiceGroupsTableFilterComposer f) f,
  ) {
    final $$RecipeChoiceGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.sourceGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeChoiceGroupSourcesRefs(
    Expression<bool> Function($$RecipeChoiceGroupSourcesTableFilterComposer f)
    f,
  ) {
    final $$RecipeChoiceGroupSourcesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroupSources,
          getReferencedColumn: (t) => t.sourceGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupSourcesTableFilterComposer(
                $db: $db,
                $table: $db.recipeChoiceGroupSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GroupProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupProductsTable> {
  $$GroupProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupProductsTable> {
  $$GroupProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeChoiceGroupsRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceGroupsTableAnnotationComposer a) f,
  ) {
    final $$RecipeChoiceGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroups,
          getReferencedColumn: (t) => t.sourceGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeChoiceGroupSourcesRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceGroupSourcesTableAnnotationComposer a)
    f,
  ) {
    final $$RecipeChoiceGroupSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroupSources,
          getReferencedColumn: (t) => t.sourceGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroupSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GroupProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupProductsTable,
          GroupProductRow,
          $$GroupProductsTableFilterComposer,
          $$GroupProductsTableOrderingComposer,
          $$GroupProductsTableAnnotationComposer,
          $$GroupProductsTableCreateCompanionBuilder,
          $$GroupProductsTableUpdateCompanionBuilder,
          (GroupProductRow, $$GroupProductsTableReferences),
          GroupProductRow,
          PrefetchHooks Function({
            bool categoryId,
            bool productsRefs,
            bool recipeChoiceGroupsRefs,
            bool recipeChoiceGroupSourcesRefs,
          })
        > {
  $$GroupProductsTableTableManager(_$AppDatabase db, $GroupProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
              }) => GroupProductsCompanion(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required int categoryId,
              }) => GroupProductsCompanion.insert(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                productsRefs = false,
                recipeChoiceGroupsRefs = false,
                recipeChoiceGroupSourcesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productsRefs) db.products,
                    if (recipeChoiceGroupsRefs) db.recipeChoiceGroups,
                    if (recipeChoiceGroupSourcesRefs)
                      db.recipeChoiceGroupSources,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$GroupProductsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$GroupProductsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productsRefs)
                        await $_getPrefetchedData<
                          GroupProductRow,
                          $GroupProductsTable,
                          ProductRow
                        >(
                          currentTable: table,
                          referencedTable: $$GroupProductsTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeChoiceGroupsRefs)
                        await $_getPrefetchedData<
                          GroupProductRow,
                          $GroupProductsTable,
                          ChoiceGroupRow
                        >(
                          currentTable: table,
                          referencedTable: $$GroupProductsTableReferences
                              ._recipeChoiceGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeChoiceGroupSourcesRefs)
                        await $_getPrefetchedData<
                          GroupProductRow,
                          $GroupProductsTable,
                          ChoiceGroupSourceRow
                        >(
                          currentTable: table,
                          referencedTable: $$GroupProductsTableReferences
                              ._recipeChoiceGroupSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceGroupSourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupProductsTable,
      GroupProductRow,
      $$GroupProductsTableFilterComposer,
      $$GroupProductsTableOrderingComposer,
      $$GroupProductsTableAnnotationComposer,
      $$GroupProductsTableCreateCompanionBuilder,
      $$GroupProductsTableUpdateCompanionBuilder,
      (GroupProductRow, $$GroupProductsTableReferences),
      GroupProductRow,
      PrefetchHooks Function({
        bool categoryId,
        bool productsRefs,
        bool recipeChoiceGroupsRefs,
        bool recipeChoiceGroupSourcesRefs,
      })
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> photoPath,
      required int groupId,
      Value<double> costPrice,
      Value<double?> salePrice,
      Value<bool> isInternalUse,
      Value<double> stockQuantity,
      Value<double> minStock,
      Value<bool> isComposite,
      Value<bool> isActive,
      Value<String> preparationLocation,
      Value<bool> trackStock,
      Value<DateTime> createdAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> photoPath,
      Value<int> groupId,
      Value<double> costPrice,
      Value<double?> salePrice,
      Value<bool> isInternalUse,
      Value<double> stockQuantity,
      Value<double> minStock,
      Value<bool> isComposite,
      Value<bool> isActive,
      Value<String> preparationLocation,
      Value<bool> trackStock,
      Value<DateTime> createdAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductRow> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupProductsTable _groupIdTable(_$AppDatabase db) =>
      db.groupProducts.createAlias('products__group_id__group_products__id');

  $$GroupProductsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupProductsTableTableManager(
      $_db,
      $_db.groupProducts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecipeChoiceGroupsTable, List<ChoiceGroupRow>>
  _recipeChoiceGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceGroups,
        aliasName: 'products__id__recipe_choice_groups__product_id',
      );

  $$RecipeChoiceGroupsTableProcessedTableManager get recipeChoiceGroupsRefs {
    final manager = $$RecipeChoiceGroupsTableTableManager(
      $_db,
      $_db.recipeChoiceGroups,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeChoiceOptionsTable, List<ChoiceOptionRow>>
  _recipeChoiceOptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceOptions,
        aliasName: 'products__id__recipe_choice_options__component_product_id',
      );

  $$RecipeChoiceOptionsTableProcessedTableManager get recipeChoiceOptionsRefs {
    final manager =
        $$RecipeChoiceOptionsTableTableManager(
          $_db,
          $_db.recipeChoiceOptions,
        ).filter(
          (f) => f.componentProductId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceOptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItemRow>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'products__id__order_items__product_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemChoicesTable, List<OrderItemChoiceRow>>
  _orderItemChoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItemChoices,
    aliasName: 'products__id__order_item_choices__selected_product_id',
  );

  $$OrderItemChoicesTableProcessedTableManager get orderItemChoicesRefs {
    final manager = $$OrderItemChoicesTableTableManager(
      $_db,
      $_db.orderItemChoices,
    ).filter((f) => f.selectedProductId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemChoicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderPrintLogsTable, List<OrderPrintLogRow>>
  _orderPrintLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderPrintLogs,
    aliasName: 'products__id__order_print_logs__product_id',
  );

  $$OrderPrintLogsTableProcessedTableManager get orderPrintLogsRefs {
    final manager = $$OrderPrintLogsTableTableManager(
      $_db,
      $_db.orderPrintLogs,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderPrintLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchasesTable, List<PurchaseRow>>
  _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchases,
    aliasName: 'products__id__purchases__product_id',
  );

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComposite => $composableBuilder(
    column: $table.isComposite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupProductsTableFilterComposer get groupId {
    final $$GroupProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableFilterComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recipeChoiceGroupsRefs(
    Expression<bool> Function($$RecipeChoiceGroupsTableFilterComposer f) f,
  ) {
    final $$RecipeChoiceGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeChoiceOptionsRefs(
    Expression<bool> Function($$RecipeChoiceOptionsTableFilterComposer f) f,
  ) {
    final $$RecipeChoiceOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeChoiceOptions,
      getReferencedColumn: (t) => t.componentProductId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceOptionsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemChoicesRefs(
    Expression<bool> Function($$OrderItemChoicesTableFilterComposer f) f,
  ) {
    final $$OrderItemChoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemChoices,
      getReferencedColumn: (t) => t.selectedProductId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemChoicesTableFilterComposer(
            $db: $db,
            $table: $db.orderItemChoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderPrintLogsRefs(
    Expression<bool> Function($$OrderPrintLogsTableFilterComposer f) f,
  ) {
    final $$OrderPrintLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderPrintLogs,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderPrintLogsTableFilterComposer(
            $db: $db,
            $table: $db.orderPrintLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchasesRefs(
    Expression<bool> Function($$PurchasesTableFilterComposer f) f,
  ) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComposite => $composableBuilder(
    column: $table.isComposite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupProductsTableOrderingComposer get groupId {
    final $$GroupProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableOrderingComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<bool> get isInternalUse => $composableBuilder(
    column: $table.isInternalUse,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<bool> get isComposite => $composableBuilder(
    column: $table.isComposite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GroupProductsTableAnnotationComposer get groupId {
    final $$GroupProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recipeChoiceGroupsRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceGroupsTableAnnotationComposer a) f,
  ) {
    final $$RecipeChoiceGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroups,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeChoiceOptionsRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceOptionsTableAnnotationComposer a) f,
  ) {
    final $$RecipeChoiceOptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceOptions,
          getReferencedColumn: (t) => t.componentProductId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceOptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceOptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderItemChoicesRefs<T extends Object>(
    Expression<T> Function($$OrderItemChoicesTableAnnotationComposer a) f,
  ) {
    final $$OrderItemChoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemChoices,
      getReferencedColumn: (t) => t.selectedProductId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemChoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemChoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderPrintLogsRefs<T extends Object>(
    Expression<T> Function($$OrderPrintLogsTableAnnotationComposer a) f,
  ) {
    final $$OrderPrintLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderPrintLogs,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderPrintLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderPrintLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
    Expression<T> Function($$PurchasesTableAnnotationComposer a) f,
  ) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (ProductRow, $$ProductsTableReferences),
          ProductRow,
          PrefetchHooks Function({
            bool groupId,
            bool recipeChoiceGroupsRefs,
            bool recipeChoiceOptionsRefs,
            bool orderItemsRefs,
            bool orderItemChoicesRefs,
            bool orderPrintLogsRefs,
            bool purchasesRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<double> costPrice = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<bool> isInternalUse = const Value.absent(),
                Value<double> stockQuantity = const Value.absent(),
                Value<double> minStock = const Value.absent(),
                Value<bool> isComposite = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> preparationLocation = const Value.absent(),
                Value<bool> trackStock = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                description: description,
                photoPath: photoPath,
                groupId: groupId,
                costPrice: costPrice,
                salePrice: salePrice,
                isInternalUse: isInternalUse,
                stockQuantity: stockQuantity,
                minStock: minStock,
                isComposite: isComposite,
                isActive: isActive,
                preparationLocation: preparationLocation,
                trackStock: trackStock,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required int groupId,
                Value<double> costPrice = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<bool> isInternalUse = const Value.absent(),
                Value<double> stockQuantity = const Value.absent(),
                Value<double> minStock = const Value.absent(),
                Value<bool> isComposite = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> preparationLocation = const Value.absent(),
                Value<bool> trackStock = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                description: description,
                photoPath: photoPath,
                groupId: groupId,
                costPrice: costPrice,
                salePrice: salePrice,
                isInternalUse: isInternalUse,
                stockQuantity: stockQuantity,
                minStock: minStock,
                isComposite: isComposite,
                isActive: isActive,
                preparationLocation: preparationLocation,
                trackStock: trackStock,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                recipeChoiceGroupsRefs = false,
                recipeChoiceOptionsRefs = false,
                orderItemsRefs = false,
                orderItemChoicesRefs = false,
                orderPrintLogsRefs = false,
                purchasesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeChoiceGroupsRefs) db.recipeChoiceGroups,
                    if (recipeChoiceOptionsRefs) db.recipeChoiceOptions,
                    if (orderItemsRefs) db.orderItems,
                    if (orderItemChoicesRefs) db.orderItemChoices,
                    if (orderPrintLogsRefs) db.orderPrintLogs,
                    if (purchasesRefs) db.purchases,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$ProductsTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeChoiceGroupsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          ChoiceGroupRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._recipeChoiceGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeChoiceOptionsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          ChoiceOptionRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._recipeChoiceOptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceOptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.componentProductId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          OrderItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemChoicesRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          OrderItemChoiceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderItemChoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemChoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.selectedProductId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderPrintLogsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          OrderPrintLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderPrintLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderPrintLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchasesRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          PurchaseRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._purchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, $$ProductsTableReferences),
      ProductRow,
      PrefetchHooks Function({
        bool groupId,
        bool recipeChoiceGroupsRefs,
        bool recipeChoiceOptionsRefs,
        bool orderItemsRefs,
        bool orderItemChoicesRefs,
        bool orderPrintLogsRefs,
        bool purchasesRefs,
      })
    >;
typedef $$RecipeItemsTableCreateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      required int productId,
      required int ingredientId,
      required double quantity,
      Value<bool> isOptional,
    });
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int> ingredientId,
      Value<double> quantity,
      Value<bool> isOptional,
    });

final class $$RecipeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItemRow> {
  $$RecipeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('recipe_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _ingredientIdTable(_$AppDatabase db) =>
      db.products.createAlias('recipe_items__ingredient_id__products__id');

  $$ProductsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get ingredientId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get ingredientId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => column,
  );

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get ingredientId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeItemsTable,
          RecipeItemRow,
          $$RecipeItemsTableFilterComposer,
          $$RecipeItemsTableOrderingComposer,
          $$RecipeItemsTableAnnotationComposer,
          $$RecipeItemsTableCreateCompanionBuilder,
          $$RecipeItemsTableUpdateCompanionBuilder,
          (RecipeItemRow, $$RecipeItemsTableReferences),
          RecipeItemRow,
          PrefetchHooks Function({bool productId, bool ingredientId})
        > {
  $$RecipeItemsTableTableManager(_$AppDatabase db, $RecipeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                productId: productId,
                ingredientId: ingredientId,
                quantity: quantity,
                isOptional: isOptional,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int ingredientId,
                required double quantity,
                Value<bool> isOptional = const Value.absent(),
              }) => RecipeItemsCompanion.insert(
                id: id,
                productId: productId,
                ingredientId: ingredientId,
                quantity: quantity,
                isOptional: isOptional,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$RecipeItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$RecipeItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable: $$RecipeItemsTableReferences
                                    ._ingredientIdTable(db),
                                referencedColumn: $$RecipeItemsTableReferences
                                    ._ingredientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeItemsTable,
      RecipeItemRow,
      $$RecipeItemsTableFilterComposer,
      $$RecipeItemsTableOrderingComposer,
      $$RecipeItemsTableAnnotationComposer,
      $$RecipeItemsTableCreateCompanionBuilder,
      $$RecipeItemsTableUpdateCompanionBuilder,
      (RecipeItemRow, $$RecipeItemsTableReferences),
      RecipeItemRow,
      PrefetchHooks Function({bool productId, bool ingredientId})
    >;
typedef $$RecipeChoiceGroupsTableCreateCompanionBuilder =
    RecipeChoiceGroupsCompanion Function({
      Value<int> id,
      required int productId,
      required String name,
      Value<int?> sourceGroupId,
      Value<int> minSelections,
      Value<int> maxSelections,
      Value<int> displayOrder,
      Value<String> kind,
    });
typedef $$RecipeChoiceGroupsTableUpdateCompanionBuilder =
    RecipeChoiceGroupsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<String> name,
      Value<int?> sourceGroupId,
      Value<int> minSelections,
      Value<int> maxSelections,
      Value<int> displayOrder,
      Value<String> kind,
    });

final class $$RecipeChoiceGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeChoiceGroupsTable,
          ChoiceGroupRow
        > {
  $$RecipeChoiceGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('recipe_choice_groups__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupProductsTable _sourceGroupIdTable(_$AppDatabase db) => db
      .groupProducts
      .createAlias('recipe_choice_groups__source_group_id__group_products__id');

  $$GroupProductsTableProcessedTableManager? get sourceGroupId {
    final $_column = $_itemColumn<int>('source_group_id');
    if ($_column == null) return null;
    final manager = $$GroupProductsTableTableManager(
      $_db,
      $_db.groupProducts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecipeChoiceGroupSourcesTable,
    List<ChoiceGroupSourceRow>
  >
  _recipeChoiceGroupSourcesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceGroupSources,
        aliasName:
            'recipe_choice_groups__id__recipe_choice_group_sources__group_id',
      );

  $$RecipeChoiceGroupSourcesTableProcessedTableManager
  get recipeChoiceGroupSourcesRefs {
    final manager = $$RecipeChoiceGroupSourcesTableTableManager(
      $_db,
      $_db.recipeChoiceGroupSources,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceGroupSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeChoiceOptionsTable, List<ChoiceOptionRow>>
  _recipeChoiceOptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeChoiceOptions,
        aliasName: 'recipe_choice_groups__id__recipe_choice_options__group_id',
      );

  $$RecipeChoiceOptionsTableProcessedTableManager get recipeChoiceOptionsRefs {
    final manager = $$RecipeChoiceOptionsTableTableManager(
      $_db,
      $_db.recipeChoiceOptions,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeChoiceOptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipeChoiceGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupsTable> {
  $$RecipeChoiceGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minSelections => $composableBuilder(
    column: $table.minSelections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSelections => $composableBuilder(
    column: $table.maxSelections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupProductsTableFilterComposer get sourceGroupId {
    final $$GroupProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableFilterComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recipeChoiceGroupSourcesRefs(
    Expression<bool> Function($$RecipeChoiceGroupSourcesTableFilterComposer f)
    f,
  ) {
    final $$RecipeChoiceGroupSourcesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroupSources,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupSourcesTableFilterComposer(
                $db: $db,
                $table: $db.recipeChoiceGroupSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recipeChoiceOptionsRefs(
    Expression<bool> Function($$RecipeChoiceOptionsTableFilterComposer f) f,
  ) {
    final $$RecipeChoiceOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeChoiceOptions,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceOptionsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipeChoiceGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupsTable> {
  $$RecipeChoiceGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minSelections => $composableBuilder(
    column: $table.minSelections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSelections => $composableBuilder(
    column: $table.maxSelections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupProductsTableOrderingComposer get sourceGroupId {
    final $$GroupProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableOrderingComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupsTable> {
  $$RecipeChoiceGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minSelections => $composableBuilder(
    column: $table.minSelections,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxSelections => $composableBuilder(
    column: $table.maxSelections,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupProductsTableAnnotationComposer get sourceGroupId {
    final $$GroupProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recipeChoiceGroupSourcesRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceGroupSourcesTableAnnotationComposer a)
    f,
  ) {
    final $$RecipeChoiceGroupSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceGroupSources,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroupSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeChoiceOptionsRefs<T extends Object>(
    Expression<T> Function($$RecipeChoiceOptionsTableAnnotationComposer a) f,
  ) {
    final $$RecipeChoiceOptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeChoiceOptions,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceOptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceOptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecipeChoiceGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeChoiceGroupsTable,
          ChoiceGroupRow,
          $$RecipeChoiceGroupsTableFilterComposer,
          $$RecipeChoiceGroupsTableOrderingComposer,
          $$RecipeChoiceGroupsTableAnnotationComposer,
          $$RecipeChoiceGroupsTableCreateCompanionBuilder,
          $$RecipeChoiceGroupsTableUpdateCompanionBuilder,
          (ChoiceGroupRow, $$RecipeChoiceGroupsTableReferences),
          ChoiceGroupRow,
          PrefetchHooks Function({
            bool productId,
            bool sourceGroupId,
            bool recipeChoiceGroupSourcesRefs,
            bool recipeChoiceOptionsRefs,
          })
        > {
  $$RecipeChoiceGroupsTableTableManager(
    _$AppDatabase db,
    $RecipeChoiceGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeChoiceGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeChoiceGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeChoiceGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> sourceGroupId = const Value.absent(),
                Value<int> minSelections = const Value.absent(),
                Value<int> maxSelections = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String> kind = const Value.absent(),
              }) => RecipeChoiceGroupsCompanion(
                id: id,
                productId: productId,
                name: name,
                sourceGroupId: sourceGroupId,
                minSelections: minSelections,
                maxSelections: maxSelections,
                displayOrder: displayOrder,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required String name,
                Value<int?> sourceGroupId = const Value.absent(),
                Value<int> minSelections = const Value.absent(),
                Value<int> maxSelections = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String> kind = const Value.absent(),
              }) => RecipeChoiceGroupsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                sourceGroupId: sourceGroupId,
                minSelections: minSelections,
                maxSelections: maxSelections,
                displayOrder: displayOrder,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeChoiceGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productId = false,
                sourceGroupId = false,
                recipeChoiceGroupSourcesRefs = false,
                recipeChoiceOptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeChoiceGroupSourcesRefs)
                      db.recipeChoiceGroupSources,
                    if (recipeChoiceOptionsRefs) db.recipeChoiceOptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$RecipeChoiceGroupsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$RecipeChoiceGroupsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceGroupId,
                                    referencedTable:
                                        $$RecipeChoiceGroupsTableReferences
                                            ._sourceGroupIdTable(db),
                                    referencedColumn:
                                        $$RecipeChoiceGroupsTableReferences
                                            ._sourceGroupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeChoiceGroupSourcesRefs)
                        await $_getPrefetchedData<
                          ChoiceGroupRow,
                          $RecipeChoiceGroupsTable,
                          ChoiceGroupSourceRow
                        >(
                          currentTable: table,
                          referencedTable: $$RecipeChoiceGroupsTableReferences
                              ._recipeChoiceGroupSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipeChoiceGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceGroupSourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeChoiceOptionsRefs)
                        await $_getPrefetchedData<
                          ChoiceGroupRow,
                          $RecipeChoiceGroupsTable,
                          ChoiceOptionRow
                        >(
                          currentTable: table,
                          referencedTable: $$RecipeChoiceGroupsTableReferences
                              ._recipeChoiceOptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipeChoiceGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeChoiceOptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipeChoiceGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeChoiceGroupsTable,
      ChoiceGroupRow,
      $$RecipeChoiceGroupsTableFilterComposer,
      $$RecipeChoiceGroupsTableOrderingComposer,
      $$RecipeChoiceGroupsTableAnnotationComposer,
      $$RecipeChoiceGroupsTableCreateCompanionBuilder,
      $$RecipeChoiceGroupsTableUpdateCompanionBuilder,
      (ChoiceGroupRow, $$RecipeChoiceGroupsTableReferences),
      ChoiceGroupRow,
      PrefetchHooks Function({
        bool productId,
        bool sourceGroupId,
        bool recipeChoiceGroupSourcesRefs,
        bool recipeChoiceOptionsRefs,
      })
    >;
typedef $$RecipeChoiceGroupSourcesTableCreateCompanionBuilder =
    RecipeChoiceGroupSourcesCompanion Function({
      Value<int> id,
      required int groupId,
      required int sourceGroupId,
    });
typedef $$RecipeChoiceGroupSourcesTableUpdateCompanionBuilder =
    RecipeChoiceGroupSourcesCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> sourceGroupId,
    });

final class $$RecipeChoiceGroupSourcesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeChoiceGroupSourcesTable,
          ChoiceGroupSourceRow
        > {
  $$RecipeChoiceGroupSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipeChoiceGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.recipeChoiceGroups.createAlias(
        'recipe_choice_group_sources__group_id__recipe_choice_groups__id',
      );

  $$RecipeChoiceGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$RecipeChoiceGroupsTableTableManager(
      $_db,
      $_db.recipeChoiceGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupProductsTable _sourceGroupIdTable(_$AppDatabase db) =>
      db.groupProducts.createAlias(
        'recipe_choice_group_sources__source_group_id__group_products__id',
      );

  $$GroupProductsTableProcessedTableManager get sourceGroupId {
    final $_column = $_itemColumn<int>('source_group_id')!;

    final manager = $$GroupProductsTableTableManager(
      $_db,
      $_db.groupProducts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeChoiceGroupSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupSourcesTable> {
  $$RecipeChoiceGroupSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipeChoiceGroupsTableFilterComposer get groupId {
    final $$RecipeChoiceGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupProductsTableFilterComposer get sourceGroupId {
    final $$GroupProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableFilterComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceGroupSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupSourcesTable> {
  $$RecipeChoiceGroupSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipeChoiceGroupsTableOrderingComposer get groupId {
    final $$RecipeChoiceGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupProductsTableOrderingComposer get sourceGroupId {
    final $$GroupProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableOrderingComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceGroupSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeChoiceGroupSourcesTable> {
  $$RecipeChoiceGroupSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$RecipeChoiceGroupsTableAnnotationComposer get groupId {
    final $$RecipeChoiceGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.recipeChoiceGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$GroupProductsTableAnnotationComposer get sourceGroupId {
    final $$GroupProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceGroupId,
      referencedTable: $db.groupProducts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceGroupSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeChoiceGroupSourcesTable,
          ChoiceGroupSourceRow,
          $$RecipeChoiceGroupSourcesTableFilterComposer,
          $$RecipeChoiceGroupSourcesTableOrderingComposer,
          $$RecipeChoiceGroupSourcesTableAnnotationComposer,
          $$RecipeChoiceGroupSourcesTableCreateCompanionBuilder,
          $$RecipeChoiceGroupSourcesTableUpdateCompanionBuilder,
          (ChoiceGroupSourceRow, $$RecipeChoiceGroupSourcesTableReferences),
          ChoiceGroupSourceRow,
          PrefetchHooks Function({bool groupId, bool sourceGroupId})
        > {
  $$RecipeChoiceGroupSourcesTableTableManager(
    _$AppDatabase db,
    $RecipeChoiceGroupSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeChoiceGroupSourcesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecipeChoiceGroupSourcesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecipeChoiceGroupSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> sourceGroupId = const Value.absent(),
              }) => RecipeChoiceGroupSourcesCompanion(
                id: id,
                groupId: groupId,
                sourceGroupId: sourceGroupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int sourceGroupId,
              }) => RecipeChoiceGroupSourcesCompanion.insert(
                id: id,
                groupId: groupId,
                sourceGroupId: sourceGroupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeChoiceGroupSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, sourceGroupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$RecipeChoiceGroupSourcesTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$RecipeChoiceGroupSourcesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (sourceGroupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceGroupId,
                                referencedTable:
                                    $$RecipeChoiceGroupSourcesTableReferences
                                        ._sourceGroupIdTable(db),
                                referencedColumn:
                                    $$RecipeChoiceGroupSourcesTableReferences
                                        ._sourceGroupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeChoiceGroupSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeChoiceGroupSourcesTable,
      ChoiceGroupSourceRow,
      $$RecipeChoiceGroupSourcesTableFilterComposer,
      $$RecipeChoiceGroupSourcesTableOrderingComposer,
      $$RecipeChoiceGroupSourcesTableAnnotationComposer,
      $$RecipeChoiceGroupSourcesTableCreateCompanionBuilder,
      $$RecipeChoiceGroupSourcesTableUpdateCompanionBuilder,
      (ChoiceGroupSourceRow, $$RecipeChoiceGroupSourcesTableReferences),
      ChoiceGroupSourceRow,
      PrefetchHooks Function({bool groupId, bool sourceGroupId})
    >;
typedef $$RecipeChoiceOptionsTableCreateCompanionBuilder =
    RecipeChoiceOptionsCompanion Function({
      Value<int> id,
      required int groupId,
      required String name,
      Value<int?> componentProductId,
      Value<double?> quantity,
      Value<double> priceAddition,
      Value<int> displayOrder,
    });
typedef $$RecipeChoiceOptionsTableUpdateCompanionBuilder =
    RecipeChoiceOptionsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<String> name,
      Value<int?> componentProductId,
      Value<double?> quantity,
      Value<double> priceAddition,
      Value<int> displayOrder,
    });

final class $$RecipeChoiceOptionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeChoiceOptionsTable,
          ChoiceOptionRow
        > {
  $$RecipeChoiceOptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipeChoiceGroupsTable _groupIdTable(_$AppDatabase db) => db
      .recipeChoiceGroups
      .createAlias('recipe_choice_options__group_id__recipe_choice_groups__id');

  $$RecipeChoiceGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$RecipeChoiceGroupsTableTableManager(
      $_db,
      $_db.recipeChoiceGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _componentProductIdTable(_$AppDatabase db) => db
      .products
      .createAlias('recipe_choice_options__component_product_id__products__id');

  $$ProductsTableProcessedTableManager? get componentProductId {
    final $_column = $_itemColumn<int>('component_product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentProductIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeChoiceOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeChoiceOptionsTable> {
  $$RecipeChoiceOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipeChoiceGroupsTableFilterComposer get groupId {
    final $$RecipeChoiceGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get componentProductId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeChoiceOptionsTable> {
  $$RecipeChoiceOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipeChoiceGroupsTableOrderingComposer get groupId {
    final $$RecipeChoiceGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.recipeChoiceGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeChoiceGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.recipeChoiceGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get componentProductId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeChoiceOptionsTable> {
  $$RecipeChoiceOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$RecipeChoiceGroupsTableAnnotationComposer get groupId {
    final $$RecipeChoiceGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.recipeChoiceGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeChoiceGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeChoiceGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ProductsTableAnnotationComposer get componentProductId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeChoiceOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeChoiceOptionsTable,
          ChoiceOptionRow,
          $$RecipeChoiceOptionsTableFilterComposer,
          $$RecipeChoiceOptionsTableOrderingComposer,
          $$RecipeChoiceOptionsTableAnnotationComposer,
          $$RecipeChoiceOptionsTableCreateCompanionBuilder,
          $$RecipeChoiceOptionsTableUpdateCompanionBuilder,
          (ChoiceOptionRow, $$RecipeChoiceOptionsTableReferences),
          ChoiceOptionRow,
          PrefetchHooks Function({bool groupId, bool componentProductId})
        > {
  $$RecipeChoiceOptionsTableTableManager(
    _$AppDatabase db,
    $RecipeChoiceOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeChoiceOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeChoiceOptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecipeChoiceOptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> componentProductId = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<double> priceAddition = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => RecipeChoiceOptionsCompanion(
                id: id,
                groupId: groupId,
                name: name,
                componentProductId: componentProductId,
                quantity: quantity,
                priceAddition: priceAddition,
                displayOrder: displayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required String name,
                Value<int?> componentProductId = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<double> priceAddition = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => RecipeChoiceOptionsCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                componentProductId: componentProductId,
                quantity: quantity,
                priceAddition: priceAddition,
                displayOrder: displayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeChoiceOptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({groupId = false, componentProductId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable:
                                        $$RecipeChoiceOptionsTableReferences
                                            ._groupIdTable(db),
                                    referencedColumn:
                                        $$RecipeChoiceOptionsTableReferences
                                            ._groupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (componentProductId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.componentProductId,
                                    referencedTable:
                                        $$RecipeChoiceOptionsTableReferences
                                            ._componentProductIdTable(db),
                                    referencedColumn:
                                        $$RecipeChoiceOptionsTableReferences
                                            ._componentProductIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecipeChoiceOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeChoiceOptionsTable,
      ChoiceOptionRow,
      $$RecipeChoiceOptionsTableFilterComposer,
      $$RecipeChoiceOptionsTableOrderingComposer,
      $$RecipeChoiceOptionsTableAnnotationComposer,
      $$RecipeChoiceOptionsTableCreateCompanionBuilder,
      $$RecipeChoiceOptionsTableUpdateCompanionBuilder,
      (ChoiceOptionRow, $$RecipeChoiceOptionsTableReferences),
      ChoiceOptionRow,
      PrefetchHooks Function({bool groupId, bool componentProductId})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      required String customerName,
      Value<String> status,
      Value<DateTime> openedAt,
      Value<DateTime?> closedAt,
      Value<double> total,
      Value<int> discountPercent,
      Value<bool> stockDeducted,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      Value<String> customerName,
      Value<String> status,
      Value<DateTime> openedAt,
      Value<DateTime?> closedAt,
      Value<double> total,
      Value<int> discountPercent,
      Value<bool> stockDeducted,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, OrderRow> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItemRow>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'orders__id__order_items__order_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderPrintLogsTable, List<OrderPrintLogRow>>
  _orderPrintLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderPrintLogs,
    aliasName: 'orders__id__order_print_logs__order_id',
  );

  $$OrderPrintLogsTableProcessedTableManager get orderPrintLogsRefs {
    final manager = $$OrderPrintLogsTableTableManager(
      $_db,
      $_db.orderPrintLogs,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderPrintLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stockDeducted => $composableBuilder(
    column: $table.stockDeducted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderPrintLogsRefs(
    Expression<bool> Function($$OrderPrintLogsTableFilterComposer f) f,
  ) {
    final $$OrderPrintLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderPrintLogs,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderPrintLogsTableFilterComposer(
            $db: $db,
            $table: $db.orderPrintLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stockDeducted => $composableBuilder(
    column: $table.stockDeducted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stockDeducted => $composableBuilder(
    column: $table.stockDeducted,
    builder: (column) => column,
  );

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderPrintLogsRefs<T extends Object>(
    Expression<T> Function($$OrderPrintLogsTableAnnotationComposer a) f,
  ) {
    final $$OrderPrintLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderPrintLogs,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderPrintLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderPrintLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          OrderRow,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (OrderRow, $$OrdersTableReferences),
          OrderRow,
          PrefetchHooks Function({bool orderItemsRefs, bool orderPrintLogsRefs})
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> discountPercent = const Value.absent(),
                Value<bool> stockDeducted = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                customerName: customerName,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                total: total,
                discountPercent: discountPercent,
                stockDeducted: stockDeducted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String customerName,
                Value<String> status = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> discountPercent = const Value.absent(),
                Value<bool> stockDeducted = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                customerName: customerName,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                total: total,
                discountPercent: discountPercent,
                stockDeducted: stockDeducted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({orderItemsRefs = false, orderPrintLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemsRefs) db.orderItems,
                    if (orderPrintLogsRefs) db.orderPrintLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          OrderRow,
                          $OrdersTable,
                          OrderItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderPrintLogsRefs)
                        await $_getPrefetchedData<
                          OrderRow,
                          $OrdersTable,
                          OrderPrintLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderPrintLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderPrintLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      OrderRow,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (OrderRow, $$OrdersTableReferences),
      OrderRow,
      PrefetchHooks Function({bool orderItemsRefs, bool orderPrintLogsRefs})
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> id,
      required int orderId,
      required int productId,
      required String productName,
      required double unitPrice,
      required double quantity,
      Value<String?> notes,
      Value<double?> unitCost,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<int> productId,
      Value<String> productName,
      Value<double> unitPrice,
      Value<double> quantity,
      Value<String?> notes,
      Value<double?> unitCost,
    });

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItemRow> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_items__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('order_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemChoicesTable, List<OrderItemChoiceRow>>
  _orderItemChoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItemChoices,
    aliasName: 'order_items__id__order_item_choices__order_item_id',
  );

  $$OrderItemChoicesTableProcessedTableManager get orderItemChoicesRefs {
    final manager = $$OrderItemChoicesTableTableManager(
      $_db,
      $_db.orderItemChoices,
    ).filter((f) => f.orderItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemChoicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemChoicesRefs(
    Expression<bool> Function($$OrderItemChoicesTableFilterComposer f) f,
  ) {
    final $$OrderItemChoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemChoices,
      getReferencedColumn: (t) => t.orderItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemChoicesTableFilterComposer(
            $db: $db,
            $table: $db.orderItemChoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemChoicesRefs<T extends Object>(
    Expression<T> Function($$OrderItemChoicesTableAnnotationComposer a) f,
  ) {
    final $$OrderItemChoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemChoices,
      getReferencedColumn: (t) => t.orderItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemChoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemChoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItemRow,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItemRow, $$OrderItemsTableReferences),
          OrderItemRow,
          PrefetchHooks Function({
            bool orderId,
            bool productId,
            bool orderItemChoicesRefs,
          })
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> unitCost = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                quantity: quantity,
                notes: notes,
                unitCost: unitCost,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int productId,
                required String productName,
                required double unitPrice,
                required double quantity,
                Value<String?> notes = const Value.absent(),
                Value<double?> unitCost = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                quantity: quantity,
                notes: notes,
                unitCost: unitCost,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                orderId = false,
                productId = false,
                orderItemChoicesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemChoicesRefs) db.orderItemChoices,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._orderIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._orderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._productIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemChoicesRefs)
                        await $_getPrefetchedData<
                          OrderItemRow,
                          $OrderItemsTable,
                          OrderItemChoiceRow
                        >(
                          currentTable: table,
                          referencedTable: $$OrderItemsTableReferences
                              ._orderItemChoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemChoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItemRow,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItemRow, $$OrderItemsTableReferences),
      OrderItemRow,
      PrefetchHooks Function({
        bool orderId,
        bool productId,
        bool orderItemChoicesRefs,
      })
    >;
typedef $$OrderItemChoicesTableCreateCompanionBuilder =
    OrderItemChoicesCompanion Function({
      Value<int> id,
      required int orderItemId,
      Value<String> choiceType,
      Value<String?> groupName,
      Value<int?> selectedProductId,
      required String selectedProductName,
      required double quantity,
      Value<double> priceAddition,
      Value<double?> costAddition,
      Value<String?> preparationLocation,
    });
typedef $$OrderItemChoicesTableUpdateCompanionBuilder =
    OrderItemChoicesCompanion Function({
      Value<int> id,
      Value<int> orderItemId,
      Value<String> choiceType,
      Value<String?> groupName,
      Value<int?> selectedProductId,
      Value<String> selectedProductName,
      Value<double> quantity,
      Value<double> priceAddition,
      Value<double?> costAddition,
      Value<String?> preparationLocation,
    });

final class $$OrderItemChoicesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderItemChoicesTable,
          OrderItemChoiceRow
        > {
  $$OrderItemChoicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderItemsTable _orderItemIdTable(_$AppDatabase db) => db.orderItems
      .createAlias('order_item_choices__order_item_id__order_items__id');

  $$OrderItemsTableProcessedTableManager get orderItemId {
    final $_column = $_itemColumn<int>('order_item_id')!;

    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _selectedProductIdTable(_$AppDatabase db) => db.products
      .createAlias('order_item_choices__selected_product_id__products__id');

  $$ProductsTableProcessedTableManager? get selectedProductId {
    final $_column = $_itemColumn<int>('selected_product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_selectedProductIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemChoicesTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemChoicesTable> {
  $$OrderItemChoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choiceType => $composableBuilder(
    column: $table.choiceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedProductName => $composableBuilder(
    column: $table.selectedProductName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costAddition => $composableBuilder(
    column: $table.costAddition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderItemsTableFilterComposer get orderItemId {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get selectedProductId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemChoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemChoicesTable> {
  $$OrderItemChoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choiceType => $composableBuilder(
    column: $table.choiceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedProductName => $composableBuilder(
    column: $table.selectedProductName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costAddition => $composableBuilder(
    column: $table.costAddition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderItemsTableOrderingComposer get orderItemId {
    final $$OrderItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableOrderingComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get selectedProductId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemChoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemChoicesTable> {
  $$OrderItemChoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get choiceType => $composableBuilder(
    column: $table.choiceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<String> get selectedProductName => $composableBuilder(
    column: $table.selectedProductName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceAddition => $composableBuilder(
    column: $table.priceAddition,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costAddition => $composableBuilder(
    column: $table.costAddition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparationLocation => $composableBuilder(
    column: $table.preparationLocation,
    builder: (column) => column,
  );

  $$OrderItemsTableAnnotationComposer get orderItemId {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get selectedProductId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProductId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemChoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemChoicesTable,
          OrderItemChoiceRow,
          $$OrderItemChoicesTableFilterComposer,
          $$OrderItemChoicesTableOrderingComposer,
          $$OrderItemChoicesTableAnnotationComposer,
          $$OrderItemChoicesTableCreateCompanionBuilder,
          $$OrderItemChoicesTableUpdateCompanionBuilder,
          (OrderItemChoiceRow, $$OrderItemChoicesTableReferences),
          OrderItemChoiceRow,
          PrefetchHooks Function({bool orderItemId, bool selectedProductId})
        > {
  $$OrderItemChoicesTableTableManager(
    _$AppDatabase db,
    $OrderItemChoicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemChoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemChoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemChoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderItemId = const Value.absent(),
                Value<String> choiceType = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<int?> selectedProductId = const Value.absent(),
                Value<String> selectedProductName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> priceAddition = const Value.absent(),
                Value<double?> costAddition = const Value.absent(),
                Value<String?> preparationLocation = const Value.absent(),
              }) => OrderItemChoicesCompanion(
                id: id,
                orderItemId: orderItemId,
                choiceType: choiceType,
                groupName: groupName,
                selectedProductId: selectedProductId,
                selectedProductName: selectedProductName,
                quantity: quantity,
                priceAddition: priceAddition,
                costAddition: costAddition,
                preparationLocation: preparationLocation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderItemId,
                Value<String> choiceType = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<int?> selectedProductId = const Value.absent(),
                required String selectedProductName,
                required double quantity,
                Value<double> priceAddition = const Value.absent(),
                Value<double?> costAddition = const Value.absent(),
                Value<String?> preparationLocation = const Value.absent(),
              }) => OrderItemChoicesCompanion.insert(
                id: id,
                orderItemId: orderItemId,
                choiceType: choiceType,
                groupName: groupName,
                selectedProductId: selectedProductId,
                selectedProductName: selectedProductName,
                quantity: quantity,
                priceAddition: priceAddition,
                costAddition: costAddition,
                preparationLocation: preparationLocation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemChoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({orderItemId = false, selectedProductId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderItemId,
                                    referencedTable:
                                        $$OrderItemChoicesTableReferences
                                            ._orderItemIdTable(db),
                                    referencedColumn:
                                        $$OrderItemChoicesTableReferences
                                            ._orderItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (selectedProductId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.selectedProductId,
                                    referencedTable:
                                        $$OrderItemChoicesTableReferences
                                            ._selectedProductIdTable(db),
                                    referencedColumn:
                                        $$OrderItemChoicesTableReferences
                                            ._selectedProductIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemChoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemChoicesTable,
      OrderItemChoiceRow,
      $$OrderItemChoicesTableFilterComposer,
      $$OrderItemChoicesTableOrderingComposer,
      $$OrderItemChoicesTableAnnotationComposer,
      $$OrderItemChoicesTableCreateCompanionBuilder,
      $$OrderItemChoicesTableUpdateCompanionBuilder,
      (OrderItemChoiceRow, $$OrderItemChoicesTableReferences),
      OrderItemChoiceRow,
      PrefetchHooks Function({bool orderItemId, bool selectedProductId})
    >;
typedef $$OrderPrintLogsTableCreateCompanionBuilder =
    OrderPrintLogsCompanion Function({
      Value<int> id,
      required int orderId,
      required String kind,
      required String signature,
      required int productId,
      required String productName,
      Value<String> choicesJson,
      required double printedQuantity,
      Value<DateTime> updatedAt,
    });
typedef $$OrderPrintLogsTableUpdateCompanionBuilder =
    OrderPrintLogsCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<String> kind,
      Value<String> signature,
      Value<int> productId,
      Value<String> productName,
      Value<String> choicesJson,
      Value<double> printedQuantity,
      Value<DateTime> updatedAt,
    });

final class $$OrderPrintLogsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OrderPrintLogsTable, OrderPrintLogRow> {
  $$OrderPrintLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_print_logs__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('order_print_logs__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderPrintLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderPrintLogsTable> {
  $$OrderPrintLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get printedQuantity => $composableBuilder(
    column: $table.printedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderPrintLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderPrintLogsTable> {
  $$OrderPrintLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get printedQuantity => $composableBuilder(
    column: $table.printedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderPrintLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderPrintLogsTable> {
  $$OrderPrintLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get printedQuantity => $composableBuilder(
    column: $table.printedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderPrintLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderPrintLogsTable,
          OrderPrintLogRow,
          $$OrderPrintLogsTableFilterComposer,
          $$OrderPrintLogsTableOrderingComposer,
          $$OrderPrintLogsTableAnnotationComposer,
          $$OrderPrintLogsTableCreateCompanionBuilder,
          $$OrderPrintLogsTableUpdateCompanionBuilder,
          (OrderPrintLogRow, $$OrderPrintLogsTableReferences),
          OrderPrintLogRow,
          PrefetchHooks Function({bool orderId, bool productId})
        > {
  $$OrderPrintLogsTableTableManager(
    _$AppDatabase db,
    $OrderPrintLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderPrintLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderPrintLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderPrintLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> signature = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> choicesJson = const Value.absent(),
                Value<double> printedQuantity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrderPrintLogsCompanion(
                id: id,
                orderId: orderId,
                kind: kind,
                signature: signature,
                productId: productId,
                productName: productName,
                choicesJson: choicesJson,
                printedQuantity: printedQuantity,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required String kind,
                required String signature,
                required int productId,
                required String productName,
                Value<String> choicesJson = const Value.absent(),
                required double printedQuantity,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrderPrintLogsCompanion.insert(
                id: id,
                orderId: orderId,
                kind: kind,
                signature: signature,
                productId: productId,
                productName: productName,
                choicesJson: choicesJson,
                printedQuantity: printedQuantity,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderPrintLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$OrderPrintLogsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn:
                                    $$OrderPrintLogsTableReferences
                                        ._orderIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$OrderPrintLogsTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$OrderPrintLogsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderPrintLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderPrintLogsTable,
      OrderPrintLogRow,
      $$OrderPrintLogsTableFilterComposer,
      $$OrderPrintLogsTableOrderingComposer,
      $$OrderPrintLogsTableAnnotationComposer,
      $$OrderPrintLogsTableCreateCompanionBuilder,
      $$OrderPrintLogsTableUpdateCompanionBuilder,
      (OrderPrintLogRow, $$OrderPrintLogsTableReferences),
      OrderPrintLogRow,
      PrefetchHooks Function({bool orderId, bool productId})
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String name,
      required String email,
      required String passwordHash,
      Value<DateTime> createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> passwordHash,
      Value<DateTime> createdAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String email,
                required String passwordHash,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      required int productId,
      required String productName,
      required double quantity,
      required double unitCost,
      Value<DateTime> purchasedAt,
      Value<String?> note,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<String> productName,
      Value<double> quantity,
      Value<double> unitCost,
      Value<DateTime> purchasedAt,
      Value<String?> note,
    });

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, PurchaseRow> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('purchases__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          PurchaseRow,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (PurchaseRow, $$PurchasesTableReferences),
          PurchaseRow,
          PrefetchHooks Function({bool productId})
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitCost = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                productId: productId,
                productName: productName,
                quantity: quantity,
                unitCost: unitCost,
                purchasedAt: purchasedAt,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required String productName,
                required double quantity,
                required double unitCost,
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                productId: productId,
                productName: productName,
                quantity: quantity,
                unitCost: unitCost,
                purchasedAt: purchasedAt,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$PurchasesTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$PurchasesTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      PurchaseRow,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (PurchaseRow, $$PurchasesTableReferences),
      PurchaseRow,
      PrefetchHooks Function({bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$GroupProductsTableTableManager get groupProducts =>
      $$GroupProductsTableTableManager(_db, _db.groupProducts);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$RecipeChoiceGroupsTableTableManager get recipeChoiceGroups =>
      $$RecipeChoiceGroupsTableTableManager(_db, _db.recipeChoiceGroups);
  $$RecipeChoiceGroupSourcesTableTableManager get recipeChoiceGroupSources =>
      $$RecipeChoiceGroupSourcesTableTableManager(
        _db,
        _db.recipeChoiceGroupSources,
      );
  $$RecipeChoiceOptionsTableTableManager get recipeChoiceOptions =>
      $$RecipeChoiceOptionsTableTableManager(_db, _db.recipeChoiceOptions);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$OrderItemChoicesTableTableManager get orderItemChoices =>
      $$OrderItemChoicesTableTableManager(_db, _db.orderItemChoices);
  $$OrderPrintLogsTableTableManager get orderPrintLogs =>
      $$OrderPrintLogsTableTableManager(_db, _db.orderPrintLogs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
}
