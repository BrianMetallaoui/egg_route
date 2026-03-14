import 'package:flutter/material.dart';

import '../../../data/models/product.dart';
import '../../../widgets/searchable_dropdown.dart';

class ProductLineEditor extends StatelessWidget {
  final List<Product> products;
  final Product? selectedProduct;
  final TextEditingController qtyController;
  final TextEditingController priceController;
  final double lineTotal;
  final ValueChanged<Product> onProductSelected;
  final VoidCallback? onProductCleared;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final String Function(Product)? productSubtitleBuilder;

  const ProductLineEditor({
    super.key,
    required this.products,
    this.selectedProduct,
    required this.qtyController,
    required this.priceController,
    required this.lineTotal,
    required this.onProductSelected,
    this.onProductCleared,
    required this.onRemove,
    required this.onChanged,
    this.productSubtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchableDropdown<Product>(
                    items: products,
                    labelBuilder: (p) => p.label,
                    subtitleBuilder:
                        productSubtitleBuilder ??
                        (p) => p.referencePrice != null
                            ? '\$${p.referencePrice!.toStringAsFixed(2)}'
                            : '',
                    selectedItem: selectedProduct,
                    onSelected: onProductSelected,
                    onCleared: onProductCleared,
                    hintText: 'Search products...',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Remove',
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: qtyController,
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '';
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed < 1) return '';
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('\u00d7'),
                ),
                Expanded(
                  child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => onChanged(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '';
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0) return '';
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('='),
                ),
                Text(
                  '\$${lineTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
