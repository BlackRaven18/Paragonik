import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paragonik/data/services/l10n_service.dart';
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

  final l10n = L10nService.l10n;
  Permission permission;

  try {
    viewModel.updateIsPermissionRequesting(true);

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          permission = Permission.photos;
        } else {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.photos;
      }
    }
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
    } else if (status.isDenied) {
      NotificationService.showError(l10n.notifictationRefusedPermission);
    } else if (status.isPermanentlyDenied && context.mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
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
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); 
                openAppSettings();
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
