import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;

  const FullScreenImageViewer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final cleanPath = imagePath.split('?').first;
    final imageProvider = FileImage(File(cleanPath));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: imageProvider,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              enableRotation: false,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),

            Positioned(
              top: 16.0,
              left: 16.0,
              child: FloatingActionButton.small(
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
