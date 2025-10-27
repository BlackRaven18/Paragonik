import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

class ReceiptEditViewModel extends ChangeNotifier {
  final String _receiptId;
  final ReceiptService _receiptService;
  final ReceiptNotifier _receiptNotifier;

  Receipt? _receipt;
  bool isLoading = true;

  late String selectedStoreName;
  late DateTime selectedDateTime;
  late String updatedSum;

  ReceiptEditViewModel({
    required String receiptId,
    required ReceiptService receiptService,
    required ReceiptNotifier receiptNotifier,
  })  : _receiptId = receiptId,
        _receiptService = receiptService,
        _receiptNotifier = receiptNotifier {
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

  void updateStore(String storeName) {
    selectedStoreName = storeName;
    notifyListeners();
  }

  void updateDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  void updateSum(String sum) {
    updatedSum = sum;
    notifyListeners();
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

  String get imagePath => _receipt?.imagePath ?? '';
}