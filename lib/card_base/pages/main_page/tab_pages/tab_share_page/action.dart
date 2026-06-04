import 'dart:typed_data';
import 'package:fish_redux/fish_redux.dart';

import '../../../../bean/link_bean.dart';

//TODO replace with your own action
enum TabShareAction {
  saveImage,
  loadDomain,
  loadSuccess,
  loadFailure,
  showLoading
}

class TabShareActionCreator {
  static Action onSaveImage(Uint8List data) {
    return Action(TabShareAction.saveImage,payload: data);
  }

  static Action onLoadSuccess(LinkDomainResponse linkDomain) {
    return Action(TabShareAction.loadSuccess,payload: linkDomain);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(TabShareAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(TabShareAction.showLoading);
  }

  static Action onLoadDomain() {
    return const Action(TabShareAction.loadDomain);
  }
}
