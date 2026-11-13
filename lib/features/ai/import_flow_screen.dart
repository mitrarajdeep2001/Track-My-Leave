import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import 'provider_key_form.dart';

const _maxPdfBytes = 10 * 1024 * 1024;

/// Pick a PDF, choose an AI provider, test the key, extract the policy.
/// Pops with the extracted [PolicyDraft] (or null if cancelled).
class ImportFlowScreen extends ConsumerStatefulWidget {
  const ImportFlowScreen({super.key});

  @override
  ConsumerState<ImportFlowScreen> createState() => _ImportFlowScreenState();
}

class _ImportFlowScreenState extends ConsumerState<ImportFlowScreen> {
  final _key = ProviderKeyController();
  PlatformFile? _file;
  int? _fileSize;
  bool _extracting = false;
  String _phase = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _key.load(ref.read(databaseProvider), ref.read(secureKeyStoreProvider));
  }

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    try {
      final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['pdf']);
      if (f == null) return;
      final size = await f.length();
      if (size != null && size > _maxPdfBytes) {
        setState(() => _error = 'That PDF is larger than 10 MB. Pick a smaller one.');
        return;
      }
      setState(() {
        _file = f;
        _fileSize = size;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Could not open the file picker: $e');
    }
  }

  Future<void> _extract() async {
    final file = _file;
    if (file == null) return;
    setState(() {
      _extracting = true;
      _error = null;
      _phase = 'Starting…';
    });
    try {
      final bytes = await file.readAsBytes();
      final policy = await ref.read(policyExtractorProvider).extract(
            provider: _key.provider,
            model: _key.model,
            apiKey: _key.apiKey,
            fileName: file.name,
            bytes: bytes,
            onPhase: (p) {
              if (mounted) setState(() => _phase = p);
            },
          );
      await _key.save(ref.read(databaseProvider), ref.read(secureKeyStoreProvider));
      if (!mounted) return;
      Navigator.pop(context, policy);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _extracting = false;
        _error = 'Extraction failed: $e';
      });
    }
  }

  String _sizeText(int? b) {
    if (b == null) return '';
    if (b < 1024 * 1024) return '${(b / 1024).ceil()} KB';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final extractor = ref.watch(policyExtractorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import from PDF')),
      body: ListenableBuilder(
        listenable: _key,
        builder: (context, _) {
          final ready = _file != null && _key.keyVerified && !_extracting;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    if (extractor.isDemo) ...[const DemoNotice(), const SizedBox(height: 16)],
                    _StepCard(
                      number: 1,
                      title: 'Policy PDF',
                      done: _file != null,
                      child: _file == null
                          ? SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _extracting ? null : _pick,
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Choose PDF'),
                              ),
                            )
                          : Row(
                              children: [
                                IconBadge(Icons.picture_as_pdf_outlined, color: cs.error),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_file!.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text(_sizeText(_fileSize),
                                          style: TextStyle(color: cs.onSurfaceVariant)),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: _extracting ? null : _pick,
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 14),
                    _StepCard(
                      number: 2,
                      title: 'AI provider',
                      done: _key.keyVerified,
                      child: ProviderKeyForm(controller: _key, extractor: extractor),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_outline, size: 18, color: cs.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your key is stored encrypted on this phone. It is sent over HTTPS to our server only to call your chosen provider, and is never saved or logged there.',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(_error!, style: TextStyle(color: cs.error)),
                    ],
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: _extracting
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: const LinearProgressIndicator(minHeight: 8),
                            ),
                            const SizedBox(height: 10),
                            Text(_phase, style: TextStyle(color: cs.onSurfaceVariant)),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: ready ? _extract : null,
                                icon: const Icon(Icons.auto_awesome),
                                label: const Text('Extract policy'),
                              ),
                            ),
                            if (!ready)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _file == null
                                      ? 'Choose your policy PDF to continue'
                                      : 'Test your API key to continue',
                                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.done,
    required this.child,
  });

  final int number;
  final String title;
  final bool done;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: done ? cs.primary : cs.surfaceContainerHighest,
                child: done
                    ? Icon(Icons.check, size: 16, color: cs.onPrimary)
                    : Text('$number',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13, color: cs.onSurfaceVariant)),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
