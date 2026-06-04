import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

class EncryptCheckState implements Cloneable<EncryptCheckState> {
  TextEditingController controller = TextEditingController(text: '123456');
  String appData = '';
  String cardData = '';

  @override
  EncryptCheckState clone() {
    return EncryptCheckState()
      ..controller = controller
      ..appData = appData
      ..cardData = cardData
    ;
  }
}

EncryptCheckState initState(Map<String, dynamic>? args) {
  return EncryptCheckState();
}
