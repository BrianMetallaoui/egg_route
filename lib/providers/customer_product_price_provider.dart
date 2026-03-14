import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/customer_product_price.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';

class CustomerProductPriceNotifier
    extends FamilyNotifier<List<CustomerProductPrice>, String> {
  @override
  List<CustomerProductPrice> build(String arg) {
    final db = ref.watch(databaseProvider);
    final sub = db.customerProductPriceRepo
        .watchByCustomerId(arg)
        .listen(
          (data) => state = data,
          onError: (Object e, StackTrace st) =>
              ErrorLogService.logError(db, e, st),
        );
    ref.onDispose(sub.cancel);
    return [];
  }

  Future<void> add(CustomerProductPrice cpp) async {
    final db = ref.read(databaseProvider);
    await db.customerProductPriceRepo.insert(cpp);
  }

  Future<void> update(CustomerProductPrice cpp) async {
    final db = ref.read(databaseProvider);
    await db.customerProductPriceRepo.updatePrice(cpp);
  }

  Future<void> delete(String id) async {
    final db = ref.read(databaseProvider);
    await db.customerProductPriceRepo.deletePrice(id);
  }
}

final customerProductPriceProvider =
    NotifierProvider.family<
      CustomerProductPriceNotifier,
      List<CustomerProductPrice>,
      String
    >(CustomerProductPriceNotifier.new);

/// Map of productId → CustomerProductPrice for fast lookup in the order form.
final customerPriceMapProvider =
    Provider.family<Map<String, CustomerProductPrice>, String?>((
      ref,
      customerId,
    ) {
      if (customerId == null) return {};
      final prices = ref.watch(customerProductPriceProvider(customerId));
      return {for (final cpp in prices) cpp.productId: cpp};
    });
