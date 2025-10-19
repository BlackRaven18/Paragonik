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
      iconPath: map['iconPath'],
    );
  }
}