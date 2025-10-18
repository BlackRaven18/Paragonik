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
      processedImageFile = await _imageProcessingService.processImageForOcr(
        imageFile,
      );

      final inputImage = InputImage.fromFilePath(processedImageFile.path);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

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
    final Map<RegExp, DateTime? Function(Match)> formatHandlers = {
      RegExp(r'(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2})'): (match) {
        return DateTime.tryParse(match.group(0)!);
      },

      RegExp(r'(\d{2}-\d{2}-\d{4})\s+(\d{2}:\d{2})'): (match) {
        final datePart = match.group(1)!;
        final timePart = match.group(2)!;

        final components = datePart.split('-');
        if (components.length != 3) return null;

        final reformattedDate =
            '${components[2]}-${components[1]}-${components[0]}';
        return DateTime.tryParse('$reformattedDate $timePart');
      },
    };

    for (final entry in formatHandlers.entries) {
      final match = entry.key.firstMatch(text);
      if (match != null) {
        final result = entry.value(match);
        if (result != null) {
          return result;
        }
      }
    }

    return null;
  }

  String? _findSumInText(String text) {
    final lines = text.split('\n');

    final patterns = [
      RegExp(r'(\d+[,.]\d{2})\s+PLN', caseSensitive: false),
      RegExp(r'PLN\s+(\d+[,.]\d{2})', caseSensitive: false),
    ];

    for (final line in lines) {
      for (final pattern in patterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          return match.group(1)!.replaceAll(',', '.');
        }
      }
    }

    return null;
  }
}
