import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class OrderBottomBar extends StatelessWidget {
  final double total;
  final VoidCallback onSave;

  const OrderBottomBar({super.key, required this.total, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: [
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          FilledButton(onPressed: onSave, child: const Text('Save')),
        ],
      ),
    );
  }
}
