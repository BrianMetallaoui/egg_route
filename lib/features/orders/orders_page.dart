import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
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
                    return _SwipeableOrderCard(
                      key: ValueKey(order.id),
                      order: order,
                      onTap: () => context.push('/order/${order.id}'),
                      onDelete: () => _deleteOrder(context, ref, order),
                      onMarkDelivered: () => _markDelivered(ref, order),
                      onMarkPaid: () => _markPaid(ref, order),
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
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Order'),
          content: const Text(
            'Are you sure you want to delete this order? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    await ref.read(orderProvider.notifier).delete(order.id);
  }

  Future<void> _markDelivered(WidgetRef ref, Order order) async {
    if (order.isDelivered) return;
    await ref.read(orderProvider.notifier).markDelivered(order.id, true);
  }

  Future<void> _markPaid(WidgetRef ref, Order order) async {
    if (order.isPaid) return;
    await ref.read(orderProvider.notifier).markPaid(order.id, true);
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

/// Order card with swipe-to-reveal actions.
///
/// Swipe right → delete (red background with trash icon, triggers on release).
/// Swipe left → reveals tappable Delivered + Paid buttons.
class _SwipeableOrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkDelivered;
  final VoidCallback onMarkPaid;

  const _SwipeableOrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onDelete,
    required this.onMarkDelivered,
    required this.onMarkPaid,
  });

  @override
  State<_SwipeableOrderCard> createState() => _SwipeableOrderCardState();
}

class _SwipeableOrderCardState extends State<_SwipeableOrderCard>
    with SingleTickerProviderStateMixin {
  // Positive = swiped right (delete), negative = swiped left (actions)
  double _offset = 0;
  bool _dragging = false;

  static const double _actionWidth = 160;
  static const double _deleteThreshold = 100;

  late final AnimationController _snapController;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final start = _offset;
    _snapController.reset();
    _snapController.addListener(() {
      setState(() {
        _offset = start + (target - start) * _snapController.value;
      });
    });
    _snapController.forward().then((_) {
      _snapController.removeListener(() {});
    });
  }

  void _onDragStart(DragStartDetails details) {
    _dragging = true;
    _snapController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    setState(() {
      _offset = (_offset + details.primaryDelta!);
      // Clamp: can't swipe left beyond action width, can't swipe right too far
      _offset = _offset.clamp(-_actionWidth, _deleteThreshold + 40);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;

    if (_offset > _deleteThreshold) {
      // Swiped right far enough → delete
      _animateTo(0);
      widget.onDelete();
    } else if (_offset < -_actionWidth * 0.4) {
      // Swiped left far enough → snap open
      _animateTo(-_actionWidth);
    } else {
      // Snap back to closed
      _animateTo(0);
    }
  }

  void _close() {
    _animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deleteProgress = (_offset / _deleteThreshold).clamp(0.0, 1.0);
    final showDelete = _offset > 0;
    final showActions = _offset < 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Delete background (left side, revealed on right swipe)
            if (showDelete)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24),
                  color: Color.lerp(
                    theme.colorScheme.errorContainer,
                    theme.colorScheme.error,
                    deleteProgress,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Color.lerp(
                      theme.colorScheme.onErrorContainer,
                      theme.colorScheme.onError,
                      deleteProgress,
                    ),
                    size: 28,
                  ),
                ),
              ),

            // Action buttons (right side, revealed on left swipe)
            if (showActions)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: _actionWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: _SwipeActionButton(
                            icon: Icons.local_shipping,
                            label: 'Delivered',
                            enabled: !widget.order.isDelivered,
                            color: theme.colorScheme.primary,
                            disabledColor: theme.colorScheme.outline,
                            onTap: () {
                              widget.onMarkDelivered();
                              _close();
                            },
                          ),
                        ),
                        Expanded(
                          child: _SwipeActionButton(
                            icon: Icons.attach_money,
                            label: 'Paid',
                            enabled: !widget.order.isPaid,
                            color: theme.colorScheme.primary,
                            disabledColor: theme.colorScheme.outline,
                            onTap: () {
                              widget.onMarkPaid();
                              _close();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // The card itself
            Transform.translate(
              offset: Offset(_offset, 0),
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: OrderCard(order: widget.order, onTap: widget.onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color color;
  final Color disabledColor;
  final VoidCallback onTap;

  const _SwipeActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.color,
    required this.disabledColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : disabledColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveColor, size: 28),
              const SizedBox(height: 4),
              Text(
                enabled ? label : 'Done',
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
