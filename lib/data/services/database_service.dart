import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;
  static const int _dbVersion = 3;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'paragonik.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _executeSqlScript(db, 'assets/migrations/v1_initial_script.sql');
    await _executeSqlScript(db, 'assets/migrations/v2_seed_stores.sql');
    await _executeSqlScript(db, 'assets/migrations/v3_updated_stores.sql');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _executeSqlScript(db, 'assets/migrations/v2_seed_stores.sql');
    }

    if (oldVersion < 3) {
      await _executeSqlScript(db, 'assets/migrations/v3_updated_stores.sql');
    }
  }

  Future<void> _executeSqlScript(Database db, String assetPath) async {
    final script = await rootBundle.loadString(assetPath);

    for (final statement in script.split(';')) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'paragonik.db');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}
