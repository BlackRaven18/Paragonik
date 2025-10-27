import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:paragonik/ui/widgets/modals/store_selection_modal.dart';
import 'package:paragonik/view_models/widgets/modals/store_selection_view_model.dart';
import 'package:provider/provider.dart';

Future<Store?> showStoreSelectionModal(BuildContext context) async {
  final selectedStore = await showModalBottomSheet<Store>(
    context: context,
    isScrollControlled: true,
    builder: (_) => ChangeNotifierProvider(
      create: (context) =>
          StoreSelectionViewModel(context.read<StoreNotifier>()),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => const StoreSelectionModal(),
      ),
    ),
  );

  return selectedStore;
}
