import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/data/models/order_line_item.dart';

void main() {
  group('OrderLineItem.lineTotal', () {
    test('multiplies quantity by unit price', () {
      const item = OrderLineItem(
        id: 'oli-1',
        orderId: 'ord-1',
        productLabel: 'Eggs',
        quantity: 3,
        unitPrice: 5.0,
      );
      expect(item.lineTotal, 15.0);
    });

    test('returns 0 when quantity is 0', () {
      const item = OrderLineItem(
        id: 'oli-1',
        orderId: 'ord-1',
        productLabel: 'Eggs',
        quantity: 0,
        unitPrice: 5.0,
      );
      expect(item.lineTotal, 0.0);
    });

    test('returns 0 when unit price is 0', () {
      const item = OrderLineItem(
        id: 'oli-1',
        orderId: 'ord-1',
        productLabel: 'Eggs',
        quantity: 3,
        unitPrice: 0.0,
      );
      expect(item.lineTotal, 0.0);
    });

    test('defaults to quantity 1 and unit price 0', () {
      const item = OrderLineItem(
        id: 'oli-1',
        orderId: 'ord-1',
        productLabel: 'Eggs',
      );
      expect(item.lineTotal, 0.0);
      expect(item.quantity, 1);
      expect(item.unitPrice, 0.0);
    });
  });

  group('OrderLineItem.productId', () {
    test('returns empty string when product is null', () {
      const item = OrderLineItem(
        id: 'oli-1',
        orderId: 'ord-1',
        productLabel: 'Eggs',
      );
      expect(item.productId, '');
    });
  });
}
