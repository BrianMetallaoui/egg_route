import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/delivery_plan.dart';
import '../models/delivery_plan_item.dart';
import '../models/order.dart' as model;

class DeliveryPlanRepository {
  final AppDatabase _db;
  DeliveryPlanRepository(this._db);

  Future<List<DeliveryPlan>> getAll() async {
    final planRows = await _db.select(_db.deliveryPlans).get();
    return Future.wait(planRows.map(_buildPlan));
  }

  Stream<List<DeliveryPlan>> watchAll() {
    return _db
        .select(_db.deliveryPlans)
        .watch()
        .asyncMap((planRows) => Future.wait(planRows.map(_buildPlan)));
  }

  Future<DeliveryPlan?> getById(String id) async {
    final row = await (_db.select(
      _db.deliveryPlans,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _buildPlan(row);
  }

  Future<void> insert(DeliveryPlan plan) async {
    await _db.transaction(() async {
      await _db
          .into(_db.deliveryPlans)
          .insert(
            DeliveryPlansCompanion.insert(
              id: plan.id,
              name: Value(plan.name),
              createdAt: plan.createdAt,
              deliveryDate: Value(plan.deliveryDate),
              isFinished: Value(plan.isFinished),
            ),
          );
      for (final item in plan.items) {
        await _db
            .into(_db.deliveryPlanItems)
            .insert(
              DeliveryPlanItemsCompanion.insert(
                id: item.id,
                deliveryPlanId: plan.id,
                orderId: item.orderId,
                sortOrder: Value(item.sortOrder),
              ),
            );
      }
    });
  }

  Future<void> updatePlan(DeliveryPlan plan) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.deliveryPlans,
      )..where((t) => t.id.equals(plan.id))).write(
        DeliveryPlansCompanion(
          name: Value(plan.name),
          deliveryDate: Value(plan.deliveryDate),
          isFinished: Value(plan.isFinished),
        ),
      );

      // Replace all items
      await (_db.delete(
        _db.deliveryPlanItems,
      )..where((t) => t.deliveryPlanId.equals(plan.id))).go();
      for (final item in plan.items) {
        await _db
            .into(_db.deliveryPlanItems)
            .insert(
              DeliveryPlanItemsCompanion.insert(
                id: item.id,
                deliveryPlanId: plan.id,
                orderId: item.orderId,
                sortOrder: Value(item.sortOrder),
              ),
            );
      }
    });
  }

  Future<void> deletePlan(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.deliveryPlanItems,
      )..where((t) => t.deliveryPlanId.equals(id))).go();
      await (_db.delete(_db.deliveryPlans)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<DeliveryPlan> _buildPlan(DeliveryPlanRow planRow) async {
    final itemRows =
        await (_db.select(_db.deliveryPlanItems)
              ..where((t) => t.deliveryPlanId.equals(planRow.id))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();

    final items = await Future.wait(
      itemRows.map((itemRow) async {
        final order = await _db.orderRepo.getById(itemRow.orderId);
        return DeliveryPlanItem(
          id: itemRow.id,
          deliveryPlanId: itemRow.deliveryPlanId,
          order:
              order ??
              model.Order(id: itemRow.orderId, orderDate: DateTime.now()),
          sortOrder: itemRow.sortOrder,
        );
      }),
    );

    return DeliveryPlan(
      id: planRow.id,
      name: planRow.name,
      createdAt: planRow.createdAt,
      deliveryDate: planRow.deliveryDate,
      isFinished: planRow.isFinished,
      items: items,
    );
  }
}
