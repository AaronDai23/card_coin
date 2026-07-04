import 'dart:async';

import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<ConvertDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<ConvertDetailState>>{
    Lifecycle.initState: _onInit,
    ConvertDetailAction.loadDetail: _onLoadDetail,
  });
}

void _onInit(Action action, Context<ConvertDetailState> ctx) {
  ctx.dispatch(ConvertDetailActionCreator.onLoadDetail());
}

Future<void> _onLoadDetail(
    Action action, Context<ConvertDetailState> ctx) async {
  final completer = action.payload is Completer<void>
      ? action.payload as Completer<void>
      : null;

  ctx.dispatch(ConvertDetailActionCreator.onUpdateLoading(true));

  try {
    final result = await HttpManager.getInstance().get(
      NetworkAddress.assetExchangeDetail,
      queryParameters: {
        'uid': ctx.state.uid,
        'exchangeOrderId': ctx.state.exchangeOrderId,
      },
    );

    if (result.isSuccess && result.data is Map) {
      final detail =
          ConvertDetailInfo.fromJson(result.data as Map<String, dynamic>);
      ctx.dispatch(ConvertDetailActionCreator.onLoadDetailSuccess(detail));
    } else {
      ctx.dispatch(ConvertDetailActionCreator.onUpdateLoading(false));
      showToast(result.message);
    }
  } finally {
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }
}
