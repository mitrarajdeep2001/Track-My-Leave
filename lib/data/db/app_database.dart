import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/models.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  AppSettings,
  Recipients,
  LeaveTypes,
  Holidays,
  WfhAllowances,
  LeaveRequests,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'holiday_tracker',
              // Only used when running in a browser (dev preview).
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(appSettings).insert(AppSettingsCompanion.insert());
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(appSettings, appSettings.userName);
        },
      );

  // ---- Settings ----------------------------------------------------------

  Stream<AppSetting> watchSettings() =>
      (select(appSettings)..where((t) => t.id.equals(1))).watchSingle();

  Future<void> updateSettings(AppSettingsCompanion c) =>
      (update(appSettings)..where((t) => t.id.equals(1))).write(c);

  // ---- Streams -----------------------------------------------------------

  Stream<List<Recipient>> watchRecipients() => select(recipients).watch();

  Stream<List<LeaveType>> watchLeaveTypes() => select(leaveTypes).watch();

  Stream<List<Holiday>> watchHolidays() =>
      (select(holidays)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  Stream<List<WfhAllowance>> watchWfh() => select(wfhAllowances).watch();

  Stream<List<LeaveRequest>> watchRequests() => (select(leaveRequests)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt), (t) => OrderingTerm.desc(t.id)]))
      .watch();

  // ---- Recipients --------------------------------------------------------

  Future<void> addRecipient(String email) => into(recipients).insert(
        RecipientsCompanion.insert(email: email.trim().toLowerCase()),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> removeRecipient(int id) =>
      (delete(recipients)..where((t) => t.id.equals(id))).go();

  // ---- Policy ------------------------------------------------------------

  Future<PolicyDraft> loadPolicy() async {
    final types = await select(leaveTypes).get();
    final hols = await (select(holidays)..orderBy([(t) => OrderingTerm.asc(t.date)])).get();
    final wfh = await select(wfhAllowances).get();
    return PolicyDraft(
      leaveTypes: [
        for (final t in types)
          LeaveTypeDraft(
              name: t.name, daysPerYear: t.daysPerYear, carryForward: t.carryForward),
      ],
      holidays: [
        for (final h in hols)
          HolidayDraft(name: h.name, date: h.date, optional: h.optional),
      ],
      wfh: {for (final w in wfh) w.month: w.daysAllowed},
    );
  }

  /// Replaces the policy. Leave types are matched by name so existing
  /// requests keep pointing at the right type; removed types are detached.
  Future<void> replacePolicy(PolicyDraft p) => transaction(() async {
        final existing = await select(leaveTypes).get();
        final byName = {for (final e in existing) e.name.toLowerCase(): e};
        final keep = <int>{};

        for (final t in p.leaveTypes) {
          final e = byName[t.name.toLowerCase()];
          if (e != null) {
            keep.add(e.id);
            await (update(leaveTypes)..where((x) => x.id.equals(e.id))).write(
              LeaveTypesCompanion(
                name: Value(t.name),
                daysPerYear: Value(t.daysPerYear),
                carryForward: Value(t.carryForward),
              ),
            );
          } else {
            await into(leaveTypes).insert(LeaveTypesCompanion.insert(
              name: t.name,
              daysPerYear: t.daysPerYear,
              carryForward: Value(t.carryForward),
            ));
          }
        }

        final removed = [for (final e in existing) if (!keep.contains(e.id)) e.id];
        if (removed.isNotEmpty) {
          await (update(leaveRequests)..where((r) => r.leaveTypeId.isIn(removed)))
              .write(const LeaveRequestsCompanion(leaveTypeId: Value(null)));
          await (delete(leaveTypes)..where((x) => x.id.isIn(removed))).go();
        }

        await delete(holidays).go();
        await batch((b) {
          b.insertAll(
            holidays,
            p.holidays.map((h) => HolidaysCompanion.insert(
                  name: h.name,
                  date: h.date,
                  optional: Value(h.optional),
                )),
            mode: InsertMode.insertOrIgnore,
          );
        });

        await delete(wfhAllowances).go();
        await batch((b) {
          b.insertAll(
            wfhAllowances,
            p.wfh.entries.where((e) => e.value > 0).map((e) =>
                WfhAllowancesCompanion.insert(month: Value(e.key), daysAllowed: e.value)),
          );
        });
      });

  /// Persists everything collected during onboarding in one transaction and
  /// flips [AppSettings.onboardingDone].
  Future<void> saveSetup({
    required String userName,
    required String companyName,
    String? emailAppPackage,
    String? whatsappNumber,
    required List<String> recipientEmails,
    required PolicyDraft policy,
  }) {
    return transaction(() async {
      await delete(recipients).go();
      await batch((b) {
        b.insertAll(
          recipients,
          recipientEmails.map((e) => RecipientsCompanion.insert(email: e)),
          mode: InsertMode.insertOrIgnore,
        );
      });
      await replacePolicy(policy);
      await updateSettings(AppSettingsCompanion(
        userName: Value(userName),
        companyName: Value(companyName),
        emailAppPackage: Value(emailAppPackage),
        whatsappNumber: Value(whatsappNumber),
        onboardingDone: const Value(true),
      ));
    });
  }

  // ---- Requests ----------------------------------------------------------

  Future<int> addRequest({
    required String category,
    int? leaveTypeId,
    required DateTime start,
    required DateTime end,
    required double days,
    String? reason,
  }) =>
      into(leaveRequests).insert(LeaveRequestsCompanion.insert(
        category: Value(category),
        leaveTypeId: Value(leaveTypeId),
        startDate: start,
        endDate: end,
        days: days,
        reason: Value(reason),
      ));

  Future<void> deleteRequest(int id) =>
      (delete(leaveRequests)..where((t) => t.id.equals(id))).go();

  /// Marks a pending request as applied once the user confirms they sent it.
  Future<void> markApplied(int requestId) =>
      (update(leaveRequests)..where((t) => t.id.equals(requestId))).write(
        LeaveRequestsCompanion(
          status: const Value('applied'),
          appliedAt: Value(DateTime.now()),
        ),
      );

  /// Wipes all app data and returns to the first-run state.
  Future<void> resetAll() => transaction(() async {
        await delete(leaveRequests).go();
        await delete(leaveTypes).go();
        await delete(holidays).go();
        await delete(wfhAllowances).go();
        await delete(recipients).go();
        await delete(appSettings).go();
        await into(appSettings).insert(AppSettingsCompanion.insert());
      });
}
