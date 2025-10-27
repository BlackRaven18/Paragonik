import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/ui/screens/camera/helpers/request_and_get_image_helper.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 120,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Rozpocznij Skanowanie',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Zrób zdjęcie paragonu lub wybierz istniejące z galerii, aby dodać nowy wydatek.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: viewModel.isBusy
                ? null
                : () => requestAndGetImage(
                    context,
                    ImageSource.camera,
                    viewModel,
                  ),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Zrób zdjęcie'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: viewModel.isBusy
                ? null
                : () => requestAndGetImage(
                    context,
                    ImageSource.gallery,
                    viewModel,
                  ),
            child: const Text('Wybierz z galerii'),
          ),
        ],
      ),
    );
  }
}
