import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum ConvertDetailAction {
  loadDetail,
  loadDetailSuccess,
  updateLoading,
}

class ConvertDetailActionCreator {
  static Action onLoadDetail() => const Action(ConvertDetailAction.loadDetail);

  static Action onLoadDetailSuccess(ConvertDetailInfo detail) =>
      Action(ConvertDetailAction.loadDetailSuccess, payload: detail);

  static Action onUpdateLoading(bool loading) =>
      Action(ConvertDetailAction.updateLoading, payload: loading);
}
