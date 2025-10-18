import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InitialView extends StatelessWidget {
  final Function(ImageSource source) onImageRequested;

  const InitialView({required this.onImageRequested, super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 18),
      minimumSize: const Size(250, 60),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => onImageRequested(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Zrób zdjęcie'),
          style: buttonStyle,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => onImageRequested(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Wybierz z galerii'),
          style: buttonStyle,
        ),
      ],
    );
  }
}