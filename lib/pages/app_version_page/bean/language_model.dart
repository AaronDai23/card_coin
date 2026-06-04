import 'dart:ui';

import '../../../utils/string_util.dart';

class LanguageModel {
  String? imageUrl;
  String? locale;
  String? localeName;
  int? seq;

  String get languageCode => locale!.split('_').first;
  Locale get languageLocale {
    return StringUtils.string2Locale(locale!);
  }

  LanguageModel({this.locale, this.localeName, this.seq});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    if (json['locale'] == 'in_ID') {
      locale = 'id_ID';
    } else {
      locale = json['locale'];
    }
    localeName = json['localeName'];
    imageUrl = json['imageUrl'];
    seq = json['seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locale'] = locale;
    data['localeName'] = localeName;
    data['imageUrl'] = imageUrl;
    data['seq'] = seq;
    return data;
  }
}
