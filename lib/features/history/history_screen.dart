import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../requests/new_request_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(historyFilterProvider);
    final all = ref.watch(requestsProvider).value ?? const <LeaveRequest>[];
    final types = ref.watch(leaveTypesProvider).value ?? const <LeaveType>[];

    final items = all.where((r) {
      switch (filter) {
        case RequestFilter.all:
          return true;
        case RequestFilter.pending:
          return r.status == 'pending';
        case RequestFilter.sent:
          return r.status == 'applied';
      }
    }).toList();

    final pendingCount = all.where((r) => r.status == 'pending').length;

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                for (final f in RequestFilter.values) ...[
                  ChoiceChip(
                    label: Text(switch (f) {
                      RequestFilter.all => 'All',
                      RequestFilter.pending =>
                        pendingCount > 0 ? 'Pending ($pendingCount)' : 'Pending',
                      RequestFilter.sent => 'Sent',
                    }),
                    selected: filter == f,
                    onSelected: (_) => ref.read(historyFilterProvider.notifier).set(f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? EmptyState(
                    icon: Icons.history,
                    title: all.isEmpty ? 'No requests yet' : 'Nothing here',
                    message: all.isEmpty
                        ? 'Requests you send will show up here so you can track them.'
                        : 'No requests match this filter.',
                    action: all.isEmpty
                        ? FilledButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const NewRequestScreen())),
                            child: const Text('Create a request'),
                          )
                        : null,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _RequestCard(
                      request: items[i],
                      typeName: types
                          .where((t) => t.id == items[i].leaveTypeId)
                          .firstOrNull
                          ?.name,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  const _RequestCard({required this.request, required this.typeName});

  final LeaveRequest request;
  final String? typeName;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this request?'),
        content: const Text('It will no longer count towards your balance.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(88, 44),
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(databaseProvider).deleteRequest(request.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isWfh = request.category == 'wfh';
    final pending = request.status == 'pending';
    final title = isWfh ? 'Work from home' : (typeName ?? 'Leave');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                isWfh ? Icons.home_work_outlined : Icons.beach_access_outlined,
                color: isWfh ? cs.secondary : cs.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$title · ${plural(request.days)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(rangeText(request.startDate, request.endDate),
                        style: TextStyle(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              StatusPill(pending: pending),
            ],
          ),
          if (request.reason != null && request.reason!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(request.reason!, style: TextStyle(color: cs.onSurfaceVariant)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  pending
                      ? 'Created ${fmtDayYear.format(request.createdAt)}'
                      : 'Sent ${fmtDayYear.format(request.appliedAt ?? request.createdAt)}',
                  style: TextStyle(color: cs.outline, fontSize: 12.5),
                ),
              ),
              if (pending)
                FilledButton.tonal(
                  onPressed: () => ref.read(databaseProvider).markApplied(request.id),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Mark as sent'),
                ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
