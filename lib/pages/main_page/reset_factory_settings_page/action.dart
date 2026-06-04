import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:fish_redux/fish_redux.dart';

enum ResetFactorySettingsAction {
  action,
  onUpdateCheck,
  onResetCard,
  updateCardList,
  onRealResetCard,
  sendResetCommand,
  oniOSResetCard,
  onUpdateScanned,
  onUpdateCount
}

class ResetFactorySettingsActionCreator {
  static Action onAction() {
    return const Action(ResetFactorySettingsAction.action);
  }

  static Action onUpdateCheck(bool value) {
    return Action(ResetFactorySettingsAction.onUpdateCheck, payload: value);
  }

  static Action onResetCard() {
    return const Action(ResetFactorySettingsAction.onResetCard);
  }

  static Action onRealResetCard() {
    return const Action(ResetFactorySettingsAction.onRealResetCard);
  }

  static Action oniOSRetsetCard() {
    return const Action(ResetFactorySettingsAction.oniOSResetCard);
  }

  static Action onUpdateCardList(List<CardInfo> cardInfoList) {
    return Action(ResetFactorySettingsAction.updateCardList,
        payload: cardInfoList);
  }

  static Action onSendResetCommand(IsoDepReaderManager isoDepReaderManager) {
    return Action(ResetFactorySettingsAction.sendResetCommand,
        payload: isoDepReaderManager);
  }

  static Action onUpdateScanned(bool value) {
    return Action(ResetFactorySettingsAction.onUpdateScanned, payload: value);
  }

  static Action onUpdateCount(int value) {
    return Action(ResetFactorySettingsAction.onUpdateCount, payload: value);
  }
}
