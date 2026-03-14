import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/data/models/delivery_plan.dart';
import 'package:egg_route/data/models/delivery_plan_item.dart';
import 'package:egg_route/data/models/order.dart';
import 'package:egg_route/data/models/order_line_item.dart';

void main() {
  Order makeOrder(String id, List<OrderLineItem> items) =>
      Order(id: id, orderDate: DateTime(2025, 1, 1), lineItems: items);

  DeliveryPlanItem makePlanItem(String id, Order order) =>
      DeliveryPlanItem(id: id, deliveryPlanId: 'dp-1', order: order);

  group('DeliveryPlan.totalValue', () {
    test('returns 0 with no items', () {
      final plan = DeliveryPlan(id: 'dp-1', createdAt: DateTime(2025, 1, 1));
      expect(plan.totalValue, 0.0);
    });

    test('sums order totals across all items', () {
      final order1 = makeOrder('ord-1', const [
        OrderLineItem(
          id: 'oli-1',
          orderId: 'ord-1',
          productLabel: 'Eggs',
          quantity: 2,
          unitPrice: 5.0,
        ),
      ]);
      final order2 = makeOrder('ord-2', const [
        OrderLineItem(
          id: 'oli-2',
          orderId: 'ord-2',
          productLabel: 'Duck Eggs',
          quantity: 1,
          unitPrice: 8.0,
        ),
      ]);

      final plan = DeliveryPlan(
        id: 'dp-1',
        createdAt: DateTime(2025, 1, 1),
        items: [makePlanItem('dpi-1', order1), makePlanItem('dpi-2', order2)],
      );
      expect(plan.totalValue, 18.0); // (2*5) + (1*8)
    });
  });

  group('DeliveryPlan.orderCount', () {
    test('returns 0 with no items', () {
      final plan = DeliveryPlan(id: 'dp-1', createdAt: DateTime(2025, 1, 1));
      expect(plan.orderCount, 0);
    });

    test('returns the number of items', () {
      final order = makeOrder('ord-1', const []);
      final plan = DeliveryPlan(
        id: 'dp-1',
        createdAt: DateTime(2025, 1, 1),
        items: [
          makePlanItem('dpi-1', order),
          makePlanItem('dpi-2', order),
          makePlanItem('dpi-3', order),
        ],
      );
      expect(plan.orderCount, 3);
    });
  });

  group('DeliveryPlan.copyWith', () {
    test('can set deliveryDate to null', () {
      final plan = DeliveryPlan(
        id: 'dp-1',
        createdAt: DateTime(2025, 1, 1),
        deliveryDate: DateTime(2025, 2, 1),
      );
      final copy = plan.copyWith(deliveryDate: () => null);
      expect(copy.deliveryDate, isNull);
    });

    test('preserves fields when called with no arguments', () {
      final plan = DeliveryPlan(
        id: 'dp-1',
        name: 'Monday Route',
        createdAt: DateTime(2025, 1, 1),
        isFinished: true,
      );
      final copy = plan.copyWith();
      expect(copy.id, plan.id);
      expect(copy.name, plan.name);
      expect(copy.isFinished, plan.isFinished);
    });
  });
}
