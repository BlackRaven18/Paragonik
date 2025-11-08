import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';

enum TimeRange { week, month, custom }

class StoreSpending {
  final String storeName;
  final double totalAmount;
  final Color color;

  StoreSpending({
    required this.storeName,
    required this.totalAmount,
    required this.color,
  });
}

class StatisticsViewModel extends ChangeNotifier {
  final ReceiptService _receiptService;
  final ReceiptNotifier _receiptNotifier;

  StatisticsViewModel(this._receiptService, this._receiptNotifier) {
    fetchStatistics();
    _receiptNotifier.addListener(_onReceiptsChanged);
  }

  bool _isDirty = true;
  bool _isLoading = true;
  TimeRange _selectedTimeRange = TimeRange.month;
  DateTimeRange? _customDateRange;

  double totalSpending = 0;
  double comparisonPercentage = 0;
  double comparisonAbsolute = 0;
  double averageDailySpending = 0;
  double lastMonthSpending = 0;
  int receiptCount = 0;
  DateTime? _activeStartDate;
  DateTime? _activeEndDate;

  List<StoreSpending> spendingByStore = [];

  bool get isLoading => _isLoading;
  TimeRange get selectedTimeRange => _selectedTimeRange;
  DateTimeRange? get customDateRange => _customDateRange;
  DateTime? get activeStartDate => _activeStartDate;
  DateTime? get activeEndDate => _activeEndDate;

  @override
  void dispose() {
    _receiptNotifier.removeListener(_onReceiptsChanged);
    super.dispose();
  }

  void _onReceiptsChanged() {
    _isDirty = true;
    refreshDataIfDirty();
  }

  void refreshDataIfDirty() {
    if (_isDirty && !_isLoading) {
      fetchStatistics();
    }
  }

  Future<void> fetchStatistics({
    TimeRange? range,
    DateTimeRange? customRange,
  }) async {
    _isLoading = true;
    _selectedTimeRange = range ?? _selectedTimeRange;
    _customDateRange = customRange ?? _customDateRange;
    
    notifyListeners();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime currentStartDate;
    DateTime currentEndDate = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );

    

    DateTime previousStartDate;
    DateTime previousEndDate;

    if (_selectedTimeRange == TimeRange.week) {
      currentStartDate = today.subtract(Duration(days: today.weekday - 1));
      previousStartDate = currentStartDate.subtract(const Duration(days: 7));
      previousEndDate = currentStartDate.subtract(const Duration(days: 1));
    } else if (_selectedTimeRange == TimeRange.month) {
      currentStartDate = DateTime(today.year, today.month, 1);
      previousStartDate = DateTime(today.year, today.month - 1, 1);
      previousEndDate = DateTime(today.year, today.month, 0);
    } else {
      currentStartDate = _customDateRange?.start ?? today;
      currentEndDate = _customDateRange?.end ?? currentEndDate;
      previousStartDate = now;
      previousEndDate = now;
    }

    _activeStartDate = currentStartDate;
    _activeEndDate = currentEndDate;

    try {
      final results = await Future.wait([
        _receiptService.getReceiptsInDateRange(
          startDate: currentStartDate,
          endDate: currentEndDate,
        ),
        if (_selectedTimeRange == TimeRange.month)
          _receiptService.getReceiptsInDateRange(
            startDate: previousStartDate,
            endDate: previousEndDate,
          )
        else
          Future.value(<Receipt>[]),
      ]);

      final receiptsInCurrentRange = results[0];
      final receiptsInPreviousRange = results[1];

      _calculateBasicStats(
        receiptsInCurrentRange,
        receiptsInPreviousRange,
        currentStartDate,
        currentEndDate,
      );
      _calculateStoreStats(receiptsInCurrentRange);

      _isDirty = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateBasicStats(
    List<Receipt> currentReceipts,
    List<Receipt> previousReceipts,
    DateTime startDate,
    DateTime endDate,
  ) {
    totalSpending = currentReceipts.fold(0, (sum, r) => sum + r.amount);
    receiptCount = currentReceipts.length;

    final daysInRange = endDate.difference(startDate).inDays + 1;
    averageDailySpending = daysInRange > 0 ? totalSpending / daysInRange : 0;

    if (_selectedTimeRange == TimeRange.month) {
      lastMonthSpending = previousReceipts.fold(
        0.0,
        (sum, r) => sum + r.amount,
      );

      comparisonAbsolute = totalSpending - lastMonthSpending;
      if (lastMonthSpending > 0) {
        comparisonPercentage = (comparisonAbsolute / lastMonthSpending) * 100;
      } else {
        comparisonPercentage = totalSpending > 0 ? 100 : 0;
      }
    } else {
      comparisonAbsolute = 0;
      comparisonPercentage = 0;
      lastMonthSpending = 0;
    }
  }

  void _calculateStoreStats(List<Receipt> receipts) {
    final Map<String, double> storeMap = {};
    for (var receipt in receipts) {
      storeMap.update(
        receipt.storeName,
        (value) => value + receipt.amount,
        ifAbsent: () => receipt.amount,
      );
    }

    var sortedEntries = storeMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<Color> barColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    spendingByStore = List.generate(sortedEntries.length, (index) {
      final entry = sortedEntries[index];
      return StoreSpending(
        storeName: entry.key,
        totalAmount: entry.value,
        color: barColors[index % barColors.length],
      );
    });
  }
}
