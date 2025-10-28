import 'package:flutter/material.dart';

Future<bool> showFutureDateWarningDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Text('Data z przyszłości'),
          ],
        ),
        content: const Text(
          'Wybrana data paragonu jest z przyszłości. Czy na pewno chcesz kontynuować?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Anuluj'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: const Text('Kontynuuj'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  return result ?? false;
}
