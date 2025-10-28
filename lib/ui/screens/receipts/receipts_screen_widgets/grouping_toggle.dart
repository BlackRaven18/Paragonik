import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
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
        segments: [
          ButtonSegment(
            value: GroupingOption.byReceiptDate,
            label: Text(
              context
                  .l10n
                  .screensReceiptsReceiptsScreenWidgetsGroupingToggleReceiptDate,
            ),
          ),
          ButtonSegment(
            value: GroupingOption.byAddedDate,
            label: Text(
              context
                  .l10n
                  .screensReceiptsReceiptsScreenWidgetsGroupingToggleAddedDate,
            ),
          ),
        ],
        selected: {viewModel.groupingOption},
        onSelectionChanged: (selection) =>
            viewModel.setGroupingOption(selection.first),
      ),
    );
  }
}
