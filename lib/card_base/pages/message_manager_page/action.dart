
import 'package:fish_redux/fish_redux.dart';

import '../../bean/notice_message_bean.dart';

//TODO replace with your own action
enum MessageManagerAction {
  managerClick,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  updateEdit,
  updateItemSelect,
  updateItemsRead,
  setMessagesRead,
  deleteMessages,
  updateMessageList,
  selectAllClick
}

class MessageManagerActionCreator {

  static Action onManagerClick() {
    return const Action(MessageManagerAction.managerClick);
  }


  static Action onLoadSuccess(MessageListInfo listInfo,{bool isMore = false}) {
    return Action(MessageManagerAction.loadSuccess, payload: {'listInfo':listInfo,'isMore':isMore});
  }


  static Action onSelectAllClick() {
    return const Action(MessageManagerAction.selectAllClick);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MessageManagerAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MessageManagerAction.showLoading);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(MessageManagerAction.loadData,payload: isLoadMore);
  }

  static Action onUpdateEdit(bool isEdit) {
    return Action(MessageManagerAction.updateEdit, payload: isEdit);
  }

  static Action onUpdateItemSelect(String id, bool isSelect) {
    return Action(MessageManagerAction.updateItemSelect,
        payload: {'id': id, 'isSelect': isSelect});
  }

  static Action onUpdateItemsRead(List<String> ids) {
    return Action(MessageManagerAction.updateItemsRead, payload: ids);
  }

  static Action onSetMessagesRead() {
    return const Action(MessageManagerAction.setMessagesRead);
  }

  static Action onDeleteMessages() {
    return const Action(MessageManagerAction.deleteMessages);
  }

  static Action onUpdateMessageList(List<NoticeMessage> list) {
    return Action(MessageManagerAction.updateMessageList, payload: list);
  }
}
