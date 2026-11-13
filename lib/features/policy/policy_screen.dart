import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models.dart';
import 'policy_editor.dart';

/// Edits the saved policy. Pass [initial] to review an imported policy
/// before it replaces the saved one.
class PolicyScreen extends ConsumerStatefulWidget {
  const PolicyScreen({super.key, this.initial, this.title = 'Leave policy', this.banner});

  final PolicyDraft? initial;
  final String title;
  final String? banner;

  @override
  ConsumerState<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends ConsumerState<PolicyScreen> {
  PolicyDraft? _draft;
  bool _saving = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _draft = widget.initial;
      _dirty = true;
    } else {
      ref.read(databaseProvider).loadPolicy().then((p) {
        if (mounted) setState(() => _draft = p);
      });
    }
  }

  Future<void> _save() async {
    final d = _draft;
    if (d == null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await ref.read(databaseProvider).replacePolicy(d);
      messenger.showSnackBar(const SnackBar(content: Text('Policy saved')));
      nav.pop(true);
    } catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  Future<bool> _confirmDiscard() async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your edits have not been saved.'),
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
    final d = _draft;
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (await _confirmDiscard()) nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: d == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (widget.banner != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                      child: _Banner(widget.banner!),
                    ),
                  Expanded(
                    child: PolicyEditor(
                      policy: d,
                      onChanged: (p) => setState(() {
                        _draft = p;
                        _dirty = true;
                      }),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: d == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving || !_dirty ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5))
                          : const Text('Save policy'),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: cs.onSecondaryContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: cs.onSecondaryContainer))),
        ],
      ),
    );
  }
}
