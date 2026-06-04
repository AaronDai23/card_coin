
import 'package:flutter/material.dart';

class ColorUtil {
  static Color parseHexColor(String? hex, {Color defaultColor = Colors.white}) {
    if (hex == null || hex.isEmpty) return defaultColor;

    var value = hex.replaceAll('#', '').replaceAll('0x', '').toUpperCase();

    // 如果是 RGB（6位），默认补 Alpha = FF
    if (value.length == 6) {
      value = 'FF$value';
    }

    if (value.length != 8) return defaultColor;

    return Color(int.parse(value, radix: 16));
  }
}
