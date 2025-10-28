import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/data/services/thumbnail_service.dart';
import 'package:uuid/uuid.dart';

class ReceiptNotifier extends ChangeNotifier {
  final ReceiptService _receiptService;
  final ThumbnailService _thumbnailService;

  List<Receipt> _receipts = [];
  List<Receipt> get receipts => _receipts;

  int _totalReceiptsCount = 0;
  int get totalReceipts => _totalReceiptsCount;

  static const _pageSize = 20;
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool isLoadingInitial = false;
  bool isLoadingMore = false;

  bool isLoading = false;

  ReceiptNotifier(this._receiptService, this._thumbnailService) {
    fetchReceipts();
  }

  Future<void> fetchReceipts() async {
    isLoadingInitial = true;
    notifyListeners();

    _currentPage = 0;
    _receipts = [];
    _hasMoreData = true;

    try {
      final results = await Future.wait([
        _receiptService.getReceiptsPaginated(limit: _pageSize, offset: 0),
        _receiptService.getReceiptsCount(),
      ]);

      _receipts.addAll(results[0] as List<Receipt>);
      _totalReceiptsCount = results[1] as int;
    } catch (e) {
      NotificationService.showError(
        "Ups! Coś poszlo nie tak przy ładowaniu paragonów",
      );
    } finally {
      isLoadingInitial = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreReceipts() async {
    if (isLoadingMore || !_hasMoreData) return;

    isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final offset = _currentPage * _pageSize;

    try {
      final newReceipts = await _receiptService.getReceiptsPaginated(
        limit: _pageSize,
        offset: offset,
      );

      if (newReceipts.length < _pageSize) {
        _hasMoreData = false;
      }

      _receipts.addAll(newReceipts);
    } catch (e) {
      NotificationService.showError(
        "Ups! Coś poszlo nie tak przy ładowaniu paragonów",
      );
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> addReceipt({
    required File imageFile,
    required double amount,
    required DateTime date,
    required String storeName,
  }) async {
    final thumbnailFile = await _thumbnailService.createThumbnail(imageFile);

    final newReceipt = Receipt(
      id: const Uuid().v4(),
      imagePath: imageFile.path,
      thumbnailPath: thumbnailFile.path,
      amount: amount,
      date: date,
      storeName: storeName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _receiptService.addReceipt(newReceipt);

    _receipts.insert(0, newReceipt);

    await updateReceiptCount();

    notifyListeners();
  }

  Future<void> deleteReceipt(String id) async {
    await _receiptService.softDeleteReceipt(id);

    _receipts.removeWhere((receipt) => receipt.id == id);

    await updateReceiptCount();

    notifyListeners();
  }

  Future<void> updateReceipt(Receipt updatedReceipt) async {
    await _receiptService.updateReceipt(updatedReceipt);

    final index = _receipts.indexWhere((r) => r.id == updatedReceipt.id);
    if (index != -1) {
      _receipts[index] = updatedReceipt;
      notifyListeners();
    }
  }

  Future<void> updateReceiptCount() async {
    _totalReceiptsCount = await _receiptService.getReceiptsCount();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
