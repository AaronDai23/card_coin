import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';

// Enum CalculationType {
//   add,
//   reduce,
//   multiply
// }

extension on Decimal {
  String formatWith(NumberFormat formatter) =>
      DecimalFormatter(formatter).format(this);
}

class NumberUtils {
  static String formatNumber(num number, int decimalPlaces) {
    if (decimalPlaces < 0) {
      throw ArgumentError("Decimal places must be non-negative.");
    }

    // 使用toStringAsFixed方法来保留固定的小数位数
    String formattedNumber = number.toStringAsFixed(decimalPlaces);

    // 如果有小数点，则移除末尾的零
    if (formattedNumber.contains('.')) {
      // 移除末尾的零
      formattedNumber = formattedNumber.replaceAll(RegExp(r'0+$'), '');

      // 如果小数点后面没有其他数字了，就去掉小数点
      if (formattedNumber.endsWith('.')) {
        formattedNumber =
            formattedNumber.substring(0, formattedNumber.length - 1);
      }
    }

    return formattedNumber;
  }

  static String getFullCountBetweenTwoNumber(
      String leftValue, String rightValue, int type) {
    if (type == 0) {
      return AddCalculationType.getFullCount(leftValue, rightValue);
    } else if (type == 1) {
      return ReduceCalculationType.getFullCount(leftValue, rightValue);
    } else if (type == 2) {
      return MultiplyCalculationType.getFullCount(leftValue, rightValue);
    } else {
      return '';
    }
  }

  static String getCountBetweenTwoNumber(
      String leftValue, String rightValue, int type) {
    if (type == 0) {
      return AddCalculationType.getCount(leftValue, rightValue);
    } else if (type == 1) {
      return ReduceCalculationType.getCount(leftValue, rightValue);
    } else if (type == 2) {
      return MultiplyCalculationType.getCount(leftValue, rightValue);
    } else {
      return '';
    }
  }

  static String getCountBetweenThreeNumber(
      String first, String second, String three, int type) {
    var value = Decimal.parse(first) * Decimal.parse(second);
    if (type == 0) {
      return AddCalculationType.getCount((value).toString(), three);
    } else if (type == 1) {
      return ReduceCalculationType.getCount((value).toString(), three);
    } else if (type == 2) {
      return MultiplyCalculationType.getCount((value).toString(), three);
    } else {
      return '';
    }
  }

  static String getFullCountWithLength(String value, int length) {
    var value1 = Decimal.parse(value);
    var temFormat = "#,##0";
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        temFormat = "$temFormat.0";
      } else {
        temFormat = "${temFormat}0";
      }
    }

    var formatter = NumberFormat(temFormat, "en-US");
    // }

    var temp = (value1).toString();
    print('getFullCountWithLength:$length,formatter$formatter,temp:$temp');
    var temp1 = Decimal.fromJson(temp).formatWith(formatter);
    if (length == 0) {
      return temp1;
    }
    return _removeEndZero(temp1);
  }

  static String getFullCount(String value) {
    var value1 = Decimal.parse(value);
    var formatter = NumberFormat("#,##0.00000000", "en-US");
    var temp = (value1).toString();
    var temp1 = Decimal.fromJson(temp).formatWith(formatter);
    return _removeEndZero(temp1);
  }

  static String getEValue(double evalue) {
    return getFullCount(evalue.toString());
  }

  static String _removeEndZero(String value) {
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }
}

abstract class CalculationType {
  static String getCount(String left, String right) {
    return '';
  }

  static String getFullCount(String left, String right) {
    return '';
  }
}

class AddCalculationType {
  static String getCount(String left, String right) {
    var value = Decimal.parse(left) + Decimal.parse(right);
    var formatter = NumberFormat("#,##0.00000000", "en-US");
    var temp = (value).toString();
    var temp1 = Decimal.fromJson(temp).formatWith(formatter);
    var reslut = _removeEndZero(temp1);
    return reslut;
  }

  static String _removeEndZero(String value) {
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static String getFullCount(String left, String right) {
    var value = Decimal.parse(left) + Decimal.parse(right);
    var temp = (value).toString();
    return temp;
  }
}

class ReduceCalculationType {
  static String getCount(String left, String right) {
    var value = Decimal.parse(left) - Decimal.parse(right);
    var formatter = NumberFormat("#,##0.00000000", "en-US");
    var temp = (value).toString();
    var temp1 = Decimal.fromJson(temp).formatWith(formatter);
    var reslut = _removeEndZero(temp1);
    return reslut;
  }

  static String _removeEndZero(String value) {
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static String getFullCount(String left, String right) {
    var value = Decimal.parse(left) - Decimal.parse(right);
    var temp = (value).toString();
    return temp;
  }
}

class MultiplyCalculationType {
  static String getCount(String left, String right) {
    var value = Decimal.parse(left) * Decimal.parse(right);
    var formatter = NumberFormat("#,##0.00000000", "en-US");
    var temp = (value).toString();
    var temp1 = Decimal.fromJson(temp).formatWith(formatter);
    var reslut = _removeEndZero(temp1);
    return reslut;
  }

  static String _removeEndZero(String value) {
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static String getFullCount(String left, String right) {
    var value = Decimal.parse(left) * Decimal.parse(right);
    var temp = (value).toString();
    return temp;
  }
}
