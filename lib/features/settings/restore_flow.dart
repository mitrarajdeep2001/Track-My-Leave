import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/backup.dart';
import '../../data/providers.dart';

final fmtBackupStamp = DateFormat('d MMM y, h:mm a');

/// Lets the user pick a backup file, shows what it contains, and restores it
/// after they confirm. Returns true if the data was restored.
///
/// [firstRun] changes the wording for the welcome screen, where there is no
/// existing data to replace. [onBusy] is called around the restore itself.
Future<bool> pickAndRestoreBackup(
  BuildContext context,
  WidgetRef ref, {
  bool firstRun = false,
  ValueChanged<bool>? onBusy,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  BackupContents contents;
  try {
    // Any type: cloud providers often report .json files as a generic type.
    final f = await FilePicker.pickFile(dialogTitle: 'Choose a TrackMyLeave backup');
    if (f == null) return false;
    final size = await f.length();
    if (size != null && size > maxBackupBytes) {
      throw const BackupException('That file is too large to be a TrackMyLeave backup.');
    }
    contents = BackupContents.parse(await f.readAsBytes());
  } on BackupException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return false;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Could not open that file: $e')));
    return false;
  }
  if (!context.mounted) return false;

  final from = contents.exportedAt == null
      ? 'This backup'
      : 'The backup from ${fmtBackupStamp.format(contents.exportedAt!)}';
  final summary = '$from has ${contents.leaveTypes.length} leave types, '
      '${contents.holidays.length} holidays, ${contents.requests.length} requests '
      'and ${contents.recipients.length} recipients.';
  final note = firstRun
      ? 'Restoring it sets up the app and skips the setup steps. AI API keys are not '
          'stored in backups, so add yours in Settings if you import policies from PDFs.'
      : 'It will replace everything currently in the app. Your saved AI API key is kept.';

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.restore, size: 32, color: Theme.of(ctx).colorScheme.primary),
      title: Text(firstRun ? 'Restore your setup?' : 'Restore this backup?'),
      content: Text('$summary\n\n$note'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
          child: const Text('Restore'),
        ),
      ],
    ),
  );
  if (ok != true) return false;

  onBusy?.call(true);
  try {
    await ref.read(databaseProvider).restoreBackup(contents);
    messenger.showSnackBar(SnackBar(
      content: Text(firstRun ? 'Welcome back! Your setup was restored.' : 'Backup restored'),
    ));
    return true;
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text('Restore failed. Your data was not changed. ($e)')));
    return false;
  } finally {
    onBusy?.call(false);
  }
}
