import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int maxBeforeDecimal;
  final int maxAfterDecimal;

  DecimalTextInputFormatter({
    this.maxBeforeDecimal = 6,
    this.maxAfterDecimal = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    final int newCursorOffset = newValue.selection.baseOffset;

    String cleanedText = newText.replaceAll(' ', '');

    int spacesRemoved =
        newText.substring(0, newCursorOffset).split(' ').length - 1;
    int adjustedCursorOffset = newCursorOffset - spacesRemoved;

    final regExp = RegExp(
      r'^\d{0,' +
          maxBeforeDecimal.toString() +
          r'}([,.]\d{0,' +
          maxAfterDecimal.toString() +
          r'})?$',
    );

    if (cleanedText.isEmpty || regExp.hasMatch(cleanedText)) {
      return newValue.copyWith(
        text: cleanedText,
        selection: TextSelection.collapsed(
          offset: adjustedCursorOffset.clamp(0, cleanedText.length),
        ),
      );
    } else {
      return oldValue;
    }
  }
}
