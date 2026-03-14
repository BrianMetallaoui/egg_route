import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/customer_product_price.dart';
import '../models/product.dart';

class CustomerProductPriceRepository {
  final AppDatabase _db;
  CustomerProductPriceRepository(this._db);

  Stream<List<CustomerProductPrice>> watchByCustomerId(String customerId) {
    final query = _db.select(_db.customerProductPrices).join([
      leftOuterJoin(
        _db.products,
        _db.products.id.equalsExp(_db.customerProductPrices.productId),
      ),
    ])..where(_db.customerProductPrices.customerId.equals(customerId));

    return query.watch().map((rows) => rows.map(_mapJoinedRow).toList());
  }

  Future<CustomerProductPrice?> getPrice(
    String customerId,
    String productId,
  ) async {
    final row =
        await (_db.select(_db.customerProductPrices)..where(
              (t) =>
                  t.customerId.equals(customerId) &
                  t.productId.equals(productId),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return CustomerProductPrice(
      id: row.id,
      customerId: row.customerId,
      productId: row.productId,
      isNegotiated: row.isNegotiated,
      overridePrice: row.overridePrice,
    );
  }

  Future<void> insert(CustomerProductPrice cpp) async {
    await _db
        .into(_db.customerProductPrices)
        .insert(
          CustomerProductPricesCompanion.insert(
            id: cpp.id,
            customerId: cpp.customerId,
            productId: cpp.productId,
            isNegotiated: Value(cpp.isNegotiated),
            overridePrice: Value(cpp.overridePrice),
          ),
        );
  }

  Future<void> updatePrice(CustomerProductPrice cpp) async {
    await (_db.update(
      _db.customerProductPrices,
    )..where((t) => t.id.equals(cpp.id))).write(
      CustomerProductPricesCompanion(
        isNegotiated: Value(cpp.isNegotiated),
        overridePrice: Value(cpp.overridePrice),
      ),
    );
  }

  Future<void> deletePrice(String id) async {
    await (_db.delete(
      _db.customerProductPrices,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteByCustomerId(String customerId) async {
    await (_db.delete(
      _db.customerProductPrices,
    )..where((t) => t.customerId.equals(customerId))).go();
  }

  CustomerProductPrice _mapJoinedRow(TypedResult row) {
    final cppRow = row.readTable(_db.customerProductPrices);
    final productRow = row.readTableOrNull(_db.products);

    return CustomerProductPrice(
      id: cppRow.id,
      customerId: cppRow.customerId,
      productId: cppRow.productId,
      isNegotiated: cppRow.isNegotiated,
      overridePrice: cppRow.overridePrice,
      product: productRow != null
          ? Product(
              id: productRow.id,
              label: productRow.label,
              referencePrice: productRow.referencePrice,
              isActive: productRow.isActive,
            )
          : null,
    );
  }
}
