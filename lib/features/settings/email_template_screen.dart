import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../services/request_composer.dart';

/// Edit the subject and body used for leave and WFH request emails.
class EmailTemplateScreen extends ConsumerStatefulWidget {
  const EmailTemplateScreen({super.key, this.initialWfh = false});

  final bool initialWfh;

  @override
  ConsumerState<EmailTemplateScreen> createState() => _EmailTemplateScreenState();
}

class _Pair {
  _Pair(String subject, String body)
      : subject = TextEditingController(text: subject),
        body = TextEditingController(text: body);

  final TextEditingController subject;
  final TextEditingController body;

  void dispose() {
    subject.dispose();
    body.dispose();
  }
}

class _EmailTemplateScreenState extends ConsumerState<EmailTemplateScreen> {
  late bool _wfh = widget.initialWfh;
  _Pair? _leave;
  _Pair? _wfhPair;
  final _subjectFocus = FocusNode();
  final _bodyFocus = FocusNode();
  bool _subjectActive = false;
  bool _dirty = false;
  bool _saving = false;

  _Pair get _cur => _wfh ? _wfhPair! : _leave!;

  @override
  void initState() {
    super.initState();
    _subjectFocus.addListener(() {
      if (_subjectFocus.hasFocus) setState(() => _subjectActive = true);
    });
    _bodyFocus.addListener(() {
      if (_bodyFocus.hasFocus) setState(() => _subjectActive = false);
    });
    final db = ref.read(databaseProvider);
    (db.select(db.appSettings)..where((t) => t.id.equals(1))).getSingle().then((s) {
      if (!mounted) return;
      setState(() {
        _leave = _Pair(s.leaveSubjectTpl ?? defaultLeaveSubject, s.leaveBodyTpl ?? defaultLeaveBody);
        _wfhPair = _Pair(s.wfhSubjectTpl ?? defaultWfhSubject, s.wfhBodyTpl ?? defaultWfhBody);
        for (final c in [_leave!.subject, _leave!.body, _wfhPair!.subject, _wfhPair!.body]) {
          c.addListener(_changed);
        }
      });
    });
  }

  void _changed() => setState(() => _dirty = true);

  @override
  void dispose() {
    _leave?.dispose();
    _wfhPair?.dispose();
    _subjectFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  void _insert(String token) {
    final c = _subjectActive ? _cur.subject : _cur.body;
    final text = c.text;
    final sel = c.selection;
    final start = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    c.value = TextEditingValue(
      text: text.replaceRange(start, end, token),
      selection: TextSelection.collapsed(offset: start + token.length),
    );
    (_subjectActive ? _subjectFocus : _bodyFocus).requestFocus();
  }

  void _reset() {
    _cur.subject.text = _wfh ? defaultWfhSubject : defaultLeaveSubject;
    _cur.body.text = _wfh ? defaultWfhBody : defaultLeaveBody;
  }

  /// Stores null when a template matches the default, so future changes to
  /// the built-in wording reach users who never customised it.
  Value<String?> _store(String v, String def) {
    final t = v.trim();
    return Value(t.isEmpty || t == def ? null : t);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    await ref.read(databaseProvider).updateSettings(AppSettingsCompanion(
          leaveSubjectTpl: _store(_leave!.subject.text, defaultLeaveSubject),
          leaveBodyTpl: _store(_leave!.body.text, defaultLeaveBody),
          wfhSubjectTpl: _store(_wfhPair!.subject.text, defaultWfhSubject),
          wfhBodyTpl: _store(_wfhPair!.body.text, defaultWfhBody),
        ));
    messenger.showSnackBar(const SnackBar(content: Text('Email template saved')));
    nav.pop();
  }

  Future<bool> _confirmDiscard() async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your template edits have not been saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep editing')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = ref.watch(settingsProvider).value;
    final ready = _leave != null;

    ComposedMessage? preview;
    if (ready) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day + 7);
      preview = composeMessage(
        wfh: _wfh,
        typeName: 'Casual leave',
        start: start,
        end: start.add(const Duration(days: 1)),
        days: 2,
        reason: 'Family function',
        userName: (s?.userName.isNotEmpty ?? false) ? s!.userName : 'Your name',
        company: (s?.companyName.isNotEmpty ?? false) ? s!.companyName : 'Your company',
        subjectTemplate: _cur.subject.text,
        bodyTemplate: _cur.body.text,
      );
    }

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (await _confirmDiscard()) nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email template'),
          actions: [
            if (ready)
              TextButton(onPressed: _reset, child: const Text('Reset')),
            const SizedBox(width: 8),
          ],
        ),
        body: !ready
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                            value: false,
                            icon: Icon(Icons.beach_access_outlined),
                            label: Text('Leave')),
                        ButtonSegment(
                            value: true,
                            icon: Icon(Icons.home_work_outlined),
                            label: Text('Work from home')),
                      ],
                      selected: {_wfh},
                      onSelectionChanged: (v) => setState(() => _wfh = v.first),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: ValueKey('subject-$_wfh'),
                    controller: _cur.subject,
                    focusNode: _subjectFocus,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(labelText: 'Subject'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: ValueKey('body-$_wfh'),
                    controller: _cur.body,
                    focusNode: _bodyFocus,
                    minLines: 8,
                    maxLines: 16,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      alignLabelWithHint: true,
                    ),
                  ),
                  SectionHeader('Insert a field (into ${_subjectActive ? 'subject' : 'message'})'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in templateFields)
                        Tooltip(
                          message: f.description,
                          child: ActionChip(
                            label: Text(f.token),
                            onPressed: () => _insert(f.token),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fields are filled in when you send a request. A line whose field is empty, such as "Reason: {reason}" with no reason, is left out.',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                  ),
                  const SectionHeader('Preview'),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(preview!.subject,
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        const Divider(height: 24),
                        Text(preview.body, style: const TextStyle(height: 1.45)),
                      ],
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: !ready
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving || !_dirty ? null : _save,
                      child: const Text('Save template'),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
