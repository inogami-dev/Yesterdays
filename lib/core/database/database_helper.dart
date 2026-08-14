import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String dbName = 'history_in_the_making.db';
  static const int dbVersion = 1;
  static const String tableEntries = 'history_entries';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableEntries (
            id TEXT PRIMARY KEY,
            date TEXT NOT NULL,
            content TEXT NOT NULL,
            word_count INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
