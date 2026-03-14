import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../data/database/database.dart';

class ErrorLogService {
  static String _currentRoute = '';
  static String _appVersion = '';

  static Future<void> init(AppDatabase db) async {
    final info = await PackageInfo.fromPlatform();
    _appVersion = '${info.version}+${info.buildNumber}';
    await db.errorLogRepo.cleanupOldLogs();
  }

  static void setCurrentRoute(String route) => _currentRoute = route;

  static Future<void> logError(
    AppDatabase db,
    Object error,
    StackTrace? stack,
  ) async {
    await db.errorLogRepo.insertLog(
      errorMessage: error.toString(),
      stackTrace: stack?.toString() ?? '',
      appVersion: _appVersion,
      currentRoute: _currentRoute,
      platform: Platform.operatingSystem,
    );
  }
}
