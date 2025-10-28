import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/statistics/statistics_view_model.dart';

class StoreSpendingListItem extends StatelessWidget {
  final StoreSpending storeSpending;
  final double maxAmount;

  const StoreSpendingListItem({
    super.key,
    required this.storeSpending,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barWidthFactor = maxAmount > 0
        ? storeSpending.totalAmount / maxAmount
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StoreDisplay(
                  storeName: storeSpending.storeName,
                  textStyle: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                Formatters.formatCurrency(storeSpending.totalAmount),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                height: 8,
                color: theme.colorScheme.surface,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: barWidthFactor,
                  child: Container(color: storeSpending.color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
