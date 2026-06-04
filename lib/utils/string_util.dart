import 'dart:typed_data';

import 'package:flutter/material.dart';

class StringUtils {
  static String uint8ToHex(Uint8List? byteArr) {
    if (byteArr == null || byteArr.isEmpty) {
      return "";
    }
    Uint8List result = Uint8List(byteArr.length << 1);
    var hexTable = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ]; //16进制字符表
    for (var i = 0; i < byteArr.length; i++) {
      var bit = byteArr[i]; //取传入的byteArr的每一位
      var index = bit >> 4 & 15; //右移4位,取剩下四位
      var i2 = i << 1; //byteArr的每一位对应结果的两位,所以对于结果的操作位数要乘2
      result[i2] = hexTable[index].codeUnitAt(0); //左边的值取字符表,转为Unicode放进resut数组
      index = bit & 15; //取右边四位
      result[i2 + 1] =
          hexTable[index].codeUnitAt(0); //右边的值取字符表,转为Unicode放进resut数组
    }
    return String.fromCharCodes(result); //Unicode转回为对应字符,生成字符串返回
  }

  static Locale string2Locale(String localeStr) {
    var localeList = localeStr.split('_');
    if (localeList.length < 2) {
      return Locale(localeList[0]);
    }
    return Locale(localeList[0], localeList[1]);
  }

  static String locale2String(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    } else {
      return locale.languageCode;
    }
  }

  // 邮箱判断
  static bool isEmail(String input) {
    String regexEmail = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    if (input.isEmpty) return false;
    return RegExp(regexEmail).hasMatch(input);
  }

  // 纯数字
  static const String DIGIT_REGEX = "[0-9]+";

  // 含有数字
  static const String CONTAIN_DIGIT_REGEX = ".*[0-9].*";

  // 纯字母
  static const String LETTER_REGEX = "[a-zA-Z]+";

  // 包含字母
  static const String SMALL_CONTAIN_LETTER_REGEX = ".*[a-z].*";

  // 包含字母
  static const String BIG_CONTAIN_LETTER_REGEX = ".*[A-Z].*";

  // 包含字母
  static const String CONTAIN_LETTER_REGEX = ".*[a-zA-Z].*";

  // 纯中文
  static const String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  // 仅仅包含字母和数字
  static const String LETTER_DIGIT_REGEX = "^[a-z0-9A-Z]+\$";
  static const String CHINESE_LETTER_REGEX = "([\u4e00-\u9fa5]+|[a-zA-Z]+)";
  static const String CHINESE_LETTER_DIGIT_REGEX =
      "^[a-z0-9A-Z\u4e00-\u9fa5]+\$";

  // 纯数字
  static bool isOnly(String input) {
    if (input.isEmpty) return false;
    return RegExp(DIGIT_REGEX).hasMatch(input);
  }

  // 含有数字
  static bool hasDigit(String input) {
    if (input.isEmpty) return false;
    return RegExp(CONTAIN_DIGIT_REGEX).hasMatch(input);
  }

  // 是否包含中文
  static bool isChinese(String input) {
    if (input.isEmpty) return false;
    return RegExp(CHINESE_REGEX).hasMatch(input);
  }

  static String addSpaceInString(String input) {
    if (input.isEmpty) return '';
    if (input.length == 16) {
      var input1 = input.substring(0, 4);
      var input2 = input.substring(4, 8);
      var input3 = input.substring(8, 12);
      var input4 = input.substring(12, 16);
      return "$input1 $input2 $input3 $input4";
    }
    return input;
  }

  static bool isNumeric(String str) {
    return RegExp(r'^\d+$').hasMatch(str);
  }

  /// 提取字符串中 Cause: 后的数字
  static String? extractCause(String input) {
    final regex = RegExp(r'Cause:\s*(\d+)(?=,)');
    final match = regex.firstMatch(input);
    return match?.group(1);
  }

  /// 提取 Stacktrace: 后面的数字
  static String? extractStacktrace(String input) {
    final regex = RegExp(r'Stacktrace:\s*([A-Za-z0-9]+)');
    final match = regex.firstMatch(input);
    return match?.group(1);
  }
}
