import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/ui/screens/camera/helpers/request_and_get_image_helper.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: viewModel.isBusy
              ? null
              : () => requestAndGetImage(context, ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Zrób zdjęcie'),
          style: buttonStyle,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => viewModel.isBusy
              ? null
              : requestAndGetImage(context, ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Wybierz z galerii'),
          style: buttonStyle,
        ),
      ],
    );
  }
}
