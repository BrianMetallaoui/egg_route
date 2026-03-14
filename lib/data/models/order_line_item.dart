import 'product.dart';

final class OrderLineItem {
  final String id;
  final String orderId;
  final Product? product;
  final String productLabel;
  final int quantity;
  final double unitPrice;

  const OrderLineItem({
    required this.id,
    required this.orderId,
    this.product,
    required this.productLabel,
    this.quantity = 1,
    this.unitPrice = 0.0,
  });

  String get productId => product?.id ?? '';

  double get lineTotal => quantity * unitPrice;

  OrderLineItem copyWith({
    Product? Function()? product,
    String? productLabel,
    int? quantity,
    double? unitPrice,
  }) => OrderLineItem(
    id: id,
    orderId: orderId,
    product: product != null ? product() : this.product,
    productLabel: productLabel ?? this.productLabel,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
  );
}
