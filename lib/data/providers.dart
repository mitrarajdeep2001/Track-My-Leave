import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/policy_extractor.dart';
import 'db/app_database.dart';
import 'secure_key_store.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final secureKeyStoreProvider = Provider<SecureKeyStore>((_) => SecureKeyStore());

/// Swap this for a real implementation once the Edge Functions exist.
final policyExtractorProvider = Provider<PolicyExtractor>((_) => DemoPolicyExtractor());

final settingsProvider = StreamProvider<AppSetting>(
  (ref) => ref.watch(databaseProvider).watchSettings(),
);

final recipientsProvider = StreamProvider<List<Recipient>>(
  (ref) => ref.watch(databaseProvider).watchRecipients(),
);

final leaveTypesProvider = StreamProvider<List<LeaveType>>(
  (ref) => ref.watch(databaseProvider).watchLeaveTypes(),
);

final holidaysProvider = StreamProvider<List<Holiday>>(
  (ref) => ref.watch(databaseProvider).watchHolidays(),
);

final wfhProvider = StreamProvider<List<WfhAllowance>>(
  (ref) => ref.watch(databaseProvider).watchWfh(),
);

final requestsProvider = StreamProvider<List<LeaveRequest>>(
  (ref) => ref.watch(databaseProvider).watchRequests(),
);

/// Whether an API key is currently stored on the device.
final apiKeyPresentProvider = FutureProvider.autoDispose<bool>((ref) async {
  final key = await ref.watch(secureKeyStoreProvider).read();
  return key != null && key.isNotEmpty;
});

// ---- Navigation state shared between tabs ---------------------------------

class NavIndex extends Notifier<int> {
  @override
  int build() => 0;
  void set(int v) => state = v;
}

final navIndexProvider = NotifierProvider<NavIndex, int>(NavIndex.new);

enum RequestFilter { all, pending, sent }

class HistoryFilter extends Notifier<RequestFilter> {
  @override
  RequestFilter build() => RequestFilter.all;
  void set(RequestFilter v) => state = v;
}

final historyFilterProvider =
    NotifierProvider<HistoryFilter, RequestFilter>(HistoryFilter.new);
