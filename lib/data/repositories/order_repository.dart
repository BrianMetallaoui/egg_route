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
    return Future.wait(orderRows.map(_buildOrder));
  }

  Stream<List<Order>> watchAll() {
    return _db
        .select(_db.orders)
        .watch()
        .asyncMap((orderRows) => Future.wait(orderRows.map(_buildOrder)));
  }

  Future<Order?> getById(String id) async {
    final row = await (_db.select(
      _db.orders,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _buildOrder(row);
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

  Future<Order> _buildOrder(OrderRow row) async {
    final lineItemRows = await (_db.select(
      _db.orderLineItems,
    )..where((t) => t.orderId.equals(row.id))).get();

    final lineItems = await Future.wait(
      lineItemRows.map((li) async {
        final productRow = await (_db.select(
          _db.products,
        )..where((t) => t.id.equals(li.productId))).getSingleOrNull();

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
      }),
    );

    final planItemRows = await (_db.select(
      _db.deliveryPlanItems,
    )..where((t) => t.orderId.equals(row.id))).get();

    final planRefs = await Future.wait(
      planItemRows.map((pi) async {
        final planRow = await (_db.select(
          _db.deliveryPlans,
        )..where((t) => t.id.equals(pi.deliveryPlanId))).getSingleOrNull();
        return DeliveryPlanRef(
          id: pi.deliveryPlanId,
          name: planRow?.name ?? '',
        );
      }),
    );

    final customerRow = await (_db.select(
      _db.customers,
    )..where((t) => t.id.equals(row.customerId))).getSingleOrNull();

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
  }
}
