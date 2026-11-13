import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../services/leave_math.dart';
import '../policy/policy_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider).value;
    final types = ref.watch(leaveTypesProvider).value ?? const <LeaveType>[];
    final holidays = ref.watch(holidaysProvider).value ?? const <Holiday>[];
    final requests = ref.watch(requestsProvider).value ?? const <LeaveRequest>[];
    final wfh = ref.watch(wfhProvider).value ?? const <WfhAllowance>[];

    final now = DateTime.now();
    final today = dateOnly(now);
    final balances = computeBalances(types, requests, now.year);
    final pendingCount = requests.where((r) => r.status == 'pending').length;
    final allowed = wfh.where((w) => w.month == now.month).firstOrNull?.daysAllowed ?? 0;
    final usage = wfhUsage(requests, now.year, now.month);
    final wfhLeft = allowed - usage.used - usage.pending;
    final leaveLeft = balances.fold<double>(0, (s, b) => s + b.remaining);
    final upcoming =
        holidays.where((h) => !dateOnly(h.date).isBefore(today)).take(3).toList();

    final name = settings?.userName.trim() ?? '';
    final first = name.isEmpty ? 'there' : name.split(RegExp(r'\s+')).first;
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          // ---- Header ----
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fmtLongDate.format(now),
                        style: TextStyle(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 2),
                    Text('$greeting, $first',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  first.isEmpty ? '?' : first[0].toUpperCase(),
                  style: TextStyle(
                      color: cs.onPrimaryContainer, fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ---- Hero summary ----
          _Hero(
            leaveLeft: leaveLeft,
            hasLeave: types.isNotEmpty,
            wfhLeft: wfhLeft,
            hasWfh: allowed > 0,
            pending: pendingCount,
            month: fmtMonthShort.format(now),
          ),

          // ---- Pending banner ----
          if (pendingCount > 0) ...[
            const SizedBox(height: 14),
            AppCard(
              color: cs.tertiaryContainer,
              onTap: () {
                ref.read(historyFilterProvider.notifier).set(RequestFilter.pending);
                ref.read(navIndexProvider.notifier).set(2);
              },
              child: Row(
                children: [
                  Icon(Icons.mark_email_unread_outlined, color: cs.onTertiaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pendingCount == 1
                              ? '1 request is waiting'
                              : '$pendingCount requests are waiting',
                          style: TextStyle(
                              color: cs.onTertiaryContainer, fontWeight: FontWeight.w700),
                        ),
                        Text('Did you send them? Tap to confirm.',
                            style: TextStyle(color: cs.onTertiaryContainer)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: cs.onTertiaryContainer),
                ],
              ),
            ),
          ],

          // ---- Leave balances ----
          SectionHeader('Leave balance ${now.year}'),
          if (balances.isEmpty)
            AppCard(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const PolicyScreen())),
              child: Row(
                children: [
                  const IconBadge(Icons.add_task),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('No leave types yet. Tap to set up your policy.')),
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                ],
              ),
            )
          else
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.98,
              children: [
                for (var i = 0; i < balances.length; i++)
                  _BalanceCard(balance: balances[i], color: accentFor(i)),
              ],
            ),

          // ---- WFH ----
          SectionHeader('Work from home · ${fmtMonth.format(now)}'),
          AppCard(
            child: allowed == 0
                ? Row(
                    children: [
                      const IconBadge(Icons.home_work_outlined),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('No WFH days set for this month.',
                            style: TextStyle(color: cs.onSurfaceVariant)),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const IconBadge(Icons.home_work_outlined),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wfhLeft < 0 ? 'Over by ${fmtNum(-wfhLeft)}' : '${fmtNum(wfhLeft)} left',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: wfhLeft < 0 ? cs.error : null,
                                  ),
                                ),
                                Text(
                                  '${fmtNum(usage.used)} used'
                                  '${usage.pending > 0 ? ' · ${fmtNum(usage.pending)} pending' : ''}'
                                  ' of $allowed',
                                  style: TextStyle(color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SegmentBar(
                        used: usage.used,
                        pending: usage.pending,
                        total: allowed.toDouble(),
                        color: cs.secondary,
                      ),
                    ],
                  ),
          ),

          // ---- Upcoming holidays ----
          SectionHeader(
            'Upcoming holidays',
            trailing: TextButton(
              onPressed: () => ref.read(navIndexProvider.notifier).set(1),
              child: const Text('Calendar'),
            ),
          ),
          if (upcoming.isEmpty)
            AppCard(
              child: Text('No upcoming holidays in your policy.',
                  style: TextStyle(color: cs.onSurfaceVariant)),
            )
          else
            for (var i = 0; i < upcoming.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _HolidayTile(holiday: upcoming[i], today: today),
            ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.leaveLeft,
    required this.hasLeave,
    required this.wfhLeft,
    required this.hasWfh,
    required this.pending,
    required this.month,
  });

  final double leaveLeft;
  final bool hasLeave;
  final double wfhLeft;
  final bool hasWfh;
  final int pending;
  final String month;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final on = cs.onPrimary;

    Widget stat(String value, String label) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      color: on, fontSize: 30, fontWeight: FontWeight.w800, height: 1.1)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(color: on.withValues(alpha: 0.85), fontSize: 13)),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, Color.alphaBlend(cs.tertiary.withValues(alpha: 0.45), cs.primary)],
        ),
      ),
      child: Row(
        children: [
          stat(hasLeave ? fmtNum(leaveLeft) : '–', 'leave days left'),
          stat(hasWfh ? fmtNum(wfhLeft < 0 ? 0 : wfhLeft) : '–', 'WFH left ($month)'),
          stat('$pending', 'pending'),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance, required this.color});

  final LeaveBalance balance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = balance.total <= 0 ? 1.0 : balance.total;
    final over = balance.remaining < 0;
    final ringColor = over ? cs.error : color;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: (balance.remaining / total).clamp(0.0, 1.0),
                        strokeWidth: 7,
                        strokeCap: StrokeCap.round,
                        color: ringColor,
                        backgroundColor: ringColor.withValues(alpha: 0.15),
                      ),
                    ),
                    Text(fmtNum(balance.remaining),
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18, color: ringColor)),
                  ],
                ),
              ),
              if (balance.type.carryForward)
                Tooltip(
                  message: 'Carries forward',
                  child: Icon(Icons.redo, size: 20, color: cs.onSurfaceVariant),
                ),
            ],
          ),
          const Spacer(),
          Text(balance.type.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          Text(
            '${fmtNum(balance.used)} used of ${fmtNum(balance.total)}'
            '${balance.pending > 0 ? ' · ${fmtNum(balance.pending)} pending' : ''}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _HolidayTile extends StatelessWidget {
  const _HolidayTile({required this.holiday, required this.today});

  final Holiday holiday;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final diff = dateOnly(holiday.date).difference(today).inDays;
    final when = diff == 0
        ? 'Today'
        : diff == 1
            ? 'Tomorrow'
            : 'In $diff days';
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          DateBox(holiday.date, color: cs.tertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holiday.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(fmtWeekday.format(holiday.date),
                    style: TextStyle(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Text(when,
              style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
