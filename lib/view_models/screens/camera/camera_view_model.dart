
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum CameraViewState { initial, processing, preview }

class CameraViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _originalImageFile;
  CameraViewState _state = CameraViewState.initial;

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      await clearAll();
      _originalImageFile = File(pickedFile.path);
      _state = CameraViewState.preview;
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    // await _processedImageFile?.delete();
    _originalImageFile = null;
    // _processedImageFile = null;
    // _ocrResult = null;
    // _isSumManuallyCorrected = false;
    // _isDateManuallyCorrected = false;
    // _showProcessedImage = true;
    _state = CameraViewState.initial;
    notifyListeners();
  }
}
