import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  /// This return date in month day, year format
  String formateDate() {
    try {
      String date = DateFormat("MMMM d, yyyy").format(this);

      return date;
    } catch (_) {
      return DateFormat("MMMM d, yyyy").format(DateTime.now());
    }
  }
}
