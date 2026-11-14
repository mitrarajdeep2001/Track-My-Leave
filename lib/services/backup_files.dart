import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../data/backup.dart';

const _channel = MethodChannel('trackmyleave/backup');

/// An installed app that can store files and give them back, such as
/// Google Drive, OneDrive or JioCloud.
class StorageApp {
  const StorageApp({required this.package, required this.label, this.icon});
  final String package;
  final String label;
  final Uint8List? icon;
}

class PickedBackupFile {
  const PickedBackupFile(this.name, this.bytes);
  final String? name;
  final Uint8List bytes;
}

/// Storage apps installed on this phone. Empty when not on Android.
Future<List<StorageApp>> storageApps() async {
  try {
    final list = await _channel.invokeListMethod<Map<Object?, Object?>>('listStorageApps') ?? [];
    return [
      for (final m in list)
        StorageApp(
          package: m['package'] as String,
          label: m['label'] as String,
          icon: m['icon'] as Uint8List?,
        ),
    ];
  } on MissingPluginException {
    return const [];
  } on PlatformException {
    return const [];
  }
}

/// Hands the backup file to [package]'s upload screen.
Future<void> saveToApp(String package, String fileName, Uint8List bytes) async {
  try {
    await _channel.invokeMethod<bool>('saveToApp', {
      'package': package,
      'fileName': fileName,
      'bytes': bytes,
    });
  } on MissingPluginException {
    throw const BackupException('Saving to another app only works on Android');
  } on PlatformException catch (e) {
    throw BackupException(e.message ?? 'Could not hand the backup to that app');
  }
}

/// Opens a backup file. With [fromPackage], that storage app's own picker
/// opens; otherwise the file picker for this phone. Both ask for JSON files
/// only, so non-backup files are hidden where the app supports filtering.
/// Returns null if the user backs out.
///
/// Throws [BackupException] with a user-facing message on failure.
Future<PickedBackupFile?> pickBackupFile({String? fromPackage}) async {
  try {
    final r = await _channel.invokeMapMethod<String, Object?>('pickFile', {
      'package': fromPackage,
    });
    if (r == null) return null;
    return PickedBackupFile(r['name'] as String?, r['bytes'] as Uint8List);
  } on MissingPluginException {
    // Not on Android (e.g. browser preview): use the plugin picker instead.
    final f = await FilePicker.pickFile(
      dialogTitle: 'Choose a TrackMyLeave backup',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (f == null) return null;
    final size = await f.length();
    if (size != null && size > maxBackupBytes) {
      throw const BackupException('That file is too large to be a TrackMyLeave backup.');
    }
    return PickedBackupFile(f.name, await f.readAsBytes());
  } on PlatformException catch (e) {
    throw BackupException(e.message ?? 'Could not open that file');
  }
}
