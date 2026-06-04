import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EncryptCheckAction { action,btnClick,updateData }

class EncryptCheckActionCreator {

  static Action onAction() {
    return const Action(EncryptCheckAction.action);
  }

  static Action onBtnClick() {
    return const Action(EncryptCheckAction.btnClick);
  }

  static Action onUpdateData(String appData,String cardData) {
    return Action(EncryptCheckAction.updateData,payload: {'appData':appData,'cardData':cardData});
  }
}
