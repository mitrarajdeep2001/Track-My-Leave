import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
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
      recipientEmails: ['lead@acme.com'],
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
      recipientEmails: ['lead@acme.com'],
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
    });
  });
}
