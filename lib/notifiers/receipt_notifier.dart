
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:uuid/uuid.dart';

class ReceiptNotifier extends ChangeNotifier {
  final ReceiptService _receiptService;
  
  List<Receipt> _receipts = [];
  List<Receipt> get receipts => _receipts;

  bool isLoading = false;

  ReceiptNotifier(this._receiptService) {
    fetchReceipts();
  }

  Future<void> fetchReceipts() async {
    _setLoading(true);

    _receipts = await _receiptService.getAllReceipts();

    _setLoading(false);
  }

  Future<void> addReceipt({
    required File imageFile,
    required double amount,
    required DateTime date,
    required String storeName,
  }) async {
    final newReceipt = Receipt(
      id: const Uuid().v4(),
      imagePath: imageFile.path,
      amount: amount,
      date: date,
      storeName: storeName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _receiptService.addReceipt(newReceipt);

    _receipts.insert(0, newReceipt);

    notifyListeners();
  }

  Future<void> deleteReceipt(String id) async {
    await _receiptService.softDeleteReceipt(id);

    _receipts.removeWhere((receipt) => receipt.id == id);

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

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}