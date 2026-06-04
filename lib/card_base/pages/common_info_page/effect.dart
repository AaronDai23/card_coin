import 'package:fish_redux/fish_redux.dart';

import '../../../http/http_manager.dart';
import '../../bean/common_info_bean.dart';
import 'action.dart';
import 'state.dart';

Effect<CommonInfoState>? buildEffect() {
  return combineEffects(<Object, Effect<CommonInfoState>>{
    Lifecycle.initState: _onInit,
    CommonInfoAction.loadData: _onInit,
  });
}

Future<void> _onInit(Action action, Context<CommonInfoState> ctx) async {
  var result = await HttpManager.getInstance().get(ctx.state.docUrl);
  if (result.isSuccess) {
    CommonInfo commonInfo = CommonInfo.fromJson(result.data);
    ctx.dispatch(CommonInfoActionCreator.onLoadSuccess(commonInfo));
  } else {
    ctx.dispatch(CommonInfoActionCreator.onLoadFailure(result.message));
  }
}
