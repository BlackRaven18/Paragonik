import 'package:flutter/material.dart';
import 'package:paragonik/ui/helpers/date_picker.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';

Future<void> showDateTimePickerDialog(
  BuildContext context,
  CameraViewModel viewModel,
) async {
  final newDateTime = await pickDateTime(
    context,
    initialDate: viewModel.ocrResult?.date,
  );

  if (newDateTime != null) {
    viewModel.updateDate(newDateTime);
  }
}
