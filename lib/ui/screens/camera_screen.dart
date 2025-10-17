import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/data/services/ocr_service.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isProcessing = false;
  String? _extractedSum;

  bool _isManuallyCorrected = false;

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _extractedSum = null;
        _isManuallyCorrected = false;
      });
    }
  }

  Future<void> _processImage() async {
    if (_imageFile == null) return;

    setState(() { _isProcessing = true; });

    try {
      final ocrService = context.read<OcrService>();
      final String? foundSum = await ocrService.extractSumFromFile(_imageFile!);

      setState(() { _extractedSum = foundSum; });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd podczas przetwarzania: $e')),
      );
    } finally {
      setState(() { _isProcessing = false; });
    }
  }

  void _acceptSum(String finalSum) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kwota $finalSum PLN została zapisana!')),
    );
    _clearImage();
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
      _extractedSum = null;
      _isManuallyCorrected = false;
    });
  }

  Future<void> _showManualInputDialog() async {
    final amountController = TextEditingController(text: _extractedSum ?? '');

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
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Anuluj')),
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
        _extractedSum = sanitizedSum;
        _isManuallyCorrected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_imageFile == null) {
      return _buildInitialView();
    } else if (_isProcessing) {
      return _buildProcessingView();
    } else if (_extractedSum != null || _imageFile != null && !_isProcessing) {
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
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, fit: BoxFit.contain),
            ),
          ),
        ),
        if (_extractedSum != null) _buildResultPanel(),
        _buildActionPanel(),
      ],
    );
  }

  Widget _buildActionPanel() {
    if (_extractedSum == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(onPressed: _clearImage, icon: const Icon(Icons.refresh), label: const Text('Zmień zdjęcie')),
            ElevatedButton.icon(onPressed: _processImage, icon: const Icon(Icons.checklist_rtl), label: const Text('Przetwórz')),
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
            onPressed: _showManualInputDialog,
            icon: const Icon(Icons.edit),
            label: const Text('Popraw'),
          ),
          ElevatedButton.icon(
            onPressed: () => _acceptSum(_extractedSum!),
            icon: const Icon(Icons.check_circle),
            label: const Text('Zatwierdź'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultPanel() {
    final labelText = _isManuallyCorrected ? 'Znaleziona kwota (poprawiona):' : 'Znaleziona kwota:';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(labelText, style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          Text(
            '${_extractedSum!} PLN',
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}