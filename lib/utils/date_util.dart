import 'package:intl/intl.dart';

class DateTimeUitls {
  static String timestampToDate(int timestamp) {
    // 将时间戳转换为DateTime对象
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 使用intl包的DateFormat进行格式化
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    // print("formattedDate-timestampToDate: $formattedDate");
    return formattedDate;
  }

  static String getTomorrowDateFromTimestamp(int timestamp) {
    // 将时间戳（毫秒）转换为 DateTime 对象
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 获取第二天的日期
    DateTime tomorrow = dateTime.add(const Duration(days: 1));
    // 格式化为 yyyy-MM-dd 格式
    return DateFormat('yyyy-MM-dd').format(tomorrow);
  }
}
