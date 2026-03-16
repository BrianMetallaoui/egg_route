import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/delivery_plan.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';
import 'notifier_helpers.dart';

class DeliveryPlanNotifier extends Notifier<List<DeliveryPlan>>
    with DbCallMixin {
  @override
  List<DeliveryPlan> build() {
    final db = ref.watch(databaseProvider);
    final sub = db.deliveryPlanRepo.watchAll().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return List.from(ref.read(initialDeliveryPlansProvider));
  }

  Future<void> add(DeliveryPlan plan) async {
    await dbCall((db) => db.deliveryPlanRepo.insert(plan));
  }

  Future<void> update(DeliveryPlan plan) async {
    await dbCall((db) => db.deliveryPlanRepo.updatePlan(plan));
  }

  Future<void> delete(String id) async {
    await dbCall((db) => db.deliveryPlanRepo.deletePlan(id));
  }

  /// Mark all orders in a plan as delivered.
  Future<void> markAllDelivered(String planId) async {
    await dbCall((db) async {
      final plan = await db.deliveryPlanRepo.getById(planId);
      if (plan == null) return;
      for (final item in plan.items) {
        if (!item.order.isDelivered) {
          await db.orderRepo.markDelivered(item.orderId, true);
        }
      }
    });
  }

}

final deliveryPlanProvider =
    NotifierProvider<DeliveryPlanNotifier, List<DeliveryPlan>>(
      DeliveryPlanNotifier.new,
    );

final deliveryPlanByIdProvider = Provider.family<DeliveryPlan?, String>((
  ref,
  id,
) {
  final plans = ref.watch(deliveryPlanProvider);
  return plans.where((p) => p.id == id).firstOrNull;
});
