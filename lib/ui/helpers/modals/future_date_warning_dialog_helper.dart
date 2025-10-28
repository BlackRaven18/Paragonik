import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

Future<bool> showFutureDateWarningDialog(BuildContext context) async {
  final l10n = context.l10n;

  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Text(l10n.helpersModalsFutureDateWarningDialogTitle),
          ],
        ),
        content: Text(l10n.helpersModalsFutureDateWarningDialogContent),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.commonCancel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: Text(l10n.commonContinue),
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
