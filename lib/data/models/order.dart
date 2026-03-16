import 'customer.dart';
import 'order_line_item.dart';

final class Order {
  final String id;
  final Customer? customer;
  final bool isDelivered;
  final bool isPaid;
  final String paymentMethod;
  final DateTime orderDate;
  final DateTime? deliveredDate;
  final DateTime? paidDate;
  final String note;
  final List<OrderLineItem> lineItems;
  final List<DeliveryPlanRef> deliveryPlanRefs;

  const Order({
    required this.id,
    this.customer,
    this.isDelivered = false,
    this.isPaid = false,
    this.paymentMethod = '',
    required this.orderDate,
    this.deliveredDate,
    this.paidDate,
    this.note = '',
    this.lineItems = const [],
    this.deliveryPlanRefs = const [],
  });

  String get customerId => customer?.id ?? '';

  bool get isFinished => isDelivered && isPaid;

  /// The date this order was fully finished (both delivered and paid).
  /// Returns the later of deliveredDate and paidDate.
  DateTime? get finishedDate {
    if (!isFinished || deliveredDate == null || paidDate == null) return null;
    return deliveredDate!.isAfter(paidDate!) ? deliveredDate : paidDate;
  }

  double get orderTotal =>
      lineItems.fold(0.0, (sum, item) => sum + item.lineTotal);

  Order copyWith({
    Customer? Function()? customer,
    bool? isDelivered,
    bool? isPaid,
    String? paymentMethod,
    DateTime? orderDate,
    DateTime? Function()? deliveredDate,
    DateTime? Function()? paidDate,
    String? note,
    List<OrderLineItem>? lineItems,
    List<DeliveryPlanRef>? deliveryPlanRefs,
  }) => Order(
    id: id,
    customer: customer != null ? customer() : this.customer,
    isDelivered: isDelivered ?? this.isDelivered,
    isPaid: isPaid ?? this.isPaid,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    orderDate: orderDate ?? this.orderDate,
    deliveredDate: deliveredDate != null ? deliveredDate() : this.deliveredDate,
    paidDate: paidDate != null ? paidDate() : this.paidDate,
    note: note ?? this.note,
    lineItems: lineItems ?? this.lineItems,
    deliveryPlanRefs: deliveryPlanRefs ?? this.deliveryPlanRefs,
  );
}

/// Lightweight reference to a delivery plan (used on order detail without deep loading).
final class DeliveryPlanRef {
  final String id;
  final String name;

  const DeliveryPlanRef({required this.id, required this.name});
}
