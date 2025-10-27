import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/ui/widgets/modals/store_selection_modal.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';

Future<void> showStoreSelectionModal(
  BuildContext context,
  CameraViewModel viewModel,
) async {
  final selectedStore = await showModalBottomSheet<Store>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (_, controller) => const StoreSelectionModal(),
    ),
  );

  if (selectedStore != null) {
    viewModel.updateStore(selectedStore);
  }
}
