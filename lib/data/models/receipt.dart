// lib/models/receipt.dart

class Receipt {
  final String id;
  final String imagePath;
  final double amount;
  final DateTime date;
  final String storeName;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Receipt({
    required this.id,
    required this.imagePath,
    required this.amount,
    required this.date,
    required this.storeName,
    required this.updatedAt,
    this.deletedAt,
  });

  // Zaktualizuj toMap()
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'amount': amount,
      'date': date.toIso8601String(),
      'storeName': storeName,
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // Zaktualizuj fromMap()
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'],
      imagePath: map['imagePath'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      storeName: map['storeName'],
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }
}