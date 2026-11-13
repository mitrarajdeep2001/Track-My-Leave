import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holiday_tracker/data/backup.dart';
import 'package:holiday_tracker/data/db/app_database.dart';
import 'package:holiday_tracker/domain/models.dart';
import 'package:holiday_tracker/services/leave_math.dart';
import 'package:holiday_tracker/services/request_composer.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  PolicyDraft policy() => PolicyDraft(
        leaveTypes: const [LeaveTypeDraft(name: 'Casual', daysPerYear: 12)],
        holidays: [HolidayDraft(name: 'Diwali', date: DateTime(2026, 11, 8))],
        wfh: const {1: 4, 2: 4},
      );

  test('creates the settings row on first open', () async {
    final s = await db.select(db.appSettings).getSingle();
    expect(s.id, 1);
    expect(s.onboardingDone, false);
  });

  test('saveSetup stores setup data and completes onboarding', () async {
    await db.saveSetup(
      userName: 'Sam',
      companyName: 'Acme',
      emailAppPackage: 'com.google.android.gm',
      toEmails: ['lead@acme.com'],
      policy: policy(),
    );
    final s = await db.select(db.appSettings).getSingle();
    expect(s.onboardingDone, true);
    expect(s.userName, 'Sam');
    expect(s.companyName, 'Acme');
    expect((await db.select(db.recipients).get()).length, 1);
    expect((await db.select(db.wfhAllowances).get()).length, 2);
  });

  test('replacePolicy keeps requests attached to a renamed-in-place type', () async {
    await db.replacePolicy(policy());
    final type = await db.select(db.leaveTypes).getSingle();
    final id = await db.addRequest(
      category: 'leave',
      leaveTypeId: type.id,
      start: DateTime(2026, 12, 1),
      end: DateTime(2026, 12, 2),
      days: 2,
    );

    // Same type (different days) stays linked; a new type is added.
    await db.replacePolicy(const PolicyDraft(leaveTypes: [
      LeaveTypeDraft(name: 'casual', daysPerYear: 10),
      LeaveTypeDraft(name: 'Sick', daysPerYear: 6),
    ]));
    var r = await (db.select(db.leaveRequests)..where((t) => t.id.equals(id))).getSingle();
    expect(r.leaveTypeId, type.id);
    expect((await db.select(db.leaveTypes).get()).length, 2);

    // Removing the type detaches the request instead of deleting it.
    await db.replacePolicy(const PolicyDraft(
        leaveTypes: [LeaveTypeDraft(name: 'Sick', daysPerYear: 6)]));
    r = await (db.select(db.leaveRequests)..where((t) => t.id.equals(id))).getSingle();
    expect(r.leaveTypeId, isNull);
  });

  test('request starts pending and can be marked applied', () async {
    final id = await db.addRequest(
      category: 'leave',
      start: DateTime(2026, 12, 1),
      end: DateTime(2026, 12, 2),
      days: 2,
    );
    var r = await (db.select(db.leaveRequests)..where((t) => t.id.equals(id))).getSingle();
    expect(r.status, 'pending');
    await db.markApplied(id);
    r = await (db.select(db.leaveRequests)..where((t) => t.id.equals(id))).getSingle();
    expect(r.status, 'applied');
    expect(r.appliedAt, isNotNull);
  });

  test('resetAll returns to first-run state', () async {
    await db.saveSetup(
      userName: 'Sam',
      companyName: 'Acme',
      toEmails: ['lead@acme.com'],
      policy: policy(),
    );
    await db.resetAll();
    final s = await db.select(db.appSettings).getSingle();
    expect(s.onboardingDone, false);
    expect(await db.select(db.leaveTypes).get(), isEmpty);
    expect(await db.select(db.recipients).get(), isEmpty);
  });

  group('workingDays', () {
    test('skips weekends', () {
      // Mon 9 Nov 2026 .. Sun 15 Nov 2026
      expect(workingDays(DateTime(2026, 11, 9), DateTime(2026, 11, 15), const []), 5);
    });

    test('skips holidays', () {
      expect(
        workingDays(DateTime(2026, 11, 9), DateTime(2026, 11, 13), [DateTime(2026, 11, 11)]),
        4,
      );
    });

    test('single weekend day is zero', () {
      expect(workingDays(DateTime(2026, 11, 14), DateTime(2026, 11, 14), const []), 0);
    });
  });

  test('saveSetup stores Cc recipients and the WhatsApp contact name', () async {
    await db.saveSetup(
      userName: 'Sam',
      companyName: 'Acme',
      whatsappNumber: '+919876543210',
      whatsappName: 'Priya',
      toEmails: ['lead@acme.com'],
      ccEmails: ['hr@acme.com'],
      policy: policy(),
    );
    final rs = await db.select(db.recipients).get();
    expect({for (final r in rs) r.email: r.kind},
        {'lead@acme.com': recipientTo, 'hr@acme.com': recipientCc});
    final s = await db.select(db.appSettings).getSingle();
    expect(s.whatsappName, 'Priya');
    expect(s.themeColor, 'teal');
    expect(s.themeMode, 'system');

    final hr = rs.firstWhere((r) => r.email == 'hr@acme.com');
    await db.setRecipientKind(hr.id, recipientTo);
    final moved = await (db.select(db.recipients)..where((t) => t.id.equals(hr.id))).getSingle();
    expect(moved.kind, recipientTo);
  });

  group('templates', () {
    test('custom template fills fields and drops lines with empty fields', () {
      final m = composeMessage(
        wfh: false,
        typeName: 'Sick leave',
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 10),
        days: 1,
        userName: 'Sam',
        company: '',
        subjectTemplate: '{type} {company}– {dates}',
        bodyTemplate: 'Dear team,\n\n{type} for {days} {when}.\nReason: {reason}\n\n\n{name}\n{company}\n{unknown}',
      );
      // Subjects keep their line; the empty field is just blank.
      expect(m.subject, 'Sick leave – 10 Nov 2026');
      expect(m.body, 'Dear team,\n\nSick leave for 1 day on 10 Nov 2026.\n\nSam\n{unknown}');
    });

    test('blank custom template falls back to the default', () {
      final m = composeMessage(
        wfh: true,
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 11),
        days: 2,
        userName: 'Sam',
        company: 'Acme',
        subjectTemplate: '  ',
        bodyTemplate: '',
      );
      expect(m.subject, startsWith('WFH request:'));
      expect(m.body, contains('work from home from 10 Nov to 11 Nov 2026 (2 days)'));
      expect(m.body, isNot(contains('Reason')));
    });
  });

  group('backup', () {
    test('export then restore round-trips the data', () async {
      await db.saveSetup(
        userName: 'Sam',
        companyName: 'Acme',
        toEmails: ['lead@acme.com'],
        ccEmails: ['hr@acme.com'],
        policy: policy(),
      );
      await db.updateSettings(const AppSettingsCompanion(
          themeColor: Value('rose'), leaveBodyTpl: Value('Custom {type}')));
      final type = await db.select(db.leaveTypes).getSingle();
      await db.addRequest(
          category: 'leave',
          leaveTypeId: type.id,
          start: DateTime(2026, 12, 1),
          end: DateTime(2026, 12, 2),
          days: 2);

      final bytes = await db.exportBackup();
      expect(utf8.decode(bytes), isNot(contains('apiKey')));

      final other = AppDatabase(NativeDatabase.memory());
      addTearDown(other.close);
      await other.restoreBackup(BackupContents.parse(bytes));

      final s = await other.select(other.appSettings).getSingle();
      expect(s.onboardingDone, true);
      expect(s.companyName, 'Acme');
      expect(s.themeColor, 'rose');
      expect(s.leaveBodyTpl, 'Custom {type}');
      expect((await other.select(other.recipients).get()).length, 2);
      expect((await other.select(other.holidays).get()).single.date, DateTime(2026, 11, 8));
      final r = await other.select(other.leaveRequests).getSingle();
      final t = await other.select(other.leaveTypes).getSingle();
      expect(r.leaveTypeId, t.id);
      expect(r.days, 2);
    });

    test('rejects files that are not backups', () {
      expect(() => BackupContents.parse(Uint8List.fromList(utf8.encode('hello'))),
          throwsA(isA<BackupException>()));
      expect(() => BackupContents.parse(Uint8List.fromList(utf8.encode('{"format":"x"}'))),
          throwsA(isA<BackupException>()));
      expect(
          () => BackupContents.parse(Uint8List.fromList(
              utf8.encode('{"format":"trackmyleave-backup","version":99}'))),
          throwsA(isA<BackupException>()));
    });

    test('a damaged backup leaves current data untouched', () async {
      await db.saveSetup(
          userName: 'Sam', companyName: 'Acme', toEmails: ['lead@acme.com'], policy: policy());
      final bad = utf8.encode(
          '{"format":"trackmyleave-backup","version":1,"leaveTypes":[{"id":1,"name":"X"}]}');
      expect(() => BackupContents.parse(Uint8List.fromList(bad)), throwsA(isA<BackupException>()));
      expect((await db.select(db.leaveTypes).get()).single.name, 'Casual');
    });
  });

  group('cleanPhone', () {
    test('keeps + and digits only', () => expect(cleanPhone(' +91 98765-43210 '), '+919876543210'));
    test('turns 00 prefix into +', () => expect(cleanPhone('0091 98765 43210'), '+919876543210'));
    test('leaves local numbers alone', () => expect(cleanPhone('098765 43210'), '09876543210'));
    test('empty stays empty', () => expect(cleanPhone(' - '), ''));
  });

  group('composeMessage', () {
    test('leave request mentions type, days and dates', () {
      final m = composeMessage(
        wfh: false,
        typeName: 'Casual leave',
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 12),
        days: 3,
        reason: 'Family function',
        userName: 'Sam',
        company: 'Acme',
      );
      expect(m.subject, contains('Leave request'));
      expect(m.body, contains('3 days of Casual leave'));
      expect(m.body, contains('Reason: Family function'));
      expect(m.body, endsWith('Sam\nAcme'));
    });

    test('mailto uri keeps recipients readable and encodes the rest', () {
      final m = composeMessage(
        wfh: true,
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 10),
        days: 1,
        userName: 'Sam',
        company: '',
      );
      final uri = mailtoUri(['a@x.com', 'b@y.com'], m);
      expect(uri.toString(), startsWith('mailto:a@x.com,b@y.com?subject='));
      expect(uri.toString(), isNot(contains(' ')));
      expect(uri.toString(), isNot(contains('cc=')));
    });

    test('mailto uri includes cc when given', () {
      final m = composeMessage(
        wfh: true,
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 10),
        days: 1,
        userName: 'Sam',
        company: '',
      );
      final uri = mailtoUri(['a@x.com'], m, cc: ['hr@x.com', 'c@x.com']);
      expect(uri.toString(), startsWith('mailto:a@x.com?cc=hr%40x.com,c%40x.com&subject='));
    });
  });
}
