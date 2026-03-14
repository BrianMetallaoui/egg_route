import 'order.dart';

final class DeliveryPlanItem {
  final String id;
  final String deliveryPlanId;
  final Order order;
  final int sortOrder;

  const DeliveryPlanItem({
    required this.id,
    required this.deliveryPlanId,
    required this.order,
    this.sortOrder = 0,
  });

  String get orderId => order.id;

  DeliveryPlanItem copyWith({Order? order, int? sortOrder}) => DeliveryPlanItem(
    id: id,
    deliveryPlanId: deliveryPlanId,
    order: order ?? this.order,
    sortOrder: sortOrder ?? this.sortOrder,
  );
}
