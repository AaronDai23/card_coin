import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/light_spark_transactions.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum LightningNetDetailAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  lightningNet,
  updatelightningNetValue,
  lightningNetSend,
  lightningNetSendAlert,
  startTime,
  stopTime,
  updateTime,
  receive,
  sendInvoice,
  withdrawLightning
}

class LightningNetDetailActionCreator {
  static Action onAction() {
    return const Action(LightningNetDetailAction.action);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(LightningNetDetailAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(List<LightSparkTransactions> list) {
    return Action(LightningNetDetailAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(LightningNetDetailAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(LightningNetDetailAction.showLoading);
  }

  static Action onGetLightningNetDetail() {
    return const Action(LightningNetDetailAction.lightningNet);
  }

  static Action onSendLightningNet() {
    return const Action(LightningNetDetailAction.lightningNetSend);
  }

  static Action onSendLightningNetAlert() {
    return const Action(LightningNetDetailAction.lightningNetSendAlert);
  }

  static Action onWithdrawLightning() {
    return const Action(LightningNetDetailAction.withdrawLightning);
  }

  static Action onUpdatelightningNetValueAction(FlashBalance flashBalance) {
    return Action(LightningNetDetailAction.updatelightningNetValue,
        payload: flashBalance);
  }

  static Action onUpdateTime(int second) {
    return Action(LightningNetDetailAction.updateTime, payload: second);
  }

  static Action onStartTime() {
    return const Action(LightningNetDetailAction.startTime);
  }

  static Action onStopTime() {
    return const Action(LightningNetDetailAction.stopTime);
  }

  static Action onReceive() {
    return const Action(LightningNetDetailAction.receive);
  }

  static Action onSendInvoice() {
    return const Action(LightningNetDetailAction.sendInvoice);
  }
}
