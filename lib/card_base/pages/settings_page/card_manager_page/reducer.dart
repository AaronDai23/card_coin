
import 'package:fish_redux/fish_redux.dart';

import '../../../../widget/base_page_loading.dart';
import '../../../bean/link_bean.dart';
import 'action.dart';
import 'card_item_component/state.dart';
import 'state.dart';

Reducer<CardManagerState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CardManagerState>>{
      CardManagerAction.loadSuccess: _onLoadSuccess,
      CardManagerAction.loadFailure: _onLoadFailure,
      CardManagerAction.showLoading: _onShowLoading,
      CardManagerAction.deleteItem: _onDeleteItem,
    },
  );
}

CardManagerState _onDeleteItem(CardManagerState state, Action action) {
  String id = action.payload;
  var list = state.list.toList();
  list.removeWhere((element) => element.bean.id == id);

  final CardManagerState newState = state.clone()..list = list;
  return newState;
}

CardManagerState _onLoadSuccess(CardManagerState state, Action action) {
  CardListInfo listInfo = action.payload;
  final CardManagerState newState = state.clone()
    ..list = listInfo.list!.map((e) => initCardItemState(e)).toList()
    ..total = listInfo.total??0
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

CardManagerState _onLoadFailure(CardManagerState state, Action action) {
  final CardManagerState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

CardManagerState _onShowLoading(CardManagerState state, Action action) {
  final CardManagerState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
