import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
import 'package:paragonik/view_models/screens/receipts/receipts_view_model.dart';
import 'package:provider/provider.dart';

class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;

  const ReceiptListItem({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final receiptsViewModel = context.watch<ReceiptsViewModel>();
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final formattedDate = Formatters.formatDateTime(receipt.date);

    Future<void> handleDeleteReceipt(String id) async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.screensReceiptsReceiptsListConfirmDeleteDialogTitle),
          content: Text(
            l10n.screensReceiptsReceiptsListConfirmDeleteDialogContent,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(dialogContext).pop(true),
                NotificationService.showSuccess(
                  l10n.notificationsSuccessReceiptDeleted,
                ),
              },
              child: Text(
                l10n.commonDelete,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
      if (shouldDelete == true && context.mounted) {
        receiptsViewModel.deleteReceipt(id);
      }
    }

    void handleEditReceipt(String id) => context.push('/receipts/edit/$id');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => handleEditReceipt(receipt.id),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(receipt.thumbnailPath),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoreDisplay(
                      storeName: receipt.storeName,
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.formatCurrency(receipt.amount),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade700),
                    onPressed: () => handleEditReceipt(receipt.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    onPressed: () => handleDeleteReceipt(receipt.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
