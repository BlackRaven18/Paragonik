import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/helpers/date_picker.dart';
import 'package:paragonik/helpers/store_selection_modal_helper.dart';
import 'package:paragonik/helpers/sum_input_dialog_helper.dart';
import 'package:paragonik/ui/widgets/editable_field.dart';
import 'package:paragonik/ui/widgets/image_viewer.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/receipts/receipt_edit_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptEditScreen extends StatelessWidget {
  const ReceiptEditScreen({super.key});

  Future<void> _handleStoreChange(
    BuildContext context,
    ReceiptEditViewModel viewModel,
  ) async {
    final selectedStore = await showStoreSelectionModal(context);

    if (selectedStore != null) {
      viewModel.updateStore(selectedStore.name);
    }
  }

  Future<void> _selectDateTime(
    BuildContext context,
    ReceiptEditViewModel viewModel,
  ) async {
    final pickedDateTime = await pickDateTime(
      context,
      initialDate: viewModel.selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime == null) return;
    viewModel.updateDateTime(pickedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReceiptEditViewModel>();
    final theme = Theme.of(context);

    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 70.0, 16.0, 100.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: ImageViewer(imageFile: File(viewModel.imagePath)),
                  ),
                  const SizedBox(height: 24),

                  EditableField(
                    label: 'Kwota:',
                    content: Text(
                      '${viewModel.updatedSum} PLN',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icons.edit,
                    onEdit: () => showSumInputDialog(
                      context,
                      initialValue: viewModel.updatedSum,
                      onValueSaved: viewModel.updateSum,
                    ),
                  ),

                  EditableField(
                    label: 'Data i godzina',
                    content: Text(
                      DateFormat(
                        'dd.MM.yyyy HH:mm',
                      ).format(viewModel.selectedDateTime),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icons.edit_calendar_outlined,
                    onEdit: () => _selectDateTime(context, viewModel),
                  ),

                  EditableField(
                    label: 'Sklep',
                    content: StoreDisplay(
                      storeName: viewModel.selectedStoreName,
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icons.store,
                    onEdit: () => _handleStoreChange(context, viewModel),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 16.0,
              left: 16.0,
              child: FloatingActionButton.small(
                onPressed: () => Navigator.of(context).pop(),
                heroTag: 'receipt_edit_back_btn',
                child: const Icon(Icons.arrow_back),
              ),
            ),

            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton.extended(
                onPressed: () {
                  viewModel.saveChanges();
                  NotificationService.showSuccess('Zapisano zmiany!');
                  Navigator.of(context).pop();
                },
                label: const Text('Zapisz zmiany'),
                icon: const Icon(Icons.save),
                heroTag: 'receipt_edit_save_btn',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
