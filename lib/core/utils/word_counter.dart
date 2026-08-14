class WordCounter {
  /// Counts words by trimming whitespace and splitting by 1 or more whitespace characters.
  static int countWords(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  /// Calculates remaining words needed to reach target (default: 100).
  static int remainingWords(String text, {int target = 100}) {
    final count = countWords(text);
    final remaining = target - count;
    return remaining > 0 ? remaining : 0;
  }

  /// Returns progress ratio from 0.0 to 1.0 towards target (default: 100).
  static double progressRatio(String text, {int target = 100}) {
    if (target <= 0) return 1.0;
    final count = countWords(text);
    final ratio = count / target;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  /// Returns whether the word count meets or exceeds the target (default: 100).
  static bool meetsRequirement(String text, {int target = 100}) {
    return countWords(text) >= target;
  }
}
