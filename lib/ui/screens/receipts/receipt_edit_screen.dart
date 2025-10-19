// lib/ui/screens/receipts/receipt_edit_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/core/widgets/full_screen_image_viewer.dart'; // Import
import 'package:provider/provider.dart';

class ReceiptEditScreen extends StatefulWidget {
  final String receiptId;
  const ReceiptEditScreen({required this.receiptId, super.key});

  @override
  State<ReceiptEditScreen> createState() => _ReceiptEditScreenState();
}

class _ReceiptEditScreenState extends State<ReceiptEditScreen> {
  Receipt? _receipt;
  bool _isLoading = true;

  late TextEditingController _amountController;
  late TextEditingController _storeController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _loadReceiptData();
  }

  Future<void> _loadReceiptData() async {
    final receipt = await context.read<ReceiptService>().getReceiptById(
      widget.receiptId,
    );
    if (receipt != null) {
      setState(() {
        _receipt = receipt;
        _amountController = TextEditingController(
          text: _receipt!.amount.toStringAsFixed(2),
        );
        _storeController = TextEditingController(text: _receipt!.storeName);
        _selectedDateTime = _receipt!.date;
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      // Handle case where receipt is not found
      Navigator.of(context).pop();
    }
  }

  // ZMIANA: Nowa, pełna funkcja wyboru daty i godziny
  Future<void> _selectDateTime() async {
    final initialDate = _selectedDateTime ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pl', 'PL'),
    );

    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _saveChanges() {
    if (_receipt == null || _selectedDateTime == null) return;

    final updatedReceipt = Receipt(
      id: _receipt!.id,
      imagePath: _receipt!.imagePath,
      amount:
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0,
      storeName: _storeController.text,
      date: _selectedDateTime!,
      updatedAt: DateTime.now(),
      deletedAt: _receipt!.deletedAt,
    );

    context.read<ReceiptNotifier>().updateReceipt(updatedReceipt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edytuj paragon')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj paragon'),
        // USUNIĘTE: Przycisk zapisu z AppBar
      ),
      // NOWOŚĆ: Przycisk zapisu w bardziej widocznym miejscu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveChanges,
        label: const Text('Zapisz zmiany'),
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          80.0,
        ), // Dodatkowy padding na dole
        child: Column(
          children: [
            // NOWOŚĆ: Podgląd zdjęcia z opcją zoomu
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImageViewer(
                    imageFile: File(_receipt!.imagePath),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_receipt!.imagePath),
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Kwota',
                border: OutlineInputBorder(),
                suffixText: 'PLN',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _storeController,
              decoration: const InputDecoration(
                labelText: 'Sklep',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // ZMIANA: Ulepszony widget wyboru daty i godziny
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              title: const Text('Data i godzina'),
              subtitle: Text(
                DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!),
              ),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _selectDateTime,
            ),
          ],
        ),
      ),
    );
  }
}
