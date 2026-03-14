import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/order_provider.dart';

class ReorderOrdersPage extends ConsumerStatefulWidget {
  final List<({String itemId, String orderId})> items;

  const ReorderOrdersPage({super.key, required this.items});

  @override
  ConsumerState<ReorderOrdersPage> createState() => _ReorderOrdersPageState();
}

class _ReorderOrdersPageState extends ConsumerState<ReorderOrdersPage> {
  late List<({String itemId, String orderId})> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(orderProvider);
    final orderMap = {for (final o in allOrders) o.id: o};

    return Scaffold(
      appBar: AppBar(title: const Text('Reorder Orders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(_items),
        child: const Icon(Icons.check),
      ),
      body: _items.isEmpty
          ? const Center(child: Text('No orders to reorder.'))
          : ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _items.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final entry = _items[index];
                final order = orderMap[entry.orderId];
                final customerName =
                    order?.customer?.name ?? 'Unknown Customer';
                final products =
                    order?.lineItems
                        .map((li) => '${li.productLabel} x ${li.quantity}')
                        .join(', ') ??
                    '';

                return ListTile(
                  key: ValueKey(entry.itemId),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_handle,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  title: Text(
                    customerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    products,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '\$${order?.orderTotal.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
    );
  }
}
