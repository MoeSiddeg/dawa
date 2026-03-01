import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _databaseName = 'dawaa.db';
  static const _databaseVersion = 1;

  static const favoritesTable = 'favorite_medicines';

  static final DatabaseService _instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY,
        name_ar TEXT,
        name_en TEXT,
        price TEXT,
        image TEXT
      )
      ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
