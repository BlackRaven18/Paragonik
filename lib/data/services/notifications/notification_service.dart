import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          messengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );
    messengerKey.currentState?.showSnackBar(snackBar);
  }

  static void showSuccess(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          messengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );
    messengerKey.currentState?.showSnackBar(snackBar);
  }
}