import 'dart:async';

import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum CashOutDetailAction {
  loadDetail,
  loadDetailSuccess,
  updateLoading,
}

class CashOutDetailActionCreator {
  static Action onLoadDetail({Completer<void>? completer}) =>
      Action(CashOutDetailAction.loadDetail, payload: completer);

  static Action onLoadDetailSuccess(CashOutDetailInfo detail) =>
      Action(CashOutDetailAction.loadDetailSuccess, payload: detail);

  static Action onUpdateLoading(bool loading) =>
      Action(CashOutDetailAction.updateLoading, payload: loading);
}
