import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/customer.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';
import 'notifier_helpers.dart';

class CustomerNotifier extends Notifier<List<Customer>> with DbCallMixin {
  @override
  List<Customer> build() {
    final db = ref.watch(databaseProvider);
    final sub = db.customerRepo.watchAll().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return List.from(ref.read(initialCustomersProvider));
  }

  Future<void> add(Customer customer) async {
    await dbCall((db) => db.customerRepo.insert(customer));
  }

  Future<void> update(Customer customer) async {
    await dbCall((db) => db.customerRepo.updateCustomer(customer));
  }

  Future<void> delete(String id) async {
    await dbCall((db) async {
      await db.customerProductPriceRepo.deleteByCustomerId(id);
      await db.customerRepo.deleteCustomer(id);
    });
  }
}

final customerProvider = NotifierProvider<CustomerNotifier, List<Customer>>(
  CustomerNotifier.new,
);

final customerByIdProvider = Provider.family<Customer?, String>((ref, id) {
  final customers = ref.watch(customerProvider);
  return customers.where((c) => c.id == id).firstOrNull;
});
