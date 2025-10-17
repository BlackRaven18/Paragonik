import 'dart:io';
import 'dart:math';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  Future<String?> extractSumFromFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      textRecognizer.close();

      return _findSumInText(recognizedText.text);
    } catch (e) {
      print('Błąd w OcrService: $e');
      return null;
    }
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