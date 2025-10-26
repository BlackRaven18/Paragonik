class Receipt {
  final String id;
  final String imagePath;
  final String thumbnailPath;
  final double amount;
  final DateTime date;
  final String storeName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Receipt({
    required this.id,
    required this.imagePath,
    required this.thumbnailPath,
    required this.amount,
    required this.date,
    required this.storeName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  // Zaktualizuj toMap()
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'thumbnail_path': thumbnailPath,
      'amount': amount,
      'date': date.toIso8601String(),
      'store_name': storeName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // Zaktualizuj fromMap()
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'],
      imagePath: map['image_path'],
      thumbnailPath: map['thumbnail_path'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      storeName: map['store_name'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'])
          : null,
    );
  }

  Receipt copyWith({
    String? id,
    String? imagePath,
    String? thumbnailPath,
    double? amount,
    DateTime? date,
    String? storeName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Receipt(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      storeName: storeName ?? this.storeName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
