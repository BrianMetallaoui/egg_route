import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/utils/id_generator.dart';
import '../../data/models/delivery_plan.dart';
import '../../data/models/delivery_plan_item.dart';
import '../../providers/delivery_plan_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../orders/widgets/order_card.dart';
import 'reorder_orders_page.dart';
import 'widgets/product_summary.dart';

enum _TriFilter { all, yes, no }

class _LocalPlanItem {
  final String itemId;
  final String orderId;
  final int sortOrder;

  const _LocalPlanItem({
    required this.itemId,
    required this.orderId,
    required this.sortOrder,
  });
}

class DeliveryPlanDetailPage extends ConsumerStatefulWidget {
  final String planId;

  const DeliveryPlanDetailPage({super.key, required this.planId});

  @override
  ConsumerState<DeliveryPlanDetailPage> createState() =>
      _DeliveryPlanDetailPageState();
}

class _DeliveryPlanDetailPageState
    extends ConsumerState<DeliveryPlanDetailPage> {
  late final TextEditingController _nameController;
  DateTime? _deliveryDate;
  bool _isFinished = false;
  List<_LocalPlanItem> _localItems = [];
  bool _initialized = false;

  _TriFilter _deliveredFilter = _TriFilter.no;
  _TriFilter _paidFilter = _TriFilter.all;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initFromPlan(DeliveryPlan plan) {
    _nameController.text = plan.name;
    _deliveryDate = plan.deliveryDate;
    _isFinished = plan.isFinished;
    _localItems = plan.items
        .map(
          (i) => _LocalPlanItem(
            itemId: i.id,
            orderId: i.orderId,
            sortOrder: i.sortOrder,
          ),
        )
        .toList();
    _initialized = true;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _pickDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _deliveryDate = picked);
    }
  }

  List<DeliveryPlanItem> _resolveItems() {
    final allOrders = ref.read(orderProvider);
    final orderMap = {for (final o in allOrders) o.id: o};
    return _localItems
        .where((li) => orderMap.containsKey(li.orderId))
        .map(
          (li) => DeliveryPlanItem(
            id: li.itemId,
            deliveryPlanId: widget.planId,
            order: orderMap[li.orderId]!,
            sortOrder: li.sortOrder,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<void> _save() async {
    final dbPlan = ref.read(deliveryPlanByIdProvider(widget.planId));
    if (dbPlan == null) return;

    final resolvedItems = _resolveItems();

    await ref
        .read(deliveryPlanProvider.notifier)
        .update(
          dbPlan.copyWith(
            name: _nameController.text.trim(),
            deliveryDate: () => _deliveryDate,
            isFinished: _isFinished,
            items: resolvedItems,
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _deletePlan() async {
    final confirmed = await _showConfirmDialog(
      'Delete Plan',
      'Delete this delivery plan? Orders will not be affected.',
    );
    if (confirmed != true) return;
    await ref.read(deliveryPlanProvider.notifier).delete(widget.planId);
    if (mounted) context.pop();
  }

  Future<void> _deleteOrder(String orderId) async {
    final settings = ref.read(settingsProvider);
    if (settings.warnOnDelete) {
      final confirmed = await _showConfirmDialog(
        'Delete Order',
        'Are you sure you want to delete this order? This cannot be undone.',
      );
      if (confirmed != true) return;
    }
    await ref.read(orderProvider.notifier).delete(orderId);
    setState(() {
      _localItems.removeWhere((li) => li.orderId == orderId);
    });
  }

  Future<void> _removeFromPlan(String orderId) async {
    final settings = ref.read(settingsProvider);
    if (settings.warnOnPlanRemove) {
      final confirmed = await _showConfirmDialog(
        'Remove from Plan',
        'Remove this order from the delivery plan?',
      );
      if (confirmed != true) return;
    }
    setState(() {
      _localItems.removeWhere((li) => li.orderId == orderId);
      for (var i = 0; i < _localItems.length; i++) {
        _localItems[i] = _LocalPlanItem(
          itemId: _localItems[i].itemId,
          orderId: _localItems[i].orderId,
          sortOrder: i,
        );
      }
    });
  }

  Future<void> _markAllDelivered() async {
    final settings = ref.read(settingsProvider);
    if (settings.warnOnPlanDeliver) {
      final confirmed = await _showConfirmDialog(
        'Mark All Delivered',
        'Mark all orders in this plan as delivered?',
      );
      if (confirmed != true) return;
    }

    final allOrders = ref.read(orderProvider);
    final orderMap = {for (final o in allOrders) o.id: o};
    for (final li in _localItems) {
      final order = orderMap[li.orderId];
      if (order != null && !order.isDelivered) {
        await ref.read(orderProvider.notifier).markDelivered(li.orderId, true);
      }
    }
  }

  Future<void> _addOrders() async {
    final excludedIds = _localItems.map((li) => li.orderId).toSet();
    final selectedIds = await context.push<List<String>>(
      '/delivery-plan/${widget.planId}/add',
      extra: excludedIds,
    );
    if (selectedIds != null && selectedIds.isNotEmpty) {
      setState(() {
        var sortOrder = _localItems.length;
        for (final orderId in selectedIds) {
          if (_localItems.any((li) => li.orderId == orderId)) continue;
          _localItems.add(
            _LocalPlanItem(
              itemId: generateId('dpi'),
              orderId: orderId,
              sortOrder: sortOrder++,
            ),
          );
        }
      });
    }
  }

  Future<void> _reorderOrders() async {
    final reordered = await Navigator.of(context)
        .push<List<({String itemId, String orderId})>>(
          MaterialPageRoute(
            builder: (_) => ReorderOrdersPage(
              items: _localItems
                  .map((li) => (itemId: li.itemId, orderId: li.orderId))
                  .toList(),
            ),
          ),
        );
    if (reordered != null) {
      setState(() {
        _localItems = reordered
            .asMap()
            .entries
            .map(
              (e) => _LocalPlanItem(
                itemId: e.value.itemId,
                orderId: e.value.orderId,
                sortOrder: e.key,
              ),
            )
            .toList();
      });
    }
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbPlan = ref.watch(deliveryPlanByIdProvider(widget.planId));
    if (dbPlan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Delivery Plan')),
        body: const Center(child: Text('Plan not found.')),
      );
    }

    if (!_initialized) {
      _initFromPlan(dbPlan);
    }

    final allOrders = ref.watch(orderProvider);
    final orderMap = {for (final o in allOrders) o.id: o};

    // Resolve local items to full DeliveryPlanItems
    final allItems =
        _localItems
            .where((li) => orderMap.containsKey(li.orderId))
            .map(
              (li) => DeliveryPlanItem(
                id: li.itemId,
                deliveryPlanId: widget.planId,
                order: orderMap[li.orderId]!,
                sortOrder: li.sortOrder,
              ),
            )
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // Apply filters for display
    var displayItems = allItems.toList();
    if (_deliveredFilter == _TriFilter.yes) {
      displayItems = displayItems.where((i) => i.order.isDelivered).toList();
    } else if (_deliveredFilter == _TriFilter.no) {
      displayItems = displayItems.where((i) => !i.order.isDelivered).toList();
    }
    if (_paidFilter == _TriFilter.yes) {
      displayItems = displayItems.where((i) => i.order.isPaid).toList();
    } else if (_paidFilter == _TriFilter.no) {
      displayItems = displayItems.where((i) => !i.order.isPaid).toList();
    }

    // Temp plan for product summary (uses ALL items, not filtered)
    final tempPlan = DeliveryPlan(
      id: widget.planId,
      createdAt: dbPlan.createdAt,
      items: allItems,
    );

    final allDelivered =
        allItems.isNotEmpty && allItems.every((i) => i.order.isDelivered);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete plan',
            onPressed: _deletePlan,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan name + delivery date on one row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Plan Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 140,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: _pickDeliveryDate,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Date',
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      suffixIcon: _deliveryDate != null
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 18,
                                              ),
                                              onPressed: () => setState(
                                                () => _deliveryDate = null,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                            ),
                                    ),
                                    child: Text(
                                      _deliveryDate != null
                                          ? _formatDate(_deliveryDate!)
                                          : 'No date',
                                      style: TextStyle(
                                        color: _deliveryDate != null
                                            ? null
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),

                          // Product summary
                          ProductSummary(plan: tempPlan),
                          const SizedBox(height: AppConstants.paddingSmall),

                          const SizedBox(height: AppConstants.paddingSmall),
                          // Complete toggle
                          SwitchListTile(
                            title: const Text('Complete'),
                            value: _isFinished,
                            onChanged: (v) => setState(() => _isFinished = v),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),

                          const SizedBox(height: AppConstants.paddingSmall),
                          // Bulk action button
                          FilledButton.icon(
                            onPressed: allDelivered
                                ? null
                                : _markAllDelivered,
                            icon: const Icon(
                              Icons.local_shipping,
                              size: 18,
                            ),
                            label: const Text('Mark All Delivered'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          const Divider(),

                          // Orders header with reorder button
                          Row(
                            children: [
                              Text(
                                'Orders (${displayItems.length}/${allItems.length})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: allItems.length < 2
                                    ? null
                                    : _reorderOrders,
                                icon: const Icon(Icons.swap_vert, size: 18),
                                label: const Text('Reorder'),
                              ),
                            ],
                          ),

                          // Add orders button
                          OutlinedButton.icon(
                            onPressed: _addOrders,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Orders'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),

                          // Filter chips
                          _buildFilters(),
                        ],
                      ),
                    ),
                  ),

                  // Order list
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = displayItems[index];
                      final order = item.order;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _PlanOrderTile(
                          order: order,
                          onTap: () => context.push('/order/${order.id}'),
                          onMarkDelivered: () {
                            if (!order.isDelivered) {
                              ref
                                  .read(orderProvider.notifier)
                                  .markDelivered(order.id, true);
                            }
                          },
                          onDelete: () => _deleteOrder(order.id),
                          onRemoveFromPlan: () => _removeFromPlan(order.id),
                        ),
                      );
                    }, childCount: displayItems.length),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),

          // Bottom bar with total + save
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Total: \$${tempPlan.totalValue.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurfaceVariant,
    );

    Widget filterChip(String label, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.secondaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        // Delivered column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text('Delivered', style: labelStyle),
              ),
              Row(
                children: [
                  filterChip(
                    'All',
                    _deliveredFilter == _TriFilter.all,
                    () => setState(() => _deliveredFilter = _TriFilter.all),
                  ),
                  const SizedBox(width: 6),
                  filterChip(
                    'Yes',
                    _deliveredFilter == _TriFilter.yes,
                    () => setState(() => _deliveredFilter = _TriFilter.yes),
                  ),
                  const SizedBox(width: 6),
                  filterChip(
                    'No',
                    _deliveredFilter == _TriFilter.no,
                    () => setState(() => _deliveredFilter = _TriFilter.no),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Vertical divider
        Container(
          width: 1,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: theme.dividerColor,
        ),
        // Paid column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text('Paid', style: labelStyle),
              ),
              Row(
                children: [
                  filterChip(
                    'All',
                    _paidFilter == _TriFilter.all,
                    () => setState(() => _paidFilter = _TriFilter.all),
                  ),
                  const SizedBox(width: 6),
                  filterChip(
                    'Yes',
                    _paidFilter == _TriFilter.yes,
                    () => setState(() => _paidFilter = _TriFilter.yes),
                  ),
                  const SizedBox(width: 6),
                  filterChip(
                    'No',
                    _paidFilter == _TriFilter.no,
                    () => setState(() => _paidFilter = _TriFilter.no),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Order tile within a delivery plan with swipe actions.
class _PlanOrderTile extends StatefulWidget {
  final dynamic order; // Order type
  final VoidCallback onTap;
  final VoidCallback onMarkDelivered;
  final VoidCallback onDelete;
  final VoidCallback onRemoveFromPlan;

  const _PlanOrderTile({
    required this.order,
    required this.onTap,
    required this.onMarkDelivered,
    required this.onDelete,
    required this.onRemoveFromPlan,
  });

  @override
  State<_PlanOrderTile> createState() => _PlanOrderTileState();
}

class _PlanOrderTileState extends State<_PlanOrderTile>
    with SingleTickerProviderStateMixin {
  double _offset = 0;
  bool _dragging = false;

  static const double _actionWidth = 140;
  static const double _deleteThreshold = 100;

  late final AnimationController _snapController;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final start = _offset;
    _snapController.reset();
    _snapController.addListener(() {
      setState(() {
        _offset = start + (target - start) * _snapController.value;
      });
    });
    _snapController.forward().then((_) {
      _snapController.removeListener(() {});
    });
  }

  void _onDragStart(DragStartDetails details) {
    _dragging = true;
    _snapController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    setState(() {
      _offset = (_offset + details.primaryDelta!).clamp(
        -_actionWidth,
        _deleteThreshold + 40,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;

    if (_offset > _deleteThreshold) {
      _animateTo(0);
      widget.onDelete();
    } else if (_offset < -_actionWidth * 0.4) {
      _animateTo(-_actionWidth);
    } else {
      _animateTo(0);
    }
  }

  void _close() {
    _animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = widget.order;
    final deleteProgress = (_offset / _deleteThreshold).clamp(0.0, 1.0);
    final showDelete = _offset > 0;
    final showActions = _offset < 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (showDelete)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24),
                  color: Color.lerp(
                    theme.colorScheme.errorContainer,
                    theme.colorScheme.error,
                    deleteProgress,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Color.lerp(
                      theme.colorScheme.onErrorContainer,
                      theme.colorScheme.onError,
                      deleteProgress,
                    ),
                    size: 28,
                  ),
                ),
              ),
            if (showActions)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: _actionWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.local_shipping,
                            label: 'Delivered',
                            enabled: !order.isDelivered,
                            color: theme.colorScheme.primary,
                            disabledColor: theme.colorScheme.outline,
                            onTap: () {
                              widget.onMarkDelivered();
                              _close();
                            },
                          ),
                        ),
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.remove_circle_outline,
                            label: 'Remove',
                            enabled: true,
                            color: theme.colorScheme.error,
                            disabledColor: theme.colorScheme.outline,
                            onTap: () {
                              widget.onRemoveFromPlan();
                              _close();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(_offset, 0),
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: OrderCard(order: order, onTap: widget.onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color color;
  final Color disabledColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.color,
    required this.disabledColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : disabledColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveColor, size: 24),
              const SizedBox(height: 2),
              Text(
                enabled ? label : 'Done',
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
