import 'package:flutter/material.dart';

import '../../../data/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final bool showFinishedDates;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.showFinishedDates = false,
  });

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String get _productSummary {
    if (order.lineItems.isEmpty) return 'No products';
    // Group by product label and sum quantities
    final grouped = <String, int>{};
    for (final li in order.lineItems) {
      grouped[li.productLabel] = (grouped[li.productLabel] ?? 0) + li.quantity;
    }
    return grouped.entries.map((e) => '${e.key} × ${e.value}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customerName = order.customer?.name ?? 'Unknown Customer';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: customer name + total
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customerName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${order.orderTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Product summary
              Text(
                _productSummary,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Bottom row: indicators + dates
              Row(
                children: [
                  // Delivered indicator
                  _StatusBox(
                    icon: Icons.local_shipping,
                    active: order.isDelivered,
                  ),
                  const SizedBox(width: 6),
                  // Paid indicator
                  _StatusBox(icon: Icons.attach_money, active: order.isPaid),

                  // Delivery plan badge
                  if (order.deliveryPlanRefs.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _StatusBox(
                      icon: Icons.route,
                      active: true,
                      activeColor: theme.colorScheme.tertiary,
                    ),
                  ],

                  const Spacer(),

                  // Date info
                  if (showFinishedDates && order.finishedDate != null)
                    Text(
                      'Finished ${_formatDate(order.finishedDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Text(
                      _formatDate(order.orderDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color? activeColor;

  const _StatusBox({
    required this.icon,
    required this.active,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? (activeColor ?? theme.colorScheme.primary)
        : theme.colorScheme.outline;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: active ? 1.5 : 1),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
