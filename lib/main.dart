import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database/database.dart';
import 'data/database/connection.dart';
import 'providers/database_providers.dart';
import 'services/error_log_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Create database
  final db = AppDatabase(openConnection());

  // 2. Initialize services
  await ErrorLogService.init(db);

  // 3. Pre-load data needed for first frame
  final settings = await db.settingsRepo.getSettings();
  final customers = await db.customerRepo.getAll();
  final products = await db.productRepo.getAll();
  final orders = await db.orderRepo.getAll();
  final deliveryPlans = await db.deliveryPlanRepo.getAll();

  // 4. Set up global error handlers
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorLogService.logError(db, details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorLogService.logError(db, error, stack);
    return true;
  };

  // 5. Launch app with pre-loaded data
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
        initialCustomersProvider.overrideWithValue(customers),
        initialProductsProvider.overrideWithValue(products),
        initialOrdersProvider.overrideWithValue(orders),
        initialDeliveryPlansProvider.overrideWithValue(deliveryPlans),
      ],
      child: const MainApp(),
    ),
  );
}
