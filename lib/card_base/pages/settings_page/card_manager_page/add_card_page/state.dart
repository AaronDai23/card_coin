
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../widget/base_page_loading.dart';
import '../../../../bean/card_info_bean.dart';

class AddCardState extends LoadPageState<AddCardState> {
  late String cardId;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late String cardNum;
  late int amount;
  late bool isMajor;
  late bool isBindCard;
  late BaseCardInfo cardInfo;
  @override
  AddCardState clone() {
    return AddCardState()
    ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..nameController = nameController
      ..isMajor = isMajor
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..isBindCard = isBindCard
      ..cardNum = cardNum
      ..amount = amount
      ..cardInfo = cardInfo
      ..passwordController = passwordController
      ..cardId = cardId;
  }
}

AddCardState initState(Map<String, dynamic>? args) {
  BaseCardInfo cardInfo = args!['cardInfo'];
  bool isMajor = args['isMajor']??false;
  print('isMajor:$isMajor');
  return AddCardState()
    ..nameController = TextEditingController(text: S.current.cardName)
    ..passwordController = TextEditingController()
    ..cardNum = cardInfo.cardNum??''
    ..amount = cardInfo.amount??0
    ..isMajor = isMajor
    ..isBindCard = true
    ..cardInfo = cardInfo
    ..cardId = cardInfo.identifier!;
}
