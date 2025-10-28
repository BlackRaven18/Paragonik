import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

Future<void> showSumInputDialog(
  BuildContext context, {
  required String initialValue,
  required void Function(String) onValueSaved,
}) async {
  final l10n = context.l10n;
  final amountController = TextEditingController(text: initialValue);

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
