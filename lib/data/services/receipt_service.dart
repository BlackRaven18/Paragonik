
import 'dart:io';
import 'package:paragonik/data/models/receipt.dart';
import 'package:paragonik/data/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReceiptService {
  final Future<Database> _database = DatabaseService.instance.database;
  final _uuid = const Uuid();

  Future<void> addReceipt({
    required File imageFile,
    required double amount,
    required DateTime date,
    String storeName = '',
  }) async {
    final db = await _database;
    
    final newReceipt = Receipt(
      id: _uuid.v4(),
      imagePath: imageFile.path,
      amount: amount,
      date: date,
      storeName: storeName,
      updatedAt: DateTime.now(),
      deletedAt: null,
    );

    await db.insert(
      'receipts',
      newReceipt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'receipts',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Receipt.fromMap(maps[i]);
    });
  }
}