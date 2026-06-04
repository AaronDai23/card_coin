import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<FlowHistoryState>? buildEffect() {
  return combineEffects(<Object, Effect<FlowHistoryState>>{
    FlowHistoryAction.action: _onAction,
    Lifecycle.initState: _onInit,
    FlowHistoryAction.loadData: _onloadData,
  });
}

void _onAction(Action action, Context<FlowHistoryState> ctx) {}

Future<void> _onInit(Action action, Context<FlowHistoryState> ctx) async {
  ctx.dispatch(FlowHistoryActionCreator.onLoadData());
}

Future<void> _onloadData(Action action, Context<FlowHistoryState> ctx) async {
  Map<String, dynamic> params = {
    "uid": ctx.state.uid,
  };

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.flowHistory, null, data: params);
  print('flowHistory resultData:${result.data}');
  if (result.isSuccess) {
    if (result.data != null) {
      List<dynamic> list = result.data;

      List<FlowProgressNewInfo> steps =
          list.map((e) => FlowProgressNewInfo.fromJson(e)).toList();
      ctx.dispatch(FlowHistoryActionCreator.onLoadSuccess(steps));
    } else {
      ctx.dispatch(FlowHistoryActionCreator.onLoadFailure(result.message));
      return;
    }
  } else {
    ctx.dispatch(FlowHistoryActionCreator.onLoadFailure(result.message));
  }
}
