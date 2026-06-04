
import 'package:fish_redux/fish_redux.dart';

import '../../../../../widget/base_page_loading.dart';
import '../../../../bean/banner_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<TabWalletState>? buildReducer() {
  return asReducer(
    <Object, Reducer<TabWalletState>>{
      TabWalletAction.loadSuccess: _onLoadSuccess,
      TabWalletAction.loadFailure: _onLoadFailure,
      TabWalletAction.showLoading: _onShowLoading,
      // TabWalletAction.updateCardInfo: _onUpdateCardInfo,
      TabWalletAction.updateIndex: _onUpdateIndex,
      TabWalletAction.updateUnReadCount: _onUpdateUnReadCount,
    },
  );
}

TabWalletState _onUpdateUnReadCount(TabWalletState state, Action action) {
  final TabWalletState newState = state.clone()
    ..unReadCount = action.payload
  ;
  return newState;
}

TabWalletState _onLoadSuccess(TabWalletState state, Action action) {

  List<BannerItem> banners = action.payload;
  final TabWalletState newState = state.clone()
    ..banners = banners
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

TabWalletState _onLoadFailure(TabWalletState state, Action action) {
  final TabWalletState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

TabWalletState _onShowLoading(TabWalletState state, Action action) {
  final TabWalletState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

TabWalletState _onUpdateIndex(TabWalletState state, Action action) {
  final TabWalletState newState = state.clone()..currentIndex = action.payload;
  return newState;
}

// TabWalletState _onUpdateCardInfo(TabWalletState state, Action action) {
//   String cardId = action.payload['id'];
//   num amount = action.payload['amount'];
//   var list = state.list.map((e) {
//     if(e.bean.id == cardId){
//       var nfcCardItem = e.bean;
//       nfcCardItem.amount = amount;
//       return initWalletItemState(nfcCardItem);
//     }
//     return e;
//   }).toList();
//   final TabWalletState newState = state.clone()..list = list;
//   return newState;
// }
