import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/id_generator.dart';
import '../../data/models/delivery_plan.dart';
import '../../data/models/delivery_plan_item.dart';
import '../../providers/delivery_plan_provider.dart';
import '../../providers/order_provider.dart';

class OrderSelectionPage extends ConsumerStatefulWidget {
  const OrderSelectionPage({super.key});

  @override
  ConsumerState<OrderSelectionPage> createState() => _OrderSelectionPageState();
}

class _OrderSelectionPageState extends ConsumerState<OrderSelectionPage> {
  final Set<String> _selectedIds = {};

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _createPlan() async {
    if (_selectedIds.isEmpty) return;

    final allOrders = ref.read(orderProvider);
    final selectedOrders = allOrders
        .where((o) => _selectedIds.contains(o.id))
        .toList();

    // Auto-sort: group by customer, then by order date within each group
    selectedOrders.sort((a, b) {
      final nameA = a.customer?.name.toLowerCase() ?? '';
      final nameB = b.customer?.name.toLowerCase() ?? '';
      final nameCompare = nameA.compareTo(nameB);
      if (nameCompare != 0) return nameCompare;
      return a.orderDate.compareTo(b.orderDate);
    });

    final planId = generateId('dp');
    final items = selectedOrders.asMap().entries.map((entry) {
      return DeliveryPlanItem(
        id: generateId('dpi'),
        deliveryPlanId: planId,
        order: entry.value,
        sortOrder: entry.key,
      );
    }).toList();

    final plan = DeliveryPlan(
      id: planId,
      createdAt: DateTime.now(),
      items: items,
    );

    await ref.read(deliveryPlanProvider.notifier).add(plan);

    if (mounted) {
      context.pop();
      context.push('/delivery-plan/$planId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(orderProvider);
    // Show non-finished orders
    final available = allOrders.where((o) => !o.isFinished).toList()
      ..sort((a, b) {
        final nameA = a.customer?.name.toLowerCase() ?? '';
        final nameB = b.customer?.name.toLowerCase() ?? '';
        final nameCompare = nameA.compareTo(nameB);
        if (nameCompare != 0) return nameCompare;
        return a.orderDate.compareTo(b.orderDate);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Select Orders')),
      floatingActionButton: _selectedIds.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _createPlan,
              icon: const Icon(Icons.check),
              label: Text('Create (${_selectedIds.length})'),
            ),
      body: available.isEmpty
          ? const Center(child: Text('No active orders available.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: available.length,
              itemBuilder: (context, index) {
                final order = available[index];
                final isSelected = _selectedIds.contains(order.id);
                final customerName = order.customer?.name ?? 'Unknown Customer';
                final hasPlans = order.deliveryPlanRefs.isNotEmpty;

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedIds.add(order.id);
                      } else {
                        _selectedIds.remove(order.id);
                      }
                    });
                  },
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$${order.orderTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.lineItems
                            .map((li) => '${li.productLabel} x ${li.quantity}')
                            .join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(_formatDate(order.orderDate)),
                          if (hasPlans) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.route,
                              size: 14,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'In ${order.deliveryPlanRefs.length} plan(s)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
