import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/utils/id_generator.dart';
import '../../data/models/customer.dart';
import '../../data/models/order.dart';
import '../../data/models/order_line_item.dart';
import '../../data/models/product.dart';
import '../../providers/customer_product_price_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/customer_search.dart';
import 'widgets/order_bottom_bar.dart';
import 'widgets/product_line_editor.dart';

class _LineItemFormData {
  final String key;
  String? existingId;
  Product? product;
  final TextEditingController qtyController;
  final TextEditingController priceController;

  _LineItemFormData({this.existingId, this.product, String? qty, String? price})
    : key = UniqueKey().toString(),
      qtyController = TextEditingController(text: qty ?? '1'),
      priceController = TextEditingController(text: price ?? '');

  double get lineTotal {
    final q = int.tryParse(qtyController.text) ?? 0;
    final p = double.tryParse(priceController.text) ?? 0;
    return q * p;
  }

  void dispose() {
    qtyController.dispose();
    priceController.dispose();
  }
}

class OrderFormPage extends ConsumerStatefulWidget {
  final String? orderId;

  const OrderFormPage({super.key, this.orderId});

  bool get isEditing => orderId != null;

  @override
  ConsumerState<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends ConsumerState<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Customer
  Customer? _selectedCustomer;

  // Dates
  DateTime _orderDate = DateTime.now();

  // Status (edit mode)
  bool _isDelivered = false;
  bool _isPaid = false;
  DateTime? _deliveredDate;
  DateTime? _paidDate;
  bool _originalIsDelivered = false;
  bool _originalIsPaid = false;

  // Line items
  final List<_LineItemFormData> _lineItems = [];

  // Note
  final _noteController = TextEditingController();

  // Delivery plan refs (edit mode, read-only)
  List<DeliveryPlanRef> _deliveryPlanRefs = [];

  bool _initialized = false;

  @override
  void dispose() {
    _noteController.dispose();
    for (final li in _lineItems) {
      li.dispose();
    }
    super.dispose();
  }

  void _initFromOrder(Order order) {
    if (!_initialized) {
      _selectedCustomer = order.customer;
      _orderDate = order.orderDate;
      _isDelivered = order.isDelivered;
      _isPaid = order.isPaid;
      _deliveredDate = order.deliveredDate;
      _paidDate = order.paidDate;
      _originalIsDelivered = order.isDelivered;
      _originalIsPaid = order.isPaid;
      _noteController.text = order.note;
      _deliveryPlanRefs = order.deliveryPlanRefs;

      for (final li in order.lineItems) {
        _lineItems.add(
          _LineItemFormData(
            existingId: li.id,
            product: li.product,
            qty: li.quantity.toString(),
            price: li.unitPrice.toStringAsFixed(2),
          ),
        );
      }

      _initialized = true;
    }
  }

  void _onCustomerSelected(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }

  void _addLineItem() {
    setState(() {
      _lineItems.add(_LineItemFormData());
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      _lineItems[index].dispose();
      _lineItems.removeAt(index);
    });
  }

  double get _orderTotal =>
      _lineItems.fold(0.0, (sum, li) => sum + li.lineTotal);

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _pickDate({
    required DateTime? initialDate,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  Future<bool?> _showWarningDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a customer')));
      return;
    }

    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one product')),
      );
      return;
    }

    for (final li in _lineItems) {
      if (li.product == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a product for each line item'),
          ),
        );
        return;
      }
    }

    // Check warnings in edit mode
    if (widget.isEditing) {
      final settings = ref.read(settingsProvider);

      if (_originalIsDelivered && !_isDelivered && settings.warnOnUndeliver) {
        final confirmed = await _showWarningDialog(
          'Un-mark Delivered',
          'This order was marked as delivered. Are you sure you want to un-mark it?',
        );
        if (confirmed != true) return;
      }

      if (_originalIsPaid && !_isPaid && settings.warnOnUnpaid) {
        final confirmed = await _showWarningDialog(
          'Un-mark Paid',
          'This order was marked as paid. Are you sure you want to un-mark it?',
        );
        if (confirmed != true) return;
      }
    }

    final orderId = widget.isEditing ? widget.orderId! : generateId('ord');

    final lineItems = _lineItems.map((li) {
      return OrderLineItem(
        id: li.existingId ?? generateId('oli'),
        orderId: orderId,
        product: li.product,
        productLabel: li.product!.label,
        quantity: int.tryParse(li.qtyController.text) ?? 1,
        unitPrice: double.tryParse(li.priceController.text) ?? 0,
      );
    }).toList();

    final order = Order(
      id: orderId,
      customer: _selectedCustomer,
      isDelivered: _isDelivered,
      isPaid: _isPaid,
      orderDate: _orderDate,
      deliveredDate: _deliveredDate,
      paidDate: _paidDate,
      note: _noteController.text.trim(),
      lineItems: lineItems,
      deliveryPlanRefs: _deliveryPlanRefs,
    );

    final notifier = ref.read(orderProvider.notifier);
    if (widget.isEditing) {
      await notifier.update(order);
    } else {
      await notifier.add(order);
    }

    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final settings = ref.read(settingsProvider);

    if (settings.warnOnDelete) {
      final confirmed = await _showWarningDialog(
        'Delete Order',
        'Are you sure you want to delete this order? This cannot be undone.',
      );
      if (confirmed != true) return;
    }

    await ref.read(orderProvider.notifier).delete(widget.orderId!);
    if (mounted) context.pop();
  }

  List<Product> _productsForLineItem(
    List<Product> activeProducts,
    Product? current,
  ) {
    if (current != null && !current.isActive) {
      return [current, ...activeProducts];
    }
    return activeProducts;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      final order = ref.watch(orderByIdProvider(widget.orderId!));
      if (order == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Order')),
          body: const Center(child: Text('Order not found.')),
        );
      }
      _initFromOrder(order);
    }

    final activeCustomers = ref
        .watch(customerProvider)
        .where((c) => c.isActive)
        .toList();
    activeCustomers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    // Include current customer even if inactive
    final customersForDropdown =
        _selectedCustomer != null &&
            !_selectedCustomer!.isActive &&
            !activeCustomers.any((c) => c.id == _selectedCustomer!.id)
        ? [_selectedCustomer!, ...activeCustomers]
        : activeCustomers;

    final priceMap = ref.watch(customerPriceMapProvider(_selectedCustomer?.id));

    final activeProducts = ref
        .watch(productProvider)
        .where((p) => p.isActive)
        .toList();
    activeProducts.sort(
      (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Order' : 'New Order'),
        actions: [
          if (widget.isEditing)
            IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
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
                      // --- Customer section ---
                      const Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      CustomerSearch(
                        customers: customersForDropdown,
                        selectedCustomer: _selectedCustomer,
                        onSelected: _onCustomerSelected,
                        onCleared: () =>
                            setState(() => _selectedCustomer = null),
                        onCustomerCreated: (id) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final c = ref.read(customerByIdProvider(id));
                            if (c != null) _onCustomerSelected(c);
                          });
                        },
                      ),

                      // Show customer info read-only
                      if (_selectedCustomer != null) ...[
                        const SizedBox(height: AppConstants.paddingSmall),
                        if (_selectedCustomer!.address.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppConstants.paddingSmall,
                            ),
                            child: Text(
                              _selectedCustomer!.address,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        if (_selectedCustomer!.notes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppConstants.paddingSmall,
                              top: 4,
                            ),
                            child: Text(
                              _selectedCustomer!.notes,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                      ],

                      const SizedBox(height: AppConstants.paddingMedium),

                      // --- Status toggles (edit mode) ---
                      if (widget.isEditing) ...[
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Delivered'),
                                value: _isDelivered,
                                onChanged: (value) {
                                  setState(() {
                                    _isDelivered = value;
                                    if (value) {
                                      _deliveredDate ??= DateTime.now();
                                    } else {
                                      _deliveredDate = null;
                                    }
                                  });
                                },
                              ),
                            ),
                            if (_isDelivered)
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                label: Text(
                                  _deliveredDate != null
                                      ? _formatDate(_deliveredDate!)
                                      : 'Not set',
                                ),
                                onPressed: () => _pickDate(
                                  initialDate: _deliveredDate,
                                  onPicked: (d) =>
                                      setState(() => _deliveredDate = d),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Paid'),
                                value: _isPaid,
                                onChanged: (value) {
                                  setState(() {
                                    _isPaid = value;
                                    if (value) {
                                      _paidDate ??= DateTime.now();
                                    } else {
                                      _paidDate = null;
                                    }
                                  });
                                },
                              ),
                            ),
                            if (_isPaid)
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                label: Text(
                                  _paidDate != null
                                      ? _formatDate(_paidDate!)
                                      : 'Not set',
                                ),
                                onPressed: () => _pickDate(
                                  initialDate: _paidDate,
                                  onPicked: (d) =>
                                      setState(() => _paidDate = d),
                                ),
                              ),
                          ],
                        ),
                      ],

                      // --- Delivery plan refs (edit mode) ---
                      if (widget.isEditing && _deliveryPlanRefs.isNotEmpty) ...[
                        const Divider(),
                        const Text(
                          'Delivery Plans',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Wrap(
                          spacing: AppConstants.paddingSmall,
                          children: _deliveryPlanRefs.map((planRef) {
                            return ActionChip(
                              label: Text(
                                planRef.name.isNotEmpty
                                    ? planRef.name
                                    : 'Unnamed Plan',
                              ),
                              onPressed: () =>
                                  context.push('/delivery-plan/${planRef.id}'),
                            );
                          }).toList(),
                        ),
                      ],

                      const Divider(),

                      // --- Line items ---
                      Row(
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'Create New Product',
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.push('/product/new');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),

                      ..._lineItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final li = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.paddingSmall,
                          ),
                          child: ProductLineEditor(
                            products: _productsForLineItem(
                              activeProducts,
                              li.product,
                            ),
                            selectedProduct: li.product,
                            qtyController: li.qtyController,
                            priceController: li.priceController,
                            lineTotal: li.lineTotal,
                            productSubtitleBuilder: (p) {
                              final override = priceMap[p.id];
                              if (override != null) {
                                if (override.isNegotiated) return 'Negotiated';
                                if (override.overridePrice != null) {
                                  return '\$${override.overridePrice!.toStringAsFixed(2)}';
                                }
                              }
                              if (p.referencePrice != null) {
                                return '\$${p.referencePrice!.toStringAsFixed(2)}';
                              }
                              return '';
                            },
                            onProductSelected: (product) {
                              setState(() {
                                li.product = product;
                                final override = priceMap[product.id];
                                if (override != null) {
                                  if (override.isNegotiated) {
                                    li.priceController.text = '';
                                  } else if (override.overridePrice != null) {
                                    li.priceController.text = override
                                        .overridePrice!
                                        .toStringAsFixed(2);
                                  } else {
                                    li.priceController.text = '';
                                  }
                                } else if (product.referencePrice != null) {
                                  li.priceController.text = product
                                      .referencePrice!
                                      .toStringAsFixed(2);
                                } else {
                                  li.priceController.text = '';
                                }
                              });
                            },
                            onProductCleared: () =>
                                setState(() => li.product = null),
                            onRemove: () => _removeLineItem(index),
                            onChanged: () => setState(() {}),
                          ),
                        );
                      }),

                      if (_lineItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text('No products added yet.')),
                        ),

                      Center(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product to Order'),
                          onPressed: _addLineItem,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                          ),
                        ),
                      ),

                      const Divider(),

                      // --- Order Date ---
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _pickDate(
                          initialDate: _orderDate,
                          onPicked: (d) => setState(() => _orderDate = d),
                        ),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Order Date',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            suffixIcon: Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(_formatDate(_orderDate)),
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),

                      // --- Note ---
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'Order Note',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                      ),
                      // Extra space so product dropdowns can scroll to the top
                      const SizedBox(height: 300),
                    ],
                  ),
                ),
              ),

              // --- Bottom bar ---
              OrderBottomBar(total: _orderTotal, onSave: _save),
            ],
          ),
        ),
      ),
    );
  }
}
