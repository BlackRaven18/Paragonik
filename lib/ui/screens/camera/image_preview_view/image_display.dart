import 'package:flutter/material.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    final imageToShow =
        viewModel.showProcessedImage && viewModel.processedImageFile != null
        ? viewModel.processedImageFile!
        : viewModel.originalImageFile!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageViewer(imageFile: imageToShow),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageToShow, fit: BoxFit.contain),
              ),
            ),
            if (viewModel.processedImageFile != null)
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton.small(
                  onPressed: viewModel.toggleImageType,
                  tooltip:
                      'Pokaż ${viewModel.showProcessedImage ? "oryginał" : "skan"}',
                  child: Icon(
                    viewModel.showProcessedImage
                        ? Icons.image_outlined
                        : Icons.document_scanner_outlined,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
