import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedStores(db);

    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        imagePath TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        storeName TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE stores (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          keywords TEXT NOT NULL,
          iconPath TEXT
        )
      ''');
      await _seedStores(db);
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        imagePath TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        storeName TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE stores (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        keywords TEXT NOT NULL,
        iconPath TEXT
      )
    ''');
  }

  Future<void> _seedStores(Database db) async {
    await db.insert('stores', {
      'id': 'biedronka',
      'name': 'Biedronka',
      'keywords': 'biedronka,jeronimo',
      'iconPath': 'assets/icons/biedronka.png'
    });
    await db.insert('stores', {
      'id': 'zabka',
      'name': 'Żabka',
      'keywords': 'żabka,zabka,abka',
      'iconPath': 'assets/icons/zabka.png'
    });
    await db.insert('stores', {
      'id': 'lidl',
      'name': 'Lidl',
      'keywords': 'lidl',
      'iconPath': 'assets/icons/lidl.png'
    });
    await db.insert('stores', {
      'id': 'spolem',
      'name': 'Społem',
      'keywords': 'społem,spolem,spo em',
      'iconPath': 'assets/icons/spolem.png'
    });
  }
}