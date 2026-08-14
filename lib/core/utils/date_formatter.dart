import 'package:intl/intl.dart';

class DateFormatter {
  static String toIsoDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String todayKey() {
    return toIsoDateKey(DateTime.now());
  }

  static String yesterdayKey() {
    return toIsoDateKey(DateTime.now().subtract(const Duration(days: 1)));
  }

  static DateTime parseKey(String key) {
    return DateFormat('yyyy-MM-dd').parse(key);
  }

  static String formatFriendly(String dateKey) {
    final date = parseKey(dateKey);
    final now = DateTime.now();
    final todayStr = todayKey();
    final yesterdayStr = yesterdayKey();

    if (dateKey == todayStr) {
      return 'Today, ${DateFormat('MMM d').format(date)}';
    } else if (dateKey == yesterdayStr) {
      return 'Yesterday, ${DateFormat('MMM d').format(date)}';
    } else if (date.year == now.year) {
      return DateFormat('EEEE, MMM d').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
}
