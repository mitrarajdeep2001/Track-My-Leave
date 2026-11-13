import 'package:url_launcher/url_launcher.dart';

import '../core/formatters.dart';

class ComposedMessage {
  const ComposedMessage(this.subject, this.body);
  final String subject;
  final String body;
}

/// A placeholder that can be used in email templates.
class TemplateField {
  const TemplateField(this.key, this.description);
  final String key;
  final String description;
  String get token => '{$key}';
}

const templateFields = [
  TemplateField('type', 'Leave type, e.g. Casual leave'),
  TemplateField('dates', 'Date range, e.g. 10 Nov – 12 Nov 2026'),
  TemplateField('when', 'e.g. "from 10 Nov to 12 Nov 2026"'),
  TemplateField('days', 'Number of days, e.g. 3 days'),
  TemplateField('start', 'First day'),
  TemplateField('end', 'Last day'),
  TemplateField('reason', 'Your reason, if you gave one'),
  TemplateField('name', 'Your name'),
  TemplateField('company', 'Your company'),
];

const defaultLeaveSubject = 'Leave request: {dates}';
const defaultLeaveBody = '''Hi,

I would like to apply for {days} of {type} {when}.

Reason: {reason}

Please let me know if you need anything else from me.

Thanks,
{name}
{company}''';

const defaultWfhSubject = 'WFH request: {dates}';
const defaultWfhBody = '''Hi,

I would like to work from home {when} ({days}).

Reason: {reason}

Please let me know if you need anything else from me.

Thanks,
{name}
{company}''';

final _token = RegExp(r'\{(\w+)\}');

/// Replaces `{field}` placeholders; unknown placeholders are kept as typed.
/// With [dropEmptyLines], a line that uses a placeholder with no value (for
/// example `Reason: {reason}` with no reason) is left out.
String fillTemplate(String template, Map<String, String> values, {bool dropEmptyLines = true}) {
  final lines = <String>[];
  for (final line in template.replaceAll('\r\n', '\n').split('\n')) {
    var missing = false;
    final out = line.replaceAllMapped(_token, (m) {
      final key = m.group(1)!;
      if (!values.containsKey(key)) return m.group(0)!;
      final v = values[key]!.trim();
      if (v.isEmpty) missing = true;
      return v;
    });
    if (!missing || !dropEmptyLines) lines.add(out);
  }
  // Removing lines can leave stacks of blank lines; keep at most one.
  return lines.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
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
  String? subjectTemplate,
  String? bodyTemplate,
}) {
  final single = dateOnly(start) == dateOnly(end);
  final values = {
    'type': wfh ? 'work from home' : (typeName ?? 'leave'),
    'dates': rangeText(start, end),
    'when': single
        ? 'on ${fmtDayYear.format(start)}'
        : 'from ${fmtDay.format(start)} to ${fmtDayYear.format(end)}',
    'days': plural(days),
    'start': fmtDayYear.format(start),
    'end': fmtDayYear.format(end),
    'reason': reason ?? '',
    'name': userName,
    'company': company,
  };

  String pick(String? custom, String fallback) =>
      (custom == null || custom.trim().isEmpty) ? fallback : custom;

  // The subject is one line, so empty fields are just left blank in it.
  final subject = fillTemplate(
      pick(subjectTemplate, wfh ? defaultWfhSubject : defaultLeaveSubject), values,
      dropEmptyLines: false);
  final body =
      fillTemplate(pick(bodyTemplate, wfh ? defaultWfhBody : defaultLeaveBody), values);
  return ComposedMessage(subject.replaceAll('\n', ' '), body);
}

Uri mailtoUri(List<String> to, ComposedMessage m, {List<String> cc = const []}) {
  final query = [
    if (cc.isNotEmpty) 'cc=${cc.map(Uri.encodeComponent).join(',')}',
    'subject=${Uri.encodeComponent(m.subject)}',
    'body=${Uri.encodeComponent(m.body)}',
  ];
  return Uri.parse('mailto:${to.join(',')}?${query.join('&')}');
}

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
