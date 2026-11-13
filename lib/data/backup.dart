import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'db/app_database.dart';

const backupFormat = 'trackmyleave-backup';
const backupVersion = 1;
const maxBackupBytes = 5 * 1024 * 1024;

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// A parsed, validated backup file, ready to restore.
class BackupContents {
  BackupContents._({
    required this.exportedAt,
    required this.settings,
    required this.recipients,
    required this.leaveTypes,
    required this.holidays,
    required this.wfh,
    required this.requests,
  });

  final DateTime? exportedAt;
  final AppSettingsCompanion settings;
  final List<RecipientsCompanion> recipients;
  final List<LeaveTypesCompanion> leaveTypes;
  final List<HolidaysCompanion> holidays;
  final List<WfhAllowancesCompanion> wfh;
  final List<LeaveRequestsCompanion> requests;

  /// Throws [BackupException] if [bytes] is not a usable backup.
  factory BackupContents.parse(Uint8List bytes) {
    if (bytes.length > maxBackupBytes) {
      throw const BackupException('That file is too large to be a TrackMyLeave backup.');
    }
    final Object? root;
    try {
      root = jsonDecode(utf8.decode(bytes));
    } on FormatException {
      throw const BackupException('That file is not a TrackMyLeave backup.');
    }
    if (root is! Map<String, dynamic> || root['format'] != backupFormat) {
      throw const BackupException('That file is not a TrackMyLeave backup.');
    }
    final version = root['version'];
    if (version is! int || version > backupVersion) {
      throw const BackupException(
          'This backup was made by a newer version of TrackMyLeave. Update the app and try again.');
    }
    try {
      return _read(root);
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupException('This backup file is damaged and cannot be restored.');
    }
  }

  static BackupContents _read(Map<String, dynamic> root) {
    List<Map<String, dynamic>> list(String key) =>
        ((root[key] as List?) ?? const []).cast<Map<String, dynamic>>();
    String? str(Map<String, dynamic> m, String k) => m[k] as String?;
    DateTime day(Object? v) {
      final d = DateTime.parse(v as String);
      return DateTime(d.year, d.month, d.day);
    }

    DateTime? instant(Object? v) => v == null ? null : DateTime.parse(v as String).toLocal();

    final s = (root['settings'] as Map<String, dynamic>?) ?? const {};
    final settings = AppSettingsCompanion(
      userName: Value(str(s, 'userName') ?? ''),
      companyName: Value(str(s, 'companyName') ?? ''),
      emailAppPackage: Value(str(s, 'emailAppPackage')),
      whatsappNumber: Value(str(s, 'whatsappNumber')),
      whatsappName: Value(str(s, 'whatsappName')),
      llmProvider: Value(str(s, 'llmProvider')),
      llmModel: Value(str(s, 'llmModel')),
      themeColor: Value(str(s, 'themeColor') ?? 'teal'),
      themeMode: Value(str(s, 'themeMode') ?? 'system'),
      leaveSubjectTpl: Value(str(s, 'leaveSubjectTpl')),
      leaveBodyTpl: Value(str(s, 'leaveBodyTpl')),
      wfhSubjectTpl: Value(str(s, 'wfhSubjectTpl')),
      wfhBodyTpl: Value(str(s, 'wfhBodyTpl')),
      onboardingDone: const Value(true),
    );

    final recipients = [
      for (final r in list('recipients'))
        if (isValidEmail(r['email'] as String))
          RecipientsCompanion.insert(
            email: (r['email'] as String).trim().toLowerCase(),
            name: Value(r['name'] as String?),
            kind: Value(r['kind'] == recipientCc ? recipientCc : recipientTo),
          ),
    ];

    final leaveTypes = [
      for (final t in list('leaveTypes'))
        LeaveTypesCompanion.insert(
          id: Value(t['id'] as int),
          name: t['name'] as String,
          daysPerYear: (t['daysPerYear'] as num).toDouble(),
          carryForward: Value(t['carryForward'] as bool? ?? false),
          maxCarryForwardDays: Value((t['maxCarryForwardDays'] as num?)?.toDouble()),
        ),
    ];
    final typeIds = {for (final t in leaveTypes) t.id.value};

    final holidays = [
      for (final h in list('holidays'))
        HolidaysCompanion.insert(
          name: h['name'] as String,
          date: day(h['date']),
          optional: Value(h['optional'] as bool? ?? false),
        ),
    ];

    final wfh = [
      for (final w in list('wfh'))
        if ((w['month'] as int) >= 1 && (w['month'] as int) <= 12)
          WfhAllowancesCompanion.insert(
            month: Value(w['month'] as int),
            daysAllowed: w['days'] as int,
          ),
    ];

    final requests = [
      for (final r in list('requests'))
        LeaveRequestsCompanion.insert(
          category: Value(r['category'] == 'wfh' ? 'wfh' : 'leave'),
          leaveTypeId:
              Value(typeIds.contains(r['leaveTypeId']) ? r['leaveTypeId'] as int : null),
          startDate: day(r['start']),
          endDate: day(r['end']),
          days: (r['days'] as num).toDouble(),
          reason: Value(r['reason'] as String?),
          status: Value(r['status'] == 'applied' ? 'applied' : 'pending'),
          createdAt: Value(instant(r['createdAt']) ?? DateTime.now()),
          appliedAt: Value(instant(r['appliedAt'])),
        ),
    ];

    return BackupContents._(
      exportedAt: instant(root['exportedAt']),
      settings: settings,
      recipients: recipients,
      leaveTypes: leaveTypes,
      holidays: holidays,
      wfh: wfh,
      requests: requests,
    );
  }
}

extension BackupDatabase on AppDatabase {
  /// Serialises everything except the AI API key, which never leaves the
  /// phone's secure storage.
  Future<Uint8List> exportBackup() async {
    final s = await (select(appSettings)..where((t) => t.id.equals(1))).getSingle();
    final data = {
      'format': backupFormat,
      'version': backupVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'settings': {
        'userName': s.userName,
        'companyName': s.companyName,
        'emailAppPackage': s.emailAppPackage,
        'whatsappNumber': s.whatsappNumber,
        'whatsappName': s.whatsappName,
        'llmProvider': s.llmProvider,
        'llmModel': s.llmModel,
        'themeColor': s.themeColor,
        'themeMode': s.themeMode,
        'leaveSubjectTpl': s.leaveSubjectTpl,
        'leaveBodyTpl': s.leaveBodyTpl,
        'wfhSubjectTpl': s.wfhSubjectTpl,
        'wfhBodyTpl': s.wfhBodyTpl,
      },
      'recipients': [
        for (final r in await select(recipients).get())
          {'email': r.email, 'name': r.name, 'kind': r.kind},
      ],
      'leaveTypes': [
        for (final t in await select(leaveTypes).get())
          {
            'id': t.id,
            'name': t.name,
            'daysPerYear': t.daysPerYear,
            'carryForward': t.carryForward,
            'maxCarryForwardDays': t.maxCarryForwardDays,
          },
      ],
      'holidays': [
        for (final h in await select(holidays).get())
          {'name': h.name, 'date': _day(h.date), 'optional': h.optional},
      ],
      'wfh': [
        for (final w in await select(wfhAllowances).get())
          {'month': w.month, 'days': w.daysAllowed},
      ],
      'requests': [
        for (final r in await select(leaveRequests).get())
          {
            'category': r.category,
            'leaveTypeId': r.leaveTypeId,
            'start': _day(r.startDate),
            'end': _day(r.endDate),
            'days': r.days,
            'reason': r.reason,
            'status': r.status,
            'createdAt': r.createdAt.toUtc().toIso8601String(),
            'appliedAt': r.appliedAt?.toUtc().toIso8601String(),
          },
      ],
    };
    return Uint8List.fromList(utf8.encode(const JsonEncoder.withIndent('  ').convert(data)));
  }

  Future<void> markBackedUp() =>
      updateSettings(AppSettingsCompanion(lastBackupAt: Value(DateTime.now())));

  /// Replaces all app data with [c] in one transaction. If anything fails,
  /// the current data is left untouched.
  Future<void> restoreBackup(BackupContents c) => transaction(() async {
        await delete(leaveRequests).go();
        await delete(leaveTypes).go();
        await delete(holidays).go();
        await delete(wfhAllowances).go();
        await delete(recipients).go();
        await batch((b) {
          b.insertAll(leaveTypes, c.leaveTypes);
          b.insertAll(holidays, c.holidays, mode: InsertMode.insertOrIgnore);
          b.insertAll(wfhAllowances, c.wfh, mode: InsertMode.insertOrReplace);
          b.insertAll(recipients, c.recipients, mode: InsertMode.insertOrIgnore);
          b.insertAll(leaveRequests, c.requests);
        });
        await updateSettings(c.settings);
      });
}
