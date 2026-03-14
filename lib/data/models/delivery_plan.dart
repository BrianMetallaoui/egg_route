import 'delivery_plan_item.dart';

final class DeliveryPlan {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? deliveryDate;
  final bool isFinished;
  final List<DeliveryPlanItem> items;

  const DeliveryPlan({
    required this.id,
    this.name = '',
    required this.createdAt,
    this.deliveryDate,
    this.isFinished = false,
    this.items = const [],
  });

  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.order.orderTotal);

  int get orderCount => items.length;

  DeliveryPlan copyWith({
    String? name,
    DateTime? Function()? deliveryDate,
    bool? isFinished,
    List<DeliveryPlanItem>? items,
  }) => DeliveryPlan(
    id: id,
    name: name ?? this.name,
    createdAt: createdAt,
    deliveryDate: deliveryDate != null ? deliveryDate() : this.deliveryDate,
    isFinished: isFinished ?? this.isFinished,
    items: items ?? this.items,
  );
}
