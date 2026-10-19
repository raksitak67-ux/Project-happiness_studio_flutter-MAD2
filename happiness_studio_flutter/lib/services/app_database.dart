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
      version: 2,

      // สร้างฐานข้อมูลใหม่
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
            createdAt TEXT NOT NULL,
            nailShape TEXT NOT NULL DEFAULT 'ไม่ระบุ',
            usePvc INTEGER NOT NULL DEFAULT 0,
            accessoryLevel TEXT NOT NULL DEFAULT 'none',
            details TEXT NOT NULL DEFAULT ''
          )
        ''');
      },

      // อัปเกรดฐานข้อมูลเวอร์ชันเดิม
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE bookings
            ADD COLUMN nailShape TEXT NOT NULL DEFAULT 'ไม่ระบุ'
          ''');

          await db.execute('''
            ALTER TABLE bookings
            ADD COLUMN usePvc INTEGER NOT NULL DEFAULT 0
          ''');

          await db.execute('''
            ALTER TABLE bookings
            ADD COLUMN accessoryLevel TEXT NOT NULL DEFAULT 'none'
          ''');

          await db.execute('''
            ALTER TABLE bookings
            ADD COLUMN details TEXT NOT NULL DEFAULT ''
          ''');
        }
      },
    );

    return _database!;
  }
}
