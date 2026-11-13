import 'package:flutter/foundation.dart';

@immutable
class LeaveTypeDraft {
  const LeaveTypeDraft({
    required this.name,
    required this.daysPerYear,
    this.carryForward = false,
  });

  final String name;
  final double daysPerYear;
  final bool carryForward;
}

@immutable
class HolidayDraft {
  const HolidayDraft({required this.name, required this.date, this.optional = false});

  final String name;
  final DateTime date;
  final bool optional;
}

/// Everything that makes up a leave policy. Used by onboarding, the policy
/// editor and the PDF import result.
@immutable
class PolicyDraft {
  const PolicyDraft({
    this.leaveTypes = const [],
    this.holidays = const [],
    this.wfh = const {},
  });

  final List<LeaveTypeDraft> leaveTypes;
  final List<HolidayDraft> holidays;

  /// Month (1..12) -> WFH days allowed.
  final Map<int, int> wfh;

  PolicyDraft copyWith({
    List<LeaveTypeDraft>? leaveTypes,
    List<HolidayDraft>? holidays,
    Map<int, int>? wfh,
  }) =>
      PolicyDraft(
        leaveTypes: leaveTypes ?? this.leaveTypes,
        holidays: holidays ?? this.holidays,
        wfh: wfh ?? this.wfh,
      );
}

enum LlmProvider {
  openai('OpenAI', 'gpt-4o-mini', 'sk-...'),
  claude('Claude', 'claude-3-5-haiku-latest', 'sk-ant-...'),
  gemini('Gemini', 'gemini-1.5-flash', 'AIza...');

  const LlmProvider(this.label, this.defaultModel, this.keyHint);
  final String label;
  final String defaultModel;
  final String keyHint;

  static LlmProvider fromName(String? name) =>
      values.firstWhere((p) => p.name == name, orElse: () => openai);
}

class EmailAppOption {
  const EmailAppOption(this.label, this.package);
  final String label;
  final String? package; // null = let Android show its chooser
}

/// Static list until installed-app detection (platform channel) lands.
const emailAppOptions = [
  EmailAppOption('Gmail', 'com.google.android.gm'),
  EmailAppOption('Outlook', 'com.microsoft.office.outlook'),
  EmailAppOption('Other / ask me each time', null),
];

String emailAppLabel(String? package) => emailAppOptions
    .firstWhere((o) => o.package == package, orElse: () => emailAppOptions.last)
    .label;

final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
bool isValidEmail(String s) => _emailRe.hasMatch(s.trim());
