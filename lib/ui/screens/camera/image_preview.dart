import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart';

class ImagePreviewView extends StatelessWidget {
  final File? originalImage;
  final File? processedImage;
  final OcrResult? ocrResult;
  final bool isProcessing;
  final bool showProcessed;
  final bool isSumCorrected;
  final bool isDateCorrected;

  final VoidCallback onProcessImage;
  final VoidCallback onClearImage;
  final VoidCallback onSaveResult;
  final VoidCallback onEditSum;
  final VoidCallback onEditDate;
  final VoidCallback onEditStore;
  final VoidCallback onToggleImageType;

  const ImagePreviewView({
    required this.originalImage,
    this.processedImage,
    this.ocrResult,
    required this.isProcessing,
    required this.showProcessed,
    required this.isSumCorrected,
    required this.isDateCorrected,
    required this.onProcessImage,
    required this.onClearImage,
    required this.onSaveResult,
    required this.onEditSum,
    required this.onEditDate,
    required this.onEditStore,
    required this.onToggleImageType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageToShow = showProcessed && processedImage != null
        ? processedImage
        : originalImage;
    if (imageToShow == null)
      return const Center(child: Text('Brak obrazu do wyświetlenia.'));

    return Column(
      children: [
        _buildImageDisplay(context, imageToShow),
        if (ocrResult != null) _buildResultPanel(),
        _buildActionPanel(),
      ],
    );
  }

  Widget _buildImageDisplay(BuildContext context, File imageToShow) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImageViewer(
                    imageFile: imageToShow,
                    title: showProcessed
                        ? 'Podgląd skanu'
                        : 'Podgląd oryginału',
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageToShow, fit: BoxFit.contain),
              ),
            ),
            if (processedImage != null)
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton.small(
                  onPressed: onToggleImageType,
                  tooltip: 'Pokaż ${showProcessed ? "oryginał" : "skan"}',
                  child: Icon(
                    showProcessed
                        ? Icons.image_outlined
                        : Icons.document_scanner_outlined,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

 Widget _buildResultPanel() {
  final sumLabelText = isSumCorrected ? 'Kwota (Poprawiona):' : 'Kwota:';
  final dateLabelText = isDateCorrected ? 'Data (Poprawiona):' : 'Data:';
  const storeLabelText = 'Sklep:';

  final sumString = ocrResult?.sum ?? 'Nie znaleziono';
  final dateString = ocrResult?.date != null
      ? DateFormat('yyyy-MM-dd HH:mm').format(ocrResult!.date!)
      : 'Nie znaleziono';
  final storeString = ocrResult?.storeName ?? 'Nie znaleziono';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
      children: [
        // --- Sekcja Kwoty (bez zmian) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sumLabelText, style: TextStyle(color: Colors.grey.shade600)),
                Text('$sumString PLN', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(icon: const Icon(Icons.edit), onPressed: onEditSum),
          ],
        ),
        const Divider(height: 20),
        
        // --- ZMIENIONA SEKCJA: Data i Sklep w jednym rzędzie ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Wyrównuje elementy do góry
          children: [
            // --- Lewa kolumna (Data) ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateLabelText, style: TextStyle(color: Colors.grey.shade600)),
                  Row(
                    children: [
                      // Używamy Flexible, aby tekst mógł się zawijać w razie potrzeby
                      Flexible(child: Text(dateString, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onEditDate,
                        child: const Icon(Icons.edit_calendar_outlined, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Odstęp między kolumnami

            // --- Prawa kolumna (Sklep) ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(storeLabelText, style: TextStyle(color: Colors.grey.shade600)),
                  Row(
                    children: [
                      Flexible(child: Text(storeString, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onEditStore, // Pamiętaj, aby przekazać ten callback
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

  Widget _buildActionPanel() {
    if (ocrResult == null && !isProcessing) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: onClearImage,
              icon: const Icon(Icons.refresh),
              label: const Text('Zmień zdjęcie'),
            ),
            ElevatedButton.icon(
              onPressed: onProcessImage,
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
            onPressed: onClearImage,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Anuluj'),
          ),
          ElevatedButton.icon(
            onPressed: onSaveResult,
            icon: const Icon(Icons.check_circle),
            label: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}
