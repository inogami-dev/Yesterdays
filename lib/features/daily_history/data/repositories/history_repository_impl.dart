import 'package:history_in_the_making/core/utils/date_formatter.dart';
import 'package:history_in_the_making/features/daily_history/data/datasources/history_local_datasource.dart';
import 'package:history_in_the_making/features/daily_history/domain/models/history_entry.dart';
import 'package:history_in_the_making/features/daily_history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDatasource localDatasource;

  HistoryRepositoryImpl({required this.localDatasource});

  @override
  Future<HistoryEntry?> getEntryByDate(String dateKey) {
    return localDatasource.getEntryByDate(dateKey);
  }

  @override
  Future<List<HistoryEntry>> getAllEntries() {
    return localDatasource.getAllEntries();
  }

  @override
  Future<void> saveEntry(HistoryEntry entry) {
    return localDatasource.saveEntry(entry);
  }

  @override
  Future<void> deleteEntry(String dateKey) {
    return localDatasource.deleteEntry(dateKey);
  }

  @override
  Future<HistoryEntry> getYesterdayEntry() async {
    final yesterdayKey = DateFormatter.yesterdayKey();
    final entry = await getEntryByDate(yesterdayKey);
    return entry ?? HistoryEntry.empty(yesterdayKey);
  }

  @override
  Future<HistoryEntry> getTodayEntry() async {
    final todayKey = DateFormatter.todayKey();
    final entry = await getEntryByDate(todayKey);
    return entry ?? HistoryEntry.empty(todayKey);
  }

  @override
  Future<int> getStreakCount() async {
    final entries = await getAllEntries();
    if (entries.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // Check if entry logged today or yesterday to start streak
    final todayStr = DateFormatter.toIsoDateKey(checkDate);
    final yesterdayStr = DateFormatter.yesterdayKey();

    final entryDates = entries.map((e) => e.date).toSet();

    if (!entryDates.contains(todayStr) && !entryDates.contains(yesterdayStr)) {
      return 0;
    }

    if (entryDates.contains(todayStr)) {
      checkDate = DateTime.now();
    } else {
      checkDate = DateTime.now().subtract(const Duration(days: 1));
    }

    while (true) {
      final key = DateFormatter.toIsoDateKey(checkDate);
      if (entryDates.contains(key)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
