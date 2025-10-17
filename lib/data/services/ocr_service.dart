import 'dart:io';
import 'dart:math';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:paragonik/data/models/ocr_result.dart';

class OcrService {
  Future<OcrResult> extractDataFromFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      textRecognizer.close();

      final String fullText = recognizedText.text;

      final String? foundSum = _findSumInText(fullText);
      final DateTime? foundDate = _findDateInText(fullText);

      return OcrResult(sum: foundSum, date: foundDate);
    } catch (e) {
      print('Błąd w OcrService: $e');
      return OcrResult(sum: null, date: null);
    }
  }

DateTime? _findDateInText(String text) {
  final dateRegex = RegExp(r'(\d{4}-\d{2}-\d{2})');
  final dateMatch = dateRegex.firstMatch(text);

  final timeRegex = RegExp(r'(\d{2}:\d{2})');
  final timeMatch = timeRegex.firstMatch(text);

  if (dateMatch != null && timeMatch != null) {
    final dateString = dateMatch.group(0)!;
    final timeString = timeMatch.group(0)!;

    return DateTime.tryParse('$dateString $timeString');
  }

  return null;
}

  String? _findSumInText(String text) {
    final amountRegex = RegExp(r'(\d+[,.]\d{2})');
    final matches = amountRegex.allMatches(text);

    if (matches.isEmpty) {
      return null;
    }

    final potentialAmounts = <double>[];
    for (final match in matches) {
      final amountString = match.group(1);
      if (amountString != null) {
        final parsedAmount = double.tryParse(amountString.replaceAll(',', '.'));
        if (parsedAmount != null) {
          potentialAmounts.add(parsedAmount);
        }
      }
    }

    if (potentialAmounts.isEmpty) {
      return null;
    }

    final highestAmount = potentialAmounts.reduce(max);
    return highestAmount.toStringAsFixed(2);
  }
}