import 'package:csv/csv.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/extensions/formatters.dart';

class CsvExportService {
  final l10n = L10nService.l10n;
  
  String receiptsToCsv(List<Receipt> receipts) {
    final List<String> headers = [
      l10n.servicesCsvExportHeaderPurchaseDate,
      l10n.servicesCsvExportHeaderStore,
      l10n.servicesCsvExportHeaderAmount,
      l10n.servicesCsvExportHeaderDateAdded,
    ];

    final List<List<dynamic>> rows = receipts.map((receipt) {
      return [
        Formatters.formatDateTime(receipt.date),
        receipt.storeName,
        receipt.amount,
        Formatters.formatDateTime(receipt.createdAt),
      ];
    }).toList();

    rows.insert(0, headers);

    return const ListToCsvConverter().convert(rows);
  }
}