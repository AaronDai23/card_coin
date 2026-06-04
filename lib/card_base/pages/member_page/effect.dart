import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../bean/member_level_bean.dart';
import 'action.dart';
import 'state.dart';
import 'view/privilege_detail_view.dart';

Effect<MemberState>? buildEffect() {
  return combineEffects(<Object, Effect<MemberState>>{
    Lifecycle.initState: _onInit,
    MemberAction.loadData: _onLoadData,
    MemberAction.showPrivilege: _onShowPrivilege,
  });
}

void _onShowPrivilege(Action action, Context<MemberState> ctx) {
  String privilegeId = action.payload;
  showDialog(
      context: ctx.context,
      builder: (context) {
        return PrivilegeDetailView(privilegeId);
      });
}

void _onInit(Action action, Context<MemberState> ctx) {
  ctx.dispatch(MemberActionCreator.onLoadData());
}

Future<void> _onLoadData(Action action, Context<MemberState> ctx) async {
  var levelDocResult =
      await HttpManager.getInstance().get(NetworkAddress.customerLevelDocUrl);
  CustomerLevelInfo levelInfo;
  if (levelDocResult.isSuccess) {
    var map = levelDocResult.data;
    if (map == '') {
      showToast(ctx.state.languageResource!.notData);
      // return;
      levelInfo = CustomerLevelInfo();
    } else {
      levelInfo = CustomerLevelInfo.fromJson(levelDocResult.data);
    }
  } else {
    showToast(levelDocResult.message);
    return;
  }
  MemberLevelInfo memberLevelInfo;
  Map<String, dynamic> params = {};
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.memberLevelUrl, queryParameters: params);

  if (result.isSuccess) {
    memberLevelInfo = MemberLevelInfo.fromJson(result.data);
    ctx.dispatch(MemberActionCreator.onLoadSuccess(memberLevelInfo, levelInfo));
  } else {
    ctx.dispatch(MemberActionCreator.onLoadFailure(result.message));
    return;
  }
}
