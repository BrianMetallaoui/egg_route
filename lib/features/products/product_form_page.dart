import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/utils/id_generator.dart';
import '../../data/models/product.dart';
import '../../providers/product_provider.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormPage({super.key, this.productId});

  bool get isEditing => productId != null;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _priceController;
  bool _isActive = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _initFromProduct(Product product) {
    if (!_initialized) {
      _labelController.text = product.label;
      _priceController.text = product.referencePrice?.toStringAsFixed(2) ?? '';
      _isActive = product.isActive;
      _initialized = true;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(productProvider.notifier);
    final priceText = _priceController.text.trim();
    final price = priceText.isEmpty ? null : double.tryParse(priceText);
    String? savedId;

    if (widget.isEditing) {
      final existing = ref.read(productByIdProvider(widget.productId!));
      if (existing == null) return;
      await notifier.update(
        existing.copyWith(
          label: _labelController.text.trim(),
          referencePrice: () => price,
          isActive: _isActive,
        ),
      );
      savedId = widget.productId;
    } else {
      final product = Product(
        id: generateId('prod'),
        label: _labelController.text.trim(),
        referencePrice: price,
        isActive: _isActive,
      );
      await notifier.add(product);
      savedId = product.id;
    }

    if (mounted) context.pop(savedId);
  }

  Future<void> _delete() async {
    // Soft-delete: set inactive
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Product'),
        content: const Text(
          'This will mark the product as inactive. It will still appear on existing orders.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productProvider.notifier).softDelete(widget.productId!);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      final product = ref.watch(productByIdProvider(widget.productId!));
      if (product == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Product')),
          body: const Center(child: Text('Product not found.')),
        );
      }
      _initFromProduct(product);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'New Product'),
        actions: [
          if (widget.isEditing)
            IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  children: [
                    TextFormField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Label is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Reference Price',
                        prefixText: '\$ ',
                        hintText: '0.00',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed < 0) {
                            return 'Enter a valid price';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    SwitchListTile(
                      title: const Text('Active'),
                      subtitle: Text(
                        _isActive
                            ? 'Product is available for new orders'
                            : 'Product is inactive and hidden from new orders',
                      ),
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
