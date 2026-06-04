import 'dart:convert';

import 'package:flutter/services.dart';

class FileUtil{
  static Future<Map<String,dynamic>> getMapFromFile(String path) async {
    final json = await rootBundle.loadString('assets/data/$path');
    return jsonDecode(json) as Map<String,dynamic>;
  }
}