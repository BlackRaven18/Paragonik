import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

enum CameraUIState { initial, processing, preview }

class CameraViewModel extends ChangeNotifier {
  final OcrService _ocrService;
  final ReceiptNotifier _receiptNotifier;

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

  bool get isBusy => _isPermissionRequesting;

  CameraViewModel({
    required OcrService ocrService,
    required ReceiptNotifier receiptNotifier,
  }) : _ocrService = ocrService,
       _receiptNotifier = receiptNotifier;

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
    if (_originalImageFile == null) return;

    _uiState = CameraUIState.processing;
    notifyListeners();

    try {
      final processedResult = await _ocrService.extractDataFromFile(
        _originalImageFile!,
      );
      if (processedResult != null) {
        _ocrResult = processedResult.result;
        _processedImageFile = processedResult.processedImageFile;
        _showProcessedImage = true;
      }
    } finally {
      _uiState = CameraUIState.preview;
      notifyListeners();
    }
  }

  Future<void> clearImage() async {
    await _processedImageFile?.delete();
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
      imageFile: _originalImageFile!,
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
    _ocrResult = _ocrResult?.copyWith(sum: sum);
    _isSumManuallyCorrected = true;
    notifyListeners();
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
}
