import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<SingleActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<SingleActivateState>>{
    Lifecycle.initState: _onInit,
    SingleActivateAction.action: _onAction,
    SingleActivateAction.scanClick: _onScanClick,
  });
}

Future<void> _onInit(Action action, Context<SingleActivateState> ctx) async {
  var result = await HttpManager.getInstance().get(
      NetworkAddress.activateSummaryUrl,
      queryParameters: {'uid': ctx.state.uid});
  if (result.isSuccess) {
    final activateSummary = ActivateSummary.fromJson(result.data);
    ctx.dispatch(SingleActivateActionCreator.onLoadSuccess(activateSummary));
  } else {
    ctx.dispatch(SingleActivateActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onScanClick(
    Action action, Context<SingleActivateState> ctx) async {
  final scanResponse = await ScanUtil.chipScanOnly();
  if (scanResponse.isSuccess) {
    final progressDialog = ProgressDialog(ctx.context);
    progressDialog.show();
    var response = await HttpManager.getInstance().post(
        NetworkAddress.activateCardV2Url, null,
        data: {'uid': scanResponse.data, 'activationType': 'SINGLE'});
    progressDialog.hide();
    if (response.isSuccess) {
      int activeCount = ctx.state.activateSummary!.activeCount! + 1;
      int inActiveCount = ctx.state.activateSummary!.inActiveCount! - 1;
      final activateSummary = ctx.state.activateSummary!
          .copyWith(activeCount: activeCount, inActiveCount: inActiveCount);
      ctx.dispatch(SingleActivateActionCreator.onLoadSuccess(activateSummary));
    } else {
      showToast(response.message);
    }
  } else {
    if (scanResponse.message != null &&
        scanResponse.message!.isNotEmpty &&
        scanResponse.message!.length < 100) {
      await ScanUtil.unlockTip(scanResponse, ctx.context, ctx.state.uid);
    }
  }
}

void _onAction(Action action, Context<SingleActivateState> ctx) {}
