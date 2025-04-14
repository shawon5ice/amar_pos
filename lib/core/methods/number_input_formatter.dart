import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##,###.##'); // Add decimals if needed

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;

    // Strip commas from new input
    final newTextRaw = newValue.text.replaceAll(',', '');

    // Exit early if not a valid number
    final number = num.tryParse(newTextRaw);
    if (number == null) return oldValue;

    // Format the number
    final formattedText = _formatter.format(number);

    // Get raw cursor position (in unformatted string)
    final rawCursorPosition = _getRawCursorPosition(newValue);

    // Map raw cursor position to formatted string
    final newCursorPosition = _getFormattedCursorPosition(
      rawText: newTextRaw,
      formattedText: formattedText,
      rawCursorPosition: rawCursorPosition,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  /// Returns the raw (unformatted) cursor position
  int _getRawCursorPosition(TextEditingValue value) {
    int rawCursorPos = 0;
    for (int i = 0; i < value.selection.baseOffset; i++) {
      if (value.text[i] != ',') rawCursorPos++;
    }
    return rawCursorPos;
  }

  /// Maps the raw cursor position to a position in the formatted text
  int _getFormattedCursorPosition({
    required String rawText,
    required String formattedText,
    required int rawCursorPosition,
  }) {
    int rawCount = 0;
    for (int i = 0; i < formattedText.length; i++) {
      if (formattedText[i] != ',') {
        rawCount++;
      }
      if (rawCount == rawCursorPosition) {
        return i + 1;
      }
    }
    return formattedText.length;
  }
}
