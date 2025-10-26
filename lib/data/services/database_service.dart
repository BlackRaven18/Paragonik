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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedStores(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _seedStores(db);
    }
    if(oldVersion < 3){
      await db.execute('ALTER TABLE receipts ADD COLUMN thumbnail_path TEXT');
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS receipts (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        thumbnail_path TEXT,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        store_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS stores (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        keywords TEXT NOT NULL,
        icon_path TEXT
      )
    ''');
  }

  Future<void> _seedStores(Database db) async {
    await db.insert('stores', {
      'id': 'unknown',
      'name': 'Nieznany sklep',
      'keywords': '',
      'icon_path': 'assets/icons/unknown.png'
    });
    await db.insert('stores', {
      'id': 'biedronka',
      'name': 'Biedronka',
      'keywords': 'biedronka,jeronimo',
      'icon_path': 'assets/icons/biedronka.png'
    });
    await db.insert('stores', {
      'id': 'zabka',
      'name': 'Żabka',
      'keywords': 'żabka,zabka,abka',
      'icon_path': 'assets/icons/zabka.png'
    });
    await db.insert('stores', {
      'id': 'lidl',
      'name': 'Lidl',
      'keywords': 'lidl',
      'icon_path': 'assets/icons/lidl.png'
    });
    await db.insert('stores', {
      'id': 'spolem',
      'name': 'Społem',
      'keywords': 'społem,spolem,spo em',
      'icon_path': 'assets/icons/spolem.png'
    });
    await db.insert('stores', {
      'id': 'rossman',
      'name': 'Rossman',
      'keywords': 'rossman',
      'icon_path': 'assets/icons/rossman.png'
    });
  }
}