import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List> processImageFast(Uint8List imageBytes) async {
  final result = await FlutterImageCompress.compressWithList(
    imageBytes,
    minWidth: 1500,
    quality: 95,
    format: CompressFormat.jpeg,
  );
  return result;
}

Uint8List setGrayscaleAndConstrast(Uint8List imageBytes) {
  final image = img.decodeImage(imageBytes);
  if (image == null) {
    NotificationService.showError(
      L10nService.l10n.servicesImageProcessingError,
    );
    throw Exception(L10nService.l10n.servicesImageProcessingError);
  }

  final stopwatch = Stopwatch()..start();

  final grayscaleImage = img.grayscale(image);
  final contrastImage = img.contrast(grayscaleImage, contrast: 200);

  stopwatch.stop();

  return Uint8List.fromList(img.encodeJpg(contrastImage, quality: 95));
}

img.Image resizeForOcr(img.Image image) {
  final int targetWidth = 1500;
  final double aspectRatio = image.height / image.width;
  final int targetHeight = (targetWidth * aspectRatio).round();

  return img.copyResize(
    image,
    width: targetWidth,
    height: targetHeight,
    interpolation: img.Interpolation.nearest,
  );
}

class ImageProcessingService {
  Future<File> processImageForOcr(File inputFile) async {
    final imageBytes = await inputFile.readAsBytes();

    var processedBytes = await processImageFast(imageBytes);

    processedBytes = setGrayscaleAndConstrast(processedBytes);

    final tempDir = await getTemporaryDirectory();
    final tempPath = join(
      tempDir.path,
      '${DateTime.now().millisecondsSinceEpoch}_processed.jpg',
    );
    final processedFile = File(tempPath);
    await processedFile.writeAsBytes(processedBytes);

    return processedFile;
  }

  Future<File> rotateImage(File imageFile) async {
    final cleanPath = imageFile.path.split('?').first;
    final fileToRead = File(cleanPath);

    final imageBytes = await fileToRead.readAsBytes();

    final processedBytes = await FlutterImageCompress.compressWithList(
      imageBytes,
      rotate: 90,
      quality: 100,
      format: CompressFormat.jpeg
    );

    await fileToRead.writeAsBytes(processedBytes);
    return imageFile;
  }
}
