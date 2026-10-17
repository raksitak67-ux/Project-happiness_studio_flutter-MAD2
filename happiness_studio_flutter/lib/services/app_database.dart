import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = p.join(await getDatabasesPath(), 'happiness_studio.db');
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerEmail TEXT NOT NULL,
            designName TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL,
            totalPrice REAL NOT NULL,
            deposit REAL NOT NULL,
            status TEXT NOT NULL,
            referencePath TEXT,
            slipPath TEXT,
            refundStatus TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }
}
