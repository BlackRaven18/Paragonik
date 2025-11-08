import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/services/image_processing_service.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/notifiers/loading_notifier.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

enum CameraUIState { initial, preview }

class CameraViewModel extends ChangeNotifier {
  final OcrService _ocrService;
  final ReceiptNotifier _receiptNotifier;
  final ImageProcessingService _imageProcessingService;

  CameraUIState _uiState = CameraUIState.initial;
  CameraUIState get uiState => _uiState;

  File? _originalImageFile;
  File? get originalImageFile => _originalImageFile;

  File? _processedImageFile;
  File? get processedImageFile => _processedImageFile;

  OcrResult? _ocrResult;
  OcrResult? get ocrResult => _ocrResult;

  bool _showProcessedImage = true;
  bool get showProcessedImage => _showProcessedImage;

  bool _isSumManuallyCorrected = false;
  bool get isSumManuallyCorrected => _isSumManuallyCorrected;

  bool _isDateManuallyCorrected = false;
  bool get isDateManuallyCorrected => _isDateManuallyCorrected;

  bool _isPermissionRequesting = false;
  bool _isProcessing = false;

  bool get isBusy => _isPermissionRequesting || _isProcessing;

  final l10n = L10nService.l10n;

  File? get activeImageFile {
    if (_originalImageFile == null) return null;
    return showProcessedImage && _processedImageFile != null
        ? _processedImageFile
        : _originalImageFile;
  }

  ImageProvider? get displayImageProvider {
    final activeFile = activeImageFile;
    if (activeFile == null) return null;

    return FileImage(_getCleanFile(activeFile));
  }

  Key get displayImageKey {
    final activeFile = activeImageFile;
    if (activeFile == null) return ValueKey(null);

    return ValueKey(activeFile.path);
  }

  CameraViewModel({
    required OcrService ocrService,
    required ReceiptNotifier receiptNotifier,
    required ImageProcessingService imageProcessingService,
  }) : _ocrService = ocrService,
       _receiptNotifier = receiptNotifier,
       _imageProcessingService = imageProcessingService;

  @override
  void dispose() {
    _processedImageFile?.delete();
    super.dispose();
  }

  Future<void> setImage(File imageFile) async {
    await clearImage();
    _originalImageFile = imageFile;
    _uiState = CameraUIState.preview;
    notifyListeners();
  }

  Future<void> processImage() async {
    if (activeImageFile == null) return;

    notifyListeners();
    LoadingNotifier.show(
      message: l10n.globalLoadingOverlayAnalyzingReceiptMessage,
    );

    try {
      final fileToProcess = _getCleanFile(_originalImageFile!);

      final processedResult = await _ocrService.extractDataFromFile(
        fileToProcess,
      );
      if (processedResult != null) {
        _ocrResult = processedResult.result;
        _processedImageFile = processedResult.processedImageFile;
        _showProcessedImage = true;
      }
    } finally {
      _uiState = CameraUIState.preview;
      notifyListeners();
      LoadingNotifier.hide();
    }
  }

  Future<void> rotateImage() async {
    if (_originalImageFile == null || isBusy) return;

    _isProcessing = true;
    notifyListeners();

    LoadingNotifier.show(
      delay: const Duration(milliseconds: 500),
      message: l10n.globalLoadingOverlayRotatingReceiptMessage,
    );

    try {
      final cleanOriginalFile = _getCleanFile(_originalImageFile!);
      await _imageProcessingService.rotateImage(cleanOriginalFile);
      _originalImageFile = File(
        '${cleanOriginalFile.path}?v=${DateTime.now().millisecondsSinceEpoch}',
      );

      PaintingBinding.instance.imageCache.evict(FileImage(cleanOriginalFile));

      if (_processedImageFile != null) {
        final cleanProcessedFile = _getCleanFile(_processedImageFile!);
        await _imageProcessingService.rotateImage(cleanProcessedFile);
        _processedImageFile = File(
          '${cleanProcessedFile.path}?v=${DateTime.now().millisecondsSinceEpoch}',
        );
        PaintingBinding.instance.imageCache.evict(
          FileImage(cleanProcessedFile),
        );
      }
    } catch (e) {
      NotificationService.showError("Błąd podczas obracania obrazu.");
    } finally {
      _isProcessing = false;
      notifyListeners();
      LoadingNotifier.hide();
    }
  }

  Future<void> clearImage() async {
    if (processedImageFile != null) {
      final cleanProcessedImageFile = _getCleanFile(_processedImageFile!);
      await cleanProcessedImageFile.delete();
    }
    _originalImageFile = null;
    _processedImageFile = null;
    _ocrResult = null;
    _isSumManuallyCorrected = false;
    _isDateManuallyCorrected = false;
    _showProcessedImage = true;
    _uiState = CameraUIState.initial;
    notifyListeners();
  }

  void saveResult() {
    if (_originalImageFile == null) return;
    final ocrData = _ocrResult ?? OcrResult();

    _receiptNotifier.addReceipt(
      imageFile: _getCleanFile(_originalImageFile!),
      amount: double.tryParse(ocrData.sum ?? '0.0') ?? 0.0,
      date: ocrData.date ?? DateTime.now(),
      storeName: ocrData.storeName ?? '',
    );
    clearImage();

    NotificationService.showSuccess(
      L10nService.l10n.notificationsSuccessReceiptAdded,
    );
  }

  void toggleImageType() {
    _showProcessedImage = !_showProcessedImage;
    notifyListeners();
  }

  void updateSum(String sum) {
    String cleanedSum = sum.replaceAll(RegExp(r'[^0-9,.]'), '');
    final normalizedSum = cleanedSum.replaceAll(',', '.');

    if (double.tryParse(normalizedSum) != null) {
      _ocrResult = _ocrResult?.copyWith(sum: normalizedSum);
      _isSumManuallyCorrected = true;
      notifyListeners();
    } else {
      NotificationService.showError(l10n.notificationInvalidSum);
    }
  }

  void updateDate(DateTime date) {
    _ocrResult = _ocrResult?.copyWith(date: date);
    _isDateManuallyCorrected = true;
    notifyListeners();
  }

  void updateStore(Store store) {
    _ocrResult = _ocrResult?.copyWith(storeName: store.name);
    notifyListeners();
  }

  void updateIsPermissionRequesting(bool value) {
    _isPermissionRequesting = value;
    notifyListeners();
  }

  File _getCleanFile(File file) {
    final cleanPath = file.path.split('?').first;
    return File(cleanPath);
  }
}
