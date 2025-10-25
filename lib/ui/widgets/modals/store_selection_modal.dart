import 'package:flutter/material.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/services/store_service.dart';
import 'package:paragonik/ui/core/assets/asset_manager.dart';
import 'package:provider/provider.dart';

class StoreSelectionModal extends StatefulWidget {
  const StoreSelectionModal({super.key});

  @override
  State<StoreSelectionModal> createState() => _StoreSelectionModalState();
}

class _StoreSelectionModalState extends State<StoreSelectionModal> {
  late Future<List<Store>> _storesFuture;
  List<Store> _filteredStores = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storesFuture = context.read<StoreService>().getAllStores();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: 'Filtruj sklepy...'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Store>>(
              future: _storesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final allStores = snapshot.data!;
                final query = _searchController.text.toLowerCase();
                _filteredStores = allStores.where((s) => s.name.toLowerCase().contains(query)).toList();

                return ListView.builder(
                  itemCount: _filteredStores.length,
                  itemBuilder: (context, index) {
                    final store = _filteredStores[index];
                    return ListTile(
                      leading: Image.asset(store.iconPath ?? AssetManager.storeDefault),
                      title: Text(store.name),
                      onTap: () {
                        Navigator.of(context).pop(store);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}