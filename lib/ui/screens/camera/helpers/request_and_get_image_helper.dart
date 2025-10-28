import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestAndGetImage(
  BuildContext context,
  ImageSource source,
  CameraViewModel viewModel,
) async {
  if (viewModel.isBusy) return;

  try {
    viewModel.updateIsPermissionRequesting(true);

    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      await viewModel.getImage(source);
    } else if (status.isPermanentlyDenied && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.l10n.screensCameraHelpersPermissionDialogTitle),
          content: Text(
            source == ImageSource.camera
                ? context.l10n.screensCameraHelpersPermissionDialogContentCamera
                : context
                      .l10n
                      .screensCameraHelpersPermissionDialogContentGallery,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: Text(
                context
                    .l10n
                    .screensCameraHelpersPermissionDialogOpenSettingsButton,
              ),
            ),
          ],
        ),
      );
    }
  } finally {
    viewModel.updateIsPermissionRequesting(false);
  }
}
