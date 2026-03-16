import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/swipeable_card.dart';
import 'widgets/order_card.dart';

enum OrderFilter { all, newOrders, delivered, paid, planned, unplanned }

enum OrderSort { orderDate, customer }

final _filterProvider = StateProvider<OrderFilter>((_) => OrderFilter.all);
final _sortProvider = StateProvider<OrderSort>((_) => OrderSort.orderDate);

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  List<Order> _filterOrders(List<Order> orders, OrderFilter filter) {
    final active = orders.where((o) => !o.isFinished).toList();
    switch (filter) {
      case OrderFilter.all:
        return active;
      case OrderFilter.newOrders:
        return active.where((o) => !o.isDelivered && !o.isPaid).toList();
      case OrderFilter.delivered:
        return active.where((o) => o.isDelivered && !o.isPaid).toList();
      case OrderFilter.paid:
        return active.where((o) => !o.isDelivered && o.isPaid).toList();
      case OrderFilter.planned:
        return active.where((o) => o.deliveryPlanRefs.isNotEmpty).toList();
      case OrderFilter.unplanned:
        return active.where((o) => o.deliveryPlanRefs.isEmpty).toList();
    }
  }

  List<Order> _sortOrders(List<Order> orders, OrderSort sort) {
    final sorted = List<Order>.from(orders);
    switch (sort) {
      case OrderSort.orderDate:
        sorted.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      case OrderSort.customer:
        sorted.sort((a, b) {
          final nameA = a.customer?.name.toLowerCase() ?? '';
          final nameB = b.customer?.name.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(orderProvider);
    final filter = ref.watch(_filterProvider);
    final sort = ref.watch(_sortProvider);

    final filtered = _filterOrders(allOrders, filter);
    final sorted = _sortOrders(filtered, sort);

    return Column(
      children: [
        // Filter tabs + sort
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: OrderFilter.values.map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_filterLabel(f)),
                          selected: filter == f,
                          onSelected: (_) =>
                              ref.read(_filterProvider.notifier).state = f,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              PopupMenuButton<OrderSort>(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort',
                onSelected: (value) =>
                    ref.read(_sortProvider.notifier).state = value,
                itemBuilder: (_) => [
                  CheckedPopupMenuItem(
                    value: OrderSort.orderDate,
                    checked: sort == OrderSort.orderDate,
                    child: const Text('Order Date'),
                  ),
                  CheckedPopupMenuItem(
                    value: OrderSort.customer,
                    checked: sort == OrderSort.customer,
                    child: const Text('Customer'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Order list
        Expanded(
          child: sorted.isEmpty
              ? const Center(child: Text('No orders found.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 80),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    final order = sorted[index];
                    return SwipeableCard(
                      key: ValueKey(order.id),
                      onDelete: () => _deleteOrder(context, ref, order),
                      actionButtonWidth: 80,
                      actions: [
                        SwipeAction(
                          icon: Icons.local_shipping,
                          label: 'Delivered',
                          enabled: !order.isDelivered,
                          color: Theme.of(context).colorScheme.primary,
                          disabledColor: Theme.of(context).colorScheme.outline,
                          onTap: () => _markDelivered(ref, order),
                        ),
                      ],
                      child: OrderCard(
                        order: order,
                        onTap: () => context.push('/order/${order.id}'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _deleteOrder(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) async {
    final settings = ref.read(settingsProvider);

    if (settings.warnOnDelete) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Delete Order',
        message: 'Are you sure you want to delete this order? This cannot be undone.',
      );
      if (!confirmed) return;
    }

    await ref.read(orderProvider.notifier).delete(order.id);
  }

  Future<void> _markDelivered(WidgetRef ref, Order order) async {
    if (order.isDelivered) return;
    await ref.read(orderProvider.notifier).markDelivered(order.id, true);
  }

  String _filterLabel(OrderFilter f) {
    switch (f) {
      case OrderFilter.all:
        return 'All';
      case OrderFilter.newOrders:
        return 'New';
      case OrderFilter.delivered:
        return 'Delivered';
      case OrderFilter.paid:
        return 'Paid';
      case OrderFilter.planned:
        return 'Planned';
      case OrderFilter.unplanned:
        return 'Unplanned';
    }
  }
}

