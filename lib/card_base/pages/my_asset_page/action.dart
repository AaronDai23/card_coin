import 'package:card_coin/card_base/bean/asset_summary_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum MyAssetAction {
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  pushWalletPage,
  investmentlist,
  selectType,
  selectTooltip,
  pushExchange,
  pushCashOut,
}

class MyAssetActionCreator {
  static Action onLoadSuccess(AssetSummaryInfo info) {
    return Action(MyAssetAction.loadSuccess, payload: info);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MyAssetAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MyAssetAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(MyAssetAction.loadData);
  }

  static Action onInvestmentPage(String cardId) {
    return Action(MyAssetAction.investmentlist, payload: cardId);
  }

  static Action onPushWalletPage(String cardId) {
    return Action(MyAssetAction.pushWalletPage, payload: cardId);
  }

  static Action onSelectType(String type) {
    return Action(MyAssetAction.selectType, payload: type);
  }

  static Action onSelectTooltip(String tip) {
    return Action(MyAssetAction.selectTooltip, payload: tip);
  }

  static Action onPushExchange() {
    return const Action(MyAssetAction.pushExchange);
  }

  static Action onPushCashOut() {
    return const Action(MyAssetAction.pushCashOut);
  }
}
