import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../ai/import_flow_screen.dart';
import '../ai/llm_settings_screen.dart';
import '../onboarding/onboarding_controller.dart';
import '../policy/policy_screen.dart';
import 'recipients_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  AppDatabase _db(WidgetRef ref) => ref.read(databaseProvider);

  void _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  Future<void> _editProfile(BuildContext context, WidgetRef ref, AppSetting s) async {
    final r = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _ProfileDialog(name: s.userName, company: s.companyName),
    );
    if (r != null) {
      await _db(ref).updateSettings(
          AppSettingsCompanion(userName: Value(r.$1), companyName: Value(r.$2)));
    }
  }

  Future<void> _pickEmailApp(BuildContext context, WidgetRef ref, AppSetting s) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Email app',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            for (final o in emailAppOptions)
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: Text(o.label),
                trailing: o.package == s.emailAppPackage
                    ? Icon(Icons.check_circle, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () async {
                  await _db(ref)
                      .updateSettings(AppSettingsCompanion(emailAppPackage: Value(o.package)));
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _editWhatsapp(BuildContext context, WidgetRef ref, AppSetting s) async {
    final v = await showDialog<String>(
      context: context,
      builder: (_) => _TextDialog(
        title: 'WhatsApp number',
        label: 'Number with country code',
        hint: '919876543210',
        initial: s.whatsappNumber ?? '',
        keyboard: TextInputType.phone,
        allowEmpty: true,
      ),
    );
    if (v != null) {
      await _db(ref).updateSettings(
          AppSettingsCompanion(whatsappNumber: Value(v.trim().isEmpty ? null : v.trim())));
    }
  }

  Future<void> _importPdf(BuildContext context) async {
    final p = await Navigator.of(context)
        .push<PolicyDraft>(MaterialPageRoute(builder: (_) => const ImportFlowScreen()));
    if (p != null && context.mounted) {
      _push(
        context,
        PolicyScreen(
          initial: p,
          title: 'Review imported policy',
          banner: 'AI can make mistakes. Check everything, then save to replace your current policy.',
        ),
      );
    }
  }

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded,
            size: 32, color: Theme.of(ctx).colorScheme.error),
        title: const Text('Erase all data?'),
        content: const Text(
            'This deletes your policy, requests, recipients and API key from this phone, and restarts setup. It cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(88, 44),
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Erase'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(secureKeyStoreProvider).clear();
    await _db(ref).resetAll();
    ref.invalidate(onboardingProvider);
    ref.invalidate(apiKeyPresentProvider);
    ref.read(navIndexProvider.notifier).set(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final s = ref.watch(settingsProvider).value;
    final recipients = ref.watch(recipientsProvider).value ?? const <Recipient>[];
    final keyPresent = ref.watch(apiKeyPresentProvider).value ?? false;
    if (s == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final provider = LlmProvider.fromName(s.llmProvider);
    final initial = s.userName.trim().isNotEmpty ? s.userName.trim()[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          AppCard(
            onTap: () => _editProfile(context, ref, s),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primaryContainer,
                  child: Text(initial,
                      style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                          fontSize: 22)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.userName.isEmpty ? 'Your name' : s.userName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                      Text(s.companyName.isEmpty ? 'Company' : s.companyName,
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
              ],
            ),
          ),
          _Group(title: 'Sending requests', children: [
            _Tile(
              icon: Icons.mail_outline,
              title: 'Email app',
              subtitle: emailAppLabel(s.emailAppPackage),
              onTap: () => _pickEmailApp(context, ref, s),
            ),
            _Tile(
              icon: Icons.group_outlined,
              title: 'Recipients',
              subtitle: recipients.isEmpty
                  ? 'None added'
                  : '${recipients.length} ${recipients.length == 1 ? 'person' : 'people'}',
              onTap: () => _push(context, const RecipientsScreen()),
            ),
            _Tile(
              icon: Icons.chat_outlined,
              title: 'WhatsApp number',
              subtitle: (s.whatsappNumber ?? '').isEmpty ? 'Not set' : s.whatsappNumber!,
              onTap: () => _editWhatsapp(context, ref, s),
            ),
          ]),
          _Group(title: 'Leave policy', children: [
            _Tile(
              icon: Icons.tune,
              title: 'Leave types, holidays & WFH',
              subtitle: 'Edit your policy',
              onTap: () => _push(context, const PolicyScreen()),
            ),
            _Tile(
              icon: Icons.auto_awesome,
              title: 'Import from PDF',
              subtitle: 'Let AI read your policy document',
              onTap: () => _importPdf(context),
            ),
            _Tile(
              icon: Icons.key_outlined,
              title: 'AI provider & API key',
              subtitle: '${provider.label} · ${keyPresent ? 'key saved' : 'no key yet'}',
              onTap: () => _push(context, const LlmSettingsScreen()),
            ),
          ]),
          _Group(title: 'Coming soon', children: [
            const _Tile(
              icon: Icons.notifications_outlined,
              title: 'Reminders',
              subtitle: 'Get nudged before holidays and to confirm requests',
              enabled: false,
            ),
            const _Tile(
              icon: Icons.cloud_upload_outlined,
              title: 'Backup',
              subtitle: 'Google Drive or OneDrive',
              enabled: false,
            ),
          ]),
          _Group(title: 'Data', children: [
            _Tile(
              icon: Icons.delete_forever_outlined,
              title: 'Erase all data',
              subtitle: 'Start over from the beginning',
              color: cs.error,
              onTap: () => _reset(context, ref),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8, left: 4),
          child: Text(title.toUpperCase(),
              style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.8)),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Divider(height: 1, indent: 72, color: cs.outlineVariant.withValues(alpha: 0.5)),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.color,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: ListTile(
        enabled: enabled,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: IconBadge(icon, color: color ?? cs.primary),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        subtitle: Text(subtitle),
        trailing: enabled && onTap != null
            ? Icon(Icons.chevron_right, color: cs.onSurfaceVariant)
            : null,
      ),
    );
  }
}

class _ProfileDialog extends StatefulWidget {
  const _ProfileDialog({required this.name, required this.company});

  final String name;
  final String company;

  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog> {
  late final _name = TextEditingController(text: widget.name);
  late final _company = TextEditingController(text: widget.company);

  @override
  void dispose() {
    _name.dispose();
    _company.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty || _company.text.trim().isEmpty) return;
    Navigator.pop(context, (_name.text.trim(), _company.text.trim()));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Your details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _company,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Company name'),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: const Text('Save'),
          ),
        ],
      );
}

class _TextDialog extends StatefulWidget {
  const _TextDialog({
    required this.title,
    required this.label,
    this.hint,
    this.initial = '',
    this.keyboard,
    this.allowEmpty = false,
  });

  final String title;
  final String label;
  final String? hint;
  final String initial;
  final TextInputType? keyboard;
  final bool allowEmpty;

  @override
  State<_TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<_TextDialog> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    if (_c.text.trim().isEmpty && !widget.allowEmpty) return;
    Navigator.pop(context, _c.text.trim());
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: _c,
          autofocus: true,
          keyboardType: widget.keyboard,
          decoration: InputDecoration(labelText: widget.label, hintText: widget.hint),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: const Text('Save'),
          ),
        ],
      );
}
