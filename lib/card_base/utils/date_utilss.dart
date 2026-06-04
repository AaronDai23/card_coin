import 'package:intl/intl.dart';

class DateUtil22 {
  static String formatTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  static String formatNewTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('M-d');
    String formattedDate = formatter.format(date);
    print("formattedDate: $formattedDate");
    return formattedDate;
  }
}
