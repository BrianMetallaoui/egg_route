import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/database_providers.dart';
import '../../providers/settings_provider.dart';
import '../../services/backup_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _exporting = false;
  bool _importing = false;

  Future<void> _exportData() async {
    setState(() => _exporting = true);
    try {
      final db = ref.read(databaseProvider);
      final service = BackupService(db);
      final file = await service.exportToFile();

      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: 'EggRoute Backup'),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _importData() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null || result.files.single.path == null) return;

    final filePath = result.files.single.path!;
    final jsonString = await File(filePath).readAsString();

    final db = ref.read(databaseProvider);
    final service = BackupService(db);

    // Validate first
    try {
      BackupService.validate(jsonString);
    } on BackupValidationError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid backup: $e')));
      }
      return;
    }

    if (!mounted) return;

    // Confirm — this replaces all data
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Backup'),
        content: const Text(
          'This will replace all existing data with the backup. '
          'This cannot be undone.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Replace All Data'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _importing = true);
    try {
      await service.importFromJson(jsonString);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup imported successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        const _SectionHeader(title: 'Appearance'),
        SwitchListTile(
          title: const Text('Dark mode'),
          secondary: const Icon(Icons.dark_mode),
          value: settings.darkMode,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(darkMode: v)),
        ),
        const Divider(),
        const _SectionHeader(title: 'Warnings'),
        SwitchListTile(
          title: const Text('Warn before deleting an order'),
          value: settings.warnOnDelete,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(warnOnDelete: v)),
        ),
        SwitchListTile(
          title: const Text('Warn before un-marking delivered'),
          value: settings.warnOnUndeliver,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(warnOnUndeliver: v)),
        ),
        SwitchListTile(
          title: const Text('Warn before un-marking paid'),
          value: settings.warnOnUnpaid,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(warnOnUnpaid: v)),
        ),
        SwitchListTile(
          title: const Text('Warn before bulk-marking plan orders'),
          value: settings.warnOnPlanDeliver,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(warnOnPlanDeliver: v)),
        ),
        SwitchListTile(
          title: const Text('Warn before removing order from plan'),
          value: settings.warnOnPlanRemove,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .update(settings.copyWith(warnOnPlanRemove: v)),
        ),
        const Divider(),
        const _SectionHeader(title: 'Data'),
        ListTile(
          leading: _exporting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          title: const Text('Export backup'),
          subtitle: const Text('Save all data as a JSON file'),
          onTap: _exporting || _importing ? null : _exportData,
        ),
        ListTile(
          leading: _importing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download),
          title: const Text('Import backup'),
          subtitle: const Text('Replace all data from a backup file'),
          onTap: _exporting || _importing ? null : _importData,
        ),
        const Divider(),
        const _SectionHeader(title: 'About'),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.hasData
                ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                : '...';
            return ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: Text(version),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.bug_report),
          title: const Text('Developer'),
          subtitle: const Text('Error log viewer'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/dev'),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
