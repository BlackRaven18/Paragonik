import 'dart:async';

import 'package:flutter/material.dart';

class LoadingNotifier extends ChangeNotifier {
  LoadingNotifier._();
  static final LoadingNotifier _instance = LoadingNotifier._();
  static LoadingNotifier get instance => _instance;

  bool _isLoading = false;
  String _message = '';

  bool get isLoading => _isLoading;
  String get message => _message;

  Timer? _debounceTimer;

  static void show({Duration? delay, String message = ''}) {
    if (_instance._isLoading) return;

    _instance._debounceTimer?.cancel();
    _instance._message = message;

    if (delay == null) {
      _instance._showInternal();
    } else {
      _instance._debounceTimer = Timer(delay, () {
        _instance._showInternal();
      });
    }
  }

  static void hide() {
    _instance._debounceTimer?.cancel();
    if (_instance._isLoading) {
      _instance._isLoading = false;
      _instance._message = '';
      _instance.notifyListeners();
    }
  }

  void _showInternal() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }
}
