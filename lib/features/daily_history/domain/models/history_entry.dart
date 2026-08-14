import 'package:history_in_the_making/core/utils/date_formatter.dart';
import 'package:history_in_the_making/core/utils/word_counter.dart';

class HistoryEntry {
  final String id; // YYYY-MM-DD
  final String date; // YYYY-MM-DD
  final String content;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HistoryEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.wordCount,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isToday => date == DateFormatter.todayKey();
  bool get isYesterday => date == DateFormatter.yesterdayKey();
  bool get meetsRequirement => wordCount >= 100;
  int get remainingWords => WordCounter.remainingWords(content, target: 100);
  double get progressRatio => WordCounter.progressRatio(content, target: 100);

  HistoryEntry copyWith({
    String? id,
    String? date,
    String? content,
    int? wordCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'content': content,
      'word_count': wordCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'] as String,
      date: map['date'] as String,
      content: map['content'] as String,
      wordCount: map['word_count'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  factory HistoryEntry.empty(String dateKey) {
    final now = DateTime.now();
    return HistoryEntry(
      id: dateKey,
      date: dateKey,
      content: '',
      wordCount: 0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
