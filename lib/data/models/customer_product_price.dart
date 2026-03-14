import 'product.dart';

final class CustomerProductPrice {
  final String id;
  final String customerId;
  final String productId;
  final bool isNegotiated;
  final double? overridePrice;
  final Product? product;

  const CustomerProductPrice({
    required this.id,
    required this.customerId,
    required this.productId,
    this.isNegotiated = false,
    this.overridePrice,
    this.product,
  });

  CustomerProductPrice copyWith({
    bool? isNegotiated,
    double? Function()? overridePrice,
    Product? product,
  }) => CustomerProductPrice(
    id: id,
    customerId: customerId,
    productId: productId,
    isNegotiated: isNegotiated ?? this.isNegotiated,
    overridePrice: overridePrice != null ? overridePrice() : this.overridePrice,
    product: product ?? this.product,
  );
}
