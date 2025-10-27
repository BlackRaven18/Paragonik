import 'package:flutter/material.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/widgets/modals/store_selection_view_model.dart';
import 'package:provider/provider.dart';

class StoreSelectionModal extends StatelessWidget {
  const StoreSelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoreSelectionViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: viewModel.setSearchQuery,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Wyszukaj sklep...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.filteredStores.length,
              itemBuilder: (context, index) {
                final store = viewModel.filteredStores[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: StoreDisplay(storeName: store.name),
                    onTap: () {
                      Navigator.of(context).pop(store);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
