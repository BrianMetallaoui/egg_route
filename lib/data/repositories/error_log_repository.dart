import 'package:drift/drift.dart';

import '../database/database.dart';

class ErrorLogRepository {
  final AppDatabase _db;
  ErrorLogRepository(this._db);

  Future<List<ErrorLogRow>> getAll() async {
    return (_db.select(
      _db.errorLogs,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<void> insertLog({
    required String errorMessage,
    String stackTrace = '',
    String appVersion = '',
    String currentRoute = '',
    String platform = '',
  }) async {
    await _db
        .into(_db.errorLogs)
        .insert(
          ErrorLogsCompanion.insert(
            errorMessage: errorMessage,
            stackTrace: Value(stackTrace),
            appVersion: Value(appVersion),
            currentRoute: Value(currentRoute),
            platform: Value(platform),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> cleanupOldLogs() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 300));
    await (_db.delete(
      _db.errorLogs,
    )..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();
  }

  Future<void> deleteAll() async {
    await _db.delete(_db.errorLogs).go();
  }
}
