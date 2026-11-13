import 'package:url_launcher/url_launcher.dart';

import '../core/formatters.dart';

class ComposedMessage {
  const ComposedMessage(this.subject, this.body);
  final String subject;
  final String body;
}

ComposedMessage composeMessage({
  required bool wfh,
  String? typeName,
  required DateTime start,
  required DateTime end,
  required double days,
  String? reason,
  required String userName,
  required String company,
}) {
  final single = dateOnly(start) == dateOnly(end);
  final when = single
      ? 'on ${fmtDayYear.format(start)}'
      : 'from ${fmtDay.format(start)} to ${fmtDayYear.format(end)}';
  final range = rangeText(start, end);

  final subject = wfh ? 'WFH request: $range' : 'Leave request: $range';

  final ask = wfh
      ? 'I would like to work from home $when (${plural(days)}).'
      : 'I would like to apply for ${plural(days)} of ${typeName ?? 'leave'} $when.';

  final b = StringBuffer('Hi,\n\n$ask\n\n');
  if (reason != null && reason.trim().isNotEmpty) {
    b.write('Reason: ${reason.trim()}\n\n');
  }
  b.write('Please let me know if you need anything else from me.\n\nThanks,');
  if (userName.trim().isNotEmpty) b.write('\n${userName.trim()}');
  if (company.trim().isNotEmpty) b.write('\n${company.trim()}');
  return ComposedMessage(subject, b.toString());
}

Uri mailtoUri(List<String> to, ComposedMessage m) => Uri.parse(
    'mailto:${to.join(',')}?subject=${Uri.encodeComponent(m.subject)}&body=${Uri.encodeComponent(m.body)}');

Uri whatsappUri(String number, ComposedMessage m) {
  final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
  final text = '*${m.subject}*\n\n${m.body}';
  return Uri.parse('https://wa.me/$digits?text=${Uri.encodeComponent(text)}');
}

/// Opens [uri] in another app. Returns false if nothing could handle it.
Future<bool> launchExternal(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
