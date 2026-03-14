import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/order_provider.dart';

class AddOrdersPage extends ConsumerStatefulWidget {
  final String planId;
  final Set<String> excludedOrderIds;

  const AddOrdersPage({
    super.key,
    required this.planId,
    this.excludedOrderIds = const {},
  });

  @override
  ConsumerState<AddOrdersPage> createState() => _AddOrdersPageState();
}

class _AddOrdersPageState extends ConsumerState<AddOrdersPage> {
  final Set<String> _selectedIds = {};

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(orderProvider);

    // Show non-finished orders not already in this plan
    final available =
        allOrders
            .where(
              (o) => !o.isFinished && !widget.excludedOrderIds.contains(o.id),
            )
            .toList()
          ..sort((a, b) {
            final nameA = a.customer?.name.toLowerCase() ?? '';
            final nameB = b.customer?.name.toLowerCase() ?? '';
            final nameCompare = nameA.compareTo(nameB);
            if (nameCompare != 0) return nameCompare;
            return a.orderDate.compareTo(b.orderDate);
          });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Orders')),
      floatingActionButton: _selectedIds.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.pop(_selectedIds.toList()),
              icon: const Icon(Icons.check),
              label: Text('Add (${_selectedIds.length})'),
            ),
      body: available.isEmpty
          ? const Center(child: Text('No more orders to add.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: available.length,
              itemBuilder: (context, index) {
                final order = available[index];
                final isSelected = _selectedIds.contains(order.id);
                final customerName = order.customer?.name ?? 'Unknown Customer';

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
                  subtitle: Text(
                    '${_formatDate(order.orderDate)}  •  ${order.lineItems.map((li) => '${li.productLabel} x ${li.quantity}').join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
    );
  }
}
