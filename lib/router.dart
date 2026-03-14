import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'services/error_log_service.dart';
import 'features/orders/orders_page.dart';
import 'features/orders/finished_orders_page.dart';
import 'features/delivery_plans/add_orders_page.dart';
import 'features/delivery_plans/delivery_plan_detail_page.dart';
import 'features/delivery_plans/delivery_plans_page.dart';
import 'features/delivery_plans/order_selection_page.dart';
import 'features/customers/customers_page.dart';
import 'features/customers/customer_form_page.dart';
import 'features/products/products_page.dart';
import 'features/orders/order_form_page.dart';
import 'features/products/product_form_page.dart';
import 'features/settings/dev_page.dart';
import 'features/settings/settings_page.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    ErrorLogService.setCurrentRoute(state.matchedLocation);
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const OrdersPage()),
        GoRoute(
          path: '/finished-orders',
          builder: (_, __) => const FinishedOrdersPage(),
        ),
        GoRoute(
          path: '/delivery-plans',
          builder: (_, __) => const DeliveryPlansPage(),
        ),
        GoRoute(path: '/customers', builder: (_, __) => const CustomersPage()),
        GoRoute(path: '/products', builder: (_, __) => const ProductsPage()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      ],
    ),
    // Full-screen routes (outside the shell)
    GoRoute(
      path: '/customer/new',
      builder: (_, __) => const CustomerFormPage(),
    ),
    GoRoute(
      path: '/customer/:id',
      builder: (_, state) =>
          CustomerFormPage(customerId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/product/new', builder: (_, __) => const ProductFormPage()),
    GoRoute(
      path: '/product/:id',
      builder: (_, state) =>
          ProductFormPage(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/delivery-plans/new',
      builder: (_, __) => const OrderSelectionPage(),
    ),
    GoRoute(
      path: '/delivery-plan/:id',
      builder: (_, state) =>
          DeliveryPlanDetailPage(planId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/delivery-plan/:id/add',
      builder: (_, state) => AddOrdersPage(
        planId: state.pathParameters['id']!,
        excludedOrderIds: state.extra as Set<String>? ?? const {},
      ),
    ),
    GoRoute(path: '/dev', builder: (_, __) => const DevPage()),
    GoRoute(path: '/order/new', builder: (_, __) => const OrderFormPage()),
    GoRoute(
      path: '/order/:id',
      builder: (_, state) =>
          OrderFormPage(orderId: state.pathParameters['id']!),
    ),
  ],
);

class AppShell extends StatelessWidget {
  final Widget child;
  final String location;
  const AppShell({super.key, required this.child, required this.location});

  String get _title {
    switch (location) {
      case '/':
        return 'Orders';
      case '/finished-orders':
        return 'Finished Orders';
      case '/delivery-plans':
        return 'Delivery Plans';
      case '/customers':
        return 'Customers';
      case '/products':
        return 'Products';
      case '/settings':
        return 'Settings';
      default:
        return 'EggRoute';
    }
  }

  Widget? _buildFab(BuildContext context) {
    switch (location) {
      case '/':
        return FloatingActionButton(
          onPressed: () => context.push('/order/new'),
          child: const Icon(Icons.add),
        );
      case '/delivery-plans':
        return FloatingActionButton(
          onPressed: () => context.push('/delivery-plans/new'),
          child: const Icon(Icons.add),
        );
      case '/customers':
        return FloatingActionButton(
          onPressed: () => context.push('/customer/new'),
          child: const Icon(Icons.add),
        );
      case '/products':
        return FloatingActionButton(
          onPressed: () => context.push('/product/new'),
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      floatingActionButton: _buildFab(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'EggRoute',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.receipt_long,
              label: 'Orders',
              path: '/',
              context: context,
            ),
            _DrawerItem(
              icon: Icons.check_circle,
              label: 'Finished Orders',
              path: '/finished-orders',
              context: context,
            ),
            _DrawerItem(
              icon: Icons.local_shipping,
              label: 'Delivery Plans',
              path: '/delivery-plans',
              context: context,
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.people,
              label: 'Customers',
              path: '/customers',
              context: context,
            ),
            _DrawerItem(
              icon: Icons.egg,
              label: 'Products',
              path: '/products',
              context: context,
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.settings,
              label: 'Settings',
              path: '/settings',
              context: context,
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final BuildContext context;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final isSelected = currentPath == path;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop(); // close drawer
        if (!isSelected) {
          context.go(path);
        }
      },
    );
  }
}
