import 'package:flutter/material.dart';
import 'package:paragonik/extensions/formatters.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

class ExportReceiptsDialog extends StatefulWidget {
  const ExportReceiptsDialog({super.key});

  @override
  State<ExportReceiptsDialog> createState() => _ExportReceiptsDialogState();
}

class _ExportReceiptsDialogState extends State<ExportReceiptsDialog> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  Future<void> _pickDateRange() async {
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (newDateRange != null) {
      setState(() {
        _startDate = newDateRange.start;
        _endDate = newDateRange.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.screensReceiptsReceiptsScreenWidgetsModalsExportReceiptsDialogDateRangeLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDateRange,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(Formatters.formatDate(_startDate)),
                  const Icon(Icons.arrow_forward),
                  Text(Formatters.formatDate(_endDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(DateTimeRange(start: _startDate, end: _endDate));
                },
                icon: const Icon(Icons.download),
                label: Text(l10n.commonExport),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
