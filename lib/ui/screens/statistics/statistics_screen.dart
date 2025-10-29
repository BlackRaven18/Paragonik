import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/screens/statistics/stat_card.dart';
import 'package:paragonik/ui/screens/statistics/store_spending_list_item.dart';
import 'package:paragonik/view_models/screens/statistics/statistics_view_model.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _getRangeLabel(TimeRange range) {
    final l10n = context.l10n;
    switch (range) {
      case TimeRange.week:
        return l10n.screensStatisticsRangeLabelCurrentWeek;
      case TimeRange.month:
        return l10n.screensStatisticsRangeLabelCurrentMonth;
      case TimeRange.custom:
        return l10n.screensStatisticsRangeLabelCustom;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticsViewModel>();
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            child: Column(
              children: [
                Text(
                  l10n.screensStatisticsScreenTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                SegmentedButton<TimeRange>(
                  segments: [
                    ButtonSegment(
                      value: TimeRange.week,
                      label: Text(l10n.screensStatisticsTimeRangeWeek),
                    ),
                    ButtonSegment(
                      value: TimeRange.month,
                      label: Text(l10n.screensStatisticsTimeRangeMonth),
                    ),
                  ],
                  selected: {viewModel.selectedTimeRange},
                  onSelectionChanged: (newSelection) {
                    viewModel.fetchStatistics(range: newSelection.first);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => viewModel.fetchStatistics(),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.6,
                          children: [
                            StatCard(
                              title: l10n.screensStatisticsCardSpendingTitle,
                              value: Formatters.formatCurrency(
                                viewModel.totalSpending,
                              ),
                            ),
                            if (viewModel.selectedTimeRange == TimeRange.month)
                              StatCard(
                                title: l10n
                                    .screensStatisticsCardVsPreviousMonthTitle,
                                value:
                                    '${viewModel.comparisonPercentage.toStringAsFixed(1)}%',
                                subtitle: Formatters.formatCurrency(
                                  viewModel.comparisonAbsolute,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            StatCard(
                              title:
                                  l10n.screensStatisticsCardDailyAverageTitle,
                              value: Formatters.formatCurrency(
                                viewModel.averageDailySpending,
                              ),
                            ),
                            StatCard(
                              title:
                                  l10n.screensStatisticsCardReceiptsCountTitle,
                              value: viewModel.receiptCount.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        Text(
                          l10n.screensStatisticsStoreSpendingTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        if (viewModel.spendingByStore.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(
                              child: Text(
                                l10n.screensStatisticsNoSpendingInRange,
                              ),
                            ),
                          )
                        else
                          Column(
                            children: viewModel.spendingByStore
                                .map(
                                  (storeData) => StoreSpendingListItem(
                                    storeSpending: storeData,
                                    maxAmount:
                                        viewModel.spendingByStore.isNotEmpty
                                        ? viewModel
                                              .spendingByStore
                                              .first
                                              .totalAmount
                                        : 1,
                                  ),
                                )
                                .toList(),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
