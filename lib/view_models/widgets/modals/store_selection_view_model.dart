import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/notifiers/store_notifier.dart';

class StoreSelectionViewModel extends ChangeNotifier {
  final StoreNotifier _storeNotifier;
  String _searchQuery = '';

  StoreSelectionViewModel(this._storeNotifier);

  List<Store> get filteredStores {
    final allStores = _storeNotifier.stores;
    final query = _searchQuery.toLowerCase();

    final filtered = allStores.where((store) {
      final normalizedStoreName = removeDiacritics(store.name.toLowerCase());

      return normalizedStoreName.contains(query);
    }).toList();

    final unknownStore = filtered.firstWhere(
      (s) => s.id == 'unknown',
      orElse: () => _storeNotifier.getStoreByName(''),
    );
    final otherStores = filtered.where((s) => s.id != 'unknown').toList();
    otherStores.sort((a, b) => a.name.compareTo(b.name));

    return [unknownStore, ...otherStores];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
