// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  @override
  List<GeneratedColumn> get $columns => [id, name, address, notes, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
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
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final String id;
  final String name;
  final String address;
  final String notes;
  final bool isActive;
  const CustomerRow({
    required this.id,
    required this.name,
    required this.address,
    required this.notes,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      notes: Value(notes),
      isActive: Value(isActive),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CustomerRow copyWith({
    String? id,
    String? name,
    String? address,
    String? notes,
    bool? isActive,
  }) => CustomerRow(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    isActive: isActive ?? this.isActive,
  );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, notes, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.isActive == this.isActive);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> notes;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CustomerRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? address,
    Value<String>? notes,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
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
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referencePriceMeta = const VerificationMeta(
    'referencePrice',
  );
  @override
  late final GeneratedColumn<double> referencePrice = GeneratedColumn<double>(
    'reference_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [id, label, referencePrice, isActive];
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('reference_price')) {
      context.handle(
        _referencePriceMeta,
        referencePrice.isAcceptableOrUnknown(
          data['reference_price']!,
          _referencePriceMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      referencePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reference_price'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String label;
  final double? referencePrice;
  final bool isActive;
  const ProductRow({
    required this.id,
    required this.label,
    this.referencePrice,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || referencePrice != null) {
      map['reference_price'] = Variable<double>(referencePrice);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      label: Value(label),
      referencePrice: referencePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(referencePrice),
      isActive: Value(isActive),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      referencePrice: serializer.fromJson<double?>(json['referencePrice']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'referencePrice': serializer.toJson<double?>(referencePrice),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ProductRow copyWith({
    String? id,
    String? label,
    Value<double?> referencePrice = const Value.absent(),
    bool? isActive,
  }) => ProductRow(
    id: id ?? this.id,
    label: label ?? this.label,
    referencePrice: referencePrice.present
        ? referencePrice.value
        : this.referencePrice,
    isActive: isActive ?? this.isActive,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      referencePrice: data.referencePrice.present
          ? data.referencePrice.value
          : this.referencePrice,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('referencePrice: $referencePrice, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, referencePrice, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.referencePrice == this.referencePrice &&
          other.isActive == this.isActive);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<double?> referencePrice;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.referencePrice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String label,
    this.referencePrice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<double>? referencePrice,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (referencePrice != null) 'reference_price': referencePrice,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<double?>? referencePrice,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      referencePrice: referencePrice ?? this.referencePrice,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (referencePrice.present) {
      map['reference_price'] = Variable<double>(referencePrice.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('referencePrice: $referencePrice, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerProductPricesTable extends CustomerProductPrices
    with TableInfo<$CustomerProductPricesTable, CustomerProductPriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerProductPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _isNegotiatedMeta = const VerificationMeta(
    'isNegotiated',
  );
  @override
  late final GeneratedColumn<bool> isNegotiated = GeneratedColumn<bool>(
    'is_negotiated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_negotiated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _overridePriceMeta = const VerificationMeta(
    'overridePrice',
  );
  @override
  late final GeneratedColumn<double> overridePrice = GeneratedColumn<double>(
    'override_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    productId,
    isNegotiated,
    overridePrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_product_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerProductPriceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('is_negotiated')) {
      context.handle(
        _isNegotiatedMeta,
        isNegotiated.isAcceptableOrUnknown(
          data['is_negotiated']!,
          _isNegotiatedMeta,
        ),
      );
    }
    if (data.containsKey('override_price')) {
      context.handle(
        _overridePriceMeta,
        overridePrice.isAcceptableOrUnknown(
          data['override_price']!,
          _overridePriceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {customerId, productId},
  ];
  @override
  CustomerProductPriceRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerProductPriceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      isNegotiated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_negotiated'],
      )!,
      overridePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}override_price'],
      ),
    );
  }

  @override
  $CustomerProductPricesTable createAlias(String alias) {
    return $CustomerProductPricesTable(attachedDatabase, alias);
  }
}

class CustomerProductPriceRow extends DataClass
    implements Insertable<CustomerProductPriceRow> {
  final String id;
  final String customerId;
  final String productId;
  final bool isNegotiated;
  final double? overridePrice;
  const CustomerProductPriceRow({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.isNegotiated,
    this.overridePrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['product_id'] = Variable<String>(productId);
    map['is_negotiated'] = Variable<bool>(isNegotiated);
    if (!nullToAbsent || overridePrice != null) {
      map['override_price'] = Variable<double>(overridePrice);
    }
    return map;
  }

  CustomerProductPricesCompanion toCompanion(bool nullToAbsent) {
    return CustomerProductPricesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      productId: Value(productId),
      isNegotiated: Value(isNegotiated),
      overridePrice: overridePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(overridePrice),
    );
  }

  factory CustomerProductPriceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerProductPriceRow(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      productId: serializer.fromJson<String>(json['productId']),
      isNegotiated: serializer.fromJson<bool>(json['isNegotiated']),
      overridePrice: serializer.fromJson<double?>(json['overridePrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'productId': serializer.toJson<String>(productId),
      'isNegotiated': serializer.toJson<bool>(isNegotiated),
      'overridePrice': serializer.toJson<double?>(overridePrice),
    };
  }

  CustomerProductPriceRow copyWith({
    String? id,
    String? customerId,
    String? productId,
    bool? isNegotiated,
    Value<double?> overridePrice = const Value.absent(),
  }) => CustomerProductPriceRow(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    productId: productId ?? this.productId,
    isNegotiated: isNegotiated ?? this.isNegotiated,
    overridePrice: overridePrice.present
        ? overridePrice.value
        : this.overridePrice,
  );
  CustomerProductPriceRow copyWithCompanion(
    CustomerProductPricesCompanion data,
  ) {
    return CustomerProductPriceRow(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      productId: data.productId.present ? data.productId.value : this.productId,
      isNegotiated: data.isNegotiated.present
          ? data.isNegotiated.value
          : this.isNegotiated,
      overridePrice: data.overridePrice.present
          ? data.overridePrice.value
          : this.overridePrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerProductPriceRow(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('productId: $productId, ')
          ..write('isNegotiated: $isNegotiated, ')
          ..write('overridePrice: $overridePrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, customerId, productId, isNegotiated, overridePrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerProductPriceRow &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.productId == this.productId &&
          other.isNegotiated == this.isNegotiated &&
          other.overridePrice == this.overridePrice);
}

class CustomerProductPricesCompanion
    extends UpdateCompanion<CustomerProductPriceRow> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> productId;
  final Value<bool> isNegotiated;
  final Value<double?> overridePrice;
  final Value<int> rowid;
  const CustomerProductPricesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.productId = const Value.absent(),
    this.isNegotiated = const Value.absent(),
    this.overridePrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerProductPricesCompanion.insert({
    required String id,
    required String customerId,
    required String productId,
    this.isNegotiated = const Value.absent(),
    this.overridePrice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       productId = Value(productId);
  static Insertable<CustomerProductPriceRow> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? productId,
    Expression<bool>? isNegotiated,
    Expression<double>? overridePrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (productId != null) 'product_id': productId,
      if (isNegotiated != null) 'is_negotiated': isNegotiated,
      if (overridePrice != null) 'override_price': overridePrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerProductPricesCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? productId,
    Value<bool>? isNegotiated,
    Value<double?>? overridePrice,
    Value<int>? rowid,
  }) {
    return CustomerProductPricesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      isNegotiated: isNegotiated ?? this.isNegotiated,
      overridePrice: overridePrice ?? this.overridePrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (isNegotiated.present) {
      map['is_negotiated'] = Variable<bool>(isNegotiated.value);
    }
    if (overridePrice.present) {
      map['override_price'] = Variable<double>(overridePrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerProductPricesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('productId: $productId, ')
          ..write('isNegotiated: $isNegotiated, ')
          ..write('overridePrice: $overridePrice, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _isDeliveredMeta = const VerificationMeta(
    'isDelivered',
  );
  @override
  late final GeneratedColumn<bool> isDelivered = GeneratedColumn<bool>(
    'is_delivered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_delivered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderDateMeta = const VerificationMeta(
    'orderDate',
  );
  @override
  late final GeneratedColumn<DateTime> orderDate = GeneratedColumn<DateTime>(
    'order_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveredDateMeta = const VerificationMeta(
    'deliveredDate',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredDate =
      GeneratedColumn<DateTime>(
        'delivered_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    isDelivered,
    isPaid,
    orderDate,
    deliveredDate,
    paidDate,
    note,
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('is_delivered')) {
      context.handle(
        _isDeliveredMeta,
        isDelivered.isAcceptableOrUnknown(
          data['is_delivered']!,
          _isDeliveredMeta,
        ),
      );
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('order_date')) {
      context.handle(
        _orderDateMeta,
        orderDate.isAcceptableOrUnknown(data['order_date']!, _orderDateMeta),
      );
    } else if (isInserting) {
      context.missing(_orderDateMeta);
    }
    if (data.containsKey('delivered_date')) {
      context.handle(
        _deliveredDateMeta,
        deliveredDate.isAcceptableOrUnknown(
          data['delivered_date']!,
          _deliveredDateMeta,
        ),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
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
  OrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      isDelivered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_delivered'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      orderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}order_date'],
      )!,
      deliveredDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_date'],
      ),
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class OrderRow extends DataClass implements Insertable<OrderRow> {
  final String id;
  final String customerId;
  final bool isDelivered;
  final bool isPaid;
  final DateTime orderDate;
  final DateTime? deliveredDate;
  final DateTime? paidDate;
  final String note;
  const OrderRow({
    required this.id,
    required this.customerId,
    required this.isDelivered,
    required this.isPaid,
    required this.orderDate,
    this.deliveredDate,
    this.paidDate,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['is_delivered'] = Variable<bool>(isDelivered);
    map['is_paid'] = Variable<bool>(isPaid);
    map['order_date'] = Variable<DateTime>(orderDate);
    if (!nullToAbsent || deliveredDate != null) {
      map['delivered_date'] = Variable<DateTime>(deliveredDate);
    }
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      customerId: Value(customerId),
      isDelivered: Value(isDelivered),
      isPaid: Value(isPaid),
      orderDate: Value(orderDate),
      deliveredDate: deliveredDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredDate),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      note: Value(note),
    );
  }

  factory OrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderRow(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      isDelivered: serializer.fromJson<bool>(json['isDelivered']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      orderDate: serializer.fromJson<DateTime>(json['orderDate']),
      deliveredDate: serializer.fromJson<DateTime?>(json['deliveredDate']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'isDelivered': serializer.toJson<bool>(isDelivered),
      'isPaid': serializer.toJson<bool>(isPaid),
      'orderDate': serializer.toJson<DateTime>(orderDate),
      'deliveredDate': serializer.toJson<DateTime?>(deliveredDate),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'note': serializer.toJson<String>(note),
    };
  }

  OrderRow copyWith({
    String? id,
    String? customerId,
    bool? isDelivered,
    bool? isPaid,
    DateTime? orderDate,
    Value<DateTime?> deliveredDate = const Value.absent(),
    Value<DateTime?> paidDate = const Value.absent(),
    String? note,
  }) => OrderRow(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    isDelivered: isDelivered ?? this.isDelivered,
    isPaid: isPaid ?? this.isPaid,
    orderDate: orderDate ?? this.orderDate,
    deliveredDate: deliveredDate.present
        ? deliveredDate.value
        : this.deliveredDate,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    note: note ?? this.note,
  );
  OrderRow copyWithCompanion(OrdersCompanion data) {
    return OrderRow(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      isDelivered: data.isDelivered.present
          ? data.isDelivered.value
          : this.isDelivered,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      orderDate: data.orderDate.present ? data.orderDate.value : this.orderDate,
      deliveredDate: data.deliveredDate.present
          ? data.deliveredDate.value
          : this.deliveredDate,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderRow(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('isDelivered: $isDelivered, ')
          ..write('isPaid: $isPaid, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveredDate: $deliveredDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    isDelivered,
    isPaid,
    orderDate,
    deliveredDate,
    paidDate,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderRow &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.isDelivered == this.isDelivered &&
          other.isPaid == this.isPaid &&
          other.orderDate == this.orderDate &&
          other.deliveredDate == this.deliveredDate &&
          other.paidDate == this.paidDate &&
          other.note == this.note);
}

class OrdersCompanion extends UpdateCompanion<OrderRow> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<bool> isDelivered;
  final Value<bool> isPaid;
  final Value<DateTime> orderDate;
  final Value<DateTime?> deliveredDate;
  final Value<DateTime?> paidDate;
  final Value<String> note;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.isDelivered = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.orderDate = const Value.absent(),
    this.deliveredDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    required String customerId,
    this.isDelivered = const Value.absent(),
    this.isPaid = const Value.absent(),
    required DateTime orderDate,
    this.deliveredDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       orderDate = Value(orderDate);
  static Insertable<OrderRow> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<bool>? isDelivered,
    Expression<bool>? isPaid,
    Expression<DateTime>? orderDate,
    Expression<DateTime>? deliveredDate,
    Expression<DateTime>? paidDate,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (isDelivered != null) 'is_delivered': isDelivered,
      if (isPaid != null) 'is_paid': isPaid,
      if (orderDate != null) 'order_date': orderDate,
      if (deliveredDate != null) 'delivered_date': deliveredDate,
      if (paidDate != null) 'paid_date': paidDate,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<bool>? isDelivered,
    Value<bool>? isPaid,
    Value<DateTime>? orderDate,
    Value<DateTime?>? deliveredDate,
    Value<DateTime?>? paidDate,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      isDelivered: isDelivered ?? this.isDelivered,
      isPaid: isPaid ?? this.isPaid,
      orderDate: orderDate ?? this.orderDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      paidDate: paidDate ?? this.paidDate,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (isDelivered.present) {
      map['is_delivered'] = Variable<bool>(isDelivered.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (orderDate.present) {
      map['order_date'] = Variable<DateTime>(orderDate.value);
    }
    if (deliveredDate.present) {
      map['delivered_date'] = Variable<DateTime>(deliveredDate.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('isDelivered: $isDelivered, ')
          ..write('isPaid: $isPaid, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveredDate: $deliveredDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderLineItemsTable extends OrderLineItems
    with TableInfo<$OrderLineItemsTable, OrderLineItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productLabelMeta = const VerificationMeta(
    'productLabel',
  );
  @override
  late final GeneratedColumn<String> productLabel = GeneratedColumn<String>(
    'product_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    productLabel,
    quantity,
    unitPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_line_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderLineItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('product_label')) {
      context.handle(
        _productLabelMeta,
        productLabel.isAcceptableOrUnknown(
          data['product_label']!,
          _productLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productLabelMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLineItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLineItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_label'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
    );
  }

  @override
  $OrderLineItemsTable createAlias(String alias) {
    return $OrderLineItemsTable(attachedDatabase, alias);
  }
}

class OrderLineItemRow extends DataClass
    implements Insertable<OrderLineItemRow> {
  final String id;
  final String orderId;
  final String productId;
  final String productLabel;
  final int quantity;
  final double unitPrice;
  const OrderLineItemRow({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productLabel,
    required this.quantity,
    required this.unitPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['product_label'] = Variable<String>(productLabel);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    return map;
  }

  OrderLineItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderLineItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      productLabel: Value(productLabel),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
    );
  }

  factory OrderLineItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLineItemRow(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      productLabel: serializer.fromJson<String>(json['productLabel']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'productLabel': serializer.toJson<String>(productLabel),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
    };
  }

  OrderLineItemRow copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productLabel,
    int? quantity,
    double? unitPrice,
  }) => OrderLineItemRow(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    productLabel: productLabel ?? this.productLabel,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
  );
  OrderLineItemRow copyWithCompanion(OrderLineItemsCompanion data) {
    return OrderLineItemRow(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productLabel: data.productLabel.present
          ? data.productLabel.value
          : this.productLabel,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderLineItemRow(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productLabel: $productLabel, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, productId, productLabel, quantity, unitPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLineItemRow &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productLabel == this.productLabel &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice);
}

class OrderLineItemsCompanion extends UpdateCompanion<OrderLineItemRow> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<String> productLabel;
  final Value<int> quantity;
  final Value<double> unitPrice;
  final Value<int> rowid;
  const OrderLineItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productLabel = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderLineItemsCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required String productLabel,
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       productLabel = Value(productLabel);
  static Insertable<OrderLineItemRow> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<String>? productLabel,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productLabel != null) 'product_label': productLabel,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderLineItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<String>? productLabel,
    Value<int>? quantity,
    Value<double>? unitPrice,
    Value<int>? rowid,
  }) {
    return OrderLineItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productLabel: productLabel ?? this.productLabel,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productLabel.present) {
      map['product_label'] = Variable<String>(productLabel.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLineItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productLabel: $productLabel, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeliveryPlansTable extends DeliveryPlans
    with TableInfo<$DeliveryPlansTable, DeliveryPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveryPlansTable(this.attachedDatabase, [this._alias]);
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryDateMeta = const VerificationMeta(
    'deliveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> deliveryDate = GeneratedColumn<DateTime>(
    'delivery_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    deliveryDate,
    isFinished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delivery_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeliveryPlanRow> instance, {
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
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('delivery_date')) {
      context.handle(
        _deliveryDateMeta,
        deliveryDate.isAcceptableOrUnknown(
          data['delivery_date']!,
          _deliveryDateMeta,
        ),
      );
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeliveryPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivery_date'],
      ),
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
    );
  }

  @override
  $DeliveryPlansTable createAlias(String alias) {
    return $DeliveryPlansTable(attachedDatabase, alias);
  }
}

class DeliveryPlanRow extends DataClass implements Insertable<DeliveryPlanRow> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? deliveryDate;
  final bool isFinished;
  const DeliveryPlanRow({
    required this.id,
    required this.name,
    required this.createdAt,
    this.deliveryDate,
    required this.isFinished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deliveryDate != null) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate);
    }
    map['is_finished'] = Variable<bool>(isFinished);
    return map;
  }

  DeliveryPlansCompanion toCompanion(bool nullToAbsent) {
    return DeliveryPlansCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      deliveryDate: deliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryDate),
      isFinished: Value(isFinished),
    );
  }

  factory DeliveryPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryPlanRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deliveryDate: serializer.fromJson<DateTime?>(json['deliveryDate']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deliveryDate': serializer.toJson<DateTime?>(deliveryDate),
      'isFinished': serializer.toJson<bool>(isFinished),
    };
  }

  DeliveryPlanRow copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    Value<DateTime?> deliveryDate = const Value.absent(),
    bool? isFinished,
  }) => DeliveryPlanRow(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    deliveryDate: deliveryDate.present ? deliveryDate.value : this.deliveryDate,
    isFinished: isFinished ?? this.isFinished,
  );
  DeliveryPlanRow copyWithCompanion(DeliveryPlansCompanion data) {
    return DeliveryPlanRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deliveryDate: data.deliveryDate.present
          ? data.deliveryDate.value
          : this.deliveryDate,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryPlanRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('isFinished: $isFinished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, createdAt, deliveryDate, isFinished);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryPlanRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.deliveryDate == this.deliveryDate &&
          other.isFinished == this.isFinished);
}

class DeliveryPlansCompanion extends UpdateCompanion<DeliveryPlanRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deliveryDate;
  final Value<bool> isFinished;
  final Value<int> rowid;
  const DeliveryPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeliveryPlansCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required DateTime createdAt,
    this.deliveryDate = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<DeliveryPlanRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deliveryDate,
    Expression<bool>? isFinished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (deliveryDate != null) 'delivery_date': deliveryDate,
      if (isFinished != null) 'is_finished': isFinished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeliveryPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deliveryDate,
    Value<bool>? isFinished,
    Value<int>? rowid,
  }) {
    return DeliveryPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      isFinished: isFinished ?? this.isFinished,
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deliveryDate.present) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('isFinished: $isFinished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeliveryPlanItemsTable extends DeliveryPlanItems
    with TableInfo<$DeliveryPlanItemsTable, DeliveryPlanItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveryPlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryPlanIdMeta = const VerificationMeta(
    'deliveryPlanId',
  );
  @override
  late final GeneratedColumn<String> deliveryPlanId = GeneratedColumn<String>(
    'delivery_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES delivery_plans (id)',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deliveryPlanId,
    orderId,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delivery_plan_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeliveryPlanItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('delivery_plan_id')) {
      context.handle(
        _deliveryPlanIdMeta,
        deliveryPlanId.isAcceptableOrUnknown(
          data['delivery_plan_id']!,
          _deliveryPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryPlanIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeliveryPlanItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryPlanItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deliveryPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_plan_id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DeliveryPlanItemsTable createAlias(String alias) {
    return $DeliveryPlanItemsTable(attachedDatabase, alias);
  }
}

class DeliveryPlanItemRow extends DataClass
    implements Insertable<DeliveryPlanItemRow> {
  final String id;
  final String deliveryPlanId;
  final String orderId;
  final int sortOrder;
  const DeliveryPlanItemRow({
    required this.id,
    required this.deliveryPlanId,
    required this.orderId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['delivery_plan_id'] = Variable<String>(deliveryPlanId);
    map['order_id'] = Variable<String>(orderId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DeliveryPlanItemsCompanion toCompanion(bool nullToAbsent) {
    return DeliveryPlanItemsCompanion(
      id: Value(id),
      deliveryPlanId: Value(deliveryPlanId),
      orderId: Value(orderId),
      sortOrder: Value(sortOrder),
    );
  }

  factory DeliveryPlanItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryPlanItemRow(
      id: serializer.fromJson<String>(json['id']),
      deliveryPlanId: serializer.fromJson<String>(json['deliveryPlanId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deliveryPlanId': serializer.toJson<String>(deliveryPlanId),
      'orderId': serializer.toJson<String>(orderId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DeliveryPlanItemRow copyWith({
    String? id,
    String? deliveryPlanId,
    String? orderId,
    int? sortOrder,
  }) => DeliveryPlanItemRow(
    id: id ?? this.id,
    deliveryPlanId: deliveryPlanId ?? this.deliveryPlanId,
    orderId: orderId ?? this.orderId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DeliveryPlanItemRow copyWithCompanion(DeliveryPlanItemsCompanion data) {
    return DeliveryPlanItemRow(
      id: data.id.present ? data.id.value : this.id,
      deliveryPlanId: data.deliveryPlanId.present
          ? data.deliveryPlanId.value
          : this.deliveryPlanId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryPlanItemRow(')
          ..write('id: $id, ')
          ..write('deliveryPlanId: $deliveryPlanId, ')
          ..write('orderId: $orderId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deliveryPlanId, orderId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryPlanItemRow &&
          other.id == this.id &&
          other.deliveryPlanId == this.deliveryPlanId &&
          other.orderId == this.orderId &&
          other.sortOrder == this.sortOrder);
}

class DeliveryPlanItemsCompanion extends UpdateCompanion<DeliveryPlanItemRow> {
  final Value<String> id;
  final Value<String> deliveryPlanId;
  final Value<String> orderId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DeliveryPlanItemsCompanion({
    this.id = const Value.absent(),
    this.deliveryPlanId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeliveryPlanItemsCompanion.insert({
    required String id,
    required String deliveryPlanId,
    required String orderId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deliveryPlanId = Value(deliveryPlanId),
       orderId = Value(orderId);
  static Insertable<DeliveryPlanItemRow> custom({
    Expression<String>? id,
    Expression<String>? deliveryPlanId,
    Expression<String>? orderId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deliveryPlanId != null) 'delivery_plan_id': deliveryPlanId,
      if (orderId != null) 'order_id': orderId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeliveryPlanItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? deliveryPlanId,
    Value<String>? orderId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DeliveryPlanItemsCompanion(
      id: id ?? this.id,
      deliveryPlanId: deliveryPlanId ?? this.deliveryPlanId,
      orderId: orderId ?? this.orderId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deliveryPlanId.present) {
      map['delivery_plan_id'] = Variable<String>(deliveryPlanId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryPlanItemsCompanion(')
          ..write('id: $id, ')
          ..write('deliveryPlanId: $deliveryPlanId, ')
          ..write('orderId: $orderId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warnOnDeleteMeta = const VerificationMeta(
    'warnOnDelete',
  );
  @override
  late final GeneratedColumn<bool> warnOnDelete = GeneratedColumn<bool>(
    'warn_on_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warn_on_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _warnOnUndeliverMeta = const VerificationMeta(
    'warnOnUndeliver',
  );
  @override
  late final GeneratedColumn<bool> warnOnUndeliver = GeneratedColumn<bool>(
    'warn_on_undeliver',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warn_on_undeliver" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _warnOnUnpaidMeta = const VerificationMeta(
    'warnOnUnpaid',
  );
  @override
  late final GeneratedColumn<bool> warnOnUnpaid = GeneratedColumn<bool>(
    'warn_on_unpaid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warn_on_unpaid" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _warnOnPlanDeliverMeta = const VerificationMeta(
    'warnOnPlanDeliver',
  );
  @override
  late final GeneratedColumn<bool> warnOnPlanDeliver = GeneratedColumn<bool>(
    'warn_on_plan_deliver',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warn_on_plan_deliver" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _warnOnPlanRemoveMeta = const VerificationMeta(
    'warnOnPlanRemove',
  );
  @override
  late final GeneratedColumn<bool> warnOnPlanRemove = GeneratedColumn<bool>(
    'warn_on_plan_remove',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warn_on_plan_remove" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    warnOnDelete,
    warnOnUndeliver,
    warnOnUnpaid,
    warnOnPlanDeliver,
    warnOnPlanRemove,
    darkMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('warn_on_delete')) {
      context.handle(
        _warnOnDeleteMeta,
        warnOnDelete.isAcceptableOrUnknown(
          data['warn_on_delete']!,
          _warnOnDeleteMeta,
        ),
      );
    }
    if (data.containsKey('warn_on_undeliver')) {
      context.handle(
        _warnOnUndeliverMeta,
        warnOnUndeliver.isAcceptableOrUnknown(
          data['warn_on_undeliver']!,
          _warnOnUndeliverMeta,
        ),
      );
    }
    if (data.containsKey('warn_on_unpaid')) {
      context.handle(
        _warnOnUnpaidMeta,
        warnOnUnpaid.isAcceptableOrUnknown(
          data['warn_on_unpaid']!,
          _warnOnUnpaidMeta,
        ),
      );
    }
    if (data.containsKey('warn_on_plan_deliver')) {
      context.handle(
        _warnOnPlanDeliverMeta,
        warnOnPlanDeliver.isAcceptableOrUnknown(
          data['warn_on_plan_deliver']!,
          _warnOnPlanDeliverMeta,
        ),
      );
    }
    if (data.containsKey('warn_on_plan_remove')) {
      context.handle(
        _warnOnPlanRemoveMeta,
        warnOnPlanRemove.isAcceptableOrUnknown(
          data['warn_on_plan_remove']!,
          _warnOnPlanRemoveMeta,
        ),
      );
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      warnOnDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warn_on_delete'],
      )!,
      warnOnUndeliver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warn_on_undeliver'],
      )!,
      warnOnUnpaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warn_on_unpaid'],
      )!,
      warnOnPlanDeliver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warn_on_plan_deliver'],
      )!,
      warnOnPlanRemove: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warn_on_plan_remove'],
      )!,
      darkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dark_mode'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final int id;
  final bool warnOnDelete;
  final bool warnOnUndeliver;
  final bool warnOnUnpaid;
  final bool warnOnPlanDeliver;
  final bool warnOnPlanRemove;
  final bool darkMode;
  const SettingRow({
    required this.id,
    required this.warnOnDelete,
    required this.warnOnUndeliver,
    required this.warnOnUnpaid,
    required this.warnOnPlanDeliver,
    required this.warnOnPlanRemove,
    required this.darkMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['warn_on_delete'] = Variable<bool>(warnOnDelete);
    map['warn_on_undeliver'] = Variable<bool>(warnOnUndeliver);
    map['warn_on_unpaid'] = Variable<bool>(warnOnUnpaid);
    map['warn_on_plan_deliver'] = Variable<bool>(warnOnPlanDeliver);
    map['warn_on_plan_remove'] = Variable<bool>(warnOnPlanRemove);
    map['dark_mode'] = Variable<bool>(darkMode);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      warnOnDelete: Value(warnOnDelete),
      warnOnUndeliver: Value(warnOnUndeliver),
      warnOnUnpaid: Value(warnOnUnpaid),
      warnOnPlanDeliver: Value(warnOnPlanDeliver),
      warnOnPlanRemove: Value(warnOnPlanRemove),
      darkMode: Value(darkMode),
    );
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      id: serializer.fromJson<int>(json['id']),
      warnOnDelete: serializer.fromJson<bool>(json['warnOnDelete']),
      warnOnUndeliver: serializer.fromJson<bool>(json['warnOnUndeliver']),
      warnOnUnpaid: serializer.fromJson<bool>(json['warnOnUnpaid']),
      warnOnPlanDeliver: serializer.fromJson<bool>(json['warnOnPlanDeliver']),
      warnOnPlanRemove: serializer.fromJson<bool>(json['warnOnPlanRemove']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'warnOnDelete': serializer.toJson<bool>(warnOnDelete),
      'warnOnUndeliver': serializer.toJson<bool>(warnOnUndeliver),
      'warnOnUnpaid': serializer.toJson<bool>(warnOnUnpaid),
      'warnOnPlanDeliver': serializer.toJson<bool>(warnOnPlanDeliver),
      'warnOnPlanRemove': serializer.toJson<bool>(warnOnPlanRemove),
      'darkMode': serializer.toJson<bool>(darkMode),
    };
  }

  SettingRow copyWith({
    int? id,
    bool? warnOnDelete,
    bool? warnOnUndeliver,
    bool? warnOnUnpaid,
    bool? warnOnPlanDeliver,
    bool? warnOnPlanRemove,
    bool? darkMode,
  }) => SettingRow(
    id: id ?? this.id,
    warnOnDelete: warnOnDelete ?? this.warnOnDelete,
    warnOnUndeliver: warnOnUndeliver ?? this.warnOnUndeliver,
    warnOnUnpaid: warnOnUnpaid ?? this.warnOnUnpaid,
    warnOnPlanDeliver: warnOnPlanDeliver ?? this.warnOnPlanDeliver,
    warnOnPlanRemove: warnOnPlanRemove ?? this.warnOnPlanRemove,
    darkMode: darkMode ?? this.darkMode,
  );
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      id: data.id.present ? data.id.value : this.id,
      warnOnDelete: data.warnOnDelete.present
          ? data.warnOnDelete.value
          : this.warnOnDelete,
      warnOnUndeliver: data.warnOnUndeliver.present
          ? data.warnOnUndeliver.value
          : this.warnOnUndeliver,
      warnOnUnpaid: data.warnOnUnpaid.present
          ? data.warnOnUnpaid.value
          : this.warnOnUnpaid,
      warnOnPlanDeliver: data.warnOnPlanDeliver.present
          ? data.warnOnPlanDeliver.value
          : this.warnOnPlanDeliver,
      warnOnPlanRemove: data.warnOnPlanRemove.present
          ? data.warnOnPlanRemove.value
          : this.warnOnPlanRemove,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('id: $id, ')
          ..write('warnOnDelete: $warnOnDelete, ')
          ..write('warnOnUndeliver: $warnOnUndeliver, ')
          ..write('warnOnUnpaid: $warnOnUnpaid, ')
          ..write('warnOnPlanDeliver: $warnOnPlanDeliver, ')
          ..write('warnOnPlanRemove: $warnOnPlanRemove, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    warnOnDelete,
    warnOnUndeliver,
    warnOnUnpaid,
    warnOnPlanDeliver,
    warnOnPlanRemove,
    darkMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.id == this.id &&
          other.warnOnDelete == this.warnOnDelete &&
          other.warnOnUndeliver == this.warnOnUndeliver &&
          other.warnOnUnpaid == this.warnOnUnpaid &&
          other.warnOnPlanDeliver == this.warnOnPlanDeliver &&
          other.warnOnPlanRemove == this.warnOnPlanRemove &&
          other.darkMode == this.darkMode);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<int> id;
  final Value<bool> warnOnDelete;
  final Value<bool> warnOnUndeliver;
  final Value<bool> warnOnUnpaid;
  final Value<bool> warnOnPlanDeliver;
  final Value<bool> warnOnPlanRemove;
  final Value<bool> darkMode;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.warnOnDelete = const Value.absent(),
    this.warnOnUndeliver = const Value.absent(),
    this.warnOnUnpaid = const Value.absent(),
    this.warnOnPlanDeliver = const Value.absent(),
    this.warnOnPlanRemove = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.warnOnDelete = const Value.absent(),
    this.warnOnUndeliver = const Value.absent(),
    this.warnOnUnpaid = const Value.absent(),
    this.warnOnPlanDeliver = const Value.absent(),
    this.warnOnPlanRemove = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  static Insertable<SettingRow> custom({
    Expression<int>? id,
    Expression<bool>? warnOnDelete,
    Expression<bool>? warnOnUndeliver,
    Expression<bool>? warnOnUnpaid,
    Expression<bool>? warnOnPlanDeliver,
    Expression<bool>? warnOnPlanRemove,
    Expression<bool>? darkMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (warnOnDelete != null) 'warn_on_delete': warnOnDelete,
      if (warnOnUndeliver != null) 'warn_on_undeliver': warnOnUndeliver,
      if (warnOnUnpaid != null) 'warn_on_unpaid': warnOnUnpaid,
      if (warnOnPlanDeliver != null) 'warn_on_plan_deliver': warnOnPlanDeliver,
      if (warnOnPlanRemove != null) 'warn_on_plan_remove': warnOnPlanRemove,
      if (darkMode != null) 'dark_mode': darkMode,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? warnOnDelete,
    Value<bool>? warnOnUndeliver,
    Value<bool>? warnOnUnpaid,
    Value<bool>? warnOnPlanDeliver,
    Value<bool>? warnOnPlanRemove,
    Value<bool>? darkMode,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      warnOnDelete: warnOnDelete ?? this.warnOnDelete,
      warnOnUndeliver: warnOnUndeliver ?? this.warnOnUndeliver,
      warnOnUnpaid: warnOnUnpaid ?? this.warnOnUnpaid,
      warnOnPlanDeliver: warnOnPlanDeliver ?? this.warnOnPlanDeliver,
      warnOnPlanRemove: warnOnPlanRemove ?? this.warnOnPlanRemove,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (warnOnDelete.present) {
      map['warn_on_delete'] = Variable<bool>(warnOnDelete.value);
    }
    if (warnOnUndeliver.present) {
      map['warn_on_undeliver'] = Variable<bool>(warnOnUndeliver.value);
    }
    if (warnOnUnpaid.present) {
      map['warn_on_unpaid'] = Variable<bool>(warnOnUnpaid.value);
    }
    if (warnOnPlanDeliver.present) {
      map['warn_on_plan_deliver'] = Variable<bool>(warnOnPlanDeliver.value);
    }
    if (warnOnPlanRemove.present) {
      map['warn_on_plan_remove'] = Variable<bool>(warnOnPlanRemove.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('warnOnDelete: $warnOnDelete, ')
          ..write('warnOnUndeliver: $warnOnUndeliver, ')
          ..write('warnOnUnpaid: $warnOnUnpaid, ')
          ..write('warnOnPlanDeliver: $warnOnPlanDeliver, ')
          ..write('warnOnPlanRemove: $warnOnPlanRemove, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }
}

class $ErrorLogsTable extends ErrorLogs
    with TableInfo<$ErrorLogsTable, ErrorLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErrorLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stackTraceMeta = const VerificationMeta(
    'stackTrace',
  );
  @override
  late final GeneratedColumn<String> stackTrace = GeneratedColumn<String>(
    'stack_trace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _currentRouteMeta = const VerificationMeta(
    'currentRoute',
  );
  @override
  late final GeneratedColumn<String> currentRoute = GeneratedColumn<String>(
    'current_route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    errorMessage,
    stackTrace,
    appVersion,
    currentRoute,
    platform,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'error_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ErrorLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_errorMessageMeta);
    }
    if (data.containsKey('stack_trace')) {
      context.handle(
        _stackTraceMeta,
        stackTrace.isAcceptableOrUnknown(data['stack_trace']!, _stackTraceMeta),
      );
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    if (data.containsKey('current_route')) {
      context.handle(
        _currentRouteMeta,
        currentRoute.isAcceptableOrUnknown(
          data['current_route']!,
          _currentRouteMeta,
        ),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ErrorLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErrorLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      )!,
      stackTrace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stack_trace'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      currentRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_route'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ErrorLogsTable createAlias(String alias) {
    return $ErrorLogsTable(attachedDatabase, alias);
  }
}

class ErrorLogRow extends DataClass implements Insertable<ErrorLogRow> {
  final int id;
  final String errorMessage;
  final String stackTrace;
  final String appVersion;
  final String currentRoute;
  final String platform;
  final DateTime createdAt;
  const ErrorLogRow({
    required this.id,
    required this.errorMessage,
    required this.stackTrace,
    required this.appVersion,
    required this.currentRoute,
    required this.platform,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['error_message'] = Variable<String>(errorMessage);
    map['stack_trace'] = Variable<String>(stackTrace);
    map['app_version'] = Variable<String>(appVersion);
    map['current_route'] = Variable<String>(currentRoute);
    map['platform'] = Variable<String>(platform);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ErrorLogsCompanion toCompanion(bool nullToAbsent) {
    return ErrorLogsCompanion(
      id: Value(id),
      errorMessage: Value(errorMessage),
      stackTrace: Value(stackTrace),
      appVersion: Value(appVersion),
      currentRoute: Value(currentRoute),
      platform: Value(platform),
      createdAt: Value(createdAt),
    );
  }

  factory ErrorLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErrorLogRow(
      id: serializer.fromJson<int>(json['id']),
      errorMessage: serializer.fromJson<String>(json['errorMessage']),
      stackTrace: serializer.fromJson<String>(json['stackTrace']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      currentRoute: serializer.fromJson<String>(json['currentRoute']),
      platform: serializer.fromJson<String>(json['platform']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'errorMessage': serializer.toJson<String>(errorMessage),
      'stackTrace': serializer.toJson<String>(stackTrace),
      'appVersion': serializer.toJson<String>(appVersion),
      'currentRoute': serializer.toJson<String>(currentRoute),
      'platform': serializer.toJson<String>(platform),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ErrorLogRow copyWith({
    int? id,
    String? errorMessage,
    String? stackTrace,
    String? appVersion,
    String? currentRoute,
    String? platform,
    DateTime? createdAt,
  }) => ErrorLogRow(
    id: id ?? this.id,
    errorMessage: errorMessage ?? this.errorMessage,
    stackTrace: stackTrace ?? this.stackTrace,
    appVersion: appVersion ?? this.appVersion,
    currentRoute: currentRoute ?? this.currentRoute,
    platform: platform ?? this.platform,
    createdAt: createdAt ?? this.createdAt,
  );
  ErrorLogRow copyWithCompanion(ErrorLogsCompanion data) {
    return ErrorLogRow(
      id: data.id.present ? data.id.value : this.id,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      stackTrace: data.stackTrace.present
          ? data.stackTrace.value
          : this.stackTrace,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      currentRoute: data.currentRoute.present
          ? data.currentRoute.value
          : this.currentRoute,
      platform: data.platform.present ? data.platform.value : this.platform,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErrorLogRow(')
          ..write('id: $id, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('appVersion: $appVersion, ')
          ..write('currentRoute: $currentRoute, ')
          ..write('platform: $platform, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    errorMessage,
    stackTrace,
    appVersion,
    currentRoute,
    platform,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorLogRow &&
          other.id == this.id &&
          other.errorMessage == this.errorMessage &&
          other.stackTrace == this.stackTrace &&
          other.appVersion == this.appVersion &&
          other.currentRoute == this.currentRoute &&
          other.platform == this.platform &&
          other.createdAt == this.createdAt);
}

class ErrorLogsCompanion extends UpdateCompanion<ErrorLogRow> {
  final Value<int> id;
  final Value<String> errorMessage;
  final Value<String> stackTrace;
  final Value<String> appVersion;
  final Value<String> currentRoute;
  final Value<String> platform;
  final Value<DateTime> createdAt;
  const ErrorLogsCompanion({
    this.id = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.stackTrace = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.currentRoute = const Value.absent(),
    this.platform = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ErrorLogsCompanion.insert({
    this.id = const Value.absent(),
    required String errorMessage,
    this.stackTrace = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.currentRoute = const Value.absent(),
    this.platform = const Value.absent(),
    required DateTime createdAt,
  }) : errorMessage = Value(errorMessage),
       createdAt = Value(createdAt);
  static Insertable<ErrorLogRow> custom({
    Expression<int>? id,
    Expression<String>? errorMessage,
    Expression<String>? stackTrace,
    Expression<String>? appVersion,
    Expression<String>? currentRoute,
    Expression<String>? platform,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (errorMessage != null) 'error_message': errorMessage,
      if (stackTrace != null) 'stack_trace': stackTrace,
      if (appVersion != null) 'app_version': appVersion,
      if (currentRoute != null) 'current_route': currentRoute,
      if (platform != null) 'platform': platform,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ErrorLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? errorMessage,
    Value<String>? stackTrace,
    Value<String>? appVersion,
    Value<String>? currentRoute,
    Value<String>? platform,
    Value<DateTime>? createdAt,
  }) {
    return ErrorLogsCompanion(
      id: id ?? this.id,
      errorMessage: errorMessage ?? this.errorMessage,
      stackTrace: stackTrace ?? this.stackTrace,
      appVersion: appVersion ?? this.appVersion,
      currentRoute: currentRoute ?? this.currentRoute,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (stackTrace.present) {
      map['stack_trace'] = Variable<String>(stackTrace.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (currentRoute.present) {
      map['current_route'] = Variable<String>(currentRoute.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErrorLogsCompanion(')
          ..write('id: $id, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('appVersion: $appVersion, ')
          ..write('currentRoute: $currentRoute, ')
          ..write('platform: $platform, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomerProductPricesTable customerProductPrices =
      $CustomerProductPricesTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderLineItemsTable orderLineItems = $OrderLineItemsTable(this);
  late final $DeliveryPlansTable deliveryPlans = $DeliveryPlansTable(this);
  late final $DeliveryPlanItemsTable deliveryPlanItems =
      $DeliveryPlanItemsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ErrorLogsTable errorLogs = $ErrorLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    products,
    customerProductPrices,
    orders,
    orderLineItems,
    deliveryPlans,
    deliveryPlanItems,
    settings,
    errorLogs,
  ];
}

typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String name,
      Value<String> address,
      Value<String> notes,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> address,
      Value<String> notes,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerRow> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CustomerProductPricesTable,
    List<CustomerProductPriceRow>
  >
  _customerProductPricesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customerProductPrices,
        aliasName: $_aliasNameGenerator(
          db.customers.id,
          db.customerProductPrices.customerId,
        ),
      );

  $$CustomerProductPricesTableProcessedTableManager
  get customerProductPricesRefs {
    final manager = $$CustomerProductPricesTableTableManager(
      $_db,
      $_db.customerProductPrices,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customerProductPricesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<OrderRow>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.customers.id, db.orders.customerId),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customerProductPricesRefs(
    Expression<bool> Function($$CustomerProductPricesTableFilterComposer f) f,
  ) {
    final $$CustomerProductPricesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customerProductPrices,
          getReferencedColumn: (t) => t.customerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerProductPricesTableFilterComposer(
                $db: $db,
                $table: $db.customerProductPrices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
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
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
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

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> customerProductPricesRefs<T extends Object>(
    Expression<T> Function($$CustomerProductPricesTableAnnotationComposer a) f,
  ) {
    final $$CustomerProductPricesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customerProductPrices,
          getReferencedColumn: (t) => t.customerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerProductPricesTableAnnotationComposer(
                $db: $db,
                $table: $db.customerProductPrices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
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
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRow,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerRow, $$CustomersTableReferences),
          CustomerRow,
          PrefetchHooks Function({
            bool customerProductPricesRefs,
            bool ordersRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                address: address,
                notes: notes,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                address: address,
                notes: notes,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerProductPricesRefs = false, ordersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customerProductPricesRefs) db.customerProductPrices,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customerProductPricesRefs)
                        await $_getPrefetchedData<
                          CustomerRow,
                          $CustomersTable,
                          CustomerProductPriceRow
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._customerProductPricesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).customerProductPricesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          CustomerRow,
                          $CustomersTable,
                          OrderRow
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
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

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRow,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerRow, $$CustomersTableReferences),
      CustomerRow,
      PrefetchHooks Function({bool customerProductPricesRefs, bool ordersRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String label,
      Value<double?> referencePrice,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<double?> referencePrice,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductRow> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CustomerProductPricesTable,
    List<CustomerProductPriceRow>
  >
  _customerProductPricesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customerProductPrices,
        aliasName: $_aliasNameGenerator(
          db.products.id,
          db.customerProductPrices.productId,
        ),
      );

  $$CustomerProductPricesTableProcessedTableManager
  get customerProductPricesRefs {
    final manager = $$CustomerProductPricesTableTableManager(
      $_db,
      $_db.customerProductPrices,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customerProductPricesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderLineItemsTable, List<OrderLineItemRow>>
  _orderLineItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLineItems,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.orderLineItems.productId,
    ),
  );

  $$OrderLineItemsTableProcessedTableManager get orderLineItemsRefs {
    final manager = $$OrderLineItemsTableTableManager(
      $_db,
      $_db.orderLineItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLineItemsRefsTable($_db));
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get referencePrice => $composableBuilder(
    column: $table.referencePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customerProductPricesRefs(
    Expression<bool> Function($$CustomerProductPricesTableFilterComposer f) f,
  ) {
    final $$CustomerProductPricesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customerProductPrices,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerProductPricesTableFilterComposer(
                $db: $db,
                $table: $db.customerProductPrices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> orderLineItemsRefs(
    Expression<bool> Function($$OrderLineItemsTableFilterComposer f) f,
  ) {
    final $$OrderLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderLineItems,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get referencePrice => $composableBuilder(
    column: $table.referencePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get referencePrice => $composableBuilder(
    column: $table.referencePrice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> customerProductPricesRefs<T extends Object>(
    Expression<T> Function($$CustomerProductPricesTableAnnotationComposer a) f,
  ) {
    final $$CustomerProductPricesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customerProductPrices,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerProductPricesTableAnnotationComposer(
                $db: $db,
                $table: $db.customerProductPrices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> orderLineItemsRefs<T extends Object>(
    Expression<T> Function($$OrderLineItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderLineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLineItems,
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
            bool customerProductPricesRefs,
            bool orderLineItemsRefs,
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
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double?> referencePrice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                label: label,
                referencePrice: referencePrice,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<double?> referencePrice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                label: label,
                referencePrice: referencePrice,
                isActive: isActive,
                rowid: rowid,
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
                customerProductPricesRefs = false,
                orderLineItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customerProductPricesRefs) db.customerProductPrices,
                    if (orderLineItemsRefs) db.orderLineItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customerProductPricesRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          CustomerProductPriceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._customerProductPricesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).customerProductPricesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderLineItemsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          OrderLineItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderLineItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLineItemsRefs,
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
        bool customerProductPricesRefs,
        bool orderLineItemsRefs,
      })
    >;
typedef $$CustomerProductPricesTableCreateCompanionBuilder =
    CustomerProductPricesCompanion Function({
      required String id,
      required String customerId,
      required String productId,
      Value<bool> isNegotiated,
      Value<double?> overridePrice,
      Value<int> rowid,
    });
typedef $$CustomerProductPricesTableUpdateCompanionBuilder =
    CustomerProductPricesCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> productId,
      Value<bool> isNegotiated,
      Value<double?> overridePrice,
      Value<int> rowid,
    });

final class $$CustomerProductPricesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomerProductPricesTable,
          CustomerProductPriceRow
        > {
  $$CustomerProductPricesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(
          db.customerProductPrices.customerId,
          db.customers.id,
        ),
      );

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(
          db.customerProductPrices.productId,
          db.products.id,
        ),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

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

class $$CustomerProductPricesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerProductPricesTable> {
  $$CustomerProductPricesTableFilterComposer({
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

  ColumnFilters<bool> get isNegotiated => $composableBuilder(
    column: $table.isNegotiated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overridePrice => $composableBuilder(
    column: $table.overridePrice,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
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

class $$CustomerProductPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerProductPricesTable> {
  $$CustomerProductPricesTableOrderingComposer({
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

  ColumnOrderings<bool> get isNegotiated => $composableBuilder(
    column: $table.isNegotiated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overridePrice => $composableBuilder(
    column: $table.overridePrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
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

class $$CustomerProductPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerProductPricesTable> {
  $$CustomerProductPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isNegotiated => $composableBuilder(
    column: $table.isNegotiated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overridePrice => $composableBuilder(
    column: $table.overridePrice,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
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

class $$CustomerProductPricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomerProductPricesTable,
          CustomerProductPriceRow,
          $$CustomerProductPricesTableFilterComposer,
          $$CustomerProductPricesTableOrderingComposer,
          $$CustomerProductPricesTableAnnotationComposer,
          $$CustomerProductPricesTableCreateCompanionBuilder,
          $$CustomerProductPricesTableUpdateCompanionBuilder,
          (CustomerProductPriceRow, $$CustomerProductPricesTableReferences),
          CustomerProductPriceRow,
          PrefetchHooks Function({bool customerId, bool productId})
        > {
  $$CustomerProductPricesTableTableManager(
    _$AppDatabase db,
    $CustomerProductPricesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerProductPricesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CustomerProductPricesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CustomerProductPricesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<bool> isNegotiated = const Value.absent(),
                Value<double?> overridePrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerProductPricesCompanion(
                id: id,
                customerId: customerId,
                productId: productId,
                isNegotiated: isNegotiated,
                overridePrice: overridePrice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String productId,
                Value<bool> isNegotiated = const Value.absent(),
                Value<double?> overridePrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerProductPricesCompanion.insert(
                id: id,
                customerId: customerId,
                productId: productId,
                isNegotiated: isNegotiated,
                overridePrice: overridePrice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomerProductPricesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customerId = false, productId = false}) {
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
                    if (customerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.customerId,
                                referencedTable:
                                    $$CustomerProductPricesTableReferences
                                        ._customerIdTable(db),
                                referencedColumn:
                                    $$CustomerProductPricesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$CustomerProductPricesTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$CustomerProductPricesTableReferences
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

typedef $$CustomerProductPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomerProductPricesTable,
      CustomerProductPriceRow,
      $$CustomerProductPricesTableFilterComposer,
      $$CustomerProductPricesTableOrderingComposer,
      $$CustomerProductPricesTableAnnotationComposer,
      $$CustomerProductPricesTableCreateCompanionBuilder,
      $$CustomerProductPricesTableUpdateCompanionBuilder,
      (CustomerProductPriceRow, $$CustomerProductPricesTableReferences),
      CustomerProductPriceRow,
      PrefetchHooks Function({bool customerId, bool productId})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      required String id,
      required String customerId,
      Value<bool> isDelivered,
      Value<bool> isPaid,
      required DateTime orderDate,
      Value<DateTime?> deliveredDate,
      Value<DateTime?> paidDate,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<bool> isDelivered,
      Value<bool> isPaid,
      Value<DateTime> orderDate,
      Value<DateTime?> deliveredDate,
      Value<DateTime?> paidDate,
      Value<String> note,
      Value<int> rowid,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, OrderRow> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias($_aliasNameGenerator(db.orders.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderLineItemsTable, List<OrderLineItemRow>>
  _orderLineItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLineItems,
    aliasName: $_aliasNameGenerator(db.orders.id, db.orderLineItems.orderId),
  );

  $$OrderLineItemsTableProcessedTableManager get orderLineItemsRefs {
    final manager = $$OrderLineItemsTableTableManager(
      $_db,
      $_db.orderLineItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLineItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeliveryPlanItemsTable, List<DeliveryPlanItemRow>>
  _deliveryPlanItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.deliveryPlanItems,
        aliasName: $_aliasNameGenerator(
          db.orders.id,
          db.deliveryPlanItems.orderId,
        ),
      );

  $$DeliveryPlanItemsTableProcessedTableManager get deliveryPlanItemsRefs {
    final manager = $$DeliveryPlanItemsTableTableManager(
      $_db,
      $_db.deliveryPlanItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deliveryPlanItemsRefsTable($_db),
    );
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDelivered => $composableBuilder(
    column: $table.isDelivered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredDate => $composableBuilder(
    column: $table.deliveredDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderLineItemsRefs(
    Expression<bool> Function($$OrderLineItemsTableFilterComposer f) f,
  ) {
    final $$OrderLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deliveryPlanItemsRefs(
    Expression<bool> Function($$DeliveryPlanItemsTableFilterComposer f) f,
  ) {
    final $$DeliveryPlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deliveryPlanItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryPlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.deliveryPlanItems,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDelivered => $composableBuilder(
    column: $table.isDelivered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredDate => $composableBuilder(
    column: $table.deliveredDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isDelivered => $composableBuilder(
    column: $table.isDelivered,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get orderDate =>
      $composableBuilder(column: $table.orderDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredDate => $composableBuilder(
    column: $table.deliveredDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderLineItemsRefs<T extends Object>(
    Expression<T> Function($$OrderLineItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderLineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deliveryPlanItemsRefs<T extends Object>(
    Expression<T> Function($$DeliveryPlanItemsTableAnnotationComposer a) f,
  ) {
    final $$DeliveryPlanItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.deliveryPlanItems,
          getReferencedColumn: (t) => t.orderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DeliveryPlanItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.deliveryPlanItems,
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
          PrefetchHooks Function({
            bool customerId,
            bool orderLineItemsRefs,
            bool deliveryPlanItemsRefs,
          })
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
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<bool> isDelivered = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<DateTime> orderDate = const Value.absent(),
                Value<DateTime?> deliveredDate = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                customerId: customerId,
                isDelivered: isDelivered,
                isPaid: isPaid,
                orderDate: orderDate,
                deliveredDate: deliveredDate,
                paidDate: paidDate,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                Value<bool> isDelivered = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                required DateTime orderDate,
                Value<DateTime?> deliveredDate = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                customerId: customerId,
                isDelivered: isDelivered,
                isPaid: isPaid,
                orderDate: orderDate,
                deliveredDate: deliveredDate,
                paidDate: paidDate,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                orderLineItemsRefs = false,
                deliveryPlanItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderLineItemsRefs) db.orderLineItems,
                    if (deliveryPlanItemsRefs) db.deliveryPlanItems,
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
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$OrdersTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderLineItemsRefs)
                        await $_getPrefetchedData<
                          OrderRow,
                          $OrdersTable,
                          OrderLineItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderLineItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLineItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deliveryPlanItemsRefs)
                        await $_getPrefetchedData<
                          OrderRow,
                          $OrdersTable,
                          DeliveryPlanItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._deliveryPlanItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).deliveryPlanItemsRefs,
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
      PrefetchHooks Function({
        bool customerId,
        bool orderLineItemsRefs,
        bool deliveryPlanItemsRefs,
      })
    >;
typedef $$OrderLineItemsTableCreateCompanionBuilder =
    OrderLineItemsCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required String productLabel,
      Value<int> quantity,
      Value<double> unitPrice,
      Value<int> rowid,
    });
typedef $$OrderLineItemsTableUpdateCompanionBuilder =
    OrderLineItemsCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<String> productLabel,
      Value<int> quantity,
      Value<double> unitPrice,
      Value<int> rowid,
    });

final class $$OrderLineItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OrderLineItemsTable, OrderLineItemRow> {
  $$OrderLineItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderLineItems.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

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
      db.products.createAlias(
        $_aliasNameGenerator(db.orderLineItems.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

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

class $$OrderLineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderLineItemsTable> {
  $$OrderLineItemsTableFilterComposer({
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

  ColumnFilters<String> get productLabel => $composableBuilder(
    column: $table.productLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
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

class $$OrderLineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderLineItemsTable> {
  $$OrderLineItemsTableOrderingComposer({
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

  ColumnOrderings<String> get productLabel => $composableBuilder(
    column: $table.productLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
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

class $$OrderLineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderLineItemsTable> {
  $$OrderLineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productLabel => $composableBuilder(
    column: $table.productLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

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

class $$OrderLineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderLineItemsTable,
          OrderLineItemRow,
          $$OrderLineItemsTableFilterComposer,
          $$OrderLineItemsTableOrderingComposer,
          $$OrderLineItemsTableAnnotationComposer,
          $$OrderLineItemsTableCreateCompanionBuilder,
          $$OrderLineItemsTableUpdateCompanionBuilder,
          (OrderLineItemRow, $$OrderLineItemsTableReferences),
          OrderLineItemRow,
          PrefetchHooks Function({bool orderId, bool productId})
        > {
  $$OrderLineItemsTableTableManager(
    _$AppDatabase db,
    $OrderLineItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderLineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderLineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderLineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productLabel = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLineItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                productLabel: productLabel,
                quantity: quantity,
                unitPrice: unitPrice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required String productLabel,
                Value<int> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLineItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                productLabel: productLabel,
                quantity: quantity,
                unitPrice: unitPrice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderLineItemsTableReferences(db, table, e),
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
                                referencedTable: $$OrderLineItemsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn:
                                    $$OrderLineItemsTableReferences
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
                                referencedTable: $$OrderLineItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$OrderLineItemsTableReferences
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

typedef $$OrderLineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderLineItemsTable,
      OrderLineItemRow,
      $$OrderLineItemsTableFilterComposer,
      $$OrderLineItemsTableOrderingComposer,
      $$OrderLineItemsTableAnnotationComposer,
      $$OrderLineItemsTableCreateCompanionBuilder,
      $$OrderLineItemsTableUpdateCompanionBuilder,
      (OrderLineItemRow, $$OrderLineItemsTableReferences),
      OrderLineItemRow,
      PrefetchHooks Function({bool orderId, bool productId})
    >;
typedef $$DeliveryPlansTableCreateCompanionBuilder =
    DeliveryPlansCompanion Function({
      required String id,
      Value<String> name,
      required DateTime createdAt,
      Value<DateTime?> deliveryDate,
      Value<bool> isFinished,
      Value<int> rowid,
    });
typedef $$DeliveryPlansTableUpdateCompanionBuilder =
    DeliveryPlansCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime?> deliveryDate,
      Value<bool> isFinished,
      Value<int> rowid,
    });

final class $$DeliveryPlansTableReferences
    extends
        BaseReferences<_$AppDatabase, $DeliveryPlansTable, DeliveryPlanRow> {
  $$DeliveryPlansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DeliveryPlanItemsTable, List<DeliveryPlanItemRow>>
  _deliveryPlanItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.deliveryPlanItems,
        aliasName: $_aliasNameGenerator(
          db.deliveryPlans.id,
          db.deliveryPlanItems.deliveryPlanId,
        ),
      );

  $$DeliveryPlanItemsTableProcessedTableManager get deliveryPlanItemsRefs {
    final manager = $$DeliveryPlanItemsTableTableManager(
      $_db,
      $_db.deliveryPlanItems,
    ).filter((f) => f.deliveryPlanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deliveryPlanItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeliveryPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveryPlansTable> {
  $$DeliveryPlansTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> deliveryPlanItemsRefs(
    Expression<bool> Function($$DeliveryPlanItemsTableFilterComposer f) f,
  ) {
    final $$DeliveryPlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deliveryPlanItems,
      getReferencedColumn: (t) => t.deliveryPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryPlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.deliveryPlanItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeliveryPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveryPlansTable> {
  $$DeliveryPlansTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeliveryPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveryPlansTable> {
  $$DeliveryPlansTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  Expression<T> deliveryPlanItemsRefs<T extends Object>(
    Expression<T> Function($$DeliveryPlanItemsTableAnnotationComposer a) f,
  ) {
    final $$DeliveryPlanItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.deliveryPlanItems,
          getReferencedColumn: (t) => t.deliveryPlanId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DeliveryPlanItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.deliveryPlanItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DeliveryPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeliveryPlansTable,
          DeliveryPlanRow,
          $$DeliveryPlansTableFilterComposer,
          $$DeliveryPlansTableOrderingComposer,
          $$DeliveryPlansTableAnnotationComposer,
          $$DeliveryPlansTableCreateCompanionBuilder,
          $$DeliveryPlansTableUpdateCompanionBuilder,
          (DeliveryPlanRow, $$DeliveryPlansTableReferences),
          DeliveryPlanRow,
          PrefetchHooks Function({bool deliveryPlanItemsRefs})
        > {
  $$DeliveryPlansTableTableManager(_$AppDatabase db, $DeliveryPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveryPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveryPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveryPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryPlansCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                deliveryDate: deliveryDate,
                isFinished: isFinished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryPlansCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                deliveryDate: deliveryDate,
                isFinished: isFinished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeliveryPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deliveryPlanItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (deliveryPlanItemsRefs) db.deliveryPlanItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (deliveryPlanItemsRefs)
                    await $_getPrefetchedData<
                      DeliveryPlanRow,
                      $DeliveryPlansTable,
                      DeliveryPlanItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$DeliveryPlansTableReferences
                          ._deliveryPlanItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DeliveryPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).deliveryPlanItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.deliveryPlanId == item.id,
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

typedef $$DeliveryPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeliveryPlansTable,
      DeliveryPlanRow,
      $$DeliveryPlansTableFilterComposer,
      $$DeliveryPlansTableOrderingComposer,
      $$DeliveryPlansTableAnnotationComposer,
      $$DeliveryPlansTableCreateCompanionBuilder,
      $$DeliveryPlansTableUpdateCompanionBuilder,
      (DeliveryPlanRow, $$DeliveryPlansTableReferences),
      DeliveryPlanRow,
      PrefetchHooks Function({bool deliveryPlanItemsRefs})
    >;
typedef $$DeliveryPlanItemsTableCreateCompanionBuilder =
    DeliveryPlanItemsCompanion Function({
      required String id,
      required String deliveryPlanId,
      required String orderId,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DeliveryPlanItemsTableUpdateCompanionBuilder =
    DeliveryPlanItemsCompanion Function({
      Value<String> id,
      Value<String> deliveryPlanId,
      Value<String> orderId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$DeliveryPlanItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DeliveryPlanItemsTable,
          DeliveryPlanItemRow
        > {
  $$DeliveryPlanItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DeliveryPlansTable _deliveryPlanIdTable(_$AppDatabase db) =>
      db.deliveryPlans.createAlias(
        $_aliasNameGenerator(
          db.deliveryPlanItems.deliveryPlanId,
          db.deliveryPlans.id,
        ),
      );

  $$DeliveryPlansTableProcessedTableManager get deliveryPlanId {
    final $_column = $_itemColumn<String>('delivery_plan_id')!;

    final manager = $$DeliveryPlansTableTableManager(
      $_db,
      $_db.deliveryPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deliveryPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.deliveryPlanItems.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

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
}

class $$DeliveryPlanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveryPlanItemsTable> {
  $$DeliveryPlanItemsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$DeliveryPlansTableFilterComposer get deliveryPlanId {
    final $$DeliveryPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deliveryPlanId,
      referencedTable: $db.deliveryPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryPlansTableFilterComposer(
            $db: $db,
            $table: $db.deliveryPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$DeliveryPlanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveryPlanItemsTable> {
  $$DeliveryPlanItemsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeliveryPlansTableOrderingComposer get deliveryPlanId {
    final $$DeliveryPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deliveryPlanId,
      referencedTable: $db.deliveryPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryPlansTableOrderingComposer(
            $db: $db,
            $table: $db.deliveryPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$DeliveryPlanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveryPlanItemsTable> {
  $$DeliveryPlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$DeliveryPlansTableAnnotationComposer get deliveryPlanId {
    final $$DeliveryPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deliveryPlanId,
      referencedTable: $db.deliveryPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveryPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.deliveryPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$DeliveryPlanItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeliveryPlanItemsTable,
          DeliveryPlanItemRow,
          $$DeliveryPlanItemsTableFilterComposer,
          $$DeliveryPlanItemsTableOrderingComposer,
          $$DeliveryPlanItemsTableAnnotationComposer,
          $$DeliveryPlanItemsTableCreateCompanionBuilder,
          $$DeliveryPlanItemsTableUpdateCompanionBuilder,
          (DeliveryPlanItemRow, $$DeliveryPlanItemsTableReferences),
          DeliveryPlanItemRow,
          PrefetchHooks Function({bool deliveryPlanId, bool orderId})
        > {
  $$DeliveryPlanItemsTableTableManager(
    _$AppDatabase db,
    $DeliveryPlanItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveryPlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveryPlanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveryPlanItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deliveryPlanId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryPlanItemsCompanion(
                id: id,
                deliveryPlanId: deliveryPlanId,
                orderId: orderId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deliveryPlanId,
                required String orderId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryPlanItemsCompanion.insert(
                id: id,
                deliveryPlanId: deliveryPlanId,
                orderId: orderId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeliveryPlanItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deliveryPlanId = false, orderId = false}) {
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
                    if (deliveryPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deliveryPlanId,
                                referencedTable:
                                    $$DeliveryPlanItemsTableReferences
                                        ._deliveryPlanIdTable(db),
                                referencedColumn:
                                    $$DeliveryPlanItemsTableReferences
                                        ._deliveryPlanIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable:
                                    $$DeliveryPlanItemsTableReferences
                                        ._orderIdTable(db),
                                referencedColumn:
                                    $$DeliveryPlanItemsTableReferences
                                        ._orderIdTable(db)
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

typedef $$DeliveryPlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeliveryPlanItemsTable,
      DeliveryPlanItemRow,
      $$DeliveryPlanItemsTableFilterComposer,
      $$DeliveryPlanItemsTableOrderingComposer,
      $$DeliveryPlanItemsTableAnnotationComposer,
      $$DeliveryPlanItemsTableCreateCompanionBuilder,
      $$DeliveryPlanItemsTableUpdateCompanionBuilder,
      (DeliveryPlanItemRow, $$DeliveryPlanItemsTableReferences),
      DeliveryPlanItemRow,
      PrefetchHooks Function({bool deliveryPlanId, bool orderId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> warnOnDelete,
      Value<bool> warnOnUndeliver,
      Value<bool> warnOnUnpaid,
      Value<bool> warnOnPlanDeliver,
      Value<bool> warnOnPlanRemove,
      Value<bool> darkMode,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> warnOnDelete,
      Value<bool> warnOnUndeliver,
      Value<bool> warnOnUnpaid,
      Value<bool> warnOnPlanDeliver,
      Value<bool> warnOnPlanRemove,
      Value<bool> darkMode,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnFilters<bool> get warnOnDelete => $composableBuilder(
    column: $table.warnOnDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warnOnUndeliver => $composableBuilder(
    column: $table.warnOnUndeliver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warnOnUnpaid => $composableBuilder(
    column: $table.warnOnUnpaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warnOnPlanDeliver => $composableBuilder(
    column: $table.warnOnPlanDeliver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warnOnPlanRemove => $composableBuilder(
    column: $table.warnOnPlanRemove,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get warnOnDelete => $composableBuilder(
    column: $table.warnOnDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warnOnUndeliver => $composableBuilder(
    column: $table.warnOnUndeliver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warnOnUnpaid => $composableBuilder(
    column: $table.warnOnUnpaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warnOnPlanDeliver => $composableBuilder(
    column: $table.warnOnPlanDeliver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warnOnPlanRemove => $composableBuilder(
    column: $table.warnOnPlanRemove,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get warnOnDelete => $composableBuilder(
    column: $table.warnOnDelete,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warnOnUndeliver => $composableBuilder(
    column: $table.warnOnUndeliver,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warnOnUnpaid => $composableBuilder(
    column: $table.warnOnUnpaid,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warnOnPlanDeliver => $composableBuilder(
    column: $table.warnOnPlanDeliver,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warnOnPlanRemove => $composableBuilder(
    column: $table.warnOnPlanRemove,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> warnOnDelete = const Value.absent(),
                Value<bool> warnOnUndeliver = const Value.absent(),
                Value<bool> warnOnUnpaid = const Value.absent(),
                Value<bool> warnOnPlanDeliver = const Value.absent(),
                Value<bool> warnOnPlanRemove = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                warnOnDelete: warnOnDelete,
                warnOnUndeliver: warnOnUndeliver,
                warnOnUnpaid: warnOnUnpaid,
                warnOnPlanDeliver: warnOnPlanDeliver,
                warnOnPlanRemove: warnOnPlanRemove,
                darkMode: darkMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> warnOnDelete = const Value.absent(),
                Value<bool> warnOnUndeliver = const Value.absent(),
                Value<bool> warnOnUnpaid = const Value.absent(),
                Value<bool> warnOnPlanDeliver = const Value.absent(),
                Value<bool> warnOnPlanRemove = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                warnOnDelete: warnOnDelete,
                warnOnUndeliver: warnOnUndeliver,
                warnOnUnpaid: warnOnUnpaid,
                warnOnPlanDeliver: warnOnPlanDeliver,
                warnOnPlanRemove: warnOnPlanRemove,
                darkMode: darkMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$ErrorLogsTableCreateCompanionBuilder =
    ErrorLogsCompanion Function({
      Value<int> id,
      required String errorMessage,
      Value<String> stackTrace,
      Value<String> appVersion,
      Value<String> currentRoute,
      Value<String> platform,
      required DateTime createdAt,
    });
typedef $$ErrorLogsTableUpdateCompanionBuilder =
    ErrorLogsCompanion Function({
      Value<int> id,
      Value<String> errorMessage,
      Value<String> stackTrace,
      Value<String> appVersion,
      Value<String> currentRoute,
      Value<String> platform,
      Value<DateTime> createdAt,
    });

class $$ErrorLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ErrorLogsTable> {
  $$ErrorLogsTableFilterComposer({
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

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentRoute => $composableBuilder(
    column: $table.currentRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ErrorLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ErrorLogsTable> {
  $$ErrorLogsTableOrderingComposer({
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

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentRoute => $composableBuilder(
    column: $table.currentRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ErrorLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ErrorLogsTable> {
  $$ErrorLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentRoute => $composableBuilder(
    column: $table.currentRoute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ErrorLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ErrorLogsTable,
          ErrorLogRow,
          $$ErrorLogsTableFilterComposer,
          $$ErrorLogsTableOrderingComposer,
          $$ErrorLogsTableAnnotationComposer,
          $$ErrorLogsTableCreateCompanionBuilder,
          $$ErrorLogsTableUpdateCompanionBuilder,
          (
            ErrorLogRow,
            BaseReferences<_$AppDatabase, $ErrorLogsTable, ErrorLogRow>,
          ),
          ErrorLogRow,
          PrefetchHooks Function()
        > {
  $$ErrorLogsTableTableManager(_$AppDatabase db, $ErrorLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ErrorLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ErrorLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ErrorLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> errorMessage = const Value.absent(),
                Value<String> stackTrace = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> currentRoute = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ErrorLogsCompanion(
                id: id,
                errorMessage: errorMessage,
                stackTrace: stackTrace,
                appVersion: appVersion,
                currentRoute: currentRoute,
                platform: platform,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String errorMessage,
                Value<String> stackTrace = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> currentRoute = const Value.absent(),
                Value<String> platform = const Value.absent(),
                required DateTime createdAt,
              }) => ErrorLogsCompanion.insert(
                id: id,
                errorMessage: errorMessage,
                stackTrace: stackTrace,
                appVersion: appVersion,
                currentRoute: currentRoute,
                platform: platform,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ErrorLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ErrorLogsTable,
      ErrorLogRow,
      $$ErrorLogsTableFilterComposer,
      $$ErrorLogsTableOrderingComposer,
      $$ErrorLogsTableAnnotationComposer,
      $$ErrorLogsTableCreateCompanionBuilder,
      $$ErrorLogsTableUpdateCompanionBuilder,
      (
        ErrorLogRow,
        BaseReferences<_$AppDatabase, $ErrorLogsTable, ErrorLogRow>,
      ),
      ErrorLogRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomerProductPricesTableTableManager get customerProductPrices =>
      $$CustomerProductPricesTableTableManager(_db, _db.customerProductPrices);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderLineItemsTableTableManager get orderLineItems =>
      $$OrderLineItemsTableTableManager(_db, _db.orderLineItems);
  $$DeliveryPlansTableTableManager get deliveryPlans =>
      $$DeliveryPlansTableTableManager(_db, _db.deliveryPlans);
  $$DeliveryPlanItemsTableTableManager get deliveryPlanItems =>
      $$DeliveryPlanItemsTableTableManager(_db, _db.deliveryPlanItems);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ErrorLogsTableTableManager get errorLogs =>
      $$ErrorLogsTableTableManager(_db, _db.errorLogs);
}
