import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/data/repositories/settings_repository.dart';

void main() {
  group('SettingsState defaults', () {
    test('all warnings default to true', () {
      const settings = SettingsState();
      expect(settings.warnOnDelete, isTrue);
      expect(settings.warnOnUndeliver, isTrue);
      expect(settings.warnOnUnpaid, isTrue);
      expect(settings.warnOnPlanDeliver, isTrue);
      expect(settings.warnOnPlanRemove, isTrue);
    });

    test('dark mode defaults to false', () {
      const settings = SettingsState();
      expect(settings.darkMode, isFalse);
    });
  });

  group('SettingsState.copyWith', () {
    test('overrides only specified fields', () {
      const original = SettingsState();
      final updated = original.copyWith(warnOnDelete: false, darkMode: true);
      expect(updated.warnOnDelete, isFalse);
      expect(updated.darkMode, isTrue);
      // Everything else unchanged
      expect(updated.warnOnUndeliver, isTrue);
      expect(updated.warnOnUnpaid, isTrue);
      expect(updated.warnOnPlanDeliver, isTrue);
      expect(updated.warnOnPlanRemove, isTrue);
    });

    test('preserves all fields when called with no arguments', () {
      const original = SettingsState(
        warnOnDelete: false,
        warnOnUndeliver: false,
        darkMode: true,
      );
      final copy = original.copyWith();
      expect(copy.warnOnDelete, isFalse);
      expect(copy.warnOnUndeliver, isFalse);
      expect(copy.warnOnUnpaid, isTrue);
      expect(copy.darkMode, isTrue);
    });
  });
}
