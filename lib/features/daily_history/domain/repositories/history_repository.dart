import 'package:history_in_the_making/features/daily_history/domain/models/history_entry.dart';

abstract class HistoryRepository {
  Future<HistoryEntry?> getEntryByDate(String dateKey);
  Future<List<HistoryEntry>> getAllEntries();
  Future<void> saveEntry(HistoryEntry entry);
  Future<void> deleteEntry(String dateKey);
  Future<HistoryEntry> getYesterdayEntry();
  Future<HistoryEntry> getTodayEntry();
  Future<int> getStreakCount();
}
