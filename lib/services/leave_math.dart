import '../core/formatters.dart';
import '../data/db/app_database.dart';

/// Counts Monday-Friday days in [start]..[end] (inclusive) that are not holidays.
double workingDays(DateTime start, DateTime end, Iterable<DateTime> holidays) {
  final hs = {for (final h in holidays) dateOnly(h)};
  var d = dateOnly(start);
  final last = dateOnly(end);
  var count = 0;
  while (!d.isAfter(last)) {
    if (d.weekday <= DateTime.friday && !hs.contains(d)) count++;
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return count.toDouble();
}

class LeaveBalance {
  const LeaveBalance(this.type, this.used, this.pending);

  final LeaveType type;
  final double used;
  final double pending;

  double get total => type.daysPerYear;
  double get remaining => total - used - pending;
}

List<LeaveBalance> computeBalances(
  List<LeaveType> types,
  List<LeaveRequest> requests,
  int year,
) {
  return [
    for (final t in types)
      () {
        var used = 0.0;
        var pending = 0.0;
        for (final r in requests) {
          if (r.category != 'leave' || r.leaveTypeId != t.id || r.startDate.year != year) {
            continue;
          }
          if (r.status == 'applied') {
            used += r.days;
          } else {
            pending += r.days;
          }
        }
        return LeaveBalance(t, used, pending);
      }(),
  ];
}

({double used, double pending}) wfhUsage(List<LeaveRequest> requests, int year, int month) {
  var used = 0.0;
  var pending = 0.0;
  for (final r in requests) {
    if (r.category != 'wfh' || r.startDate.year != year || r.startDate.month != month) {
      continue;
    }
    if (r.status == 'applied') {
      used += r.days;
    } else {
      pending += r.days;
    }
  }
  return (used: used, pending: pending);
}
