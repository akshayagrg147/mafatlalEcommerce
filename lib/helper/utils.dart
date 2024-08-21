import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("EEE, dd MMM''yy, hh:mm a")
        .format(dateTime)
        .toLowerCase();
  }
}
