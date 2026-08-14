import 'package:sqflite/sqflite.dart';
import 'package:history_in_the_making/core/database/database_helper.dart';
import 'package:history_in_the_making/features/daily_history/domain/models/history_entry.dart';

class HistoryLocalDatasource {
  Future<HistoryEntry?> getEntryByDate(String dateKey) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableEntries,
      where: 'id = ?',
      whereArgs: [dateKey],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return HistoryEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<List<HistoryEntry>> getAllEntries() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableEntries,
      orderBy: 'date DESC',
    );

    return maps.map((map) => HistoryEntry.fromMap(map)).toList();
  }

  Future<void> saveEntry(HistoryEntry entry) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      DatabaseHelper.tableEntries,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEntry(String dateKey) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      DatabaseHelper.tableEntries,
      where: 'id = ?',
      whereArgs: [dateKey],
    );
  }
}
