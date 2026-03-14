import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/customer_product_price_provider.dart';
import '../../providers/customer_provider.dart';

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  bool _showInactive = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider);
    var filtered = _showInactive
        ? customers
        : customers.where((c) => c.isActive).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Sort alphabetically by name
    filtered.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search customers...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Row(
            children: [
              const Spacer(),
              FilterChip(
                label: const Text('Show inactive'),
                selected: _showInactive,
                onSelected: (value) => setState(() => _showInactive = value),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'No customers yet. Tap + to add one.'
                        : 'No customers match your search.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final customer = filtered[index];
                    return _CustomerTile(
                      customerId: customer.id,
                      name: customer.name,
                      address: customer.address,
                      isActive: customer.isActive,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CustomerTile extends ConsumerWidget {
  final String customerId;
  final String name;
  final String address;
  final bool isActive;

  const _CustomerTile({
    required this.customerId,
    required this.name,
    required this.address,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(customerProductPriceProvider(customerId));
    final count = prices.length;

    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: isActive ? null : Theme.of(context).disabledColor,
        ),
      ),
      subtitle: Text(
        [
          if (address.isNotEmpty) address,
          if (count > 0)
            '$count custom product ${count == 1 ? 'price' : 'prices'}',
        ].join('\n'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isActive)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: const Text('Inactive'),
                visualDensity: VisualDensity.compact,
              ),
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => context.push('/customer/$customerId'),
    );
  }
}
