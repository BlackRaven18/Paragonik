import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/models/processed_ocr_result.dart';
import 'package:paragonik/data/services/image_processing_service.dart';

class OcrService {
  final ImageProcessingService _imageProcessingService;

  OcrService(this._imageProcessingService);
  
  Future<ProcessedOcrResult?> extractDataFromFile(File imageFile) async {
    File? processedImageFile;

    try {
      processedImageFile = await _imageProcessingService.processImageForOcr(imageFile);

      final inputImage = InputImage.fromFilePath(processedImageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      textRecognizer.close();

      final String fullText = recognizedText.text;
      final String? foundSum = _findSumInText(fullText);
      final DateTime? foundDate = _findDateInText(fullText);

      return ProcessedOcrResult(
        result: OcrResult(sum: foundSum, date: foundDate),
        processedImageFile: processedImageFile,
      );

    } catch (e) {
      print('Błąd w OcrService: $e');
      await processedImageFile?.delete();
      return null;
    }
  }

DateTime? _findDateInText(String text) {
  final dateTimeRegex = RegExp(r'(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2})');
  final match = dateTimeRegex.firstMatch(text);

  if (match != null) {
    return DateTime.tryParse(match.group(0)!);
  }

  return null;
}

  String? _findSumInText(String text) {
  final amountRegex = RegExp(r'(\d+[,.]\d{2})\s+PLN', caseSensitive: false);
  final match = amountRegex.firstMatch(text);

  if (match != null) {
    return match.group(1)!.replaceAll(',', '.');
  }

  return null;
}
}