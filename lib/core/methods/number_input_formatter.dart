import 'package:amar_pos/core/core.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Remove existing commas before parsing
    String newText = newValue.text.replaceAll(',', '');
    double? number = double.tryParse(newText);

    if (number == null) return oldValue; // Prevent invalid input

    String formattedText = Methods.getFormattedNumber(number);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length), // Keep cursor at the end
    );
  }
}
