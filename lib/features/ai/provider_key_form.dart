import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../core/widgets.dart';
import '../../data/db/app_database.dart';
import '../../data/secure_key_store.dart';
import '../../domain/models.dart';
import '../../services/policy_extractor.dart';

/// State behind [ProviderKeyForm]: which AI provider, model and API key to use.
class ProviderKeyController extends ChangeNotifier {
  LlmProvider provider = LlmProvider.openai;
  final modelField = TextEditingController(text: LlmProvider.openai.defaultModel);
  final keyField = TextEditingController();
  bool checking = false;
  bool obscure = true;
  KeyCheck? result;

  String get model => modelField.text.trim();
  String get apiKey => keyField.text.trim();
  bool get canTest => apiKey.isNotEmpty && model.isNotEmpty && !checking;
  bool get keyVerified => result == KeyCheck.valid;

  ProviderKeyController() {
    keyField.addListener(_edited);
    modelField.addListener(_edited);
  }

  void _edited() {
    if (result != null) result = null;
    notifyListeners();
  }

  void setProvider(LlmProvider p) {
    if (p == provider) return;
    provider = p;
    modelField.text = p.defaultModel;
    result = null;
    notifyListeners();
  }

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  Future<void> load(AppDatabase db, SecureKeyStore store) async {
    final s = await (db.select(db.appSettings)..where((t) => t.id.equals(1))).getSingleOrNull();
    provider = LlmProvider.fromName(s?.llmProvider);
    modelField.text = (s?.llmModel?.isNotEmpty ?? false) ? s!.llmModel! : provider.defaultModel;
    keyField.text = await store.read() ?? '';
    result = null;
    notifyListeners();
  }

  Future<void> test(PolicyExtractor extractor) async {
    checking = true;
    result = null;
    notifyListeners();
    try {
      result = await extractor.validateKey(provider: provider, model: model, apiKey: apiKey);
    } catch (_) {
      result = KeyCheck.network;
    }
    checking = false;
    notifyListeners();
  }

  Future<void> save(AppDatabase db, SecureKeyStore store) async {
    await store.write(apiKey);
    await db.updateSettings(AppSettingsCompanion(
      llmProvider: Value(provider.name),
      llmModel: Value(model),
    ));
  }

  @override
  void dispose() {
    modelField.dispose();
    keyField.dispose();
    super.dispose();
  }
}

class ProviderKeyForm extends StatelessWidget {
  const ProviderKeyForm({super.key, required this.controller, required this.extractor});

  final ProviderKeyController controller;
  final PolicyExtractor extractor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<LlmProvider>(
                showSelectedIcon: false,
                segments: [
                  for (final p in LlmProvider.values)
                    ButtonSegment(value: p, label: Text(p.label)),
                ],
                selected: {c.provider},
                onSelectionChanged: (s) => c.setProvider(s.first),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: c.modelField,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Model',
                helperText: 'Model names change over time. Edit this if yours differs.',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: c.keyField,
              obscureText: c.obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: 'API key',
                hintText: c.provider.keyHint,
                prefixIcon: const Icon(Icons.key_outlined),
                suffixIcon: IconButton(
                  tooltip: c.obscure ? 'Show key' : 'Hide key',
                  icon: Icon(c.obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: c.toggleObscure,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: c.canTest ? () => c.test(extractor) : null,
                  icon: c.checking
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.verified_outlined),
                  label: Text(c.checking ? 'Testing…' : 'Test key'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46)),
                ),
                const SizedBox(width: 12),
                Expanded(child: _Result(c.result, cs)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Result extends StatelessWidget {
  const _Result(this.result, this.cs);

  final KeyCheck? result;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();
    final (icon, text, color) = switch (result!) {
      KeyCheck.valid => (Icons.check_circle, 'Key works', cs.primary),
      KeyCheck.invalid => (Icons.error, 'Key was rejected', cs.error),
      KeyCheck.rateLimited => (Icons.hourglass_bottom, 'Rate limited, try again soon', cs.tertiary),
      KeyCheck.network => (Icons.wifi_off, 'Could not reach the server', cs.error),
    };
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600))),
      ],
    );
  }
}

/// Notice shown while the backend is not connected yet.
class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      color: cs.tertiaryContainer.withValues(alpha: 0.6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, color: cs.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Preview mode: the server is not connected yet, so any key of 8+ characters passes and extraction returns a sample policy.',
              style: TextStyle(color: cs.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
