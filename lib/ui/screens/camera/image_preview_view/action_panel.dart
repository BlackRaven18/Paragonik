import 'package:flutter/material.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/helpers/modals/future_date_warning_dialog_helper.dart';
import 'package:paragonik/view_models/screens/camera/camera_view_model.dart';
import 'package:provider/provider.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key});

  Future<void> _handleOnSave(
    BuildContext context,
    CameraViewModel viewModel,
  ) async {
    if (viewModel.ocrResult!.date != null &&
        viewModel.ocrResult!.date!.isAfter(DateTime.now())) {
      final bool confirmed = await showFutureDateWarningDialog(context);

      if (!confirmed) {
        return;
      }
    }

    viewModel.saveResult();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    if (viewModel.ocrResult == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: viewModel.isBusy ? null : viewModel.clearImage,
              icon: const Icon(Icons.refresh),
              label: Text(
                context.l10n.screensCameraActionPanelChangePhotoButton,
              ),
            ),
            ElevatedButton.icon(
              onPressed: viewModel.isBusy ? null : viewModel.processImage,
              icon: const Icon(Icons.checklist_rtl),
              label: Text(context.l10n.screensCameraActionPanelProcessButton),
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
            label: Text(context.l10n.commonCancel),
          ),
          ElevatedButton.icon(
            onPressed: () => _handleOnSave(context, viewModel),
            icon: const Icon(Icons.check_circle),
            label: Text(context.l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
