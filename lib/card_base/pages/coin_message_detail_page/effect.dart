import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<CoinMessageDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<CoinMessageDetailState>>{
    Lifecycle.initState: _onInit,
    CoinMessageDetailAction.loadData: _onLoadData,
  });
}

Future<void> _onInit(Action action, Context<CoinMessageDetailState> ctx) async {
  ctx.dispatch(CoinMessageDetailActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<CoinMessageDetailState> ctx) async {
  String messageId = ctx.state.noticeId;
  String? uid = await LocalStorage.getCardUuid();
  Map<String, dynamic> params = {
    'uid': uid,
    'id': messageId,
  };
  var resultData = await HttpManager.getInstance()
      .get(NetworkAddress.chainStampDetail, queryParameters: params);

  if (resultData.isSuccess) {
    CoinMessageDetail commonInfo = CoinMessageDetail.fromJson(resultData.data);
    ctx.dispatch(CoinMessageDetailActionCreator.onLoadSuccess(commonInfo));
  } else {
    ctx.dispatch(
        CoinMessageDetailActionCreator.onLoadFailure(resultData.message));
  }
}
