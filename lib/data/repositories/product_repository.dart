import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/product.dart';

class ProductRepository {
  final AppDatabase _db;
  ProductRepository(this._db);

  Future<List<Product>> getAll() async {
    final rows = await _db.select(_db.products).get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<Product>> watchAll() {
    return _db
        .select(_db.products)
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<Product?> getById(String id) async {
    final row = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _mapRow(row) : null;
  }

  Future<void> insert(Product product) async {
    await _db
        .into(_db.products)
        .insert(
          ProductsCompanion.insert(
            id: product.id,
            label: product.label,
            referencePrice: Value(product.referencePrice),
            isActive: Value(product.isActive),
          ),
        );
  }

  Future<void> updateProduct(Product product) async {
    await (_db.update(
      _db.products,
    )..where((t) => t.id.equals(product.id))).write(
      ProductsCompanion(
        label: Value(product.label),
        referencePrice: Value(product.referencePrice),
        isActive: Value(product.isActive),
      ),
    );
  }

  Future<void> deleteProduct(String id) async {
    await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
  }

  Product _mapRow(ProductRow row) => Product(
    id: row.id,
    label: row.label,
    referencePrice: row.referencePrice,
    isActive: row.isActive,
  );
}
