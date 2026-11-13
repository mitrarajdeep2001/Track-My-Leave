import 'dart:typed_data';

import '../domain/models.dart';

enum KeyCheck { valid, invalid, rateLimited, network }

/// Talks to the backend (`/validate-key`, `/extract-policy`).
abstract class PolicyExtractor {
  /// True while no real backend is connected; the UI shows a notice.
  bool get isDemo;

  Future<KeyCheck> validateKey({
    required LlmProvider provider,
    required String model,
    required String apiKey,
  });

  Future<PolicyDraft> extract({
    required LlmProvider provider,
    required String model,
    required String apiKey,
    required String fileName,
    required Uint8List bytes,
    void Function(String phase)? onPhase,
  });
}

/// Stand-in until the Supabase Edge Functions exist. It accepts any key of
/// 8+ characters and returns a fixed sample policy.
class DemoPolicyExtractor implements PolicyExtractor {
  @override
  bool get isDemo => true;

  @override
  Future<KeyCheck> validateKey({
    required LlmProvider provider,
    required String model,
    required String apiKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return apiKey.trim().length >= 8 ? KeyCheck.valid : KeyCheck.invalid;
  }

  @override
  Future<PolicyDraft> extract({
    required LlmProvider provider,
    required String model,
    required String apiKey,
    required String fileName,
    required Uint8List bytes,
    void Function(String phase)? onPhase,
  }) async {
    onPhase?.call('Reading your PDF…');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    onPhase?.call('Asking ${provider.label} to find your policy…');
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    onPhase?.call('Checking the result…');
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final y = DateTime.now().year;
    return PolicyDraft(
      leaveTypes: const [
        LeaveTypeDraft(name: 'Casual leave', daysPerYear: 12),
        LeaveTypeDraft(name: 'Sick leave', daysPerYear: 8),
        LeaveTypeDraft(name: 'Earned leave', daysPerYear: 15, carryForward: true),
      ],
      holidays: [
        HolidayDraft(name: 'New Year\'s Day', date: DateTime(y, 1, 1)),
        HolidayDraft(name: 'Republic Day', date: DateTime(y, 1, 26)),
        HolidayDraft(name: 'Independence Day', date: DateTime(y, 8, 15)),
        HolidayDraft(name: 'Gandhi Jayanti', date: DateTime(y, 10, 2)),
        HolidayDraft(name: 'Christmas', date: DateTime(y, 12, 25)),
      ],
      wfh: {for (var m = 1; m <= 12; m++) m: 4},
    );
  }
}
