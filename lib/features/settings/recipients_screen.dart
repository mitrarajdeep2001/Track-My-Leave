import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';

class RecipientsScreen extends ConsumerStatefulWidget {
  const RecipientsScreen({super.key});

  @override
  ConsumerState<RecipientsScreen> createState() => _RecipientsScreenState();
}

class _RecipientsScreenState extends ConsumerState<RecipientsScreen> {
  final _email = TextEditingController();
  String? _err;
  String _kind = recipientTo;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final e = _email.text.trim().toLowerCase();
    if (e.isEmpty) return;
    final existing = ref.read(recipientsProvider).value ?? [];
    if (!isValidEmail(e) || existing.any((r) => r.email == e)) {
      setState(() => _err = 'Enter a valid email that is not already added');
      return;
    }
    await ref.read(databaseProvider).addRecipient(e, kind: _kind);
    _email.clear();
    setState(() => _err = null);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final list = ref.watch(recipientsProvider).value ?? const <Recipient>[];
    final to = list.where((r) => r.kind != recipientCc).toList();
    final cc = list.where((r) => r.kind == recipientCc).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Recipients')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Requests are addressed to everyone in To. People in Cc get a copy, for example HR.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: recipientTo, label: Text('Add to To')),
              ButtonSegment(value: recipientCc, label: Text('Add to Cc')),
            ],
            selected: {_kind},
            onSelectionChanged: (v) => setState(() => _kind = v.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: _kind == recipientCc ? 'Add Cc email' : 'Add To email',
              prefixIcon: const Icon(Icons.alternate_email),
              errorText: _err,
              suffixIcon: IconButton(
                tooltip: 'Add',
                icon: Icon(Icons.add_circle, color: cs.primary),
                onPressed: _add,
              ),
            ),
            onSubmitted: (_) => _add(),
          ),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: EmptyState(
                icon: Icons.group_outlined,
                title: 'No recipients yet',
                message: 'Add at least one To email to send requests.',
              ),
            ),
          if (list.isNotEmpty) ...[
            const SectionHeader('To'),
            if (to.isEmpty)
              AppCard(
                child: Text('Requests need at least one To recipient.',
                    style: TextStyle(color: cs.error)),
              ),
            for (final r in to) _RecipientCard(recipient: r),
            if (cc.isNotEmpty) ...[
              const SectionHeader('Cc'),
              for (final r in cc) _RecipientCard(recipient: r),
            ],
          ],
        ],
      ),
    );
  }
}

class _RecipientCard extends ConsumerWidget {
  const _RecipientCard({required this.recipient});

  final Recipient recipient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isCc = recipient.kind == recipientCc;
    final db = ref.read(databaseProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isCc ? cs.secondaryContainer : cs.primaryContainer,
              child: Text(recipient.email[0].toUpperCase(),
                  style: TextStyle(
                      color: isCc ? cs.onSecondaryContainer : cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(recipient.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            PopupMenuButton<String>(
              tooltip: 'Options',
              onSelected: (v) {
                if (v == 'move') {
                  db.setRecipientKind(recipient.id, isCc ? recipientTo : recipientCc);
                } else {
                  db.removeRecipient(recipient.id);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'move',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(isCc ? Icons.arrow_upward : Icons.arrow_downward),
                    title: Text(isCc ? 'Move to To' : 'Move to Cc'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.delete_outline),
                    title: Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
