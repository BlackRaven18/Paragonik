import 'package:flutter/material.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class DateRangeFilterButton extends StatelessWidget {
  const DateRangeFilterButton({super.key});

  Future<void> _pickDateRange(BuildContext context, ReceiptsViewModel viewModel) async {
    final now = DateTime.now();
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: viewModel.dateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
    );

    if (newDateRange != null) {
      viewModel.setDateRange(newDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();
    final bool isDateFilterActive = viewModel.dateRange != null;

    return IconButton(
      icon: Icon(isDateFilterActive ? Icons.calendar_month : Icons.calendar_today_outlined),
      onPressed: () => _pickDateRange(context, viewModel),
    );
  }
}