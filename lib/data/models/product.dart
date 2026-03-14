final class Product {
  final String id;
  final String label;
  final double? referencePrice;
  final bool isActive;

  const Product({
    required this.id,
    required this.label,
    this.referencePrice,
    this.isActive = true,
  });

  Product copyWith({
    String? label,
    double? Function()? referencePrice,
    bool? isActive,
  }) => Product(
    id: id,
    label: label ?? this.label,
    referencePrice: referencePrice != null
        ? referencePrice()
        : this.referencePrice,
    isActive: isActive ?? this.isActive,
  );
}
