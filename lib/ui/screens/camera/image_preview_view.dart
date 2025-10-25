import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/helpers/date_picker.dart';
import 'package:paragonik/ui/screens/camera/modals/store_selection_modal.dart';
import 'package:paragonik/ui/widgets/image_viewer.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ImagePreviewView extends StatelessWidget {
  const ImagePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    final imageToShow =
        viewModel.showProcessedImage && viewModel.processedImageFile != null
        ? viewModel.processedImageFile
        : viewModel.originalImageFile;
    if (imageToShow == null) {
      return const Center(child: Text('Błąd: Brak obrazu'));
    }

    return Column(
      children: [
        Expanded(
          child: ImageViewer(
            imageFile: viewModel.originalImageFile!,
            secondaryImageFile: viewModel.processedImageFile,
          ),
        ),
        if (viewModel.ocrResult != null) _buildResultPanel(context, viewModel),
        _buildActionPanel(context, viewModel),
      ],
    );
  }

  Widget _buildResultPanel(BuildContext context, CameraViewModel viewModel) {
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

    Future<void> showSumInputDialog(BuildContext context) async {
      final amountController = TextEditingController(
        text: viewModel.ocrResult?.sum ?? '',
      );
      final newSum = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ręczna poprawa kwoty'),
          content: TextField(
            controller: amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Wpisz poprawną kwotę',
              suffixText: 'PLN',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(amountController.text),
              child: const Text('Zapisz'),
            ),
          ],
        ),
      );

      if (newSum != null && newSum.isNotEmpty) {
        viewModel.updateSum(newSum);
      }
    }

    Future<void> showDateTimePickerDialog(BuildContext context) async {
      final newDateTime = await pickDateTime(
        context,
        initialDate: viewModel.ocrResult?.date,
      );

      if (newDateTime != null) {
        viewModel.updateDate(newDateTime);
      }
    }

    Future<void> showStoreSelectionModal(BuildContext context) async {
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
                onPressed: () => showSumInputDialog(context),
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
                          onTap: () => showDateTimePickerDialog(context),
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
                          onTap: () => showStoreSelectionModal(context),
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

  Widget _buildActionPanel(BuildContext context, CameraViewModel viewModel) {
    if (viewModel.ocrResult == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: viewModel.clearImage,
              icon: const Icon(Icons.refresh),
              label: const Text('Zmień zdjęcie'),
            ),
            ElevatedButton.icon(
              onPressed: viewModel.processImage,
              icon: const Icon(Icons.checklist_rtl),
              label: const Text('Przetwórz'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: viewModel.clearImage,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Anuluj'),
          ),
          ElevatedButton.icon(
            onPressed: viewModel.saveResult,
            icon: const Icon(Icons.check_circle),
            label: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}
