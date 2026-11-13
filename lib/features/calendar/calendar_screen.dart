import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../requests/new_request_screen.dart';

enum _Mark { none, holiday, leave, leavePending, wfh, wfhPending }

/// Which mark wins when several fall on the same day.
const _priority = {
  _Mark.none: 0,
  _Mark.wfhPending: 1,
  _Mark.leavePending: 2,
  _Mark.wfh: 3,
  _Mark.leave: 4,
  _Mark.holiday: 5,
};

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int delta) => setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final holidays = ref.watch(holidaysProvider).value ?? const <Holiday>[];
    final requests = ref.watch(requestsProvider).value ?? const <LeaveRequest>[];
    final types = ref.watch(leaveTypesProvider).value ?? const <LeaveType>[];

    // Per-day marks for the visible month. Higher priority wins.
    final holidayDays = {for (final h in holidays) dateOnly(h.date)};
    final marks = <DateTime, _Mark>{};
    void put(DateTime d, _Mark m) {
      final cur = marks[d] ?? _Mark.none;
      if (_priority[m]! > _priority[cur]!) marks[d] = m;
    }

    for (final h in holidayDays) {
      put(h, _Mark.holiday);
    }
    for (final r in requests) {
      var d = dateOnly(r.startDate);
      final end = dateOnly(r.endDate);
      var guard = 0;
      while (!d.isAfter(end) && guard++ < 400) {
        if (d.weekday <= DateTime.friday && !holidayDays.contains(d)) {
          final sent = r.status == 'applied';
          put(
            d,
            r.category == 'wfh'
                ? (sent ? _Mark.wfh : _Mark.wfhPending)
                : (sent ? _Mark.leave : _Mark.leavePending),
          );
        }
        d = DateTime(d.year, d.month, d.day + 1);
      }
    }

    final first = _month;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1; // Monday-first
    final cells = ((lead + daysInMonth + 6) ~/ 7) * 7;
    final today = dateOnly(DateTime.now());

    // Events listed under the grid.
    final monthStart = DateTime(first.year, first.month, 1);
    final monthEnd = DateTime(first.year, first.month, daysInMonth);
    final monthHolidays = holidays
        .where((h) => !dateOnly(h.date).isBefore(monthStart) && !dateOnly(h.date).isAfter(monthEnd))
        .toList();
    final monthRequests = requests
        .where((r) =>
            !dateOnly(r.endDate).isBefore(monthStart) && !dateOnly(r.startDate).isAfter(monthEnd))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    Widget cell(int index) {
      final dayNum = index - lead + 1;
      if (dayNum < 1 || dayNum > daysInMonth) return const SizedBox.shrink();
      final date = DateTime(first.year, first.month, dayNum);
      final mark = marks[date] ?? _Mark.none;
      final isToday = date == today;
      final weekend = date.weekday > DateTime.friday;

      Color? bg;
      Color fg = weekend ? cs.outline : cs.onSurface;
      Border? border;
      switch (mark) {
        case _Mark.holiday:
          bg = cs.tertiaryContainer;
          fg = cs.onTertiaryContainer;
        case _Mark.leave:
          bg = cs.primary;
          fg = cs.onPrimary;
        case _Mark.leavePending:
          bg = cs.primaryContainer.withValues(alpha: 0.6);
          fg = cs.onPrimaryContainer;
          border = Border.all(color: cs.primary, width: 1.5);
        case _Mark.wfh:
          bg = cs.secondary;
          fg = cs.onSecondary;
        case _Mark.wfhPending:
          bg = cs.secondaryContainer.withValues(alpha: 0.6);
          fg = cs.onSecondaryContainer;
          border = Border.all(color: cs.secondary, width: 1.5);
        case _Mark.none:
          break;
      }
      if (isToday && border == null) border = Border.all(color: cs.primary, width: 2);

      return Padding(
        padding: const EdgeInsets.all(2.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: weekend || mark == _Mark.holiday
              ? null
              : () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => NewRequestScreen(initialDate: date))),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: border,
            ),
            alignment: Alignment.center,
            child: Text('$dayNum',
                style: TextStyle(
                    color: fg,
                    fontWeight: isToday || mark != _Mark.none ? FontWeight.w800 : FontWeight.w500)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          TextButton(
            onPressed: () => setState(
                () => _month = DateTime(DateTime.now().year, DateTime.now().month)),
            child: const Text('Today'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                  onPressed: () => _shift(-1), icon: const Icon(Icons.chevron_left)),
              Expanded(
                child: Text(fmtMonthYear.format(first),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ),
              IconButton.filledTonal(
                  onPressed: () => _shift(1), icon: const Icon(Icons.chevron_right)),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                      Expanded(
                        child: Center(
                          child: Text(d,
                              style: TextStyle(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                for (var row = 0; row < cells ~/ 7; row++)
                  Row(
                    children: [
                      for (var col = 0; col < 7; col++)
                        Expanded(child: AspectRatio(aspectRatio: 1, child: cell(row * 7 + col))),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Legend(color: cs.tertiaryContainer, label: 'Holiday'),
              _Legend(color: cs.primary, label: 'Leave'),
              _Legend(color: cs.secondary, label: 'WFH'),
              _Legend(color: cs.primaryContainer, label: 'Pending', outlined: cs.primary),
            ],
          ),
          SectionHeader('In ${fmtMonth.format(first)}'),
          if (monthHolidays.isEmpty && monthRequests.isEmpty)
            AppCard(
              child: Text('Nothing planned this month. Tap a weekday to start a request.',
                  style: TextStyle(color: cs.onSurfaceVariant)),
            ),
          for (final h in monthHolidays) ...[
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  DateBox(h.date, color: cs.tertiary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text('Holiday · ${fmtWeekday.format(h.date)}',
                            style: TextStyle(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (final r in monthRequests) ...[
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  DateBox(r.startDate, color: r.category == 'wfh' ? cs.secondary : cs.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.category == 'wfh'
                              ? 'Work from home'
                              : (types.where((t) => t.id == r.leaveTypeId).firstOrNull?.name ??
                                  'Leave'),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text('${rangeText(r.startDate, r.endDate)} · ${plural(r.days)}',
                            style: TextStyle(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  StatusPill(pending: r.status == 'pending'),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.outlined});

  final Color color;
  final String label;
  final Color? outlined;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              border: outlined == null ? null : Border.all(color: outlined!, width: 1.5),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      );
}
