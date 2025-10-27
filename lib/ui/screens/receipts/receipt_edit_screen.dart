import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/receipt_service.dart';
import 'package:paragonik/helpers/date_picker.dart';
import 'package:paragonik/helpers/store_selection_modal_helper.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/widgets/image_viewer.dart';
import 'package:paragonik/ui/widgets/store_display.dart';
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
  late String _selectedStoreName;
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
        _selectedStoreName = _receipt!.storeName;
        _selectedDateTime = _receipt!.date;
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleStoreChange(BuildContext context) async {
    final selectedStore = await showStoreSelectionModal(context);

    if (selectedStore != null) {
      setState(() {
        _selectedStoreName = selectedStore.name;
      });
    }
  }

  Future<void> _selectDateTime() async {
    final pickedDateTime = await pickDateTime(
      context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedDateTime.hour,
        pickedDateTime.minute,
      );
    });
  }

  void _saveChanges() {
    if (_receipt == null || _selectedDateTime == null) return;

    final updatedReceipt = _receipt!.copyWith(
      amount:
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0,
      storeName: _selectedStoreName,
      updatedAt: DateTime.now(),
    );

    context.read<ReceiptNotifier>().updateReceipt(updatedReceipt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: ImageViewer(imageFile: File(_receipt!.imagePath)),
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
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    title: const Text('Sklep'),
                    subtitle: StoreDisplay(
                      storeName: _selectedStoreName,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.store),
                    onTap: () => _handleStoreChange(context),
                  ),
                  const SizedBox(height: 16),
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

            Positioned(
              top: 16.0,
              left: 16.0,
              child: FloatingActionButton.small(
                onPressed: () => Navigator.of(context).pop(),
                heroTag: 'receipt_edit_back_btn',
                child: const Icon(Icons.arrow_back),
              ),
            ),

            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton.extended(
                onPressed: _saveChanges,
                label: const Text('Zapisz zmiany'),
                icon: const Icon(Icons.save),
                heroTag: 'receipt_edit_save_btn',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
