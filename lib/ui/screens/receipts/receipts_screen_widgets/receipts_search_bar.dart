import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptsSearchBar extends StatelessWidget {
  const ReceiptsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ReceiptsViewModel>();

    return TextField(
      onChanged: viewModel.setSearchQuery,
      decoration: InputDecoration(
        labelText: context.l10n.screensReceiptsReceiptsScreenWidgetsSearchLabel,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
