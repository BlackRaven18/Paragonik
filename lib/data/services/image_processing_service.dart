import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class _ProcessRequest {
  final Uint8List imageBytes;
  _ProcessRequest(this.imageBytes);
}

Future<List<int>> _processImageInBackground(_ProcessRequest request) async {
  final image = img.decodeImage(request.imageBytes);
  if (image == null) {
    throw Exception('Nie udało się zdekodować obrazu w tle.');
  }

  final stopwatch = Stopwatch()..start();

  final resizedImage = resizeForOcr(image);
  final grayscaleImage = img.grayscale(resizedImage);
  final contrastImage = img.contrast(grayscaleImage, contrast: 200);

  stopwatch.stop();

  return img.encodeJpg(contrastImage, quality: 95);
}

img.Image resizeForOcr(img.Image image) {
  final int targetWidth = 1500;
  final double aspectRatio = image.height / image.width;
  final int targetHeight = (targetWidth * aspectRatio).round();

  return img.copyResize(
    image,
    width: targetWidth,
    height: targetHeight,
    interpolation: img.Interpolation.linear,
  );
}

class ImageProcessingService {
  Future<File> processImageForOcr(File inputFile) async {
    final imageBytes = await inputFile.readAsBytes();

    final stopwatch = Stopwatch()..start();

    final processedBytes = await compute(
       _processImageInBackground,
      _ProcessRequest(imageBytes),
    );

    stopwatch.stop();

    final tempDir = await getTemporaryDirectory();
    final tempPath = join(
      tempDir.path,
      '${DateTime.now().millisecondsSinceEpoch}_processed.jpg',
    );
    final processedFile = File(tempPath);
    await processedFile.writeAsBytes(processedBytes);

    return processedFile;
  }
}
