import 'package:card_coin/utils/runnable/encrypt_runnable.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../utils/scan_util.dart';
import 'action.dart';
import 'state.dart';

Effect<EncryptCheckState>? buildEffect() {
  return combineEffects(<Object, Effect<EncryptCheckState>>{
    EncryptCheckAction.action: _onAction,
    EncryptCheckAction.btnClick: _onBtnClick,
  });
}

void _onAction(Action action, Context<EncryptCheckState> ctx) {}

Future<void> _onBtnClick(Action action, Context<EncryptCheckState> ctx) async {
  String data = ctx.state.controller.text;
  if (data.isEmpty) {
    showToast('请输入加密内容');
    return;
  }
  var result = await ScanUtil.chipScanWithRunnable(EncryptRunnable(data));
  if (result.isSuccess) {
    ctx.dispatch(EncryptCheckActionCreator.onUpdateData(
        result.data['appData'], result.data['cardData']));
  } else {
    // if (result.message != "Session invalidated by user") {
    //   showToast(result.message!);
    // }
  }
}
