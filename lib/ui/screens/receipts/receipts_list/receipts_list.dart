import 'package:flutter/material.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/receipt_list_item.dart';
import 'package:paragonik/ui/screens/receipts/receipts_list/section_header.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptsList extends StatefulWidget {
  const ReceiptsList({super.key});

  @override
  State<ReceiptsList> createState() => _ReceiptsListState();
}

class _ReceiptsListState extends State<ReceiptsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReceiptsViewModel>().fetchMoreReceipts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();

    if (viewModel.isLoadingInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.groupedReceipts.isEmpty) {
      return const Center(child: Text('Nie znaleziono pasujących paragonów.'));
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.fetchReceipts(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            viewModel.groupedReceipts.length +
            (viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.groupedReceipts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final entry = viewModel.groupedReceipts.entries.elementAt(index);

          if (entry.value.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: entry.key),
                ...entry.value.map(
                  (receipt) => ReceiptListItem(receipt: receipt),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
