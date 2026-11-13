import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
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
    await ref.read(databaseProvider).addRecipient(e);
    _email.clear();
    setState(() => _err = null);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final list = ref.watch(recipientsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Recipients')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text('Your supervisor or team lead. Every request is addressed to all of them.',
              style: TextStyle(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Add email address',
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
          const SizedBox(height: 20),
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.group_outlined,
              title: 'No recipients yet',
              message: 'Add at least one email to send requests.',
            ),
          for (final r in list) ...[
            AppCard(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Text(r.email[0].toUpperCase(),
                        style: TextStyle(
                            color: cs.onPrimaryContainer, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(r.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    tooltip: 'Remove',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref.read(databaseProvider).removeRecipient(r.id),
                  ),
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
