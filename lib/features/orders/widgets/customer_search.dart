import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/customer.dart';
import '../../../widgets/searchable_dropdown.dart';

class CustomerSearch extends StatelessWidget {
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final ValueChanged<Customer> onSelected;
  final VoidCallback? onCleared;
  final ValueChanged<String>? onCustomerCreated;

  const CustomerSearch({
    super.key,
    required this.customers,
    this.selectedCustomer,
    required this.onSelected,
    this.onCleared,
    this.onCustomerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<Customer>(
      items: customers,
      labelBuilder: (c) => c.name,
      subtitleBuilder: (c) => c.address,
      selectedItem: selectedCustomer,
      onSelected: onSelected,
      onCleared: onCleared,
      hintText: 'Search customers...',
      trailingAction: IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add Customer',
        onPressed: () async {
          FocusScope.of(context).unfocus();
          final result = await context.push<String>('/customer/new');
          if (result != null) {
            onCustomerCreated?.call(result);
          }
        },
      ),
    );
  }
}
