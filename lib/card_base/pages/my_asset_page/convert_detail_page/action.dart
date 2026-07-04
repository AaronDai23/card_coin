import 'dart:async';

import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum ConvertDetailAction {
  loadDetail,
  loadDetailSuccess,
  updateLoading,
}

class ConvertDetailActionCreator {
  static Action onLoadDetail({Completer<void>? completer}) =>
      Action(ConvertDetailAction.loadDetail, payload: completer);

  static Action onLoadDetailSuccess(ConvertDetailInfo detail) =>
      Action(ConvertDetailAction.loadDetailSuccess, payload: detail);

  static Action onUpdateLoading(bool loading) =>
      Action(ConvertDetailAction.updateLoading, payload: loading);
}
