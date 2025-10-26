import 'package:flutter/material.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class GroupingToggle extends StatelessWidget {
  const GroupingToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptsViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SegmentedButton<GroupingOption>(
        segments: const [
          ButtonSegment(
            value: GroupingOption.byReceiptDate,
            label: Text('Data paragonu'),
          ),
          ButtonSegment(
            value: GroupingOption.byAddedDate,
            label: Text('Data dodania'),
          ),
        ],
        selected: {viewModel.groupingOption},
        onSelectionChanged: (selection) =>
            viewModel.setGroupingOption(selection.first),
      ),
    );
  }
}
