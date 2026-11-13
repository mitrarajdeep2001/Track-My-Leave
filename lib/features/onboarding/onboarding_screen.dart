import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../domain/models.dart';
import '../ai/import_flow_screen.dart';
import '../policy/policy_editor.dart';
import 'onboarding_controller.dart';

const _stepCount = 5; // everything after the welcome screen

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(onboardingProvider);
    final c = ref.read(onboardingProvider.notifier);

    if (d.step == OnboardingStep.welcome) {
      return _WelcomeStep(onStart: c.next);
    }

    final cs = Theme.of(context).colorScheme;
    final isMethod = d.step == OnboardingStep.leaveMethod;
    final isReview = d.step == OnboardingStep.review;

    final body = switch (d.step) {
      OnboardingStep.profile => const _ProfileStep(),
      OnboardingStep.emailApp => const _EmailAppStep(),
      OnboardingStep.recipients => const _RecipientsStep(),
      OnboardingStep.leaveMethod => const _LeaveMethodStep(),
      OnboardingStep.review => const _ReviewStep(),
      OnboardingStep.welcome => const SizedBox.shrink(),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) c.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: c.back),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: d.step.index / _stepCount,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${d.step.index}/$_stepCount',
                        style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(key: ValueKey(d.step), child: body),
                ),
              ),
              if (d.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(d.error!, style: TextStyle(color: cs.error)),
                ),
              if (!isMethod)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: d.canContinue ? (isReview ? c.finish : c.next) : null,
                      child: d.saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5))
                          : Text(isReview ? 'Save and finish' : 'Continue'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary, Color.alphaBlend(cs.tertiary.withValues(alpha: 0.5), cs.primary)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(Icons.beach_access, size: 48, color: cs.onPrimary),
                ),
                const SizedBox(height: 28),
                Text('Holiday\nTracker',
                    style: t.displaySmall?.copyWith(
                        color: cs.onPrimary, fontWeight: FontWeight.w800, height: 1.05)),
                const SizedBox(height: 14),
                Text(
                  'Keep track of your leave, holidays and work-from-home days. Send requests from your own email app in a few taps.',
                  style: t.bodyLarge?.copyWith(color: cs.onPrimary.withValues(alpha: 0.9)),
                ),
                const Spacer(flex: 2),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.onPrimary,
                      foregroundColor: cs.primary,
                    ),
                    child: const Text('Get started'),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text('Setup takes about a minute',
                      style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.8))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStep extends ConsumerWidget {
  const _ProfileStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.read(onboardingProvider);
    final c = ref.read(onboardingProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader('About you', 'This goes into the signature of your emails.'),
          TextFormField(
            initialValue: d.userName,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Your name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: c.setUserName,
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: d.companyName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Company name',
              prefixIcon: Icon(Icons.business_outlined),
            ),
            onChanged: c.setCompany,
          ),
        ],
      ),
    );
  }
}

class _EmailAppStep extends ConsumerWidget {
  const _EmailAppStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider.select((d) => d.emailApp));
    final c = ref.read(onboardingProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    const icons = [Icons.mail_outline, Icons.outbox_outlined, Icons.apps];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader('Your email app',
              'Requests open in this app with everything filled in. You just tap Send.'),
          for (var i = 0; i < emailAppOptions.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            SelectableCard(
              selected: selected == i,
              onTap: () => c.setEmailApp(i),
              child: Row(
                children: [
                  IconBadge(icons[i % icons.length]),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(emailAppOptions[i].label,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                  Icon(
                    selected == i ? Icons.check_circle : Icons.circle_outlined,
                    color: selected == i ? cs.primary : cs.outline,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecipientsStep extends ConsumerStatefulWidget {
  const _RecipientsStep();

  @override
  ConsumerState<_RecipientsStep> createState() => _RecipientsStepState();
}

class _RecipientsStepState extends ConsumerState<_RecipientsStep> {
  final _email = TextEditingController();
  String? _err;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _add() {
    if (_email.text.trim().isEmpty) return;
    final ok = ref.read(onboardingProvider.notifier).addRecipient(_email.text);
    setState(() => _err = ok ? null : 'Enter a valid email that is not already added');
    if (ok) _email.clear();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(onboardingProvider);
    final c = ref.read(onboardingProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader('Who gets your requests?',
              'Add your supervisor or team lead. You can add more later.'),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Email address',
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
          if (d.recipients.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in d.recipients)
                  InputChip(
                    avatar: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Text(r[0].toUpperCase(),
                          style: TextStyle(fontSize: 12, color: cs.onPrimaryContainer)),
                    ),
                    label: Text(r),
                    onDeleted: () => c.removeRecipient(r),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          TextFormField(
            initialValue: d.whatsapp,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'WhatsApp number (optional)',
              hintText: 'With country code, e.g. 919876543210',
              prefixIcon: Icon(Icons.chat_outlined),
            ),
            onChanged: c.setWhatsapp,
          ),
        ],
      ),
    );
  }
}

class _LeaveMethodStep extends ConsumerWidget {
  const _LeaveMethodStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(onboardingProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader('Set up your leave policy',
              'Let AI read your company policy PDF, or type it in yourself.'),
          SelectableCard(
            selected: false,
            onTap: () async {
              final p = await Navigator.of(context).push<PolicyDraft>(
                MaterialPageRoute(builder: (_) => const ImportFlowScreen()),
              );
              if (p != null) c.importPolicy(p);
            },
            child: Row(
              children: [
                const IconBadge(Icons.auto_awesome, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Upload policy PDF',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Fastest',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onPrimaryContainer)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Uses your own OpenAI, Claude or Gemini key',
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SelectableCard(
            selected: false,
            onTap: c.next,
            child: Row(
              children: [
                IconBadge(Icons.edit_note, size: 52, color: cs.tertiary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter manually',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('Leave types, holidays and WFH days. No API key needed.',
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(onboardingProvider);
    final c = ref.read(onboardingProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _StepHeader(
            d.imported ? 'Check your policy' : 'Your policy',
            d.imported
                ? 'AI can make mistakes. Fix anything that looks off before saving.'
                : 'Add your leave types, holidays and WFH days. You can change these later in Settings.',
          ),
        ),
        Expanded(
          child: PolicyEditor(
            policy: d.policy,
            onChanged: c.setPolicy,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          ),
        ),
      ],
    );
  }
}
