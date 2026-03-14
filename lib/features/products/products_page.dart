import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/product_provider.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  bool _showInactive = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    var filtered = _showInactive
        ? products
        : products.where((p) => p.isActive).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.label.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Sort alphabetically by label
    filtered.sort(
      (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search products...',
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
                        ? 'No products yet. Tap + to add one.'
                        : 'No products match your search.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ListTile(
                      title: Text(
                        product.label,
                        style: product.isActive
                            ? null
                            : TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontStyle: FontStyle.italic,
                              ),
                      ),
                      subtitle: Text(
                        product.referencePrice != null
                            ? '\$${product.referencePrice!.toStringAsFixed(2)}'
                            : 'No default price',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!product.isActive)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppConstants.paddingSmall,
                              ),
                              child: Text(
                                'Inactive',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => context.push('/product/${product.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
