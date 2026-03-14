import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/id_generator.dart';
import '../../data/database/database.dart';
import '../../data/models/customer.dart';
import '../../data/models/customer_product_price.dart';
import '../../data/models/delivery_plan.dart';
import '../../data/models/delivery_plan_item.dart';
import '../../data/models/order.dart';
import '../../data/models/order_line_item.dart';
import '../../data/models/product.dart';
import '../../providers/customer_product_price_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/delivery_plan_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/database_providers.dart';

class DevPage extends ConsumerStatefulWidget {
  const DevPage({super.key});

  @override
  ConsumerState<DevPage> createState() => _DevPageState();
}

class _DevPageState extends ConsumerState<DevPage> {
  List<ErrorLogRow>? _logs;
  bool _loading = true;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final db = ref.read(databaseProvider);
    final logs = await db.errorLogRepo.getAll();
    if (mounted) {
      setState(() {
        _logs = logs;
        _loading = false;
      });
    }
  }

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Delete all error logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final db = ref.read(databaseProvider);
    await db.errorLogRepo.deleteAll();
    await _loadLogs();
  }

  Future<void> _seedFakeData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seed Fake Data'),
        content: const Text(
          'This will add sample customers, products, orders, and delivery '
          'plans to the app. Existing data will not be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Seed'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _seeding = true);

    try {
      await _doSeed();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Fake data added!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  Future<void> _doSeed() async {
    final now = DateTime.now();

    // --- Customers ---
    final customers = [
      Customer(
        id: generateId('cust'),
        name: 'Maria Garcia',
        address: '142 Oak Lane, Springfield',
        notes: 'Prefers delivery before 10am',
      ),
      Customer(
        id: generateId('cust'),
        name: 'James Wilson',
        address: '88 Pine Street, Riverside',
      ),
      Customer(
        id: generateId('cust'),
        name: 'Sun Valley Farm Stand',
        address: '2100 Valley Road',
        notes: 'Wholesale account, large orders',
      ),
      Customer(
        id: generateId('cust'),
        name: 'Linda Chen',
        address: '55 Maple Ave, Unit 3',
      ),
      Customer(
        id: generateId('cust'),
        name: 'Bob\'s Diner',
        address: '901 Main Street',
        notes: 'Back entrance for deliveries',
      ),
      Customer(
        id: generateId('cust'),
        name: 'Rachel Thompson',
        address: '17 Birch Court',
        isActive: false,
      ),
    ];

    for (final c in customers) {
      await ref.read(customerProvider.notifier).add(c);
    }

    // --- Products ---
    final products = [
      Product(
        id: generateId('prod'),
        label: 'Large Brown Eggs (dozen)',
        referencePrice: 5.50,
      ),
      Product(
        id: generateId('prod'),
        label: 'Large White Eggs (dozen)',
        referencePrice: 5.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Medium Brown Eggs (dozen)',
        referencePrice: 4.50,
      ),
      Product(
        id: generateId('prod'),
        label: 'Jumbo Eggs (dozen)',
        referencePrice: 7.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Duck Eggs (half dozen)',
        referencePrice: 8.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Quail Eggs (dozen)',
        referencePrice: 6.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Large Brown Eggs (flat of 30)',
        referencePrice: 12.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Egg Carton (empty)',
        referencePrice: 0.50,
      ),
      Product(
        id: generateId('prod'),
        label: 'Organic Large Brown (dozen)',
        referencePrice: 7.50,
      ),
      Product(
        id: generateId('prod'),
        label: 'Pickled Eggs (jar)',
        referencePrice: 9.00,
      ),
      Product(
        id: generateId('prod'),
        label: 'Small Eggs (dozen)',
        referencePrice: 3.50,
        isActive: false,
      ),
      Product(
        id: generateId('prod'),
        label: 'Cracked Eggs (discount)',
        referencePrice: 2.00,
      ),
    ];

    for (final p in products) {
      await ref.read(productProvider.notifier).add(p);
    }

    // --- Customer product price overrides ---
    // Sun Valley gets wholesale pricing
    final sunValley = customers[2];
    final overrides = [
      CustomerProductPrice(
        id: generateId('cpp'),
        customerId: sunValley.id,
        productId: products[0].id,
        overridePrice: 4.25,
      ),
      CustomerProductPrice(
        id: generateId('cpp'),
        customerId: sunValley.id,
        productId: products[1].id,
        overridePrice: 3.75,
      ),
      CustomerProductPrice(
        id: generateId('cpp'),
        customerId: sunValley.id,
        productId: products[6].id,
        overridePrice: 9.50,
      ),
      // Bob's Diner negotiates egg prices
      CustomerProductPrice(
        id: generateId('cpp'),
        customerId: customers[4].id,
        productId: products[0].id,
        isNegotiated: true,
      ),
      CustomerProductPrice(
        id: generateId('cpp'),
        customerId: customers[4].id,
        productId: products[3].id,
        overridePrice: 6.00,
      ),
    ];

    for (final o in overrides) {
      await ref
          .read(customerProductPriceProvider(o.customerId).notifier)
          .add(o);
    }

    // --- Orders ---
    // Helper to build an order
    Order makeOrder({
      required Customer customer,
      required DateTime date,
      required List<({Product product, int qty, double price})> items,
      bool delivered = false,
      bool paid = false,
      DateTime? deliveredDate,
      DateTime? paidDate,
      String note = '',
    }) {
      final orderId = generateId('ord');
      return Order(
        id: orderId,
        customer: customer,
        orderDate: date,
        isDelivered: delivered,
        isPaid: paid,
        deliveredDate: deliveredDate,
        paidDate: paidDate,
        note: note,
        lineItems: items
            .map(
              (i) => OrderLineItem(
                id: generateId('oli'),
                orderId: orderId,
                product: i.product,
                productLabel: i.product.label,
                quantity: i.qty,
                unitPrice: i.price,
              ),
            )
            .toList(),
      );
    }

    final orders = <Order>[
      // --- Finished orders (delivered + paid) ---
      makeOrder(
        customer: customers[0], // Maria
        date: now.subtract(const Duration(days: 45)),
        items: [(product: products[0], qty: 2, price: 5.50)],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 43)),
        paidDate: now.subtract(const Duration(days: 43)),
      ),
      makeOrder(
        customer: customers[1], // James
        date: now.subtract(const Duration(days: 40)),
        items: [
          (product: products[1], qty: 1, price: 5.00),
          (product: products[4], qty: 1, price: 8.00),
        ],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 38)),
        paidDate: now.subtract(const Duration(days: 35)),
      ),
      makeOrder(
        customer: customers[2], // Sun Valley
        date: now.subtract(const Duration(days: 35)),
        items: [
          (product: products[0], qty: 10, price: 4.25),
          (product: products[6], qty: 5, price: 9.50),
        ],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 33)),
        paidDate: now.subtract(const Duration(days: 30)),
      ),
      makeOrder(
        customer: customers[3], // Linda
        date: now.subtract(const Duration(days: 30)),
        items: [(product: products[0], qty: 1, price: 5.50)],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 28)),
        paidDate: now.subtract(const Duration(days: 28)),
      ),
      makeOrder(
        customer: customers[4], // Bob's Diner
        date: now.subtract(const Duration(days: 28)),
        items: [
          (product: products[0], qty: 5, price: 5.50),
          (product: products[3], qty: 3, price: 6.00),
          (product: products[9], qty: 2, price: 9.00),
        ],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 26)),
        paidDate: now.subtract(const Duration(days: 20)),
        note: 'Weekly standing order',
      ),
      makeOrder(
        customer: customers[0], // Maria again
        date: now.subtract(const Duration(days: 20)),
        items: [
          (product: products[0], qty: 2, price: 5.50),
          (product: products[8], qty: 1, price: 7.50),
        ],
        delivered: true,
        paid: true,
        deliveredDate: now.subtract(const Duration(days: 18)),
        paidDate: now.subtract(const Duration(days: 18)),
      ),

      // --- Delivered but not paid ---
      makeOrder(
        customer: customers[2], // Sun Valley
        date: now.subtract(const Duration(days: 14)),
        items: [
          (product: products[0], qty: 8, price: 4.25),
          (product: products[1], qty: 6, price: 3.75),
          (product: products[6], qty: 4, price: 9.50),
        ],
        delivered: true,
        deliveredDate: now.subtract(const Duration(days: 12)),
        note: 'Net 30 payment terms',
      ),
      makeOrder(
        customer: customers[4], // Bob's Diner
        date: now.subtract(const Duration(days: 10)),
        items: [
          (product: products[0], qty: 4, price: 5.50),
          (product: products[3], qty: 2, price: 6.00),
        ],
        delivered: true,
        deliveredDate: now.subtract(const Duration(days: 8)),
      ),

      // --- Paid but not delivered (prepaid) ---
      makeOrder(
        customer: customers[3], // Linda
        date: now.subtract(const Duration(days: 7)),
        items: [
          (product: products[0], qty: 3, price: 5.50),
          (product: products[5], qty: 1, price: 6.00),
        ],
        paid: true,
        paidDate: now.subtract(const Duration(days: 7)),
        note: 'Paid in advance, deliver Saturday',
      ),

      // --- New orders (not delivered, not paid) ---
      makeOrder(
        customer: customers[0], // Maria
        date: now.subtract(const Duration(days: 5)),
        items: [
          (product: products[0], qty: 2, price: 5.50),
          (product: products[4], qty: 1, price: 8.00),
        ],
      ),
      makeOrder(
        customer: customers[1], // James
        date: now.subtract(const Duration(days: 4)),
        items: [(product: products[8], qty: 2, price: 7.50)],
      ),
      makeOrder(
        customer: customers[2], // Sun Valley
        date: now.subtract(const Duration(days: 3)),
        items: [
          (product: products[0], qty: 12, price: 4.25),
          (product: products[6], qty: 6, price: 9.50),
        ],
        note: 'Farmer\'s market restock',
      ),
      makeOrder(
        customer: customers[3], // Linda
        date: now.subtract(const Duration(days: 2)),
        items: [(product: products[1], qty: 1, price: 5.00)],
      ),
      makeOrder(
        customer: customers[4], // Bob's Diner
        date: now.subtract(const Duration(days: 2)),
        items: [
          (product: products[0], qty: 6, price: 5.50),
          (product: products[3], qty: 4, price: 6.00),
          (product: products[11], qty: 2, price: 2.00),
        ],
        note: 'Usual weekly order',
      ),
      makeOrder(
        customer: customers[0], // Maria
        date: now.subtract(const Duration(days: 1)),
        items: [(product: products[0], qty: 1, price: 5.50)],
        note: 'Quick add-on for neighbor',
      ),
      makeOrder(
        customer: customers[1], // James
        date: now,
        items: [
          (product: products[0], qty: 2, price: 5.50),
          (product: products[9], qty: 1, price: 9.00),
        ],
      ),
      makeOrder(
        customer: customers[2], // Sun Valley
        date: now,
        items: [
          (product: products[0], qty: 15, price: 4.25),
          (product: products[1], qty: 10, price: 3.75),
        ],
        note: 'Weekend rush order',
      ),
      makeOrder(
        customer: customers[4], // Bob's Diner
        date: now,
        items: [
          (product: products[3], qty: 3, price: 6.00),
          (product: products[4], qty: 2, price: 8.00),
        ],
        note: 'Special brunch menu',
      ),
    ];

    for (final o in orders) {
      await ref.read(orderProvider.notifier).add(o);
    }

    // --- Delivery Plans ---
    // Plan 1: completed past delivery
    final plan1Id = generateId('dp');
    final plan1 = DeliveryPlan(
      id: plan1Id,
      name: 'Monday Route - Week 6',
      createdAt: now.subtract(const Duration(days: 34)),
      deliveryDate: now.subtract(const Duration(days: 33)),
      isFinished: true,
      items: [
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan1Id,
          order: orders[2],
          sortOrder: 0,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan1Id,
          order: orders[3],
          sortOrder: 1,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan1Id,
          order: orders[4],
          sortOrder: 2,
        ),
      ],
    );

    // Plan 2: completed recent delivery
    final plan2Id = generateId('dp');
    final plan2 = DeliveryPlan(
      id: plan2Id,
      name: 'Thursday Deliveries',
      createdAt: now.subtract(const Duration(days: 13)),
      deliveryDate: now.subtract(const Duration(days: 12)),
      isFinished: true,
      items: [
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan2Id,
          order: orders[6],
          sortOrder: 0,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan2Id,
          order: orders[7],
          sortOrder: 1,
        ),
      ],
    );

    // Plan 3: active upcoming delivery
    final plan3Id = generateId('dp');
    final plan3 = DeliveryPlan(
      id: plan3Id,
      name: 'Saturday Route',
      createdAt: now.subtract(const Duration(days: 1)),
      deliveryDate: now.add(const Duration(days: 2)),
      items: [
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan3Id,
          order: orders[9],
          sortOrder: 0,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan3Id,
          order: orders[11],
          sortOrder: 1,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan3Id,
          order: orders[13],
          sortOrder: 2,
        ),
        DeliveryPlanItem(
          id: generateId('dpi'),
          deliveryPlanId: plan3Id,
          order: orders[8],
          sortOrder: 3,
        ),
      ],
    );

    for (final plan in [plan1, plan2, plan3]) {
      await ref.read(deliveryPlanProvider.notifier).add(plan);
    }
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer'),
        actions: [
          if (_logs != null && _logs!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all logs',
              onPressed: _clearLogs,
            ),
        ],
      ),
      body: Column(
        children: [
          // Dev actions
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                onPressed: _seeding ? null : _seedFakeData,
                icon: _seeding
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.dataset),
                label: Text(_seeding ? 'Seeding...' : 'Add Fake Data'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ),

          if (kDebugMode) const Divider(height: 1),
          // Error logs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Error Logs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(child: _buildLogList()),
        ],
      ),
    );
  }

  Widget _buildLogList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final logs = _logs!;
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No errors logged.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return ExpansionTile(
          title: Text(
            log.errorMessage,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            _formatTimestamp(log.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (log.currentRoute.isNotEmpty)
                    _DetailRow(label: 'Route', value: log.currentRoute),
                  if (log.appVersion.isNotEmpty)
                    _DetailRow(label: 'Version', value: log.appVersion),
                  if (log.platform.isNotEmpty)
                    _DetailRow(label: 'Platform', value: log.platform),
                  if (log.stackTrace.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Stack Trace:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SelectableText(
                        log.stackTrace,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
