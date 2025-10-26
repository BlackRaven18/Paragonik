import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ThumbnailService {
  static Future<Uint8List> _createThumbnailBytes(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Nie można zdekodować obrazu');
    
    final thumbnail = img.copyResize(image, width: 200);
    
    return img.encodeJpg(thumbnail, quality: 85);
  }

  Future<File> createThumbnail(File originalImage) async {
    final imageBytes = await originalImage.readAsBytes();
    
    final thumbnailBytes = await compute(_createThumbnailBytes, imageBytes);

    final tempDir = await getApplicationDocumentsDirectory();
    final fileName = 'thumb_${basename(originalImage.path)}';
    final thumbFile = File(join(tempDir.path, fileName));
    
    await thumbFile.writeAsBytes(thumbnailBytes);
    return thumbFile;
  }
}