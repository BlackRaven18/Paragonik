import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/notifiers/store_notifier.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class FilterModalContent extends StatelessWidget {
  const FilterModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final storeNotifier = context.watch<StoreNotifier>();
    final receiptsViewModel = context.watch<ReceiptsViewModel>();
    final allStores = storeNotifier.stores;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.screensReceiptsReceiptsScreenWidgetsModalsFilterTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            initialValue: receiptsViewModel.selectedStoreFilter,
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  context
                      .l10n
                      .screensReceiptsReceiptsScreenWidgetsModalsFilterAllStoresOption,
                ),
              ),
              ...allStores.map((store) {
                return DropdownMenuItem<String>(
                  value: store.name,
                  child: StoreDisplay(storeName: store.name),
                );
              }),
            ],
            onChanged: (newValue) {
              context.read<ReceiptsViewModel>().setStoreFilter(newValue);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
