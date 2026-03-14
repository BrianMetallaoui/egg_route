import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/data/models/order.dart';
import 'package:egg_route/data/models/order_line_item.dart';

void main() {
  group('Order.isFinished', () {
    test('returns false when neither delivered nor paid', () {
      final order = Order(id: 'ord-1', orderDate: DateTime(2025, 1, 1));
      expect(order.isFinished, isFalse);
    });

    test('returns false when delivered but not paid', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
      );
      expect(order.isFinished, isFalse);
    });

    test('returns false when paid but not delivered', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isPaid: true,
      );
      expect(order.isFinished, isFalse);
    });

    test('returns true when both delivered and paid', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
      );
      expect(order.isFinished, isTrue);
    });
  });

  group('Order.finishedDate', () {
    test('returns null when not finished', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        deliveredDate: DateTime(2025, 1, 5),
      );
      expect(order.finishedDate, isNull);
    });

    test('returns null when finished but deliveredDate is null', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
        paidDate: DateTime(2025, 1, 5),
      );
      expect(order.finishedDate, isNull);
    });

    test('returns null when finished but paidDate is null', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
        deliveredDate: DateTime(2025, 1, 5),
      );
      expect(order.finishedDate, isNull);
    });

    test('returns deliveredDate when it is later than paidDate', () {
      final delivered = DateTime(2025, 1, 10);
      final paid = DateTime(2025, 1, 5);
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
        deliveredDate: delivered,
        paidDate: paid,
      );
      expect(order.finishedDate, delivered);
    });

    test('returns paidDate when it is later than deliveredDate', () {
      final delivered = DateTime(2025, 1, 5);
      final paid = DateTime(2025, 1, 10);
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
        deliveredDate: delivered,
        paidDate: paid,
      );
      expect(order.finishedDate, paid);
    });

    test('returns paidDate when both dates are the same', () {
      final date = DateTime(2025, 1, 5);
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        isDelivered: true,
        isPaid: true,
        deliveredDate: date,
        paidDate: date,
      );
      // When equal, deliveredDate.isAfter(paidDate) is false, so paidDate
      expect(order.finishedDate, date);
    });
  });

  group('Order.orderTotal', () {
    test('returns 0 with no line items', () {
      final order = Order(id: 'ord-1', orderDate: DateTime(2025, 1, 1));
      expect(order.orderTotal, 0.0);
    });

    test('sums a single line item', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        lineItems: const [
          OrderLineItem(
            id: 'oli-1',
            orderId: 'ord-1',
            productLabel: 'Eggs',
            quantity: 3,
            unitPrice: 5.0,
          ),
        ],
      );
      expect(order.orderTotal, 15.0);
    });

    test('sums multiple line items', () {
      final order = Order(
        id: 'ord-1',
        orderDate: DateTime(2025, 1, 1),
        lineItems: const [
          OrderLineItem(
            id: 'oli-1',
            orderId: 'ord-1',
            productLabel: 'Eggs',
            quantity: 2,
            unitPrice: 5.0,
          ),
          OrderLineItem(
            id: 'oli-2',
            orderId: 'ord-1',
            productLabel: 'Duck Eggs',
            quantity: 1,
            unitPrice: 8.0,
          ),
        ],
      );
      expect(order.orderTotal, 18.0);
    });
  });

  group('Order.copyWith', () {
    final base = Order(
      id: 'ord-1',
      orderDate: DateTime(2025, 1, 1),
      isDelivered: true,
      isPaid: false,
      deliveredDate: DateTime(2025, 1, 5),
      note: 'original',
    );

    test('preserves all fields when called with no arguments', () {
      final copy = base.copyWith();
      expect(copy.id, base.id);
      expect(copy.isDelivered, base.isDelivered);
      expect(copy.isPaid, base.isPaid);
      expect(copy.deliveredDate, base.deliveredDate);
      expect(copy.note, base.note);
    });

    test('overrides specified fields', () {
      final copy = base.copyWith(isPaid: true, note: 'updated');
      expect(copy.isPaid, isTrue);
      expect(copy.note, 'updated');
      expect(copy.isDelivered, isTrue); // unchanged
    });

    test('can set nullable fields to null', () {
      final copy = base.copyWith(deliveredDate: () => null);
      expect(copy.deliveredDate, isNull);
    });
  });
}
