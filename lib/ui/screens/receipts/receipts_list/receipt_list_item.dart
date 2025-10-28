import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
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
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(receipt.date);

    Future<void> handleDeleteReceipt(String id) async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Potwierdź usunięcie'),
          content: const Text('Czy na pewno chcesz usunąć ten paragon?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(true),
                NotificationService.showSuccess('Paragon usunięty!'),
              },
              child: const Text('Usuń', style: TextStyle(color: Colors.red)),
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
                    '${receipt.amount.toStringAsFixed(2)} PLN',
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
    );
  }
}
