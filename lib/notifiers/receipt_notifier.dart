import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/data/services/thumbnail_service.dart';
import 'package:paragonik/notifiers/loading_notifier.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
    LoadingNotifier.show(delay: const Duration(milliseconds: 500));

    _currentPage = 0;
    _receipts = [];
    _hasMoreData = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      final results = await Future.wait([
        _receiptService.getReceiptsPaginated(limit: _pageSize, offset: 0),
        _receiptService.getReceiptsCount(),
      ]);

      _receipts.addAll(results[0] as List<Receipt>);
      _totalReceiptsCount = results[1] as int;
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationsErrorLoadingReceipts,
      );
    } finally {
      isLoadingInitial = false;
      notifyListeners();
      LoadingNotifier.hide();
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
        L10nService.l10n.notificationsErrorLoadingReceipts,
      );
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<List<Receipt>> getReceiptsInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _receiptService.getReceiptsInDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> addReceipt({
    required File imageFile,
    required double amount,
    required DateTime date,
    required String storeName,
  }) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final uniqueId = const Uuid().v4();
    final imageExtension = p.extension(imageFile.path);
    final newImageName = '$uniqueId$imageExtension';
    final newThumbnailName = '${uniqueId}_thumb$imageExtension';

    final permanentImagePath = p.join(documentsDirectory.path, newImageName);
    final permanentThumbnailPath = p.join(
      documentsDirectory.path,
      newThumbnailName,
    );

    await imageFile.copy(permanentImagePath);
    final thumbnailFile = await _thumbnailService.createThumbnail(imageFile);
    await thumbnailFile.copy(permanentThumbnailPath);

    final newReceipt = Receipt(
      id: uniqueId,
      imagePath: permanentImagePath,
      thumbnailPath: permanentThumbnailPath,
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
