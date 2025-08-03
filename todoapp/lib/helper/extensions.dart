import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  /// This return date in month day, year format
  String formateDate({String? prefix}) {
    try {
      String date = DateFormat("MMMM d, yyyy").format(this);
      if (prefix != null) return "$prefix $date";
      return date;
    } catch (_) {
      return DateFormat("MMMM d, yyyy").format(DateTime.now());
    }
  }
}
