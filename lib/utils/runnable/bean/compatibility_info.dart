import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CompatibilityInfo {
  ///true 为兼容， false为不兼容
  late PageCategoryItem data;
  bool? result;
  String? message;
  // String? seconds;

  CompatibilityInfo({this.result, this.message, required this.data});

  CompatibilityInfo copyWith(
      {bool? result,
      String? versionCode,
      String? message,
      PageCategoryItem? data}) {
    return CompatibilityInfo(
        result: result ?? this.result,
        message: message ?? this.message,
        data: data ?? this.data);
  }

  CompatibilityInfo.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    print("PageCategoryItem:${json['data']}");
    data = PageCategoryItem.fromJson(json['data']);
    // seconds = json['seconds'];
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'message': message,
        'data': data.toJson(),
        // 'seconds': seconds,
      };
}
