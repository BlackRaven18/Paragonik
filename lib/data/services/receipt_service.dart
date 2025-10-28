import 'package:paragonik/data/models/database/receipt.dart';
import 'package:paragonik/data/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptService {
  final Future<Database> _database = DatabaseService.instance.database;

  Future<void> addReceipt(Receipt receipt) async {
    final db = await _database;

    await db.insert(
      'receipts',
      receipt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> softDeleteReceipt(String id) async {
    final db = await _database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'receipts',
      {'deleted_at': now, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateReceipt(Receipt receipt) async {
    final db = await _database;
    await db.update(
      'receipts',
      receipt.toMap(),
      where: 'id = ?',
      whereArgs: [receipt.id],
    );
  }

  Future<List<Receipt>> getReceiptsPaginated({
    required int limit,
    required int offset,
  }) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'receipts',
      where: 'deleted_at IS NULL',
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return Receipt.fromMap(maps[i]);
    });
  }

  Future<Receipt?> getReceiptById(String id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Receipt.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getReceiptsCount() async {
    final db = await _database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM receipts WHERE deleted_at IS NULL',
      ),
    );
    return count ?? 0;
  }

  Future<List<Receipt>> getReceiptsInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'receipts',
      where: 'deleted_at IS NULL AND date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Receipt.fromMap(maps[i]);
    });
  }
}
