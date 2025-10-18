// lib/ui/screens/widgets/receipt_list_item.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/receipt.dart';

class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;

  const ReceiptListItem({required this.receipt, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(receipt.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Miniaturka zdjęcia
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(receipt.imagePath),
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
                  Text(
                    receipt.storeName.isEmpty ? 'Nieznany sklep' : receipt.storeName,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
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
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // Przyciski akcji
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue.shade700),
                  onPressed: () {
                    // TODO: Dodać logikę edycji/przejścia do szczegółów
                    print('Edit receipt: ${receipt.id}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade700),
                  onPressed: () {
                    // TODO: Dodać logikę usuwania (najlepiej z potwierdzeniem)
                    print('Delete receipt: ${receipt.id}');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}