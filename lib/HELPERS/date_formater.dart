import 'package:intl/intl.dart';

class DateFormatHelper {
 static String getExpectedDeliveryRange() {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 7));

    String formattedEnd = DateFormat('MMM d, EEEE').format(endDate);

    return "Expected Delivery: $formattedEnd";
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }
  static String formatDateWithTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm:ss');
    return formatter.format(date);
  }

  static String formatDateToISO(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  static String formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }

  static String formatFullDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, d MMM yyyy HH:mm:ss');
    return formatter.format(date);
  }

  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    return formatDate(now);
  }

  static String getCurrentTime() {
    final DateTime now = DateTime.now();
    return formatTime(now);
  }
}
