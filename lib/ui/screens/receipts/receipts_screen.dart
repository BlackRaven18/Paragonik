import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paragonik/data/models/receipt.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/screens/receipts/receipt_list_item.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  List<Receipt> _filteredReceipts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterReceipts);

    _filteredReceipts = context.read<ReceiptNotifier>().receipts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterReceipts() {
    final receiptNotifier = context.read<ReceiptNotifier>();
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredReceipts = receiptNotifier.receipts.where((receipt) {
        return query.isEmpty ||
            receipt.storeName.toLowerCase().contains(query) ||
            receipt.amount.toString().contains(query);
      }).toList();
    });
  }

  Future<void> _handleDeleteReceipt(String id) async {
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
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Usuń', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Jeśli użytkownik potwierdził, wywołaj logikę usuwania
    if (shouldDelete == true) {
      if (!mounted) return;

      context.read<ReceiptNotifier>().deleteReceipt(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptNotifier>(
      builder: (context, notifier, child) {
        if (_searchController.text.isEmpty) {
          _filteredReceipts = notifier.receipts;
        }

        if (notifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notifier.receipts.isEmpty) {
          return const Center(child: Text('Brak zapisanych paragonów.'));
        }

        return Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _filteredReceipts.isEmpty
                  ? const Center(
                      child: Text('Nie znaleziono pasujących paragonów.'),
                    )
                  : RefreshIndicator(
                    onRefresh: () => context.read<ReceiptNotifier>().fetchReceipts(),
                    child: ListView.builder(
                        itemCount: _filteredReceipts.length,
                        itemBuilder: (context, index) {
                          return ReceiptListItem(
                            receipt: _filteredReceipts[index],
                            onDelete: _handleDeleteReceipt,
                            onEdit: (id) => context.push('/receipts/edit/$id'),
                          );
                        },
                      ),
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Szukaj...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterReceipts();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
