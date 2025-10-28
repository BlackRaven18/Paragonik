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
        return 'Bieżący tydzień';
      case TimeRange.month:
        return 'Bieżący miesiąc';
      case TimeRange.custom:
        return 'Niestandardowy';
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
                      context.l10n.statistics,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),

                  Text(
                    'Podsumowanie (${_getRangeLabel(viewModel.selectedTimeRange)})',
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
                        title: 'Wydatki',
                        value: Formatters.formatCurrency(
                          viewModel.totalSpending,
                        ),
                      ),

                      if (viewModel.selectedTimeRange == TimeRange.month)
                        StatCard(
                          title: 'Poprzedni miesiąc',
                          value:
                              '${viewModel.comparisonPercentage.toStringAsFixed(1)}%',
                          subtitle: Formatters.formatCurrency(
                            viewModel.comparisonAbsolute,
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      StatCard(
                        title: 'Średnio dziennie',
                        value: Formatters.formatCurrency(
                          viewModel.averageDailySpending,
                        ),
                      ),
                      StatCard(
                        title: 'Liczba paragonów',
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
                        'Wydatki w sklepach',
                        style: theme.textTheme.titleLarge,
                      ),
                      SegmentedButton<TimeRange>(
                        segments: const [
                          ButtonSegment(
                            value: TimeRange.week,
                            label: Text('Tydzień'),
                          ),
                          ButtonSegment(
                            value: TimeRange.month,
                            label: Text('Miesiąc'),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text('Brak wydatków w tym okresie.'),
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
