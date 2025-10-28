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
    switch (range) {
      case TimeRange.week:
        return context.l10n.screensStatisticsRangeLabelCurrentWeek;
      case TimeRange.month:
        return context.l10n.screensStatisticsRangeLabelCurrentMonth;
      case TimeRange.custom:
        return context.l10n.screensStatisticsRangeLabelCustom;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.fetchStatistics(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: Text(
                      context.l10n.screensStatisticsScreenTitle,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),

                  Text(
                    context.l10n.screensStatisticsSummaryTitleWithRange(
                      _getRangeLabel(viewModel.selectedTimeRange),
                    ),
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    children: [
                      StatCard(
                        title: context.l10n.screensStatisticsCardSpendingTitle,
                        value: Formatters.formatCurrency(
                          viewModel.totalSpending,
                        ),
                      ),

                      if (viewModel.selectedTimeRange == TimeRange.month)
                        StatCard(
                          title: context
                              .l10n
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
                            context.l10n.screensStatisticsCardDailyAverageTitle,
                        value: Formatters.formatCurrency(
                          viewModel.averageDailySpending,
                        ),
                      ),
                      StatCard(
                        title: context
                            .l10n
                            .screensStatisticsCardReceiptsCountTitle,
                        value: viewModel.receiptCount.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 16,
                    children: [
                      Text(
                        context.l10n.screensStatisticsStoreSpendingTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                      SegmentedButton<TimeRange>(
                        segments: [
                          ButtonSegment(
                            value: TimeRange.week,
                            label: Text(
                              context.l10n.screensStatisticsTimeRangeWeek,
                            ),
                          ),
                          ButtonSegment(
                            value: TimeRange.month,
                            label: Text(
                              context.l10n.screensStatisticsTimeRangeMonth,
                            ),
                          ),
                        ],
                        selected: {viewModel.selectedTimeRange},
                        onSelectionChanged: (newSelection) {
                          viewModel.fetchStatistics(range: newSelection.first);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (viewModel.spendingByStore.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          context.l10n.screensStatisticsNoSpendingInRange,
                        ),
                      ),
                    )
                  else
                    ...viewModel.spendingByStore.map(
                      (storeData) => StoreSpendingListItem(
                        storeSpending: storeData,
                        maxAmount: viewModel.spendingByStore.first.totalAmount,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
