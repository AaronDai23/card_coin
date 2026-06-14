import 'package:fish_redux/fish_redux.dart';

enum CleanCacheAction {
  action,
  clearCache,
  updateClearing,
}

class CleanCacheActionCreator {
  static Action onAction() {
    return const Action(CleanCacheAction.action);
  }

  static Action onClearCache() {
    return const Action(CleanCacheAction.clearCache);
  }

  static Action onUpdateClearing(bool isClearing) {
    return Action(CleanCacheAction.updateClearing, payload: isClearing);
  }
}
