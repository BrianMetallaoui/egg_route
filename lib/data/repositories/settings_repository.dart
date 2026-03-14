import 'package:drift/drift.dart';

import '../database/database.dart';

class SettingsState {
  final bool warnOnDelete;
  final bool warnOnUndeliver;
  final bool warnOnUnpaid;
  final bool warnOnPlanDeliver;
  final bool warnOnPlanRemove;
  final bool darkMode;

  const SettingsState({
    this.warnOnDelete = true,
    this.warnOnUndeliver = true,
    this.warnOnUnpaid = true,
    this.warnOnPlanDeliver = true,
    this.warnOnPlanRemove = true,
    this.darkMode = false,
  });

  SettingsState copyWith({
    bool? warnOnDelete,
    bool? warnOnUndeliver,
    bool? warnOnUnpaid,
    bool? warnOnPlanDeliver,
    bool? warnOnPlanRemove,
    bool? darkMode,
  }) => SettingsState(
    warnOnDelete: warnOnDelete ?? this.warnOnDelete,
    warnOnUndeliver: warnOnUndeliver ?? this.warnOnUndeliver,
    warnOnUnpaid: warnOnUnpaid ?? this.warnOnUnpaid,
    warnOnPlanDeliver: warnOnPlanDeliver ?? this.warnOnPlanDeliver,
    warnOnPlanRemove: warnOnPlanRemove ?? this.warnOnPlanRemove,
    darkMode: darkMode ?? this.darkMode,
  );
}

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  Future<SettingsState> getSettings() async {
    final row = await (_db.select(
      _db.settings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return const SettingsState();
    return SettingsState(
      warnOnDelete: row.warnOnDelete,
      warnOnUndeliver: row.warnOnUndeliver,
      warnOnUnpaid: row.warnOnUnpaid,
      warnOnPlanDeliver: row.warnOnPlanDeliver,
      warnOnPlanRemove: row.warnOnPlanRemove,
      darkMode: row.darkMode,
    );
  }

  Stream<SettingsState> watchSettings() {
    return (_db.select(
      _db.settings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map((row) {
      if (row == null) return const SettingsState();
      return SettingsState(
        warnOnDelete: row.warnOnDelete,
        warnOnUndeliver: row.warnOnUndeliver,
        warnOnUnpaid: row.warnOnUnpaid,
        warnOnPlanDeliver: row.warnOnPlanDeliver,
        darkMode: row.darkMode,
      );
    });
  }

  Future<void> updateSettings(SettingsState settings) async {
    await (_db.update(_db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(
        warnOnDelete: Value(settings.warnOnDelete),
        warnOnUndeliver: Value(settings.warnOnUndeliver),
        warnOnUnpaid: Value(settings.warnOnUnpaid),
        warnOnPlanDeliver: Value(settings.warnOnPlanDeliver),
        warnOnPlanRemove: Value(settings.warnOnPlanRemove),
        darkMode: Value(settings.darkMode),
      ),
    );
  }
}
