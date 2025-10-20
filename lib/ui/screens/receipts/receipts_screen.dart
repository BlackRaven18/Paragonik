import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/notifiers/receipt_notifier.dart';
import 'package:paragonik/ui/screens/receipts/receipt_list_item.dart';
import 'package:paragonik/ui/screens/receipts/section_header.dart';
import 'package:provider/provider.dart';

enum GroupingOption { byReceiptDate, byAddedDate }

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final TextEditingController _searchController = TextEditingController();
  GroupingOption _groupingOption = GroupingOption.byReceiptDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<Receipt>> _groupReceipts(List<Receipt> receipts, GroupingOption groupingOption) {
    final Map<String, List<Receipt>> grouped = {};
    final now = DateTime.now();

    for (final receipt in receipts) {
      final dateToCompare = groupingOption == GroupingOption.byAddedDate ? receipt.createdAt : receipt.date;
      final difference = now.difference(dateToCompare).inDays;
      String groupKey;

      if (difference == 0) {
        groupKey = 'Dzisiaj';
      } else if (difference == 1) {
        groupKey = 'Wczoraj';
      } else if (difference < 7) {
        groupKey = 'W tym tygodniu';
      } else {
        groupKey = 'Wcześniej';
      }

      if (grouped[groupKey] == null) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(receipt);
    }
    return grouped;
  }

  Widget _buildReceiptCounter(int count) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.receipt_long_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Całkowita liczba paragonów'),
        trailing: Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
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

    if (shouldDelete == true) {
      if (!mounted) return;

      context.read<ReceiptNotifier>().deleteReceipt(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptNotifier>(
      builder: (context, notifier, child) {

        if (notifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notifier.receipts.isEmpty) {
          return const Center(child: Text('Brak zapisanych paragonów.'));
        }

        final query = _searchController.text.toLowerCase();
        final filtered = notifier.receipts.where((r) {
          return query.isEmpty ||
              r.storeName.toLowerCase().contains(query) ||
              r.amount.toString().contains(query);
        }).toList();

        final groupedReceipts = _groupReceipts(filtered, _groupingOption);

        return Column(
          children: [
            _buildSearchBar(),
            _buildGroupingToggle(),
            _buildReceiptCounter(notifier.totalReceipts),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<ReceiptNotifier>().fetchReceipts(),
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Nie znaleziono pasujących paragonów.'),
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          for (final entry in groupedReceipts.entries) ...[
                            SectionHeader(title: entry.key),
                            ...entry.value.map(
                              (receipt) => ReceiptListItem(
                                receipt: receipt,
                                onDelete: _handleDeleteReceipt,
                                onEdit: (id) =>
                                    context.push('/receipts/edit/$id'),
                              ),
                            ),
                          ],
                        ],
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
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildGroupingToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SegmentedButton<GroupingOption>(
        segments: const [
          ButtonSegment(value: GroupingOption.byReceiptDate, label: Text('Data paragonu')),
          ButtonSegment(value: GroupingOption.byAddedDate, label: Text('Data dodania')),
        ],
        selected: {_groupingOption},
        onSelectionChanged: (Set<GroupingOption> newSelection) {
          setState(() {
            _groupingOption = newSelection.first;
          });
        },
      ),
    );
  }
}
