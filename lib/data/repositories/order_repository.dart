import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/order_line_item.dart';

class OrderRepository {
  final AppDatabase _db;
  OrderRepository(this._db);

  Future<List<Order>> getAll() async {
    final orderRows = await _db.select(_db.orders).get();
    return _buildOrders(orderRows);
  }

  Stream<List<Order>> watchAll() {
    return _db
        .select(_db.orders)
        .watch()
        .asyncMap(_buildOrders);
  }

  Future<Order?> getById(String id) async {
    final row = await (_db.select(
      _db.orders,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final results = await _buildOrders([row]);
    return results.first;
  }

  Future<void> insert(Order order) async {
    await _db.transaction(() async {
      await _db
          .into(_db.orders)
          .insert(
            OrdersCompanion.insert(
              id: order.id,
              customerId: order.customerId,
              isDelivered: Value(order.isDelivered),
              isPaid: Value(order.isPaid),
              orderDate: order.orderDate,
              deliveredDate: Value(order.deliveredDate),
              paidDate: Value(order.paidDate),
              note: Value(order.note),
              paymentMethod: Value(order.paymentMethod),
            ),
          );
      for (final item in order.lineItems) {
        await _db
            .into(_db.orderLineItems)
            .insert(
              OrderLineItemsCompanion.insert(
                id: item.id,
                orderId: order.id,
                productId: item.productId,
                productLabel: item.productLabel,
                quantity: Value(item.quantity),
                unitPrice: Value(item.unitPrice),
              ),
            );
      }
    });
  }

  Future<void> updateOrder(Order order) async {
    await _db.transaction(() async {
      await (_db.update(_db.orders)..where((t) => t.id.equals(order.id))).write(
        OrdersCompanion(
          customerId: Value(order.customerId),
          isDelivered: Value(order.isDelivered),
          isPaid: Value(order.isPaid),
          orderDate: Value(order.orderDate),
          deliveredDate: Value(order.deliveredDate),
          paidDate: Value(order.paidDate),
          note: Value(order.note),
          paymentMethod: Value(order.paymentMethod),
        ),
      );

      // Replace all line items
      await (_db.delete(
        _db.orderLineItems,
      )..where((t) => t.orderId.equals(order.id))).go();
      for (final item in order.lineItems) {
        await _db
            .into(_db.orderLineItems)
            .insert(
              OrderLineItemsCompanion.insert(
                id: item.id,
                orderId: order.id,
                productId: item.productId,
                productLabel: item.productLabel,
                quantity: Value(item.quantity),
                unitPrice: Value(item.unitPrice),
              ),
            );
      }
    });
  }

  Future<void> deleteOrder(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.orderLineItems,
      )..where((t) => t.orderId.equals(id))).go();
      await (_db.delete(
        _db.deliveryPlanItems,
      )..where((t) => t.orderId.equals(id))).go();
      await (_db.delete(_db.orders)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> markDelivered(
    String id,
    bool isDelivered, {
    DateTime? deliveredDate,
  }) async {
    await (_db.update(_db.orders)..where((t) => t.id.equals(id))).write(
      OrdersCompanion(
        isDelivered: Value(isDelivered),
        deliveredDate: Value(
          isDelivered ? (deliveredDate ?? DateTime.now()) : null,
        ),
      ),
    );
  }

  /// Batch-builds full [Order] objects from rows, using bulk queries for
  /// related tables instead of per-order lookups.
  Future<List<Order>> _buildOrders(List<OrderRow> orderRows) async {
    if (orderRows.isEmpty) return [];

    final orderIds = orderRows.map((r) => r.id).toSet();
    final customerIds = orderRows.map((r) => r.customerId).toSet();

    // Batch load all related rows in parallel
    final results = await Future.wait([
      (_db.select(_db.orderLineItems)
            ..where((t) => t.orderId.isIn(orderIds)))
          .get(),
      (_db.select(_db.deliveryPlanItems)
            ..where((t) => t.orderId.isIn(orderIds)))
          .get(),
      (_db.select(_db.customers)
            ..where((t) => t.id.isIn(customerIds)))
          .get(),
    ]);

    final allLineItems = results[0] as List<OrderLineItemRow>;
    final allPlanItems = results[1] as List<DeliveryPlanItemRow>;
    final allCustomers = results[2] as List<CustomerRow>;

    // Batch load products and plans referenced by the items
    final productIds = allLineItems.map((li) => li.productId).toSet();
    final planIds = allPlanItems.map((pi) => pi.deliveryPlanId).toSet();

    final lookups = await Future.wait([
      productIds.isEmpty
          ? Future.value(<ProductRow>[])
          : (_db.select(_db.products)
                ..where((t) => t.id.isIn(productIds)))
              .get(),
      planIds.isEmpty
          ? Future.value(<DeliveryPlanRow>[])
          : (_db.select(_db.deliveryPlans)
                ..where((t) => t.id.isIn(planIds)))
              .get(),
    ]);

    final productMap = {
      for (final p in lookups[0] as List<ProductRow>) p.id: p,
    };
    final planMap = {
      for (final dp in lookups[1] as List<DeliveryPlanRow>) dp.id: dp,
    };
    final customerMap = {
      for (final c in allCustomers) c.id: c,
    };

    // Group line items and plan items by order id
    final lineItemsByOrder = <String, List<OrderLineItemRow>>{};
    for (final li in allLineItems) {
      lineItemsByOrder.putIfAbsent(li.orderId, () => []).add(li);
    }
    final planItemsByOrder = <String, List<DeliveryPlanItemRow>>{};
    for (final pi in allPlanItems) {
      planItemsByOrder.putIfAbsent(pi.orderId, () => []).add(pi);
    }

    // Assemble orders
    return orderRows.map((row) {
      final lineItems = (lineItemsByOrder[row.id] ?? []).map((li) {
        final productRow = productMap[li.productId];
        return OrderLineItem(
          id: li.id,
          orderId: li.orderId,
          product: productRow != null
              ? Product(
                  id: productRow.id,
                  label: productRow.label,
                  referencePrice: productRow.referencePrice,
                  isActive: productRow.isActive,
                )
              : null,
          productLabel: li.productLabel,
          quantity: li.quantity,
          unitPrice: li.unitPrice,
        );
      }).toList();

      final planRefs = (planItemsByOrder[row.id] ?? []).map((pi) {
        final planRow = planMap[pi.deliveryPlanId];
        return DeliveryPlanRef(
          id: pi.deliveryPlanId,
          name: planRow?.name ?? '',
        );
      }).toList();

      final customerRow = customerMap[row.customerId];
      return Order(
        id: row.id,
        customer: customerRow != null
            ? Customer(
                id: customerRow.id,
                name: customerRow.name,
                address: customerRow.address,
                notes: customerRow.notes,
                isActive: customerRow.isActive,
              )
            : null,
        isDelivered: row.isDelivered,
        isPaid: row.isPaid,
        paymentMethod: row.paymentMethod,
        orderDate: row.orderDate,
        deliveredDate: row.deliveredDate,
        paidDate: row.paidDate,
        note: row.note,
        lineItems: lineItems,
        deliveryPlanRefs: planRefs,
      );
    }).toList();
  }
}
