import 'package:paragonik/data/models/database/store.dart';
import 'package:paragonik/data/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class StoreService {
  final Future<Database> _database = DatabaseService.instance.database;

  Future<List<Store>> getAllStores() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('stores', orderBy: 'name ASC');
    return List.generate(maps.length, (i) => Store.fromMap(maps[i]));
  }
}