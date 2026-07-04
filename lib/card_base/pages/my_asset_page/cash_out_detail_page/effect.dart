import 'dart:async';

import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<CashOutDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<CashOutDetailState>>{
    Lifecycle.initState: _onInit,
    CashOutDetailAction.loadDetail: _onLoadDetail,
  });
}

void _onInit(Action action, Context<CashOutDetailState> ctx) {
  ctx.dispatch(CashOutDetailActionCreator.onLoadDetail());
}

Future<void> _onLoadDetail(
    Action action, Context<CashOutDetailState> ctx) async {
  final completer = action.payload is Completer<void>
      ? action.payload as Completer<void>
      : null;

  ctx.dispatch(CashOutDetailActionCreator.onUpdateLoading(true));

  try {
    final result = await HttpManager.getInstance().get(
      NetworkAddress.cashOutDetail,
      queryParameters: {
        'uid': ctx.state.uid,
        'cashOutAuditId': ctx.state.cashOutAuditId,
      },
    );

    if (result.isSuccess && result.data is Map) {
      final detail =
          CashOutDetailInfo.fromJson(result.data as Map<String, dynamic>);
      ctx.dispatch(CashOutDetailActionCreator.onLoadDetailSuccess(detail));
    } else {
      ctx.dispatch(CashOutDetailActionCreator.onUpdateLoading(false));
      showToast(result.message);
    }
  } finally {
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }
}
