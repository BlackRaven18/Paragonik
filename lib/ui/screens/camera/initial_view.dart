import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CameraViewModel>();
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 18),
      minimumSize: const Size(250, 60),
    );

    Future<void> requestAndGetImage(ImageSource source) async {
      final permission = source == ImageSource.camera
          ? Permission.camera
          : Permission.photos;
      final status = await permission.request();

      if (status.isGranted) {
        await viewModel.getImage(source);
      } else if (status.isPermanentlyDenied && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Brak uprawnień'),
            content: Text(
              'Aplikacja potrzebuje dostępu do ${source == ImageSource.camera ? "aparatu" : "galerii"}. Proszę włączyć uprawnienie w ustawieniach aplikacji.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Anuluj'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text('Otwórz ustawienia'),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => requestAndGetImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Zrób zdjęcie'),
          style: buttonStyle,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => requestAndGetImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Wybierz z galerii'),
          style: buttonStyle,
        ),
      ],
    );
  }
}
