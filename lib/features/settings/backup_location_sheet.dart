import 'package:flutter/material.dart';

import '../../core/widgets.dart';
import '../../services/backup_files.dart';

/// Where a backup is saved to or restored from. [app] is null for this phone.
class BackupLocation {
  const BackupLocation.phone() : app = null;
  const BackupLocation.app(StorageApp this.app);

  final StorageApp? app;
  bool get isPhone => app == null;
}

/// Lets the user choose this phone or one of the installed storage apps.
/// Returns null if the sheet is dismissed.
Future<BackupLocation?> showBackupLocationSheet(BuildContext context, {required bool restore}) =>
    showModalBottomSheet<BackupLocation>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LocationSheet(restore: restore),
    );

class _LocationSheet extends StatefulWidget {
  const _LocationSheet({required this.restore});
  final bool restore;

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  late final Future<List<StorageApp>> _apps = storageApps();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final restore = widget.restore;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
              child: Text(
                restore ? 'Restore backup from' : 'Save backup to',
                style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                restore
                    ? 'Only TrackMyLeave backup files are shown, where the app supports it.'
                    : 'Pick where to keep your backup file.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
            Flexible(
              child: FutureBuilder<List<StorageApp>>(
                future: _apps,
                builder: (context, snap) {
                  final apps = snap.data ?? const <StorageApp>[];
                  final loading = snap.connectionState != ConnectionState.done;
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    children: [
                      _Tile(
                        leading: const IconBadge(Icons.phone_android, size: 44),
                        title: 'This phone',
                        subtitle: restore ? 'Browse files on this phone' : 'Choose a folder on this phone',
                        onTap: () => Navigator.pop(context, const BackupLocation.phone()),
                      ),
                      if (loading)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (apps.isEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Text(
                            'No cloud storage apps found. Install Google Drive, OneDrive or another storage app to keep your backup in the cloud.',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        )
                      else ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text(
                            'CLOUD STORAGE',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        for (final a in apps)
                          _Tile(
                            leading: _AppIcon(a),
                            title: a.label,
                            subtitle: restore ? 'Open a backup from ${a.label}' : 'Upload to ${a.label}',
                            onTap: () => Navigator.pop(context, BackupLocation.app(a)),
                          ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: leading,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      );
}

class _AppIcon extends StatelessWidget {
  const _AppIcon(this.app);
  final StorageApp app;

  @override
  Widget build(BuildContext context) {
    final icon = app.icon;
    if (icon == null) return const IconBadge(Icons.cloud_outlined, size: 44);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(icon, width: 44, height: 44, gaplessPlayback: true),
    );
  }
}
