import 'package:flutter/foundation.dart';
import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/services/store_service.dart';

class StoreNotifier extends ChangeNotifier {
  final StoreService _storeService;
  List<Store> _stores = [];
  List<Store> get stores => _stores;
  bool isLoading = true;

  StoreNotifier(this._storeService) {
    fetchStores();
  }

  Future<void> fetchStores() async {
    _stores = await _storeService.getAllStores();
    _setLoading();
  }

  Store getStoreByName(String name) {
    final matchingStores = _stores.where((store) => store.name == name);

    if (matchingStores.isNotEmpty) {
      return matchingStores.first;
    } else {
      return _stores.firstWhere(
        (store) => store.id == 'unknown',
        orElse: () =>
            Store(id: 'unknown', name: 'Nieznany sklep', keywords: []),
      );
    }
  }

  void _setLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
