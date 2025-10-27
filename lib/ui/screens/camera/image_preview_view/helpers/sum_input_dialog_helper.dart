import 'package:flutter/material.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';

Future<void> showSumInputDialog(
  BuildContext context,
  CameraViewModel viewModel,
) async {
  final amountController = TextEditingController(
    text: viewModel.ocrResult?.sum ?? '',
  );
  final newSum = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ręczna poprawa kwoty'),
      content: TextField(
        controller: amountController,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Wpisz poprawną kwotę',
          suffixText: 'PLN',
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

  if (newSum != null && newSum.isNotEmpty) {
    viewModel.updateSum(newSum);
  }
}
