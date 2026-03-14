import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/order.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';
import 'notifier_helpers.dart';

class OrderNotifier extends Notifier<List<Order>> with DbCallMixin {
  @override
  List<Order> build() {
    final db = ref.watch(databaseProvider);
    final sub = db.orderRepo.watchAll().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return List.from(ref.read(initialOrdersProvider));
  }

  Future<void> add(Order order) async {
    await dbCall((db) => db.orderRepo.insert(order));
  }

  Future<void> update(Order order) async {
    await dbCall((db) => db.orderRepo.updateOrder(order));
  }

  Future<void> delete(String id) async {
    await dbCall((db) => db.orderRepo.deleteOrder(id));
  }

  Future<void> deleteFinished() async {
    await dbCall((db) async {
      final all = await db.orderRepo.getAll();
      for (final order in all.where((o) => o.isFinished)) {
        await db.orderRepo.deleteOrder(order.id);
      }
    });
  }

  Future<void> markDelivered(
    String id,
    bool isDelivered, {
    DateTime? deliveredDate,
  }) async {
    await dbCall(
      (db) => db.orderRepo.markDelivered(
        id,
        isDelivered,
        deliveredDate: deliveredDate,
      ),
    );
  }

  Future<void> markPaid(String id, bool isPaid, {DateTime? paidDate}) async {
    await dbCall((db) => db.orderRepo.markPaid(id, isPaid, paidDate: paidDate));
  }
}

final orderProvider = NotifierProvider<OrderNotifier, List<Order>>(
  OrderNotifier.new,
);

final orderByIdProvider = Provider.family<Order?, String>((ref, id) {
  final orders = ref.watch(orderProvider);
  return orders.where((o) => o.id == id).firstOrNull;
});
