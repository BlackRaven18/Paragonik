import 'package:flutter/material.dart';

Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Locale? locale,
}) async {
  firstDate ??= DateTime(2000);
  lastDate ??= DateTime.now().add(const Duration(days: 365));

  if (initialDate != null &&
      (initialDate.isAfter(lastDate) || initialDate.isBefore(firstDate))) {
    initialDate = DateTime.now();
  }

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    locale: locale ?? const Locale('pl', 'PL'),
  );

  if (pickedDate == null || !context.mounted) return null;

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (pickedTime == null) return null;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
