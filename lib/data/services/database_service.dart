// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Wzór Singleton - zapewnia, że mamy tylko jedną instancję bazy w całej aplikacji
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicjalizacja i tworzenie tabeli
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'paragonik.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Ta funkcja jest wywoływana tylko raz, przy pierwszym utworzeniu bazy
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        imagePath TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        storeName TEXT,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
  }
}