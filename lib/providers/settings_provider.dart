import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_repository.dart';
import '../services/error_log_service.dart';
import 'database_providers.dart';
import 'notifier_helpers.dart';

class SettingsNotifier extends Notifier<SettingsState> with DbCallMixin {
  @override
  SettingsState build() {
    final db = ref.watch(databaseProvider);
    final sub = db.settingsRepo.watchSettings().listen(
      (data) => state = data,
      onError: (Object e, StackTrace st) => ErrorLogService.logError(db, e, st),
    );
    ref.onDispose(sub.cancel);
    return ref.read(initialSettingsProvider);
  }

  Future<void> update(SettingsState settings) async {
    await dbCall((db) => db.settingsRepo.updateSettings(settings));
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
