import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';
import 'notifier_helpers.dart';

class ProductNotifier extends Notifier<List<Product>> with DbCallMixin {
  @override
  List<Product> build() {
    final db = ref.watch(databaseProvider);
    final sub = db.productRepo.watchAll().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return List.from(ref.read(initialProductsProvider));
  }

  Future<void> add(Product product) async {
    await dbCall((db) => db.productRepo.insert(product));
  }

  Future<void> update(Product product) async {
    await dbCall((db) => db.productRepo.updateProduct(product));
  }

  /// Soft-delete: sets isActive = false.
  Future<void> softDelete(String id) async {
    final product = ref
        .read(productProvider)
        .where((p) => p.id == id)
        .firstOrNull;
    if (product != null) {
      await dbCall(
        (db) => db.productRepo.updateProduct(product.copyWith(isActive: false)),
      );
    }
  }
}

final productProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productProvider);
  return products.where((p) => p.id == id).firstOrNull;
});
