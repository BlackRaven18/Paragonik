import 'dart:io';
import 'package:flutter/material.dart';

class CacheBustedFileImage extends StatelessWidget {
  final String filePath;

  final double? width;
  final double? height;
  final BoxFit? fit;

  const CacheBustedFileImage({
    required this.filePath,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final cleanPath = filePath.split('?').first;
    final imageProvider = FileImage(File(cleanPath));

    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
      key: ValueKey(filePath),
    );
  }
}
