import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models.dart';

enum OnboardingStep { welcome, profile, emailApp, recipients, leaveMethod, review }

class OnboardingDraft {
  const OnboardingDraft({
    this.step = OnboardingStep.welcome,
    this.userName = '',
    this.companyName = '',
    this.emailApp = 0,
    this.recipients = const [],
    this.whatsapp = '',
    this.policy = const PolicyDraft(),
    this.imported = false,
    this.saving = false,
    this.error,
  });

  final OnboardingStep step;
  final String userName;
  final String companyName;
  final int emailApp; // index into emailAppOptions
  final List<String> recipients;
  final String whatsapp;
  final PolicyDraft policy;
  final bool imported; // policy came from a PDF
  final bool saving;
  final String? error;

  OnboardingDraft copyWith({
    OnboardingStep? step,
    String? userName,
    String? companyName,
    int? emailApp,
    List<String>? recipients,
    String? whatsapp,
    PolicyDraft? policy,
    bool? imported,
    bool? saving,
    String? error,
    bool clearError = false,
  }) =>
      OnboardingDraft(
        step: step ?? this.step,
        userName: userName ?? this.userName,
        companyName: companyName ?? this.companyName,
        emailApp: emailApp ?? this.emailApp,
        recipients: recipients ?? this.recipients,
        whatsapp: whatsapp ?? this.whatsapp,
        policy: policy ?? this.policy,
        imported: imported ?? this.imported,
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
      );

  /// Whether the main button is enabled on the current step.
  bool get canContinue => switch (step) {
        OnboardingStep.welcome => true,
        OnboardingStep.profile =>
          userName.trim().isNotEmpty && companyName.trim().isNotEmpty,
        OnboardingStep.emailApp => true,
        OnboardingStep.recipients => recipients.isNotEmpty,
        OnboardingStep.leaveMethod => true,
        OnboardingStep.review => policy.leaveTypes.isNotEmpty && !saving,
      };
}

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  static const _order = OnboardingStep.values;

  void next() {
    final i = state.step.index;
    if (i < _order.length - 1) {
      state = state.copyWith(step: _order[i + 1], clearError: true);
    }
  }

  void back() {
    final i = state.step.index;
    if (i > 0) state = state.copyWith(step: _order[i - 1], clearError: true);
  }

  void setUserName(String v) => state = state.copyWith(userName: v);
  void setCompany(String v) => state = state.copyWith(companyName: v);
  void setEmailApp(int i) => state = state.copyWith(emailApp: i);
  void setWhatsapp(String v) => state = state.copyWith(whatsapp: v);
  void setPolicy(PolicyDraft p) => state = state.copyWith(policy: p);

  /// Called with a policy extracted from a PDF; moves on to the review step.
  void importPolicy(PolicyDraft p) {
    state = state.copyWith(policy: p, imported: true);
    next();
  }

  /// Returns false when the address is invalid or already added.
  bool addRecipient(String email) {
    final e = email.trim().toLowerCase();
    if (!isValidEmail(e) || state.recipients.contains(e)) return false;
    state = state.copyWith(recipients: [...state.recipients, e]);
    return true;
  }

  void removeRecipient(String email) => state = state.copyWith(
      recipients: state.recipients.where((e) => e != email).toList());

  /// Saves everything. The root widget switches to the app once
  /// `onboardingDone` flips in the database.
  Future<void> finish() async {
    if (!state.canContinue) return;
    state = state.copyWith(saving: true, clearError: true);
    try {
      final s = state;
      final whatsapp = s.whatsapp.trim();
      await ref.read(databaseProvider).saveSetup(
            userName: s.userName.trim(),
            companyName: s.companyName.trim(),
            emailAppPackage: emailAppOptions[s.emailApp].package,
            whatsappNumber: whatsapp.isEmpty ? null : whatsapp,
            recipientEmails: s.recipients,
            policy: s.policy,
          );
      state = state.copyWith(saving: false);
    } catch (e) {
      state = state.copyWith(saving: false, error: 'Could not save: $e');
    }
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingController, OnboardingDraft>(OnboardingController.new);
