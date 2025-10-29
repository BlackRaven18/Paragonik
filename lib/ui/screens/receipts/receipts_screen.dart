import 'package:flutter/material.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/modals/export_receipts_dialog_helper.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/receipts_list.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/filter_button.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/grouping_toggle.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/receipts_counter.dart';
import 'package:paragonik/ui/screens/receipts/receipts_screen_widgets/receipts_search_bar.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  Future<void> _showExportDialog(BuildContext context, ReceiptsViewModel viewModel) async {

    final selectedDateRange = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExportReceiptsDialog(),
    );

    if (selectedDateRange != null) {
      await viewModel.exportReceiptsWithDateRange(selectedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();

    if (viewModel.isLoading && viewModel.allReceipts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.allReceipts.isEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.fetchReceipts,
        child: Stack(
          children: [
            Center(child: Text(context.l10n.screensReceiptsNoReceiptsSaved)),
            ListView(),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(child: ReceiptsSearchBar()),
              const SizedBox(width: 8),
              const FilterButton(),
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: L10nService.l10n.screensReceiptsReceiptsScreenExportReceiptsButtonTooltip,
                onPressed: () => _showExportDialog(context, viewModel),
              ),
            ],
          ),
        ),
        GroupingToggle(),
        ReceiptsCounter(),

        Expanded(child: ReceiptsList()),
      ],
    );
  }
}
