import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 4),
    );
  }

  static void showWarning(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: Colors.orange,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccess(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    );
  }

  static void _showSnackbar({
    required String message,
    required Color backgroundColor,
    required Duration duration,
  }) {
    messengerKey.currentState?.hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: SizedBox(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Zamknij',
              onPressed: () {
                messengerKey.currentState?.hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
