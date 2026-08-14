import 'package:flutter_test/flutter_test.dart';
import 'package:yesterdays/core/utils/date_formatter.dart';
import 'package:yesterdays/core/utils/word_counter.dart';

void main() {
  group('WordCounter Unit Tests', () {
    test('countWords accurately counts words in simple string', () {
      const text = 'Today was a productive day. I learned Flutter clean architecture.';
      expect(WordCounter.countWords(text), 10);
    });

    test('countWords handles empty and whitespace strings', () {
      expect(WordCounter.countWords(''), 0);
      expect(WordCounter.countWords('   \n\t  '), 0);
    });

    test('remainingWords calculates exact words remaining until 100', () {
      final text50 = List.generate(50, (i) => 'word').join(' ');
      expect(WordCounter.remainingWords(text50, target: 100), 50);

      final text105 = List.generate(105, (i) => 'word').join(' ');
      expect(WordCounter.remainingWords(text105, target: 100), 0);
    });

    test('meetsRequirement returns true if and only if word count >= 100', () {
      final text99 = List.generate(99, (i) => 'word').join(' ');
      expect(WordCounter.meetsRequirement(text99, target: 100), isFalse);

      final text100 = List.generate(100, (i) => 'word').join(' ');
      expect(WordCounter.meetsRequirement(text100, target: 100), isTrue);
    });

    test('progressRatio returns correct float fraction from 0.0 to 1.0', () {
      final text50 = List.generate(50, (i) => 'word').join(' ');
      expect(WordCounter.progressRatio(text50, target: 100), 0.5);

      final text200 = List.generate(200, (i) => 'word').join(' ');
      expect(WordCounter.progressRatio(text200, target: 100), 1.0);
    });
  });

  group('DateFormatter Unit Tests', () {
    test('IsoDateKey returns yyyy-MM-dd format', () {
      final dt = DateTime(2026, 8, 14);
      expect(DateFormatter.toIsoDateKey(dt), '2026-08-14');
    });

    test('yesterdayKey returns previous day in ISO format', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      expect(DateFormatter.yesterdayKey(), DateFormatter.toIsoDateKey(yesterday));
    });
  });
}
