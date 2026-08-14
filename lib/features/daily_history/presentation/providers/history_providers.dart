import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_in_the_making/core/notifications/alarm_service.dart';
import 'package:history_in_the_making/core/utils/date_formatter.dart';
import 'package:history_in_the_making/core/utils/word_counter.dart';
import 'package:history_in_the_making/features/daily_history/data/datasources/history_local_datasource.dart';
import 'package:history_in_the_making/features/daily_history/data/repositories/history_repository_impl.dart';
import 'package:history_in_the_making/features/daily_history/domain/models/history_entry.dart';
import 'package:history_in_the_making/features/daily_history/domain/repositories/history_repository.dart';

final historyDatasourceProvider = Provider<HistoryLocalDatasource>((ref) {
  return HistoryLocalDatasource();
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final ds = ref.watch(historyDatasourceProvider);
  return HistoryRepositoryImpl(localDatasource: ds);
});

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

class HistoryState {
  final List<HistoryEntry> entries;
  final HistoryEntry yesterdayEntry;
  final HistoryEntry todayEntry;
  final int streakCount;
  final bool isLoading;

  const HistoryState({
    required this.entries,
    required this.yesterdayEntry,
    required this.todayEntry,
    required this.streakCount,
    this.isLoading = false,
  });

  bool get hasUserEverSavedLog => entries.isNotEmpty;
  bool get yesterdaySatisfied => yesterdayEntry.meetsRequirement;
  int get yesterdayRemainingWords => yesterdayEntry.remainingWords;

  HistoryState copyWith({
    List<HistoryEntry>? entries,
    HistoryEntry? yesterdayEntry,
    HistoryEntry? todayEntry,
    int? streakCount,
    bool? isLoading,
  }) {
    return HistoryState(
      entries: entries ?? this.entries,
      yesterdayEntry: yesterdayEntry ?? this.yesterdayEntry,
      todayEntry: todayEntry ?? this.todayEntry,
      streakCount: streakCount ?? this.streakCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repository;
  final AlarmService _alarmService;

  HistoryNotifier(this._repository, this._alarmService)
      : super(HistoryState(
          entries: [],
          yesterdayEntry: HistoryEntry.empty(DateFormatter.yesterdayKey()),
          todayEntry: HistoryEntry.empty(DateFormatter.todayKey()),
          streakCount: 0,
          isLoading: true,
        )) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final entries = await _repository.getAllEntries();
    final yesterday = await _repository.getYesterdayEntry();
    final today = await _repository.getTodayEntry();
    final streak = await _repository.getStreakCount();

    state = HistoryState(
      entries: entries,
      yesterdayEntry: yesterday,
      todayEntry: today,
      streakCount: streak,
      isLoading: false,
    );

    _syncAlarmStatus(entries, yesterday);
  }

  Future<void> saveEntry({
    required String dateKey,
    required String content,
  }) async {
    final wordCount = WordCounter.countWords(content);
    final existing = await _repository.getEntryByDate(dateKey);
    final now = DateTime.now();

    final entryToSave = HistoryEntry(
      id: dateKey,
      date: dateKey,
      content: content,
      wordCount: wordCount,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await _repository.saveEntry(entryToSave);
    await loadData();
  }

  Future<void> deleteEntry(String dateKey) async {
    await _repository.deleteEntry(dateKey);
    await loadData();
  }

  void _syncAlarmStatus(List<HistoryEntry> allEntries, HistoryEntry yesterdayEntry) {
    // The alarm rule ONLY exists AFTER the user has saved their first log!
    if (allEntries.isEmpty) {
      _alarmService.cancelYesterdayAlarm();
      return;
    }

    if (!yesterdayEntry.meetsRequirement) {
      _alarmService.scheduleYesterdayHourlyAlarm(
        yesterdayDateKey: yesterdayEntry.date,
        remainingWords: yesterdayEntry.remainingWords,
      );
    } else {
      _alarmService.cancelYesterdayAlarm();
    }
  }

  Future<void> triggerTestAlarm() async {
    await _alarmService.triggerTestAlarm(
      yesterdayDateKey: DateFormatter.yesterdayKey(),
      title: '⚠️ Yesterday History Unfinished',
      body: 'Yesterday\'s daily history is under 100 words! Tap here to write now.',
    );
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  final alarmService = ref.watch(alarmServiceProvider);
  return HistoryNotifier(repo, alarmService);
});
