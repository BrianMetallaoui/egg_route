import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/services/backup_service.dart';

void main() {
  /// Builds a minimal valid backup JSON map.
  Map<String, dynamic> validBackup() => {
    'backupVersion': 1,
    'exportedAt': DateTime.now().toIso8601String(),
    'customers': [
      {'id': 'cust-1', 'name': 'Farm A', 'address': '', 'notes': ''},
    ],
    'products': [
      {'id': 'prod-1', 'label': 'Eggs', 'referencePrice': 5.0},
    ],
    'customerProductPrices': <Map<String, dynamic>>[],
    'orders': [
      {
        'id': 'ord-1',
        'customerId': 'cust-1',
        'orderDate': '2025-01-01T00:00:00.000',
        'isDelivered': false,
        'isPaid': false,
      },
    ],
    'orderLineItems': [
      {
        'id': 'oli-1',
        'orderId': 'ord-1',
        'productId': 'prod-1',
        'productLabel': 'Eggs',
        'quantity': 2,
        'unitPrice': 5.0,
      },
    ],
    'deliveryPlans': [
      {
        'id': 'dp-1',
        'name': 'Monday',
        'createdAt': '2025-01-01T00:00:00.000',
      },
    ],
    'deliveryPlanItems': [
      {
        'id': 'dpi-1',
        'deliveryPlanId': 'dp-1',
        'orderId': 'ord-1',
        'sortOrder': 0,
      },
    ],
  };

  group('valid backup', () {
    test('accepts a well-formed backup', () {
      final json = jsonEncode(validBackup());
      final result = BackupService.validate(json);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['backupVersion'], 1);
    });
  });

  group('structural validation', () {
    test('rejects invalid JSON', () {
      expect(
        () => BackupService.validate('not json at all'),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          'File is not valid JSON.',
        )),
      );
    });

    test('rejects non-object JSON', () {
      expect(
        () => BackupService.validate(jsonEncode([1, 2, 3])),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          'Expected a JSON object at root.',
        )),
      );
    });

    test('rejects unsupported backup version', () {
      final data = validBackup()..['backupVersion'] = 99;
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Unsupported backup version'),
        )),
      );
    });

    test('rejects missing backup version', () {
      final data = validBackup()..remove('backupVersion');
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>()),
      );
    });

    test('rejects missing required array', () {
      final data = validBackup()..remove('orders');
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('"orders"'),
        )),
      );
    });
  });

  group('entity validation', () {
    test('rejects customer without id', () {
      final data = validBackup();
      (data['customers'] as List).add({'name': 'No ID'});
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Customer missing required "id"'),
        )),
      );
    });

    test('rejects customer without name', () {
      final data = validBackup();
      (data['customers'] as List).add({'id': 'cust-2'});
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Customer missing required "name"'),
        )),
      );
    });

    test('rejects product without id', () {
      final data = validBackup();
      (data['products'] as List).add({'label': 'No ID'});
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Product missing required "id"'),
        )),
      );
    });

    test('rejects product without label', () {
      final data = validBackup();
      (data['products'] as List).add({'id': 'prod-2'});
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Product missing required "label"'),
        )),
      );
    });
  });

  group('referential integrity', () {
    test('rejects order referencing unknown customer', () {
      final data = validBackup();
      (data['orders'] as List).add({
        'id': 'ord-2',
        'customerId': 'cust-nonexistent',
        'orderDate': '2025-01-01T00:00:00.000',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Order references unknown customer'),
        )),
      );
    });

    test('rejects line item referencing unknown order', () {
      final data = validBackup();
      (data['orderLineItems'] as List).add({
        'id': 'oli-2',
        'orderId': 'ord-nonexistent',
        'productId': 'prod-1',
        'productLabel': 'Eggs',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Order line item references unknown order'),
        )),
      );
    });

    test('rejects line item referencing unknown product', () {
      final data = validBackup();
      (data['orderLineItems'] as List).add({
        'id': 'oli-2',
        'orderId': 'ord-1',
        'productId': 'prod-nonexistent',
        'productLabel': 'Ghost Product',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Order line item references unknown product'),
        )),
      );
    });

    test('rejects delivery plan item referencing unknown plan', () {
      final data = validBackup();
      (data['deliveryPlanItems'] as List).add({
        'id': 'dpi-2',
        'deliveryPlanId': 'dp-nonexistent',
        'orderId': 'ord-1',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Delivery plan item references unknown plan'),
        )),
      );
    });

    test('rejects delivery plan item referencing unknown order', () {
      final data = validBackup();
      (data['deliveryPlanItems'] as List).add({
        'id': 'dpi-2',
        'deliveryPlanId': 'dp-1',
        'orderId': 'ord-nonexistent',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Delivery plan item references unknown order'),
        )),
      );
    });

    test('rejects customer product price referencing unknown customer', () {
      final data = validBackup();
      (data['customerProductPrices'] as List).add({
        'id': 'cpp-1',
        'customerId': 'cust-nonexistent',
        'productId': 'prod-1',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Customer product price references unknown customer'),
        )),
      );
    });

    test('rejects customer product price referencing unknown product', () {
      final data = validBackup();
      (data['customerProductPrices'] as List).add({
        'id': 'cpp-1',
        'customerId': 'cust-1',
        'productId': 'prod-nonexistent',
      });
      expect(
        () => BackupService.validate(jsonEncode(data)),
        throwsA(isA<BackupValidationError>().having(
          (e) => e.message,
          'message',
          contains('Customer product price references unknown product'),
        )),
      );
    });
  });
}
