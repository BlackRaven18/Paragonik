import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:paragonik/notifiers/loading_notifier.dart';
import 'package:provider/provider.dart';

class GlobalLoadingOverlay extends StatelessWidget {
  final Widget child;
  const GlobalLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final loadingNotifier = context.watch<LoadingNotifier>();

    final bool isLoading = loadingNotifier.isLoading;
    final String message = loadingNotifier.message;

    return Stack(
      children: [
        child,
        if (isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),
        if (isLoading)
          Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/animations/loading.gif',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
