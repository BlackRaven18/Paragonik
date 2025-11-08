import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/date_range_filter_button.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/modals/export_receipts_dialog_helper.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/receipts_list.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/filter_button.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/grouping_toggle.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/receipts_counter.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/receipts_search_bar.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final viewModel = context.read<ReceiptsViewModel>();
      if (_searchController.text != viewModel.searchQuery) {
        viewModel.setSearchQuery(_searchController.text);
      }
    });
  }
  
  Future<void> _showExportDialog(
    BuildContext context,
    ReceiptsViewModel viewModel,
  ) async {
    final selectedDateRange = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExportReceiptsDialog(),
    );

    if (selectedDateRange != null) {
      await viewModel.exportReceiptsWithDateRange(selectedDateRange);
    }
  }

  Widget _buildReceiptsList(ReceiptsViewModel viewModel) {
    if (viewModel.allReceipts.isNotEmpty) {
      return Expanded(child: ReceiptsList());
    } else {
      return Expanded(
        child: Stack(
          children: [
            Center(
              child: Text(L10nService.l10n.screensReceiptsNoReceiptsSaved),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();
    final l10n = context.l10n;

    if (viewModel.isLoadingInitial && viewModel.allReceipts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: ReceiptsSearchBar(controller: _searchController,)),
              const SizedBox(width: 8),
              const DateRangeFilterButton(),
              const FilterButton(),
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: L10nService
                    .l10n
                    .screensReceiptsReceiptsScreenExportReceiptsButtonTooltip,
                onPressed: () => _showExportDialog(context, viewModel),
              ),
            ],
          ),
        ),
        GroupingToggle(),
        ReceiptsCounter(),

        if (viewModel.selectedStoreFilter != null ||
            viewModel.dateRange != null)
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  if (viewModel.selectedStoreFilter != null)
                    Chip(
                      label: Text(
                        l10n.screensReceiptsActiveStoreFilterLabel(
                          viewModel.selectedStoreFilter!,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      onDeleted: () {
                        context.read<ReceiptsViewModel>().setStoreFilter(null);
                      },
                      deleteButtonTooltipMessage:
                          l10n.screensReceiptsClearFilterTooltip,
                    ),

                  if (viewModel.selectedStoreFilter != null &&
                      viewModel.dateRange != null)
                    const SizedBox(width: 8),

                  if (viewModel.dateRange != null)
                    Chip(
                      label: Text(
                        l10n.screensReceiptsActiveDateFilterLabel(
                          '${Formatters.formatDate(viewModel.dateRange!.start)} - ${Formatters.formatDate(viewModel.dateRange!.end)}',
                        ),
                      ),
                      onDeleted: () {
                        viewModel.setDateRange(null);
                      },
                    ),
                ],
              ),
            ),
          ),

        _buildReceiptsList(viewModel),
      ],
    );
  }
}
