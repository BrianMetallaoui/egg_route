import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/database.dart';
import '../data/models/customer.dart';
import '../data/models/delivery_plan.dart';
import '../data/models/order.dart';
import '../data/models/product.dart';
import '../data/repositories/settings_repository.dart';

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(),
);

final initialSettingsProvider = Provider<SettingsState>(
  (ref) => throw UnimplementedError(),
);

final initialCustomersProvider = Provider<List<Customer>>(
  (ref) => throw UnimplementedError(),
);

final initialProductsProvider = Provider<List<Product>>(
  (ref) => throw UnimplementedError(),
);

final initialOrdersProvider = Provider<List<Order>>(
  (ref) => throw UnimplementedError(),
);

final initialDeliveryPlansProvider = Provider<List<DeliveryPlan>>(
  (ref) => throw UnimplementedError(),
);
