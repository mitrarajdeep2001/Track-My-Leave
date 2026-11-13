import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../services/contact_picker.dart';

/// Phone number field with a button that fills it from the device contacts.
class WhatsappField extends StatefulWidget {
  const WhatsappField({
    super.key,
    this.initialNumber = '',
    this.initialName,
    required this.onChanged,
  });

  final String initialNumber;
  final String? initialName;

  /// Called with the raw number and the contact name. The name is null when
  /// the number was typed (or edited) by hand.
  final void Function(String number, String? name) onChanged;

  @override
  State<WhatsappField> createState() => _WhatsappFieldState();
}

class _WhatsappFieldState extends State<WhatsappField> {
  late final _c = TextEditingController(text: widget.initialNumber);
  late String? _name = widget.initialName;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final p = await pickPhoneContact();
      if (p == null || !mounted) return;
      final n = cleanPhone(p.number);
      setState(() {
        _c.text = n;
        _name = p.name;
      });
      widget.onChanged(n, p.name);
    } on ContactPickerException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final n = _c.text.trim();
    final parts = <String>[
      if (_name != null) 'From contacts: $_name',
      if (n.isNotEmpty && !n.startsWith('+')) 'Make sure it includes the country code, e.g. +91',
    ];

    return TextField(
      controller: _c,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'WhatsApp number (optional)',
        hintText: '+91 98765 43210',
        helperText: parts.isEmpty ? null : parts.join('\n'),
        helperMaxLines: 2,
        prefixIcon: const Icon(Icons.chat_outlined),
        suffixIcon: IconButton(
          tooltip: 'Choose from contacts',
          icon: Icon(Icons.contacts_outlined, color: cs.primary),
          onPressed: _pick,
        ),
      ),
      onChanged: (v) {
        setState(() => _name = null);
        widget.onChanged(v, null);
      },
    );
  }
}
