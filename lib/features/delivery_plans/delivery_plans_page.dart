import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/format_date.dart';
import '../../data/models/delivery_plan.dart';
import '../../providers/delivery_plan_provider.dart';

class DeliveryPlansPage extends ConsumerWidget {
  const DeliveryPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(deliveryPlanProvider);
    final current = plans.where((p) => !p.isFinished).toList()
      ..sort((a, b) {
        // Sort by delivery date (nulls at bottom), then created date
        if (a.deliveryDate != null && b.deliveryDate != null) {
          return a.deliveryDate!.compareTo(b.deliveryDate!);
        }
        if (a.deliveryDate != null) return -1;
        if (b.deliveryDate != null) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
    final finished = plans.where((p) => p.isFinished).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Finished'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PlanList(
                  plans: current,
                  emptyMessage: 'No current delivery plans.',
                  formatDate: formatDate,
                ),
                _PlanList(
                  plans: finished,
                  emptyMessage: 'No finished delivery plans.',
                  formatDate: formatDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  final List<DeliveryPlan> plans;
  final String emptyMessage;
  final String Function(DateTime) formatDate;

  const _PlanList({
    required this.plans,
    required this.emptyMessage,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final theme = Theme.of(context);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            title: Text(
              plan.name.isNotEmpty ? plan.name : 'Unnamed Plan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plan.orderCount} orders  •  \$${plan.totalValue.toStringAsFixed(2)}',
                ),
                if (plan.deliveryDate != null)
                  Text(
                    'Delivery: ${formatDate(plan.deliveryDate!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/delivery-plan/${plan.id}'),
          ),
        );
      },
    );
  }
}
