import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/models/ocr_result.dart';
import 'package:paragonik/data/models/processed_ocr_result.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:paragonik/helpers/date_picker.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/screens/camera/image_preview_view.dart';
import 'package:paragonik/ui/screens/camera/initial_view.dart';
import 'package:paragonik/ui/screens/camera/modals/store_selection_modal.dart';
import 'package:paragonik/ui/screens/camera/processing_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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

  Future<void> _requestAndGetImage(ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;

    final status = await permission.request();

    if (status.isGranted) {
      _getImage(source);
    } else if (status.isPermanentlyDenied) {
      if(mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Brak uprawnień'),
            content: Text('Aplikacja potrzebuje dostępu do ${source == ImageSource.camera ? "aparatu" : "galerii"}. Proszę włączyć uprawnienie w ustawieniach aplikacji.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Anuluj'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text('Otwórz ustawienia'),
              ),
            ],
          ),
        );
      }
    } else {
      // Jeśli użytkownik po prostu odmówił (ale nie trwale)
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Odmówiono dostępu do ${source == ImageSource.camera ? "aparatu" : "galerii"}.')),
        );
      }
    }
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
        _ocrResult = OcrResult(
          sum: sanitizedSum,
          date: _ocrResult!.date,
          storeName: _ocrResult!.storeName,
        );
        _isSumManuallyCorrected = true;
      });
    }
  }

  Future<void> _showDateTimePickerDialog() async {

    final pickedDateTime = await pickDateTime(
      context,
      initialDate: _ocrResult?.date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime == null) return;

    final newDateTime = DateTime(
      pickedDateTime.year,
      pickedDateTime.month,
      pickedDateTime.day,
      pickedDateTime.hour,
      pickedDateTime.minute,
    );

    setState(() {
      _ocrResult = _ocrResult?.copyWith(date: newDateTime);
      _isDateManuallyCorrected = true;
    });
  }

  Future<void> _showStoreSelectionModal() async {
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
      setState(() {
        _ocrResult = OcrResult(
          sum: _ocrResult?.sum,
          date: _ocrResult?.date,
          storeName: selectedStore.name,
        );
      });
    }
  }

  void _saveResult() {
    if (_originalImageFile == null) return;

    final ocrData = _ocrResult ?? OcrResult(sum: null, date: null);
    final receiptNotifier = context.read<ReceiptNotifier>();

    final amountToSave = double.tryParse(ocrData.sum ?? '0.0') ?? 0.0;
    final dateToSave = ocrData.date ?? DateTime.now();
    final storeNameToSave = ocrData.storeName ?? '';

    try {
      receiptNotifier.addReceipt(
        imageFile: _originalImageFile!,
        amount: amountToSave,
        date: dateToSave,
        storeName: storeNameToSave,
      );

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
      return InitialView(onImageRequested: _requestAndGetImage);
    }
    if (_isProcessing) {
      return const ProcessingView();
    }
    return ImagePreviewView(
      originalImage: _originalImageFile,
      processedImage: _processedImageFile,
      ocrResult: _ocrResult,
      showProcessed: _showProcessedImage,
      isSumCorrected: _isSumManuallyCorrected,
      isDateCorrected: _isDateManuallyCorrected,
      isProcessing: _isProcessing,
      onProcessImage: _processImage,
      onClearImage: _clearImage,
      onSaveResult: _saveResult,
      onEditSum: _showSumInputDialog,
      onEditDate: _showDateTimePickerDialog,
      onEditStore: _showStoreSelectionModal,
      onToggleImageType: () {
        setState(() {
          _showProcessedImage = !_showProcessedImage;
        });
      },
    );
  }
}
