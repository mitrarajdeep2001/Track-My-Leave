import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../domain/models.dart';

/// Editable view of a [PolicyDraft]. Purely controlled: it never keeps its
/// own copy, so any screen can host it.
class PolicyEditor extends StatelessWidget {
  const PolicyEditor({
    super.key,
    required this.policy,
    required this.onChanged,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 24),
  });

  final PolicyDraft policy;
  final ValueChanged<PolicyDraft> onChanged;
  final EdgeInsets padding;

  Future<void> _addType(BuildContext context) async {
    final t = await showDialog<LeaveTypeDraft>(
      context: context,
      builder: (_) => _LeaveTypeDialog(existing: policy.leaveTypes),
    );
    if (t != null) onChanged(policy.copyWith(leaveTypes: [...policy.leaveTypes, t]));
  }

  Future<void> _editType(BuildContext context, int i) async {
    final t = await showDialog<LeaveTypeDraft>(
      context: context,
      builder: (_) => _LeaveTypeDialog(initial: policy.leaveTypes[i], existing: policy.leaveTypes),
    );
    if (t != null) {
      final l = [...policy.leaveTypes]..[i] = t;
      onChanged(policy.copyWith(leaveTypes: l));
    }
  }

  Future<void> _addHoliday(BuildContext context) async {
    final h = await showDialog<HolidayDraft>(
      context: context,
      builder: (_) => const _HolidayDialog(),
    );
    if (h != null) {
      final l = [...policy.holidays, h]..sort((a, b) => a.date.compareTo(b.date));
      onChanged(policy.copyWith(holidays: l));
    }
  }

  Future<void> _editHoliday(BuildContext context, int i) async {
    final h = await showDialog<HolidayDraft>(
      context: context,
      builder: (_) => _HolidayDialog(initial: policy.holidays[i]),
    );
    if (h != null) {
      final l = [...policy.holidays]..[i] = h;
      l.sort((a, b) => a.date.compareTo(b.date));
      onChanged(policy.copyWith(holidays: l));
    }
  }

  Future<void> _setAllWfh(BuildContext context) async {
    final v = await showDialog<int>(
      context: context,
      builder: (_) => const _NumberDialog(
        title: 'WFH days for every month',
        label: 'Days per month',
      ),
    );
    if (v != null) onChanged(policy.copyWith(wfh: {for (var m = 1; m <= 12; m++) m: v}));
  }

  void _setWfh(int month, int days) =>
      onChanged(policy.copyWith(wfh: {...policy.wfh, month: days.clamp(0, 31)}));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = TextStyle(color: cs.onSurfaceVariant);

    return ListView(
      padding: padding,
      children: [
        // ---- Leave types ----
        SectionHeader('Leave types', trailing: SmallAddButton(onPressed: () => _addType(context))),
        if (policy.leaveTypes.isEmpty)
          AppCard(child: Text('Add at least one leave type, such as Casual or Sick leave.', style: muted)),
        for (var i = 0; i < policy.leaveTypes.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          AppCard(
            onTap: () => _editType(context, i),
            padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
            child: Row(
              children: [
                IconBadge(Icons.beach_access_outlined, color: accentFor(i)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.leaveTypes[i].name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(
                        '${plural(policy.leaveTypes[i].daysPerYear)} a year'
                        '${policy.leaveTypes[i].carryForward ? ' · carries forward' : ''}',
                        style: muted,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    final l = [...policy.leaveTypes]..removeAt(i);
                    onChanged(policy.copyWith(leaveTypes: l));
                  },
                ),
              ],
            ),
          ),
        ],

        // ---- Holidays ----
        SectionHeader('Holidays', trailing: SmallAddButton(onPressed: () => _addHoliday(context))),
        if (policy.holidays.isEmpty)
          AppCard(child: Text('No holidays yet. Add the public holidays you get off.', style: muted)),
        for (var i = 0; i < policy.holidays.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          AppCard(
            onTap: () => _editHoliday(context, i),
            padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
            child: Row(
              children: [
                DateBox(policy.holidays[i].date, color: cs.tertiary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.holidays[i].name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(
                        '${fmtWeekday.format(policy.holidays[i].date)}, ${fmtDayYear.format(policy.holidays[i].date)}'
                        '${policy.holidays[i].optional ? ' · optional' : ''}',
                        style: muted,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    final l = [...policy.holidays]..removeAt(i);
                    onChanged(policy.copyWith(holidays: l));
                  },
                ),
              ],
            ),
          ),
        ],

        // ---- WFH ----
        SectionHeader(
          'Work from home per month',
          trailing: TextButton(onPressed: () => _setAllWfh(context), child: const Text('Set all')),
        ),
        LayoutBuilder(builder: (context, c) {
          const gap = 10.0;
          final w = (c.maxWidth - gap * 2) / 3;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (var m = 1; m <= 12; m++)
                SizedBox(
                  width: w,
                  child: _WfhCell(
                    month: m,
                    days: policy.wfh[m] ?? 0,
                    onChanged: (d) => _setWfh(m, d),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _WfhCell extends StatelessWidget {
  const _WfhCell({required this.month, required this.days, required this.onChanged});

  final int month;
  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget btn(IconData icon, VoidCallback? onTap) => InkResponse(
          onTap: onTap,
          radius: 18,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: 20, color: onTap == null ? cs.outline : cs.primary),
          ),
        );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: days > 0 ? cs.primaryContainer.withValues(alpha: 0.4) : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(fmtMonthShort.format(DateTime(2000, month)),
              style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              btn(Icons.remove, days > 0 ? () => onChanged(days - 1) : null),
              Text('$days', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              btn(Icons.add, days < 31 ? () => onChanged(days + 1) : null),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- Dialogs (own their controllers so disposal is safe) --------------------

class _LeaveTypeDialog extends StatefulWidget {
  const _LeaveTypeDialog({this.initial, this.existing = const []});

  final LeaveTypeDraft? initial;
  final List<LeaveTypeDraft> existing;

  @override
  State<_LeaveTypeDialog> createState() => _LeaveTypeDialogState();
}

class _LeaveTypeDialogState extends State<_LeaveTypeDialog> {
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final _days = TextEditingController(
      text: widget.initial == null ? '' : fmtNum(widget.initial!.daysPerYear));
  late bool _carry = widget.initial?.carryForward ?? false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _days.dispose();
    super.dispose();
  }

  void _submit() {
    final n = _name.text.trim();
    final d = double.tryParse(_days.text.trim().replaceAll(',', '.'));
    if (n.isEmpty) return setState(() => _error = 'Enter a name');
    if (d == null || d <= 0) return setState(() => _error = 'Enter the days per year');
    final dup = widget.existing.any((e) =>
        e.name.toLowerCase() == n.toLowerCase() &&
        e.name.toLowerCase() != widget.initial?.name.toLowerCase());
    if (dup) return setState(() => _error = 'You already have a leave type with this name');
    Navigator.pop(context, LeaveTypeDraft(name: n, daysPerYear: d, carryForward: _carry));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.initial == null ? 'Add leave type' : 'Edit leave type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'Casual leave'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _days,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Days per year'),
              onSubmitted: (_) => _submit(),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Carries forward'),
              subtitle: const Text('Unused days move to next year'),
              value: _carry,
              onChanged: (v) => setState(() => _carry = v),
            ),
            if (_error != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: Text(widget.initial == null ? 'Add' : 'Save'),
          ),
        ],
      );
}

class _HolidayDialog extends StatefulWidget {
  const _HolidayDialog({this.initial});

  final HolidayDraft? initial;

  @override
  State<_HolidayDialog> createState() => _HolidayDialogState();
}

class _HolidayDialogState extends State<_HolidayDialog> {
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late DateTime _date = widget.initial?.date ?? dateOnly(DateTime.now());
  late bool _optional = widget.initial?.optional ?? false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (d != null) setState(() => _date = d);
  }

  void _submit() {
    final n = _name.text.trim();
    if (n.isEmpty) return setState(() => _error = 'Enter a name');
    Navigator.pop(context, HolidayDraft(name: n, date: dateOnly(_date), optional: _optional));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.initial == null ? 'Add holiday' : 'Edit holiday'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Name', hintText: 'Diwali', errorText: _error),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.event),
              label: Text(fmtLongDate.format(_date)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Optional holiday'),
              value: _optional,
              onChanged: (v) => setState(() => _optional = v),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: Text(widget.initial == null ? 'Add' : 'Save'),
          ),
        ],
      );
}

class _NumberDialog extends StatefulWidget {
  const _NumberDialog({required this.title, required this.label});

  final String title;
  final String label;

  @override
  State<_NumberDialog> createState() => _NumberDialogState();
}

class _NumberDialogState extends State<_NumberDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final v = int.tryParse(_c.text.trim());
    if (v != null && v >= 0 && v <= 31) Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: _c,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: widget.label),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: const Text('Apply'),
          ),
        ],
      );
}
