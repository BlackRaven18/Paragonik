import 'package:paragonik/data/models/enums/store_enum.dart';

class Store {
  final String id;
  final String name;
  final List<String> keywords;
  final String? iconPath;

  Store({
    required this.id,
    required this.name,
    required this.keywords,
    this.iconPath,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      keywords: (map['keywords'] as String).split(','),
      iconPath: map['icon_path'],
    );
  }

  StoreEnum get storeEnum {
    switch (name) {
      case 'biedronka':
        return StoreEnum.biedronka;
      case 'Żabka':
        return StoreEnum.zabka;
      case 'Lidl':
        return StoreEnum.lidl;
      case 'Społem':
        return StoreEnum.spolem;
      case 'Rossman':
        return StoreEnum.rossman;
      default:
        return StoreEnum.unknown;
    }
  }
}