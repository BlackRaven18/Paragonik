import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/screens/camera/take_picture.dart';
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

    String? imagePath;

    if (status.isGranted) {
      if (source == ImageSource.camera) {
        if (context.mounted) {
          imagePath = await Navigator.of(context).push<String>(
            MaterialPageRoute(builder: (context) => const TakePicture()),
          );
        }
      } else {
        final pickedFile = await ImagePicker().pickImage(
          source: source,
          imageQuality: 100,
        );
        imagePath = pickedFile?.path;
      }

      if (imagePath != null) {
        await viewModel.setImage(File(imagePath));
      }
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
  } catch (e) {
    NotificationService.showError(e.toString());
  } finally {
    viewModel.updateIsPermissionRequesting(false);
  }
}
