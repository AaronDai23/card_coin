import 'package:card_coin/bean/card_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../../../../../../widget/base_page_loading.dart';
import '../../../../../../bean/card_group_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<GroupCardDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<GroupCardDetailState>>{
      GroupCardDetailAction.loadFailure: _onLoadFailure,
      GroupCardDetailAction.loadSuccess: _onLoadSuccess,
      GroupCardDetailAction.showLoading: _onShowLoading,
    },
  );
}

GroupCardDetailState _onLoadSuccess(GroupCardDetailState state, Action action) {
  SmartCardListInfo smartCardListInfo = action.payload['smartCardListInfo'];
  bool isMore = action.payload['isMore'];
  List<SmartCardDetail> list;
  if (isMore) {
    list = state.smartCardItemList.toList();
    list.addAll(smartCardListInfo.rows ?? []);
  } else {
    list = smartCardListInfo.rows ?? [];
  }
  final GroupCardDetailState newState = state.clone()
    ..smartCardListInfo = smartCardListInfo
    ..smartCardItemList = list
    ..loadStatus = LoadType.loadSuccess
    ..isFirstLoading = false;

  cacheGroupCardList(state.cardGroup.groupId ?? '', list);
  return newState;
}

GroupCardDetailState _onLoadFailure(GroupCardDetailState state, Action action) {
  final GroupCardDetailState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure
    ..isFirstLoading = false;
  return newState;
}

GroupCardDetailState _onShowLoading(GroupCardDetailState state, Action action) {
  final GroupCardDetailState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
