import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProcessingView extends StatelessWidget {
  const ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitFadingCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 80.0,
        ),
        const SizedBox(height: 20),
        const Text('Analizuję paragon...', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}