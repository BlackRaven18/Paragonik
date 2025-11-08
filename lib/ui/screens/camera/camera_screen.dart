import 'package:flutter/material.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/image_preview_view.dart';
import 'package:paragonik/ui/screens/camera/initial_view.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    return Scaffold(body: Center(child: _buildContent(viewModel)));
  }

  Widget _buildContent(CameraViewModel viewModel) {
    switch (viewModel.uiState) {
      case CameraUIState.initial:
        return const InitialView();
      case CameraUIState.preview:
        return const ImagePreviewView();
    }
  }
}
