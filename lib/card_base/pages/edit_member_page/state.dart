
import 'package:card_coin/card_base/bean/card_info_bean.dart';
import 'package:flutter/material.dart';


import '../../../widget/base_page_loading.dart';

class EditMemberState extends LoadPageState<EditMemberState> {
  late BaseCardInfo cardInfo;
  late String cardId;
  late TextEditingController phoneController;
  late TextEditingController remarkController;
  late bool isBind;

  @override
  EditMemberState clone() {
    return EditMemberState()
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..isBind = isBind
      ..phoneController = phoneController
      ..remarkController = remarkController
      ..cardId = cardId
      ..cardInfo = cardInfo;
  }
}

EditMemberState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  BaseCardInfo cardInfo = args['cardInfo'];
  print('cardId:${cardInfo.cardNum}');
  return EditMemberState()
    ..cardInfo = cardInfo
    ..cardId = cardId
    ..isBind = true
    ..phoneController = TextEditingController()
    ..remarkController = TextEditingController()
  ;
}
