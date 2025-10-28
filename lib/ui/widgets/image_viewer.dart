import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart';

class ImageViewer extends StatelessWidget {
  final File imageFile;
  final File? secondaryImageFile;
  final bool showSecondary;
  final VoidCallback? onToggle;

  const ImageViewer({
    required this.imageFile,
    this.secondaryImageFile,
    this.showSecondary = false,
    this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageToShow = showSecondary && secondaryImageFile != null
        ? secondaryImageFile!
        : imageFile;

    return Padding(
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

          if (secondaryImageFile != null && onToggle != null)
            Positioned(
              top: 8,
              right: 8,
              child: FloatingActionButton.small(
                onPressed: onToggle,
                tooltip: showSecondary
                    ? context.l10n.widgetsImageViewerTooltipShowOriginal
                    : context.l10n.widgetsImageViewerTooltipShowScan,
                child: Icon(
                  showSecondary
                      ? Icons.image_outlined
                      : Icons.document_scanner_outlined,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
