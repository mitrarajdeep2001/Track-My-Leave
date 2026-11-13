import 'package:drift/drift.dart';

/// Single-row profile/settings table (id is always 1).
/// The LLM API key is NOT stored here; it lives in flutter_secure_storage.
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get userName => text().withDefault(const Constant(''))();
  TextColumn get companyName => text().withLength(min: 0, max: 120).withDefault(const Constant(''))();
  TextColumn get emailAppPackage => text().nullable()(); // e.g. com.google.android.gm
  TextColumn get whatsappNumber => text().nullable()();
  TextColumn get llmProvider => text().nullable()(); // openai | claude | gemini
  TextColumn get llmModel => text().nullable()();
  BoolColumn get onboardingDone => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Recipients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text()();
  // to | cc
  TextColumn get kind => text().withDefault(const Constant('to'))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {email},
      ];
}

class LeaveTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get daysPerYear => real()();
  BoolColumn get carryForward => boolean().withDefault(const Constant(false))();
  RealColumn get maxCarryForwardDays => real().nullable()();
}

class Holidays extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get optional => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {date, name},
      ];
}

/// WFH allowance per calendar month (month 1-12). A null month row is not used;
/// create one row per month the user configures.
class WfhAllowances extends Table {
  IntColumn get month => integer()(); // 1..12
  IntColumn get daysAllowed => integer()();

  @override
  Set<Column> get primaryKey => {month};
}

class LeaveRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  // leave | wfh
  TextColumn get category => text().withDefault(const Constant('leave'))();
  IntColumn get leaveTypeId => integer().nullable().references(LeaveTypes, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get days => real()();
  TextColumn get reason => text().nullable()();
  // pending | applied
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get appliedAt => dateTime().nullable()();
}
