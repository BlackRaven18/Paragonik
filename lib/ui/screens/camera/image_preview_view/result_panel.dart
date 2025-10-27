import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/helpers/store_selection_modal_helper.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/helpers/date_time_picker_dialog_helper.dart';
import 'package:paragonik/helpers/sum_input_dialog_helper.dart';
import 'package:paragonik/ui/widgets/editable_field.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key});

  Future<void> _handleStoreChange(
    BuildContext context,
    CameraViewModel viewModel,
  ) async {
    final selectedStore = await showStoreSelectionModal(context);

    if (selectedStore != null) {
      viewModel.updateStore(selectedStore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    final theme = Theme.of(context);

    final DateFormat displayDateFormat = DateFormat(
      'dd.MM.yyyy HH:mm',
      'pl_PL',
    );

    final sumString = viewModel.ocrResult?.sum ?? '0.00';
    final dateDisplayString = viewModel.ocrResult?.date != null
        ? displayDateFormat.format(viewModel.ocrResult!.date!)
        : 'Nie znaleziono';
    final storeString = viewModel.ocrResult?.storeName ?? 'Nieznany sklep';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          EditableField(
            label: viewModel.isSumManuallyCorrected
                ? 'Kwota (Poprawiona):'
                : 'Kwota:',
            content: Text(
              '$sumString PLN',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icons.edit,
            onEdit: () => showSumInputDialog(
              context,
              initialValue: viewModel.ocrResult?.sum ?? '0.00',
              onValueSaved: viewModel.updateSum,
            ),
          ),
          EditableField(
            label: viewModel.isDateManuallyCorrected
                ? 'Data (Poprawiona):'
                : 'Data:',
            content: Text(
              dateDisplayString,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icons.edit_calendar_outlined,
            onEdit: () => showDateTimePickerDialog(context, viewModel),
          ),
          EditableField(
            label: 'Sklep:',
            content: StoreDisplay(
              storeName: storeString,
              textStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icons.store,
            onEdit: () => _handleStoreChange(context, viewModel),
          ),
        ],
      ),
    );
  }
}
