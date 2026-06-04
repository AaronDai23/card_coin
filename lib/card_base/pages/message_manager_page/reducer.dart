
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/notice_message_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<MessageManagerState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MessageManagerState>>{
      MessageManagerAction.loadSuccess: _onLoadSuccess,
      MessageManagerAction.loadFailure: _onLoadFailure,
      MessageManagerAction.showLoading: _onShowLoading,
      MessageManagerAction.updateEdit: _onUpdateEdit,
      MessageManagerAction.updateItemSelect: _onUpdateItemSelect,
      MessageManagerAction.updateItemsRead: _onUpdateItemsRead,
      MessageManagerAction.updateMessageList: _onUpdateMessageList,

    },
  );
}

MessageManagerState _onLoadSuccess(MessageManagerState state, Action action) {
  MessageListInfo listInfo = action.payload['listInfo'];
  bool isMore = action.payload['isMore'];
  List<NoticeMessage> list;
  if(isMore){
    list = state.list.toList();
    list.addAll(listInfo.rows??[]);
  }else{
    list = listInfo.rows??[];
  }
  final MessageManagerState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..list = list;
  return newState;
}

MessageManagerState _onLoadFailure(MessageManagerState state, Action action) {
  final MessageManagerState newState = state.clone();
  return newState..loadStatus = LoadType.loadFailure..errorMsg = action.payload;
}

MessageManagerState _onShowLoading(MessageManagerState state, Action action) {
  final MessageManagerState newState = state.clone();
  return newState..loadStatus = LoadType.loading;
}

MessageManagerState _onUpdateEdit(MessageManagerState state, Action action) {
  final MessageManagerState newState = state.clone();
  return newState..isEdit = action.payload;
}

MessageManagerState _onUpdateItemSelect(MessageManagerState state, Action action) {
  String id = action.payload['id'];
  var list = state.list.map((e) {
    if(e.id == id){
      e.isSelected = action.payload['isSelect'];
    }
    return e;
  }).toList();

  bool isAllSelected = list.where((element) => element.isSelected).length == list.length;

  final MessageManagerState newState = state.clone();
  return newState
    ..isAllSelected = isAllSelected
    ..list = list;
}

MessageManagerState _onUpdateItemsRead(MessageManagerState state, Action action) {
  List<String> ids = action.payload;
  var list = state.list.map((e) {
    if(ids.contains(e.id)){
      e.status = 'READ';
    }
    return e;
  }).toList();
  final MessageManagerState newState = state.clone();
  return newState..list = list;
}

MessageManagerState _onUpdateMessageList(MessageManagerState state, Action action) {
  final MessageManagerState newState = state.clone();
  return newState..list = action.payload;
}


