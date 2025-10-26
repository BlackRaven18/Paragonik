import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

enum GroupingOption { byReceiptDate, byAddedDate }

class ReceiptsViewModel extends ChangeNotifier {
  final ReceiptNotifier _receiptNotifier;

  GroupingOption _groupingOption = GroupingOption.byReceiptDate;
  GroupingOption get groupingOption => _groupingOption;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<Receipt> get allReceipts => _receiptNotifier.receipts;
  bool get isLoading => _receiptNotifier.isLoading;
  int get totalReceipts => _receiptNotifier.totalReceipts;

  String? _selectedStoreFilter;
  String? get selectedStoreFilter => _selectedStoreFilter;

  Future<void> fetchReceipts() => _receiptNotifier.fetchReceipts();
  Future<void> deleteReceipt(String id) => _receiptNotifier.deleteReceipt(id);

  Map<String, List<Receipt>> get groupedReceipts {
    final filtered = _getFilteredReceipts();
    return _groupReceipts(filtered);
  }

  ReceiptsViewModel(this._receiptNotifier) {
    _receiptNotifier.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _receiptNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setGroupingOption(GroupingOption option) {
    _groupingOption = option;
    notifyListeners();
  }

  void setStoreFilter(String? storeName) {
    _selectedStoreFilter = storeName;
    notifyListeners();
  }

  List<Receipt> _getFilteredReceipts() {
    final query = _searchQuery.toLowerCase();

    return allReceipts.where((r) {
      final queryMatch =
          query.isEmpty ||
          r.storeName.toLowerCase().contains(query) ||
          r.amount.toString().contains(query);

      final storeMatch =
          _selectedStoreFilter == null || r.storeName == _selectedStoreFilter;

      return queryMatch && storeMatch;
    }).toList();
  }

  Map<String, List<Receipt>> _groupReceipts(List<Receipt> receipts) {
    final Map<String, List<Receipt>> grouped = {};
    final now = DateTime.now();
    for (final receipt in receipts) {
      final dateToCompare = _groupingOption == GroupingOption.byAddedDate
          ? receipt.createdAt
          : receipt.date;
      final difference = now.difference(dateToCompare).inDays;
      String groupKey;
      if (difference == 0) {
        groupKey = 'Dzisiaj';
      } else if (difference == 1) {
        groupKey = 'Wczoraj';
      } else if (difference < 7) {
        groupKey = 'W tym tygodniu';
      } else {
        groupKey = 'Wcześniej';
      }

      if (grouped[groupKey] == null) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(receipt);
    }
    return grouped;
  }
}
