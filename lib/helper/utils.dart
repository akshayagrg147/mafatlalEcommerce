import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("EEEE, dd MMM yy, hh:mm a").format(dateTime);
  }

  static DateTime getTodayDate() {
    DateTime startOfToday = DateTime.now();
    DateTime todayStart =
        DateTime(startOfToday.year, startOfToday.month, startOfToday.day);
    return todayStart;
  }

  static String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d h:mm a').format(dateTime);
    }
  }
}
