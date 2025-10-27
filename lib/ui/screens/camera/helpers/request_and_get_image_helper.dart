import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> requestAndGetImage(
  BuildContext context,
  ImageSource source,
) async {
  final viewModel = context.read<CameraViewModel>();
  if (viewModel.isBusy) return;

  try {
    viewModel.updateIsPermissionRequesting(true);

    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      await viewModel.getImage(source);
    } else if (status.isPermanentlyDenied && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Brak uprawnień'),
          content: Text(
            'Aplikacja potrzebuje dostępu do ${source == ImageSource.camera ? "aparatu" : "galerii"}. Proszę włączyć uprawnienie w ustawieniach aplikacji.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Otwórz ustawienia'),
            ),
          ],
        ),
      );
    }
  } finally {
    viewModel.updateIsPermissionRequesting(false);
  }
}
