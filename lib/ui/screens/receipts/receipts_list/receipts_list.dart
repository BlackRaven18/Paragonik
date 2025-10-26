import 'package:flutter/material.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/receipt_list_item.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/section_header.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptsList extends StatelessWidget {
  const ReceiptsList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();

    Future<void> handleOnRefresh() => viewModel.fetchReceipts();

    return RefreshIndicator(
      onRefresh: handleOnRefresh,
      child: viewModel.groupedReceipts.isEmpty
          ? const Center(child: Text('Nie znaleziono pasujących paragonów.'))
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                for (final entry in viewModel.groupedReceipts.entries) ...[
                  SectionHeader(title: entry.key),
                  ...entry.value.map(
                    (receipt) => ReceiptListItem(receipt: receipt),
                  ),
                ],
              ],
            ),
    );
  }
}
