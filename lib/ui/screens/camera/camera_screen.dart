import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/models/processed_ocr_result.dart';
import 'package:paragonik/data/models/receipt.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _originalImageFile;
  File? _processedImageFile;

  final ImagePicker _picker = ImagePicker();

  bool _isProcessing = false;
  OcrResult? _ocrResult;

  bool _showProcessedImage = true;
  bool _isSumManuallyCorrected = false;
  bool _isDateManuallyCorrected = false;

  @override
  void dispose() {
    _processedImageFile?.delete();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      await _clearImage();
      setState(() {
        _originalImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _processImage() async {
    if (_originalImageFile == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final ocrService = context.read<OcrService>();
      final ProcessedOcrResult? processedResult = await ocrService
          .extractDataFromFile(_originalImageFile!);

      if (processedResult != null) {
        setState(() {
          _ocrResult = processedResult.result;
          _processedImageFile = processedResult.processedImageFile;
          _showProcessedImage = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd podczas przetwarzania: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _clearImage() async {
    await _processedImageFile?.delete();

    setState(() {
      _originalImageFile = null;
      _processedImageFile = null;
      _ocrResult = null;
      _isSumManuallyCorrected = false;
      _isDateManuallyCorrected = false;
      _showProcessedImage = true;
    });
  }

  Future<void> _showSumInputDialog() async {
    final amountController = TextEditingController(text: _ocrResult?.sum ?? '');

    final String? manuallyEnteredSum = await showDialog<String>(
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

    if (manuallyEnteredSum != null && manuallyEnteredSum.isNotEmpty) {
      final sanitizedSum = manuallyEnteredSum.replaceAll(',', '.');
      setState(() {
        _ocrResult = OcrResult(sum: sanitizedSum, date: _ocrResult!.date);
        _isSumManuallyCorrected = true;
      });
    }
  }

  Future<void> _showDateTimePickerDialog() async {
    final firstDate = DateTime(2000);
    final lastDate = DateTime.now().add(const Duration(days: 365));

    var initialDate = _ocrResult?.date ?? DateTime.now();

    if (initialDate.isAfter(lastDate) || initialDate.isBefore(firstDate)) {
      initialDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('pl', 'PL')
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _ocrResult = OcrResult(sum: _ocrResult!.sum, date: newDateTime);
      _isDateManuallyCorrected = true;
    });
  }

  void _saveResult() {
    if (_originalImageFile == null) return;

    final ocrData = _ocrResult ?? OcrResult(sum: null, date: null);

    final receiptNotifier = context.read<ReceiptNotifier>();
    final receiptService = context.read<ReceiptService>();

    final amountToSave = double.tryParse(ocrData.sum ?? '0.0') ?? 0.0;
    final dateToSave = ocrData.date ?? DateTime.now();

    final newReceipt = Receipt(
      id: const Uuid().v4(),
      imagePath: _originalImageFile!.path,
      amount: amountToSave,
      date: dateToSave,
      storeName: '',
      updatedAt: DateTime.now(),
    );

    try {
      receiptService.addReceipt(
        imageFile: _originalImageFile!,
        amount: amountToSave,
        date: dateToSave,
        storeName: '',
      );

      receiptNotifier.addReceipt(newReceipt);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zapisano paragon!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas zapisu paragonu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _clearImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _buildContent()));
  }

  Widget _buildContent() {
    if (_originalImageFile == null) {
      return _buildInitialView();
    } else if (_isProcessing) {
      return _buildProcessingView();
    } else if (_ocrResult != null ||
        _originalImageFile != null && !_isProcessing) {
      return _buildImageView();
    }
    return _buildInitialView();
  }

  Widget _buildInitialView() {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 18),
      minimumSize: const Size(250, 60),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => _getImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Zrób zdjęcie'),
          style: buttonStyle,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _getImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Wybierz z galerii'),
          style: buttonStyle,
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitFadingCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 80.0,
        ),
        const SizedBox(height: 20),
        const Text('Analizuję paragon...', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildImageView() {
    final imageToShow = _showProcessedImage && _processedImageFile != null
        ? _processedImageFile
        : _originalImageFile;

    if (imageToShow == null) {
      return const Center(child: Text('Brak obrazu do wyświetlenia.'));
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageFile: imageToShow,
                          title: _showProcessedImage
                              ? 'Podgląd skanu'
                              : 'Podgląd oryginału',
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageToShow, fit: BoxFit.contain),
                  ),
                ),
                if (_processedImageFile != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        setState(() {
                          _showProcessedImage = !_showProcessedImage;
                        });
                      },
                      tooltip:
                          'Pokaż ${_showProcessedImage ? "oryginał" : "skan"}',
                      child: Icon(
                        _showProcessedImage
                            ? Icons.image_outlined
                            : Icons.document_scanner_outlined,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (_ocrResult != null) _buildResultPanel(),

        _buildActionPanel(),
      ],
    );
  }

  Widget _buildActionPanel() {
    // If OCR hasn't been run yet (_ocrResult is null), show the "Process" button
    if (_ocrResult == null && !_isProcessing) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: _clearImage,
              icon: const Icon(Icons.refresh),
              label: const Text('Zmień zdjęcie'),
            ),
            ElevatedButton.icon(
              onPressed: _processImage,
              icon: const Icon(Icons.checklist_rtl),
              label: const Text('Przetwórz'),
            ),
          ],
        ),
      );
    }

    // If OCR has been run or is running, show the "Cancel" and "Confirm" buttons
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: _clearImage,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Anuluj'),
          ),
          ElevatedButton.icon(
            onPressed: () => _saveResult(),
            icon: const Icon(Icons.check_circle),
            label: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPanel() {
    final sumLabelText = _isSumManuallyCorrected
        ? 'Kwota (Poprawiona):'
        : 'Kwota:';
    final dateLabelText = _isDateManuallyCorrected
        ? 'Data (Poprawiona):'
        : 'Data:';

    // **CHANGE**: Provide a default value if OCR fails
    final sumString = _ocrResult?.sum ?? 'Nie znaleziono';
    final dateString = _ocrResult?.date != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(_ocrResult!.date!)
        : 'Nie znaleziono';

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
                onPressed: _showSumInputDialog,
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabelText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    dateString,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_calendar_outlined),
                onPressed: _showDateTimePickerDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
