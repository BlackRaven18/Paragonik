import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';

Future<void> showSumInputDialog(
  BuildContext context, {
  required String initialValue,
  required void Function(String) onValueSaved,
}) async {
  final amountController = TextEditingController(text: initialValue);

  final newValue = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ręczna poprawa kwoty'),
      content: TextField(
        controller: amountController,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Wpisz poprawną kwotę',
          suffixText: Formatters.currencySymbol,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(amountController.text),
          child: const Text('Zapisz'),
        ),
      ],
    ),
  );

  if (newValue != null && newValue.isNotEmpty) {
    onValueSaved(newValue);
  }
}
