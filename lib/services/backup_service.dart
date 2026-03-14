import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../data/database/database.dart';

/// JSON backup format version. Bump when the schema changes in a
/// way that old backups can't be imported anymore.
const _backupVersion = 1;

class BackupValidationError {
  final String message;
  const BackupValidationError(this.message);
  @override
  String toString() => message;
}

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);

  // ---------------------------------------------------------------------------
  // Export
  // ---------------------------------------------------------------------------

  /// Serialises the entire database to a JSON string.
  Future<String> exportToJson() async {
    final customers = await _db.select(_db.customers).get();
    final products = await _db.select(_db.products).get();
    final customerProductPrices = await _db
        .select(_db.customerProductPrices)
        .get();
    final orders = await _db.select(_db.orders).get();
    final orderLineItems = await _db.select(_db.orderLineItems).get();
    final deliveryPlans = await _db.select(_db.deliveryPlans).get();
    final deliveryPlanItems = await _db.select(_db.deliveryPlanItems).get();

    final data = {
      'backupVersion': _backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'customers': customers.map(_customerToJson).toList(),
      'products': products.map(_productToJson).toList(),
      'customerProductPrices': customerProductPrices.map(_cppToJson).toList(),
      'orders': orders.map(_orderToJson).toList(),
      'orderLineItems': orderLineItems.map(_oliToJson).toList(),
      'deliveryPlans': deliveryPlans.map(_planToJson).toList(),
      'deliveryPlanItems': deliveryPlanItems.map(_planItemToJson).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Writes the export JSON to a temp file and returns its path.
  Future<File> exportToFile() async {
    final json = await exportToJson();
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final file = File('${dir.path}/eggroute_backup_$timestamp.json');
    await file.writeAsString(json);
    return file;
  }

  // ---------------------------------------------------------------------------
  // Import
  // ---------------------------------------------------------------------------

  /// Validates JSON string and returns parsed data map, or throws
  /// [BackupValidationError] if anything is wrong.
  static Map<String, dynamic> validate(String jsonString) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (e) {
      throw const BackupValidationError('File is not valid JSON.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const BackupValidationError('Expected a JSON object at root.');
    }

    final version = decoded['backupVersion'];
    if (version is! int || version > _backupVersion) {
      throw BackupValidationError(
        'Unsupported backup version: $version. '
        'This app supports up to version $_backupVersion.',
      );
    }

    // Check required top-level keys
    const requiredKeys = [
      'customers',
      'products',
      'orders',
      'orderLineItems',
      'deliveryPlans',
      'deliveryPlanItems',
    ];
    for (final key in requiredKeys) {
      if (decoded[key] is! List) {
        throw BackupValidationError('Missing or invalid "$key" array.');
      }
    }

    // Validate referential integrity
    _validateRefs(decoded);

    return decoded;
  }

  static void _validateRefs(Map<String, dynamic> data) {
    final customerIds = <String>{};
    for (final c in data['customers'] as List) {
      final id = c['id'];
      if (id is! String || id.isEmpty) {
        throw const BackupValidationError(
          'Customer missing required "id" field.',
        );
      }
      if (c['name'] is! String || (c['name'] as String).isEmpty) {
        throw const BackupValidationError(
          'Customer missing required "name" field.',
        );
      }
      customerIds.add(id);
    }

    final productIds = <String>{};
    for (final p in data['products'] as List) {
      final id = p['id'];
      if (id is! String || id.isEmpty) {
        throw const BackupValidationError(
          'Product missing required "id" field.',
        );
      }
      if (p['label'] is! String || (p['label'] as String).isEmpty) {
        throw const BackupValidationError(
          'Product missing required "label" field.',
        );
      }
      productIds.add(id);
    }

    // Customer product prices
    for (final cpp in (data['customerProductPrices'] as List?) ?? []) {
      if (cpp['customerId'] is! String ||
          !customerIds.contains(cpp['customerId'])) {
        throw const BackupValidationError(
          'Customer product price references unknown customer.',
        );
      }
      if (cpp['productId'] is! String ||
          !productIds.contains(cpp['productId'])) {
        throw const BackupValidationError(
          'Customer product price references unknown product.',
        );
      }
    }

    final orderIds = <String>{};
    for (final o in data['orders'] as List) {
      final id = o['id'];
      if (id is! String || id.isEmpty) {
        throw const BackupValidationError('Order missing required "id" field.');
      }
      if (o['customerId'] is! String ||
          !customerIds.contains(o['customerId'])) {
        throw const BackupValidationError('Order references unknown customer.');
      }
      if (o['orderDate'] is! String) {
        throw const BackupValidationError(
          'Order missing required "orderDate" field.',
        );
      }
      orderIds.add(id);
    }

    for (final oli in data['orderLineItems'] as List) {
      if (oli['orderId'] is! String || !orderIds.contains(oli['orderId'])) {
        throw const BackupValidationError(
          'Order line item references unknown order.',
        );
      }
      if (oli['productId'] is! String ||
          !productIds.contains(oli['productId'])) {
        throw const BackupValidationError(
          'Order line item references unknown product.',
        );
      }
    }

    final planIds = <String>{};
    for (final dp in data['deliveryPlans'] as List) {
      final id = dp['id'];
      if (id is! String || id.isEmpty) {
        throw const BackupValidationError(
          'Delivery plan missing required "id" field.',
        );
      }
      planIds.add(id);
    }

    for (final dpi in data['deliveryPlanItems'] as List) {
      if (dpi['deliveryPlanId'] is! String ||
          !planIds.contains(dpi['deliveryPlanId'])) {
        throw const BackupValidationError(
          'Delivery plan item references unknown plan.',
        );
      }
      if (dpi['orderId'] is! String || !orderIds.contains(dpi['orderId'])) {
        throw const BackupValidationError(
          'Delivery plan item references unknown order.',
        );
      }
    }
  }

  /// Imports validated data, replacing all existing app data.
  Future<void> importFromJson(String jsonString) async {
    final data = BackupService.validate(jsonString);
    await _db.transaction(() async {
      // Clear all tables in reverse dependency order
      await _db.delete(_db.deliveryPlanItems).go();
      await _db.delete(_db.deliveryPlans).go();
      await _db.delete(_db.orderLineItems).go();
      await _db.delete(_db.orders).go();
      await _db.delete(_db.customerProductPrices).go();
      await _db.delete(_db.products).go();
      await _db.delete(_db.customers).go();

      // Insert in dependency order
      for (final c in data['customers'] as List) {
        await _db
            .into(_db.customers)
            .insert(
              CustomersCompanion.insert(
                id: c['id'] as String,
                name: c['name'] as String,
                address: Value(c['address'] as String? ?? ''),
                notes: Value(c['notes'] as String? ?? ''),
                isActive: Value(c['isActive'] as bool? ?? true),
              ),
            );
      }

      for (final p in data['products'] as List) {
        await _db
            .into(_db.products)
            .insert(
              ProductsCompanion.insert(
                id: p['id'] as String,
                label: p['label'] as String,
                referencePrice: Value(
                  (p['referencePrice'] as num?)?.toDouble(),
                ),
                isActive: Value(p['isActive'] as bool? ?? true),
              ),
            );
      }

      for (final cpp in (data['customerProductPrices'] as List?) ?? []) {
        await _db
            .into(_db.customerProductPrices)
            .insert(
              CustomerProductPricesCompanion.insert(
                id: cpp['id'] as String,
                customerId: cpp['customerId'] as String,
                productId: cpp['productId'] as String,
                isNegotiated: Value(cpp['isNegotiated'] as bool? ?? false),
                overridePrice: Value(
                  (cpp['overridePrice'] as num?)?.toDouble(),
                ),
              ),
            );
      }

      for (final o in data['orders'] as List) {
        await _db
            .into(_db.orders)
            .insert(
              OrdersCompanion.insert(
                id: o['id'] as String,
                customerId: o['customerId'] as String,
                isDelivered: Value(o['isDelivered'] as bool? ?? false),
                isPaid: Value(o['isPaid'] as bool? ?? false),
                orderDate: DateTime.parse(o['orderDate'] as String),
                deliveredDate: Value(
                  o['deliveredDate'] != null
                      ? DateTime.parse(o['deliveredDate'] as String)
                      : null,
                ),
                paidDate: Value(
                  o['paidDate'] != null
                      ? DateTime.parse(o['paidDate'] as String)
                      : null,
                ),
                note: Value(o['note'] as String? ?? ''),
              ),
            );
      }

      for (final oli in data['orderLineItems'] as List) {
        await _db
            .into(_db.orderLineItems)
            .insert(
              OrderLineItemsCompanion.insert(
                id: oli['id'] as String,
                orderId: oli['orderId'] as String,
                productId: oli['productId'] as String,
                productLabel: oli['productLabel'] as String,
                quantity: Value(oli['quantity'] as int? ?? 1),
                unitPrice: Value((oli['unitPrice'] as num?)?.toDouble() ?? 0.0),
              ),
            );
      }

      for (final dp in data['deliveryPlans'] as List) {
        await _db
            .into(_db.deliveryPlans)
            .insert(
              DeliveryPlansCompanion.insert(
                id: dp['id'] as String,
                name: Value(dp['name'] as String? ?? ''),
                createdAt: DateTime.parse(dp['createdAt'] as String),
                deliveryDate: Value(
                  dp['deliveryDate'] != null
                      ? DateTime.parse(dp['deliveryDate'] as String)
                      : null,
                ),
                isFinished: Value(dp['isFinished'] as bool? ?? false),
              ),
            );
      }

      for (final dpi in data['deliveryPlanItems'] as List) {
        await _db
            .into(_db.deliveryPlanItems)
            .insert(
              DeliveryPlanItemsCompanion.insert(
                id: dpi['id'] as String,
                deliveryPlanId: dpi['deliveryPlanId'] as String,
                orderId: dpi['orderId'] as String,
                sortOrder: Value(dpi['sortOrder'] as int? ?? 0),
              ),
            );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Row → JSON helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _customerToJson(CustomerRow c) => {
    'id': c.id,
    'name': c.name,
    'address': c.address,
    'notes': c.notes,
    'isActive': c.isActive,
  };

  Map<String, dynamic> _productToJson(ProductRow p) => {
    'id': p.id,
    'label': p.label,
    'referencePrice': p.referencePrice,
    'isActive': p.isActive,
  };

  Map<String, dynamic> _cppToJson(CustomerProductPriceRow cpp) => {
    'id': cpp.id,
    'customerId': cpp.customerId,
    'productId': cpp.productId,
    'isNegotiated': cpp.isNegotiated,
    'overridePrice': cpp.overridePrice,
  };

  Map<String, dynamic> _orderToJson(OrderRow o) => {
    'id': o.id,
    'customerId': o.customerId,
    'isDelivered': o.isDelivered,
    'isPaid': o.isPaid,
    'orderDate': o.orderDate.toIso8601String(),
    'deliveredDate': o.deliveredDate?.toIso8601String(),
    'paidDate': o.paidDate?.toIso8601String(),
    'note': o.note,
  };

  Map<String, dynamic> _oliToJson(OrderLineItemRow oli) => {
    'id': oli.id,
    'orderId': oli.orderId,
    'productId': oli.productId,
    'productLabel': oli.productLabel,
    'quantity': oli.quantity,
    'unitPrice': oli.unitPrice,
  };

  Map<String, dynamic> _planToJson(DeliveryPlanRow dp) => {
    'id': dp.id,
    'name': dp.name,
    'createdAt': dp.createdAt.toIso8601String(),
    'deliveryDate': dp.deliveryDate?.toIso8601String(),
    'isFinished': dp.isFinished,
  };

  Map<String, dynamic> _planItemToJson(DeliveryPlanItemRow dpi) => {
    'id': dpi.id,
    'deliveryPlanId': dpi.deliveryPlanId,
    'orderId': dpi.orderId,
    'sortOrder': dpi.sortOrder,
  };
}
