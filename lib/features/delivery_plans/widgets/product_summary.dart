import 'package:flutter/material.dart';

import '../../../data/models/delivery_plan.dart';

class ProductSummary extends StatelessWidget {
  final DeliveryPlan plan;

  const ProductSummary({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    // Aggregate: productLabel → total quantity
    final quantities = <String, int>{};
    for (final item in plan.items) {
      for (final li in item.order.lineItems) {
        quantities[li.productLabel] =
            (quantities[li.productLabel] ?? 0) + li.quantity;
      }
    }

    if (quantities.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = quantities.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Product Summary',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '\$${plan.totalValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: sorted.map((entry) {
                return Chip(
                  label: Text(
                    '${entry.key} × ${entry.value}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
