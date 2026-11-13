import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/widgets.dart';
import '../../data/backup.dart';
import '../../data/providers.dart';
import 'restore_flow.dart';

final _fmtStamp = fmtBackupStamp;

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      final bytes = await db.exportBackup();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final uri = await FilePicker.saveFile(
        dialogTitle: 'Save TrackMyLeave backup',
        fileName: 'TrackMyLeave-backup-$today.json',
        bytes: bytes,
        mimeType: 'application/json',
      );
      if (uri != null) {
        await db.markBackedUp();
        messenger.showSnackBar(const SnackBar(content: Text('Backup saved')));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not save the backup: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() => pickAndRestoreBackup(
        context,
        ref,
        onBusy: (b) {
          if (mounted) setState(() => _busy = b);
        },
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final last = ref.watch(settingsProvider).value?.lastBackupAt;
    final muted = TextStyle(color: cs.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & restore')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          AppCard(
            child: Row(
              children: [
                IconBadge(last == null ? Icons.cloud_off_outlined : Icons.cloud_done_outlined),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(last == null ? 'Not backed up yet' : 'Last backup',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      if (last != null) Text(_fmtStamp.format(last), style: muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A backup is one file with your policy, holidays, requests, recipients, email templates and settings. '
            'Save it to Google Drive, OneDrive or your phone. You can restore it here or on a new phone.',
            style: muted,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: _busy
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.cloud_upload_outlined),
              label: const Text('Save backup'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _restore,
              icon: const Icon(Icons.settings_backup_restore),
              label: const Text('Restore from backup'),
            ),
          ),
          const SectionHeader('Good to know'),
          _Tip(
            icon: Icons.add_to_drive_outlined,
            text: 'To save to Google Drive or OneDrive, pick it in the menu (☰) of the save screen. '
                'The app has to be installed and signed in on your phone.',
          ),
          _Tip(
            icon: Icons.key_off_outlined,
            text: 'Your AI API key is never included. Enter it again after restoring on a new phone.',
          ),
          _Tip(
            icon: Icons.phone_android_outlined,
            text: 'If Google backup is on for your phone, Android also backs up this app\'s data '
                'automatically and restores it when you reinstall.',
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: cs.onSurfaceVariant))),
        ],
      ),
    );
  }
}
