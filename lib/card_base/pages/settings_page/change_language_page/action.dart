import 'package:card_coin/pages/app_version_page/bean/language_model.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ChangeLanguageAction { action, loadFailure, loadSuccess, selectLan }

class ChangeLanguageActionCreator {
  static Action onAction() {
    return const Action(ChangeLanguageAction.action);
  }

  static Action onLoadFailure() {
    return const Action(ChangeLanguageAction.loadFailure);
  }

  static Action onLoadSuccess(List<LanguageModel> list) {
    return Action(ChangeLanguageAction.loadSuccess, payload: list);
  }

  static Action onSelectLan(int currentIndex) {
    return Action(ChangeLanguageAction.selectLan, payload: currentIndex);
  }
}
