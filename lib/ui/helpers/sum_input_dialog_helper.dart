import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/core/widgets/decimal_text_input_formatter.dart';

Future<void> showSumInputDialog(
  BuildContext context, {
  required String initialValue,
  required void Function(String) onValueSaved,
}) async {
  final cleanInitialValue = initialValue
      .replaceAll(Formatters.currencySymbol, '')
      .replaceAll(' ', '');
  final amountController = TextEditingController(text: cleanInitialValue);

  final l10n = context.l10n;

  final newValue = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.helpersSumInputDialogTitle),
      content: TextField(
        controller: amountController,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: l10n.helpersSumInputDialogLabel,
          suffixText: Formatters.currencySymbol,
        ),
        inputFormatters: [
          DecimalTextInputFormatter(maxBeforeDecimal: 6, maxAfterDecimal: 2),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(amountController.text),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );

  if (newValue != null && newValue.isNotEmpty) {
    onValueSaved(newValue);
  }
}
