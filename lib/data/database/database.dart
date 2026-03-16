import 'package:drift/drift.dart';

import 'tables.dart';
import '../repositories/customer_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/delivery_plan_repository.dart';
import '../repositories/customer_product_price_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/error_log_repository.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Customers,
    Products,
    CustomerProductPrices,
    Orders,
    OrderLineItems,
    DeliveryPlans,
    DeliveryPlanItems,
    Settings,
    ErrorLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Insert default settings row
      await into(settings).insert(SettingsCompanion.insert(id: Value(1)));
    },
    onUpgrade: (m, from, to) async {
      // Destructive migration for development — recreate all tables
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
      await into(settings).insert(SettingsCompanion.insert(id: Value(1)));
    },
  );

  late final customerRepo = CustomerRepository(this);
  late final productRepo = ProductRepository(this);
  late final customerProductPriceRepo = CustomerProductPriceRepository(this);
  late final orderRepo = OrderRepository(this);
  late final deliveryPlanRepo = DeliveryPlanRepository(this);
  late final settingsRepo = SettingsRepository(this);
  late final errorLogRepo = ErrorLogRepository(this);
}
