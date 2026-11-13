import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../services/leave_math.dart';
import '../../services/request_composer.dart';
import '../settings/email_template_screen.dart';

class NewRequestScreen extends ConsumerStatefulWidget {
  const NewRequestScreen({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  ConsumerState<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends ConsumerState<NewRequestScreen>
    with WidgetsBindingObserver {
  bool _wfh = false;
  int? _typeId;
  DateTimeRange? _range;
  final _reason = TextEditingController();

  /// The pending request created by the last send attempt, awaiting the
  /// user's "Did you send it?" answer.
  int? _awaitingId;
  bool _asking = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final d = widget.initialDate;
    if (d != null) _range = DateTimeRange(start: dateOnly(d), end: dateOnly(d));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reason.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingId != null) _askSent();
  }

  Future<void> _askSent() async {
    if (_asking || !mounted) return;
    _asking = true;
    final id = _awaitingId!;
    final sent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.mark_email_read_outlined,
            size: 32, color: Theme.of(ctx).colorScheme.primary),
        title: const Text('Did you send it?'),
        content: const Text(
            'Come back and confirm once you have pressed Send, so your records stay accurate.'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not yet')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(minimumSize: const Size(120, 44)),
            child: const Text('Yes, sent'),
          ),
        ],
      ),
    );
    _asking = false;
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (sent == true) {
      await ref.read(databaseProvider).markApplied(id);
      _awaitingId = null;
      messenger.showSnackBar(const SnackBar(content: Text('Request marked as sent')));
      if (mounted) Navigator.of(context).pop();
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Saved as pending. You can send it now or confirm it later from History.'),
      ));
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: _range,
      helpText: _wfh ? 'Select WFH dates' : 'Select leave dates',
    );
    if (r != null) setState(() => _range = r);
  }

  Future<void> _send({required bool whatsapp}) async {
    final s = ref.read(settingsProvider).value;
    final all = ref.read(recipientsProvider).value ?? const <Recipient>[];
    final recipients = [for (final r in all) if (r.kind != recipientCc) r.email];
    final cc = [for (final r in all) if (r.kind == recipientCc) r.email];
    final types = ref.read(leaveTypesProvider).value ?? const <LeaveType>[];
    final holidays = ref.read(holidaysProvider).value ?? const <Holiday>[];
    final messenger = ScaffoldMessenger.of(context);
    final range = _range;

    String? problem;
    final typeId = _typeId ?? types.firstOrNull?.id;
    final days = range == null
        ? 0.0
        : workingDays(range.start, range.end, holidays.map((h) => h.date));
    if (range == null) {
      problem = 'Pick the dates first';
    } else if (days == 0) {
      problem = 'Those dates are all weekends or holidays';
    } else if (!_wfh && typeId == null) {
      problem = 'Add a leave type in Settings first';
    } else if (!whatsapp && recipients.isEmpty) {
      problem = 'Add a To recipient in Settings first';
    }
    if (problem != null) {
      messenger.showSnackBar(SnackBar(content: Text(problem)));
      return;
    }

    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    // Re-sending after edits replaces the earlier pending record.
    if (_awaitingId != null) await db.deleteRequest(_awaitingId!);
    final reason = _reason.text.trim();
    final id = await db.addRequest(
      category: _wfh ? 'wfh' : 'leave',
      leaveTypeId: _wfh ? null : typeId,
      start: range!.start,
      end: range.end,
      days: days,
      reason: reason.isEmpty ? null : reason,
    );

    final msg = composeMessage(
      wfh: _wfh,
      typeName: types.where((t) => t.id == typeId).firstOrNull?.name,
      start: range.start,
      end: range.end,
      days: days,
      reason: reason,
      userName: s?.userName ?? '',
      company: s?.companyName ?? '',
      subjectTemplate: _wfh ? s?.wfhSubjectTpl : s?.leaveSubjectTpl,
      bodyTemplate: _wfh ? s?.wfhBodyTpl : s?.leaveBodyTpl,
    );
    final uri = whatsapp
        ? whatsappUri(s?.whatsappNumber ?? '', msg)
        : mailtoUri(recipients, msg, cc: cc);
    final ok = await launchExternal(uri);

    if (!mounted) return;
    if (!ok) {
      await db.deleteRequest(id);
      _awaitingId = null;
      messenger.showSnackBar(SnackBar(
          content: Text(whatsapp ? 'Could not open WhatsApp' : 'Could not open an email app')));
    } else {
      _awaitingId = id;
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = ref.watch(settingsProvider).value;
    final recipients = ref.watch(recipientsProvider).value ?? const <Recipient>[];
    final types = ref.watch(leaveTypesProvider).value ?? const <LeaveType>[];
    final holidays = ref.watch(holidaysProvider).value ?? const <Holiday>[];
    final requests = ref.watch(requestsProvider).value ?? const <LeaveRequest>[];
    final wfhRows = ref.watch(wfhProvider).value ?? const <WfhAllowance>[];

    final typeId = _typeId ?? types.firstOrNull?.id;
    final range = _range;
    final days = range == null
        ? 0.0
        : workingDays(range.start, range.end, holidays.map((h) => h.date));
    final skipped = range == null ? 0 : range.duration.inDays + 1 - days.toInt();

    // Balance warning
    String? warning;
    if (range != null && days > 0) {
      if (_wfh) {
        final m = range.start;
        final allowed = wfhRows.where((w) => w.month == m.month).firstOrNull?.daysAllowed ?? 0;
        final u = wfhUsage(requests, m.year, m.month);
        final left = allowed - u.used - u.pending;
        if (days > left) {
          warning = allowed == 0
              ? 'You have no WFH days set for ${fmtMonth.format(m)}.'
              : 'Only ${fmtNum(left < 0 ? 0 : left)} WFH days left in ${fmtMonth.format(m)}.';
        }
      } else if (typeId != null) {
        final b = computeBalances(types, requests, range.start.year)
            .where((b) => b.type.id == typeId)
            .firstOrNull;
        if (b != null && days > b.remaining) {
          warning =
              'Only ${fmtNum(b.remaining < 0 ? 0 : b.remaining)} days of ${b.type.name} left.';
        }
      }
    }

    final typeName = types.where((t) => t.id == typeId).firstOrNull?.name;
    final msg = range == null || days == 0
        ? null
        : composeMessage(
            wfh: _wfh,
            typeName: typeName,
            start: range.start,
            end: range.end,
            days: days,
            reason: _reason.text,
            userName: s?.userName ?? '',
            company: s?.companyName ?? '',
            subjectTemplate: _wfh ? s?.wfhSubjectTpl : s?.leaveSubjectTpl,
            bodyTemplate: _wfh ? s?.wfhBodyTpl : s?.leaveBodyTpl,
          );
    final hasWhatsapp = (s?.whatsappNumber ?? '').trim().isNotEmpty;
    final toList = [for (final r in recipients) if (r.kind != recipientCc) r.email];
    final ccList = [for (final r in recipients) if (r.kind == recipientCc) r.email];

    return Scaffold(
      appBar: AppBar(title: const Text('New request')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                    value: false, icon: Icon(Icons.beach_access_outlined), label: Text('Leave')),
                ButtonSegment(
                    value: true, icon: Icon(Icons.home_work_outlined), label: Text('Work from home')),
              ],
              selected: {_wfh},
              onSelectionChanged: (v) => setState(() => _wfh = v.first),
            ),
          ),

          if (!_wfh) ...[
            const SectionHeader('Leave type'),
            if (types.isEmpty)
              AppCard(
                child: Text('No leave types yet. Add them under Settings → Leave policy.',
                    style: TextStyle(color: cs.onSurfaceVariant)),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in types)
                    ChoiceChip(
                      label: Text(t.name),
                      selected: t.id == typeId,
                      onSelected: (_) => setState(() => _typeId = t.id),
                    ),
                ],
              ),
          ],

          const SectionHeader('Dates'),
          AppCard(
            onTap: _pickRange,
            child: Row(
              children: [
                const IconBadge(Icons.event),
                const SizedBox(width: 14),
                Expanded(
                  child: range == null
                      ? Text('Choose dates',
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rangeText(range.start, range.end),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(
                              days == 0
                                  ? 'No working days in this range'
                                  : '${plural(days)}'
                                      '${skipped > 0 ? ' · $skipped weekend/holiday skipped' : ''}',
                              style: TextStyle(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                ),
                Icon(Icons.edit_calendar_outlined, color: cs.onSurfaceVariant),
              ],
            ),
          ),

          if (warning != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.onErrorContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('$warning You can still send the request.',
                        style: TextStyle(color: cs.onErrorContainer)),
                  ),
                ],
              ),
            ),
          ],

          const SectionHeader('Reason (optional)'),
          TextField(
            controller: _reason,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'e.g. Family function'),
            onChanged: (_) => setState(() {}),
          ),

          SectionHeader(
            'Email preview',
            trailing: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EmailTemplateScreen(initialWfh: _wfh))),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit template'),
            ),
          ),
          AppCard(
            child: msg == null
                ? Text('Pick your dates to see the email.',
                    style: TextStyle(color: cs.onSurfaceVariant))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreviewRow('To', toList.isEmpty ? 'No recipients yet' : toList.join(', ')),
                      if (ccList.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _PreviewRow('Cc', ccList.join(', ')),
                      ],
                      const Divider(height: 24),
                      _PreviewRow('Subject', msg.subject),
                      const Divider(height: 24),
                      Text(msg.body, style: const TextStyle(height: 1.45)),
                    ],
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your email app opens with this filled in. You review it and tap Send.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => _send(whatsapp: false),
                  icon: _busy
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send_outlined),
                  label: Text('Open in ${emailAppLabel(s?.emailAppPackage).split(' / ').first}'),
                ),
              ),
              if (hasWhatsapp) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : () => _send(whatsapp: true),
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Send on WhatsApp'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 64,
            child: Text(label, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
