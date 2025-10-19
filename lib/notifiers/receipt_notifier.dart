
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';

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

  Future<void> addReceipt(Receipt receipt) async {
    _receipts.insert(0, receipt);
    notifyListeners(); 
  }

  Future<void> deleteReceipt(String id) async {
    await _receiptService.softDeleteReceipt(id);

    _receipts.removeWhere((receipt) => receipt.id == id);

    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}