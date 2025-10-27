import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/helpers/store_selection_modal_helper.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/helpers/date_time_picker_dialog_helper.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view/helpers/sum_input_dialog_helper.dart';
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

    final sumLabelText = viewModel.isSumManuallyCorrected
        ? 'Kwota (Poprawiona):'
        : 'Kwota:';
    final dateLabelText = viewModel.isDateManuallyCorrected
        ? 'Data (Poprawiona):'
        : 'Data:';
    const storeLabelText = 'Sklep:';

    final sumString = viewModel.ocrResult?.sum ?? 'Nie znaleziono';
    final dateString = viewModel.ocrResult?.date != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(viewModel.ocrResult!.date!)
        : 'Nie znaleziono';
    final storeString = viewModel.ocrResult?.storeName ?? 'Nie znaleziono';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sumLabelText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    '$sumString PLN',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showSumInputDialog(context, viewModel),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabelText,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            dateString,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () =>
                              showDateTimePickerDialog(context, viewModel),
                          child: const Icon(
                            Icons.edit_calendar_outlined,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeLabelText,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: StoreDisplay(
                            storeName: storeString,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _handleStoreChange(context, viewModel),
                          child: const Icon(Icons.store, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
