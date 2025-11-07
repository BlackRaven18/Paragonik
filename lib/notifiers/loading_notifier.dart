import 'package:flutter/material.dart';

class LoadingNotifier extends ChangeNotifier {
  LoadingNotifier._();
  static final LoadingNotifier _instance = LoadingNotifier._();
  static LoadingNotifier get instance => _instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static void show() {
    if (_instance._isLoading) return;
    _instance._isLoading = true;
    _instance.notifyListeners();
  }

  static void hide() {
    if (!_instance._isLoading) return;
    _instance._isLoading = false;
    _instance.notifyListeners();
  }
}
