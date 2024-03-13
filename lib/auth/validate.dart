import 'package:flutter/services.dart';

class CNICMaskTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.length > 0 && newText.length <= 15) {
      // Insert hyphen after first 5 digits and after 7th digit
      newText = newText.replaceAllMapped(
          RegExp(r'^(\d{5})(\d{7})(\d{1})$'), (Match m) => '${m[1]}-${m[2]}-${m[3]}');
      if (newText.length > 15) {
        newText = newText.substring(0, 15);
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}