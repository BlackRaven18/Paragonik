import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraScreen2 extends StatefulWidget {
  const CameraScreen2({super.key});

  @override
  State<CameraScreen2> createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  late final CameraViewModel cameraViewModel;

  static final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: const TextStyle(fontSize: 18),
    minimumSize: const Size(250, 60),
  );

  @override
  void initState() {
    super.initState();
    cameraViewModel = context.read<CameraViewModel>();
  }

  Future<void> _onImageRequested(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final status = await permission.request();

    if (status.isGranted) {
      cameraViewModel.pickImage(source);
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
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
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Odmówiono dostępu do ${source == ImageSource.camera ? "aparatu" : "galerii"}.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => _onImageRequested(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Zrób zdjęcie'),
          style: _buttonStyle,
        ),

        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _onImageRequested(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Wybierz z galerii'),
          style: _buttonStyle,
        ),
      ],
    );
  }
}
