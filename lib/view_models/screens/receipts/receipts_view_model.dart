import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/csv_export_service.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  bool get isLoadingInitial => _receiptNotifier.isLoadingInitial;
  bool get isLoadingMore => _receiptNotifier.isLoadingMore;

  String? _selectedStoreFilter;
  String? get selectedStoreFilter => _selectedStoreFilter;

  Future<void> fetchReceipts() => _receiptNotifier.fetchReceipts();
  Future<void> fetchMoreReceipts() => _receiptNotifier.fetchMoreReceipts();
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
    final l10n = L10nService.l10n;

    final Map<String, List<Receipt>> grouped = {
      l10n.viewModelsScreensReceiptsGroupToday: [],
      l10n.viewModelsScreensReceiptsGroupYesterday: [],
      l10n.viewModelsScreensReceiptsGroupThisWeek: [],
      l10n.viewModelsScreensReceiptsGroupEarlier: [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    for (final receipt in receipts) {
      final dateToCompare = _groupingOption == GroupingOption.byAddedDate
          ? receipt.createdAt
          : receipt.date;
      final receiptDate = DateTime(
        dateToCompare.year,
        dateToCompare.month,
        dateToCompare.day,
      );

      if (receiptDate.isAtSameMomentAs(today)) {
        grouped[l10n.viewModelsScreensReceiptsGroupToday]!.add(receipt);
      } else if (receiptDate.isAtSameMomentAs(yesterday)) {
        grouped[l10n.viewModelsScreensReceiptsGroupYesterday]!.add(receipt);
      } else if (!receiptDate.isBefore(startOfWeek) &&
          !receiptDate.isAfter(today)) {
        grouped[l10n.viewModelsScreensReceiptsGroupThisWeek]!.add(receipt);
      } else {
        grouped[l10n.viewModelsScreensReceiptsGroupEarlier]!.add(receipt);
      }
    }
    return grouped;
  }

  Future<void> exportReceiptsWithDateRange(DateTimeRange dateRange) async {
    final l10n = L10nService.l10n;

    final receiptsToExport = await _receiptNotifier.getReceiptsInDateRange(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );

    final dateRangeString =
        '${Formatters.formatDate(dateRange.start)} - ${Formatters.formatDate(dateRange.end)}';

    if (receiptsToExport.isEmpty) {
      NotificationService.showError(
        l10n.viewModelsScreensReceiptsExportNoReceiptsInDateRangeError,
      );
      return;
    }

    final csvData = CsvExportService().receiptsToCsv(receiptsToExport);

    final tempDir = await getTemporaryDirectory();
    final fileName =
        '${l10n.viewModelsScreensReceiptsExportFileNamePrefix}_$dateRangeString.csv';
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(
        text: l10n.viewModelsScreensReceiptsExportShareText(dateRangeString),
        files: [XFile(filePath)],
        subject: l10n.viewModelsScreensReceiptsExportShareSubject(
          dateRangeString,
        ),
      ),
    );
  }
}
