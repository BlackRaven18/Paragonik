import 'package:flutter/material.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CameraViewModel>();
    if (viewModel.ocrResult == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: viewModel.clearImage,
              icon: const Icon(Icons.refresh),
              label: const Text('Zmień zdjęcie'),
            ),
            ElevatedButton.icon(
              onPressed: viewModel.processImage,
              icon: const Icon(Icons.checklist_rtl),
              label: const Text('Przetwórz'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: viewModel.clearImage,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Anuluj'),
          ),
          ElevatedButton.icon(
            onPressed: viewModel.saveResult,
            icon: const Icon(Icons.check_circle),
            label: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}
