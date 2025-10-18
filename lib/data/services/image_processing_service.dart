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

  final resizedImage = img.copyResize(image, width: 1200);
  final grayscaleImage = img.grayscale(resizedImage);
  final contrastImage = img.contrast(grayscaleImage, contrast: 200);

  return img.encodeJpg(contrastImage, quality: 95);
}

class ImageProcessingService {
  Future<File> processImageForOcr(File inputFile) async {
    final imageBytes = await inputFile.readAsBytes();

    final processedBytes = await compute(
      _processImageInBackground,
      _ProcessRequest(imageBytes),
    );

    final tempDir = await getTemporaryDirectory();
    final tempPath = join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}_processed.jpg');
    final processedFile = File(tempPath);
    await processedFile.writeAsBytes(processedBytes);

    return processedFile;
  }
}