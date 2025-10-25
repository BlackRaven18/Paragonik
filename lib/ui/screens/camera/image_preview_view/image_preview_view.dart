import 'package:flutter/material.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/action_panel.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/image_display.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/result_panel.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ImagePreviewView extends StatelessWidget {
  const ImagePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    return Column(
      children: [
        const ImageDisplay(),
        if (viewModel.ocrResult != null) ResultPanel(),
        const ActionPanel(),
      ],
    );
  }
}
