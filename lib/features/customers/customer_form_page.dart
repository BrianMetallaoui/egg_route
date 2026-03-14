import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/utils/id_generator.dart';
import '../../data/models/customer.dart';
import '../../data/models/customer_product_price.dart';
import '../../data/models/product.dart';
import '../../providers/customer_product_price_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/searchable_dropdown.dart';

class CustomerFormPage extends ConsumerStatefulWidget {
  final String? customerId;

  const CustomerFormPage({super.key, this.customerId});

  bool get isEditing => customerId != null;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  bool _isActive = true;
  bool _initialized = false;

  // Local overrides state — only committed on save
  List<CustomerProductPrice> _localOverrides = [];
  List<CustomerProductPrice> _originalOverrides = [];
  bool _overridesInitialized = false;

  // Add override form state
  bool _showAddOverride = false;
  Product? _pendingProduct;
  bool _pendingNegotiated = false;
  final _pendingPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _pendingPriceController.dispose();
    super.dispose();
  }

  void _initFromCustomer(Customer customer) {
    if (!_initialized) {
      _nameController.text = customer.name;
      _addressController.text = customer.address;
      _notesController.text = customer.notes;
      _isActive = customer.isActive;
      _initialized = true;
    }
  }

  void _initOverrides(List<CustomerProductPrice> dbOverrides) {
    if (!_overridesInitialized) {
      _localOverrides = List.from(dbOverrides);
      _originalOverrides = List.from(dbOverrides);
      _overridesInitialized = true;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(customerProvider.notifier);
    String? savedId;

    if (widget.isEditing) {
      final existing = ref.read(customerByIdProvider(widget.customerId!));
      if (existing == null) return;
      await notifier.update(
        existing.copyWith(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          isActive: _isActive,
        ),
      );
      savedId = widget.customerId;

      // Commit override changes by diffing local vs original
      await _commitOverrides();
    } else {
      final customer = Customer(
        id: generateId('cust'),
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
      );
      await notifier.add(customer);
      savedId = customer.id;
    }

    if (mounted) context.pop(savedId);
  }

  Future<void> _commitOverrides() async {
    final priceNotifier = ref.read(
      customerProductPriceProvider(widget.customerId!).notifier,
    );

    final originalIds = _originalOverrides.map((o) => o.id).toSet();
    final localIds = _localOverrides.map((o) => o.id).toSet();

    // Deleted: in original but not in local
    for (final orig in _originalOverrides) {
      if (!localIds.contains(orig.id)) {
        await priceNotifier.delete(orig.id);
      }
    }

    // Added: in local but not in original
    for (final local in _localOverrides) {
      if (!originalIds.contains(local.id)) {
        await priceNotifier.add(local);
      }
    }

    // Updated: in both, check if changed
    for (final local in _localOverrides) {
      if (originalIds.contains(local.id)) {
        final orig = _originalOverrides.firstWhere((o) => o.id == local.id);
        if (local.isNegotiated != orig.isNegotiated ||
            local.overridePrice != orig.overridePrice) {
          await priceNotifier.update(local);
        }
      }
    }
  }

  void _addOverrideToLocal() {
    if (_pendingProduct == null) return;
    if (!_pendingNegotiated && _pendingPriceController.text.trim().isEmpty) {
      return;
    }

    final cpp = CustomerProductPrice(
      id: generateId('cpp'),
      customerId: widget.customerId!,
      productId: _pendingProduct!.id,
      isNegotiated: _pendingNegotiated,
      overridePrice: _pendingNegotiated
          ? null
          : double.tryParse(_pendingPriceController.text.trim()),
      product: _pendingProduct,
    );

    setState(() {
      _localOverrides.add(cpp);
      _showAddOverride = false;
      _pendingProduct = null;
      _pendingNegotiated = false;
      _pendingPriceController.clear();
    });
  }

  void _cancelAddOverride() {
    setState(() {
      _showAddOverride = false;
      _pendingProduct = null;
      _pendingNegotiated = false;
      _pendingPriceController.clear();
    });
  }

  void _updateLocalOverride(CustomerProductPrice updated) {
    setState(() {
      final idx = _localOverrides.indexWhere((o) => o.id == updated.id);
      if (idx >= 0) {
        _localOverrides[idx] = updated;
      }
    });
  }

  void _deleteLocalOverride(String id) {
    setState(() {
      _localOverrides.removeWhere((o) => o.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      final customer = ref.watch(customerByIdProvider(widget.customerId!));
      if (customer == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Customer')),
          body: const Center(child: Text('Customer not found.')),
        );
      }
      _initFromCustomer(customer);

      // Snapshot overrides once for local editing
      final dbOverrides = ref.watch(
        customerProductPriceProvider(widget.customerId!),
      );
      _initOverrides(dbOverrides);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Customer' : 'New Customer'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                      ),
                      if (widget.isEditing) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          subtitle: Text(
                            _isActive
                                ? 'Customer available for new orders'
                                : 'Customer hidden from new orders',
                          ),
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
                        ),
                        const Divider(),
                        _buildProductPricesSection(),
                      ],
                      const SizedBox(height: 200),
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
      ),
    );
  }

  Widget _buildProductPricesSection() {
    final allProducts = ref.watch(productProvider);
    final activeProducts = allProducts.where((p) => p.isActive).toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    // Products not yet overridden (check local state)
    final overriddenIds = _localOverrides.map((o) => o.productId).toSet();
    final availableProducts = activeProducts
        .where((p) => !overriddenIds.contains(p.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Product Prices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (!_showAddOverride)
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add price override',
                onPressed: availableProducts.isEmpty
                    ? null
                    : () => setState(() => _showAddOverride = true),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),

        // Existing overrides (from local state)
        ..._localOverrides.map(
          (cpp) => _OverrideRow(
            cpp: cpp,
            onUpdate: _updateLocalOverride,
            onDelete: () => _deleteLocalOverride(cpp.id),
          ),
        ),

        if (_localOverrides.isEmpty && !_showAddOverride)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No product price overrides.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

        // Add new override form
        if (_showAddOverride)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchableDropdown<Product>(
                    items: availableProducts,
                    labelBuilder: (p) => p.label,
                    subtitleBuilder: (p) => p.referencePrice != null
                        ? '\$${p.referencePrice!.toStringAsFixed(2)}'
                        : '',
                    selectedItem: _pendingProduct,
                    onSelected: (p) => setState(() => _pendingProduct = p),
                    onCleared: () => setState(() => _pendingProduct = null),
                    hintText: 'Search products...',
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Always negotiated'),
                    subtitle: const Text('Price left blank on new orders'),
                    value: _pendingNegotiated,
                    onChanged: (value) =>
                        setState(() => _pendingNegotiated = value!),
                  ),
                  if (!_pendingNegotiated) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pendingPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Override Price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _cancelAddOverride,
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _pendingProduct != null
                            ? _addOverrideToLocal
                            : null,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _OverrideRow extends StatefulWidget {
  final CustomerProductPrice cpp;
  final ValueChanged<CustomerProductPrice> onUpdate;
  final VoidCallback onDelete;

  const _OverrideRow({
    required this.cpp,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_OverrideRow> createState() => _OverrideRowState();
}

class _OverrideRowState extends State<_OverrideRow> {
  late final TextEditingController _priceController;
  late bool _isNegotiated;

  @override
  void initState() {
    super.initState();
    _isNegotiated = widget.cpp.isNegotiated;
    _priceController = TextEditingController(
      text: widget.cpp.overridePrice?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    widget.onUpdate(
      widget.cpp.copyWith(
        isNegotiated: _isNegotiated,
        overridePrice: () => _isNegotiated
            ? null
            : double.tryParse(_priceController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productLabel = widget.cpp.product?.label ?? 'Unknown Product';
    final defaultPrice = widget.cpp.product?.referencePrice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (defaultPrice != null)
                        Text(
                          'Default: \$${defaultPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: 'Remove override',
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Always negotiated'),
              value: _isNegotiated,
              onChanged: (value) {
                setState(() => _isNegotiated = value!);
                _notifyParent();
              },
            ),
            if (!_isNegotiated) ...[
              const SizedBox(height: 4),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Override Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => _notifyParent(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
