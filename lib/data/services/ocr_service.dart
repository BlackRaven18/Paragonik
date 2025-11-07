import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/models/processed_ocr_result.dart';
import 'package:paragonik/data/services/image_processing_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/store_service.dart';

typedef _LevenshteinConfig = ({int maxDistance, int minWordLength});

class OcrService {
  final StoreService _storeService;
  final ImageProcessingService _imageProcessingService;
  final _LevenshteinConfig _levenshteinConfig = (
    maxDistance: 2,
    minWordLength: 4,
  );

  OcrService(this._storeService, this._imageProcessingService);

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
      final String? foundStore = await _findStoreNameInText(fullText);

      return ProcessedOcrResult(
        result: OcrResult(
          sum: foundSum,
          date: foundDate,
          storeName: foundStore,
        ),
        processedImageFile: processedImageFile,
      );
    } catch (e) {
      NotificationService.showError(e.toString());
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

  Future<String?> _findStoreNameInText(String text) async {
    final lowerCaseText = text.toLowerCase();
    final allStores = await _storeService.getAllStores();

    final List<({String keyword, String storeName})> allKeywords = [];
    for (final store in allStores) {
      for (final keyword in store.keywords) {
        if (keyword.isNotEmpty) {
          allKeywords.add((
            keyword: keyword.trim().toLowerCase(),
            storeName: store.name,
          ));
        }
      }
    }

    allKeywords.sort((a, b) => b.keyword.length.compareTo(a.keyword.length));

    for (final entry in allKeywords) {
      if (lowerCaseText.contains(entry.keyword)) {
        return entry.storeName;
      }
    }

    final words = lowerCaseText.split(RegExp(r'[\s\n]+'));

    for (final word in words) {
      if (word.length < _levenshteinConfig.minWordLength) continue;

      for (final entry in allKeywords) {
        if (!entry.keyword.contains(' ') &&
            (word.length - entry.keyword.length).abs() <=
                _levenshteinConfig.maxDistance) {
          if (levenshteinDistance(word, entry.keyword) <=
              _levenshteinConfig.maxDistance) {
            return entry.storeName;
          }
        }
      }
    }

    final unknownStore = await _storeService.getUnknownStore();
    return unknownStore.name;
  }

  int levenshteinDistance(String s, String t) {
    final m = s.length;
    final n = t.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (s[i - 1] == t[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] =
              1 +
              [
                dp[i - 1][j],
                dp[i][j - 1],
                dp[i - 1][j - 1],
              ].reduce((a, b) => a < b ? a : b);
        }
      }
    }
    return dp[m][n];
  }
}
