import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_providers.dart';
import '../data/database/database.dart';
import '../services/error_log_service.dart';

mixin DbCallMixin<T> on Notifier<T> {
  Future<R> dbCall<R>(Future<R> Function(AppDatabase db) fn) async {
    final db = ref.read(databaseProvider);
    try {
      return await fn(db);
    } catch (e, st) {
      await ErrorLogService.logError(db, e, st);
      rethrow;
    }
  }
}
