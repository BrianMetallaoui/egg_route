import 'package:drift/drift.dart';

@DataClassName('CustomerRow')
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  RealColumn get referencePrice => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderRow')
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  BoolColumn get isDelivered => boolean().withDefault(const Constant(false))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get orderDate => dateTime()();
  DateTimeColumn get deliveredDate => dateTime().nullable()();
  DateTimeColumn get paidDate => dateTime().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderLineItemRow')
class OrderLineItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get productLabel => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomerProductPriceRow')
class CustomerProductPrices extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get productId => text().references(Products, #id)();
  BoolColumn get isNegotiated => boolean().withDefault(const Constant(false))();
  RealColumn get overridePrice => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {customerId, productId},
  ];
}

@DataClassName('DeliveryPlanRow')
class DeliveryPlans extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deliveryDate => dateTime().nullable()();
  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeliveryPlanItemRow')
class DeliveryPlanItems extends Table {
  TextColumn get id => text()();
  TextColumn get deliveryPlanId => text().references(DeliveryPlans, #id)();
  TextColumn get orderId => text().references(Orders, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SettingRow')
class Settings extends Table {
  IntColumn get id => integer()();
  BoolColumn get warnOnDelete => boolean().withDefault(const Constant(true))();
  BoolColumn get warnOnUndeliver =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get warnOnUnpaid => boolean().withDefault(const Constant(true))();
  BoolColumn get warnOnPlanDeliver =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get warnOnPlanRemove =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ErrorLogRow')
class ErrorLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get errorMessage => text()();
  TextColumn get stackTrace => text().withDefault(const Constant(''))();
  TextColumn get appVersion => text().withDefault(const Constant(''))();
  TextColumn get currentRoute => text().withDefault(const Constant(''))();
  TextColumn get platform => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
}
