import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    final imageProvider = viewModel.displayImageProvider;
    final imageKey = viewModel.displayImageKey;

    if (imageProvider == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImageViewer(
                    imagePath: viewModel.activeImageFile!.path,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  key: imageKey,
                ),
              ),
            ),
            if (viewModel.processedImageFile != null)
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton.small(
                  onPressed: viewModel.toggleImageType,
                  tooltip: viewModel.showProcessedImage
                      ? context
                            .l10n
                            .screensCameraImagePreviewViewImageDisplayShowOriginalTooltip
                      : context
                            .l10n
                            .screensCameraImagePreviewViewImageDisplayShowScanTooltip,
                  child: Icon(
                    viewModel.showProcessedImage
                        ? Icons.image_outlined
                        : Icons.document_scanner_outlined,
                  ),
                ),
              ),

            Positioned(
              top: 60,
              right: 8,
              child: FloatingActionButton.small(
                heroTag: 'camera_rotate_btn',
                onPressed: viewModel.isBusy ? null : viewModel.rotateImage,
                child: const Icon(Icons.rotate_90_degrees_cw_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
