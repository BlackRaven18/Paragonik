import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/image_processing_service.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/notifiers/loading_notifier.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

class ReceiptEditViewModel extends ChangeNotifier {
  final String _receiptId;
  final ReceiptService _receiptService;
  final ReceiptNotifier _receiptNotifier;
  final ImageProcessingService _imageProcessingService;

  Receipt? _receipt;
  bool isLoading = true;

  late String selectedStoreName;
  late DateTime selectedDateTime;
  late String updatedSum;

  String get imagePath {
    if (_receipt == null) return '';
    return _receipt!.imagePath;
  }

  final l10n = L10nService.l10n;

  ReceiptEditViewModel({
    required String receiptId,
    required ReceiptService receiptService,
    required ReceiptNotifier receiptNotifier,
    required ImageProcessingService imageProcessingService,
  }) : _receiptId = receiptId,
       _receiptService = receiptService,
       _receiptNotifier = receiptNotifier,
       _imageProcessingService = imageProcessingService {
    loadReceiptData();
  }

  Future<void> loadReceiptData() async {
    _receipt = await _receiptService.getReceiptById(_receiptId);
    if (_receipt != null) {
      selectedStoreName = _receipt!.storeName;
      selectedDateTime = _receipt!.date;
      updatedSum = _receipt!.amount.toStringAsFixed(2);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rotateImage() async {
    if (_receipt == null || isLoading) return;

    isLoading = true;
    notifyListeners();
    LoadingNotifier.show();

    try {
      String cleanImagePath = _receipt!.imagePath.split('?').first;
      String cleanThumbPath = _receipt!.thumbnailPath.split('?').first;

      final originalFile = File(cleanImagePath);
      final thumbnailFile = File(cleanThumbPath);

      await _imageProcessingService.rotateImage(originalFile);
      await _imageProcessingService.rotateImage(thumbnailFile);

      PaintingBinding.instance.imageCache.evict(FileImage(originalFile));
      PaintingBinding.instance.imageCache.evict(FileImage(thumbnailFile));

      _receipt = _receipt!.copyWith(
        imagePath: '$cleanImagePath?v=${DateTime.now().millisecondsSinceEpoch}',
        thumbnailPath:
            '$cleanThumbPath?v=${DateTime.now().millisecondsSinceEpoch}',
        updatedAt: DateTime.now(),
      );

      await _receiptService.updateReceipt(_receipt!);
    } catch (e) {
      NotificationService.showError(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
      LoadingNotifier.hide();
    }
  }

  void updateStore(String storeName) {
    selectedStoreName = storeName;
    notifyListeners();
  }

  void updateDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  void updateSum(String sum) {
    String cleanedSum = sum.replaceAll(RegExp(r'[^0-9,.]'), '');
    final normalizedSum = cleanedSum.replaceAll(',', '.');

    if (double.tryParse(normalizedSum) != null) {
      updatedSum = normalizedSum;
      notifyListeners();
    } else {
      NotificationService.showError(l10n.notificationInvalidSum);
    }
  }

  void saveChanges() {
    if (_receipt == null) return;
    final updatedReceipt = _receipt!.copyWith(
      amount: double.tryParse(updatedSum.replaceAll(',', '.')) ?? 0.0,
      storeName: selectedStoreName,
      date: selectedDateTime,
      updatedAt: DateTime.now(),
    );
    _receiptNotifier.updateReceipt(updatedReceipt);
  }
}
