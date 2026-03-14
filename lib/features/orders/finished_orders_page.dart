import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/order.dart';
import '../../providers/customer_provider.dart';
import '../../providers/order_provider.dart';
import 'widgets/order_card.dart';

final _groupByMonthProvider = StateProvider<bool>((_) => false);
final _customerFilterProvider = StateProvider<String?>((_) => null);

class FinishedOrdersPage extends ConsumerWidget {
  const FinishedOrdersPage({super.key});

  static const _months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _monthHeader(DateTime date) {
    return '${_months[date.month]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _deleteAllFinished(BuildContext context, WidgetRef ref) async {
    final allOrders = ref.read(orderProvider);
    final count = allOrders.where((o) => o.isFinished).length;

    final first = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Finished Orders'),
        content: Text(
          'This will permanently delete $count finished '
          '${count == 1 ? 'order' : 'orders'}. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (first != true || !context.mounted) return;

    final second = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(
          'Really delete all $count finished '
          '${count == 1 ? 'order' : 'orders'}? '
          'This is permanent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (second != true) return;

    await ref.read(orderProvider.notifier).deleteFinished();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(orderProvider);
    final groupByMonth = ref.watch(_groupByMonthProvider);
    final customerFilterId = ref.watch(_customerFilterProvider);
    final customers = ref.watch(customerProvider);

    // Get finished orders, sorted by finished date descending
    final allFinished = allOrders.where((o) => o.isFinished).toList();
    var finished = List<Order>.from(allFinished);

    // Apply customer filter
    if (customerFilterId != null) {
      finished = finished
          .where((o) => o.customerId == customerFilterId)
          .toList();
    }

    // Sort by finished date descending
    finished.sort((a, b) {
      final aDate = a.finishedDate ?? a.orderDate;
      final bDate = b.finishedDate ?? b.orderDate;
      return bDate.compareTo(aDate);
    });

    // Customers that actually have finished orders (for filter dropdown)
    final finishedCustomerIds = allFinished.map((o) => o.customerId).toSet();
    final filterCustomers =
        customers.where((c) => finishedCustomerIds.contains(c.id)).toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    return Column(
      children: [
        // Controls row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              // Customer filter dropdown
              Expanded(
                child: DropdownButtonFormField<String?>(
                  value: customerFilterId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Customers'),
                    ),
                    ...filterCustomers.map(
                      (c) => DropdownMenuItem<String?>(
                        value: c.id,
                        child: Text(c.name, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (value) =>
                      ref.read(_customerFilterProvider.notifier).state = value,
                ),
              ),
              const SizedBox(width: 8),
              // Group by month toggle
              FilterChip(
                label: const Text('By Month'),
                selected: groupByMonth,
                onSelected: (value) =>
                    ref.read(_groupByMonthProvider.notifier).state = value,
              ),
              if (allFinished.isNotEmpty) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Delete all finished orders',
                  onPressed: () => _deleteAllFinished(context, ref),
                ),
              ],
            ],
          ),
        ),

        // List
        Expanded(
          child: finished.isEmpty
              ? const Center(child: Text('No finished orders.'))
              : groupByMonth
              ? _GroupedList(
                  orders: finished,
                  monthHeader: _monthHeader,
                  formatDate: _formatDate,
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 80),
                  itemCount: finished.length,
                  itemBuilder: (context, index) {
                    final order = finished[index];
                    return OrderCard(
                      order: order,
                      showFinishedDates: true,
                      onTap: () => context.push('/order/${order.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _GroupedList extends StatelessWidget {
  final List<Order> orders;
  final String Function(DateTime) monthHeader;
  final String Function(DateTime) formatDate;

  const _GroupedList({
    required this.orders,
    required this.monthHeader,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    // Group orders by month
    final groups = <String, List<Order>>{};
    for (final order in orders) {
      final date = order.finishedDate ?? order.orderDate;
      final key = monthHeader(date);
      groups.putIfAbsent(key, () => []).add(order);
    }

    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 80),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final header = groups.keys.elementAt(groupIndex);
        final groupOrders = groups[header]!;
        final groupTotal = groupOrders.fold(
          0.0,
          (sum, o) => sum + o.orderTotal,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              child: Row(
                children: [
                  Text(
                    header,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${groupTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ...groupOrders.map(
              (order) => OrderCard(
                order: order,
                showFinishedDates: true,
                onTap: () => context.push('/order/${order.id}'),
              ),
            ),
          ],
        );
      },
    );
  }
}
