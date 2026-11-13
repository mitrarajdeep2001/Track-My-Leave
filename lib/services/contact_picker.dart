import 'package:flutter/services.dart';

class PickedContact {
  const PickedContact({required this.number, this.name});

  final String number;
  final String? name;
}

class ContactPickerException implements Exception {
  const ContactPickerException(this.message);

  final String message;

  @override
  String toString() => message;
}

const _channel = MethodChannel('trackmyleave/contacts');

/// Opens the system contact picker filtered to phone numbers.
///
/// Uses Android's picker intent, which grants access to the one contact the
/// user picks, so the app needs no READ_CONTACTS permission. Returns null if
/// the user backs out.
Future<PickedContact?> pickPhoneContact() async {
  try {
    final r = await _channel.invokeMapMethod<String, Object?>('pickPhone');
    if (r == null) return null;
    final number = (r['number'] as String?)?.trim() ?? '';
    if (number.isEmpty) {
      throw const ContactPickerException('That contact has no phone number');
    }
    final name = (r['name'] as String?)?.trim();
    return PickedContact(number: number, name: (name == null || name.isEmpty) ? null : name);
  } on MissingPluginException {
    throw const ContactPickerException('Choosing from contacts only works on Android');
  } on PlatformException catch (e) {
    throw ContactPickerException(e.message ?? 'Could not open your contacts');
  }
}
