import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'provider_key_form.dart';

/// Change the AI provider, model and API key used for PDF import.
class LlmSettingsScreen extends ConsumerStatefulWidget {
  const LlmSettingsScreen({super.key});

  @override
  ConsumerState<LlmSettingsScreen> createState() => _LlmSettingsScreenState();
}

class _LlmSettingsScreenState extends ConsumerState<LlmSettingsScreen> {
  final _c = ProviderKeyController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _c.load(ref.read(databaseProvider), ref.read(secureKeyStoreProvider));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    await _c.save(ref.read(databaseProvider), ref.read(secureKeyStoreProvider));
    ref.invalidate(apiKeyPresentProvider);
    messenger.showSnackBar(const SnackBar(content: Text('AI settings saved')));
    nav.pop();
  }

  Future<void> _remove() async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    await ref.read(secureKeyStoreProvider).clear();
    ref.invalidate(apiKeyPresentProvider);
    messenger.showSnackBar(const SnackBar(content: Text('API key removed from this phone')));
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final extractor = ref.watch(policyExtractorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI provider')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          if (extractor.isDemo) ...[const DemoNotice(), const SizedBox(height: 16)],
          Text(
            'Used only when you import a policy from a PDF. Your key is stored encrypted on this phone and never leaves it except to call your chosen provider through our server.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          ProviderKeyForm(controller: _c, extractor: extractor),
          const SizedBox(height: 28),
          TextButton.icon(
            onPressed: _remove,
            icon: Icon(Icons.delete_outline, color: cs.error),
            label: Text('Remove saved key', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: ListenableBuilder(
            listenable: _c,
            builder: (context, _) => SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving || _c.apiKey.isEmpty || _c.model.isEmpty ? null : _save,
                child: const Text('Save'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
