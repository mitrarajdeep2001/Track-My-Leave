import 'package:intl/intl.dart';

final fmtDay = DateFormat('d MMM');
final fmtDayYear = DateFormat('d MMM y');
final fmtMonthYear = DateFormat('MMMM y');
final fmtMonth = DateFormat('MMMM');
final fmtMonthShort = DateFormat('MMM');
final fmtWeekday = DateFormat('EEE');
final fmtLongDate = DateFormat('EEEE, d MMMM');

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String fmtNum(double v) => v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);

String plural(double d) => d == 1 ? '1 day' : '${fmtNum(d)} days';

String rangeText(DateTime start, DateTime end) {
  if (dateOnly(start) == dateOnly(end)) return fmtDayYear.format(start);
  if (start.year == end.year) return '${fmtDay.format(start)} – ${fmtDayYear.format(end)}';
  return '${fmtDayYear.format(start)} – ${fmtDayYear.format(end)}';
}
