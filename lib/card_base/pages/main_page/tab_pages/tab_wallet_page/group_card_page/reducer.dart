import 'package:card_coin/card_base/bean/card_group_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'adapter/state.dart';
import 'state.dart';

Reducer<GroupCardState>? buildReducer() {
  return asReducer(
    <Object, Reducer<GroupCardState>>{
      // GroupCardAction.updateRemark: _onUpdateRemark,
      GroupCardAction.loadSuccess: _onLoadSuccess,
      GroupCardAction.loadFailure: _onLoadFailure,
      GroupCardAction.showLoading: _onShowLoading,
      GroupCardAction.updateUnReadCount: _onUpdateUnReadCount,
    },
  );
}

// GroupCardState _onUpdateRemark(GroupCardState state, Action action) {
//   String id = action.payload['id'];
//   String remark = action.payload['remark'];
//   print('_onUpdateRemark id:$id,remark:$remark');
//   var list = state.list.map((e) {
//     var cardItem = e.bean;
//     if(cardItem.id == id){
//       cardItem.nickName = remark;
//       return initMemberCardItemState(cardItem);
//     }
//     return e;
//   }).toList();
//   final GroupCardState newState = state.clone()..list = list;
//   return newState;
// }

GroupCardState _onLoadSuccess(GroupCardState state, Action action) {
  CardGroupListInfo listInfo = action.payload;

  var list = listInfo.list!.map((e) => initCardGroupItemState(e)).toList();

  final GroupCardState newState = state.clone()
    ..list = list
    ..loadStatus = LoadType.loadSuccess
    ..isFirstLoading = false;

  cacheGroupCardList('default', list);
  return newState;
}

GroupCardState _onLoadFailure(GroupCardState state, Action action) {
  final GroupCardState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload
    ..isFirstLoading = false;
  return newState;
}

GroupCardState _onShowLoading(GroupCardState state, Action action) {
  final GroupCardState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..isFirstLoading = true;
  return newState;
}

GroupCardState _onUpdateUnReadCount(GroupCardState state, Action action) {
  final GroupCardState newState = state.clone()..unReadCount = action.payload;
  return newState;
}
