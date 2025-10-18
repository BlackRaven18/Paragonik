

import 'dart:io';
import 'package:paragonik/data/models/ocr_result.dart';

class ProcessedOcrResult {
  final OcrResult result;
  final File processedImageFile;

  ProcessedOcrResult({
    required this.result,
    required this.processedImageFile,
  });
}