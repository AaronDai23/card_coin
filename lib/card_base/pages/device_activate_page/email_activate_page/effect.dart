import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/card_base/pages/device_activate_page/selected_activate_page/action.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../widgets/verification_button.dart';
import 'action.dart';
import 'state.dart';

Effect<EmailActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<EmailActivateState>>{
    // EmailActivateAction.action: _onAction,
    EmailActivateAction.verifyEmail: _onVerifyEmail,
    EmailActivateAction.sendVerifyCode: _onSendVerifyCode,
    EmailActivateAction.activateClick: _onActivateClick,
    EmailActivateAction.showVerifyDialog: _onShowVerifyDialog,
    SelectedActivateAction.cardActivateChanged: _onCardActivateChanged,
  });
}

Future<void> _onActivateClick(
    Action action, Context<EmailActivateState> ctx) async {
  KeyboardService.dismiss();
  String emailAddress = ctx.state.emailController.text;
  String code = action.payload;
  var params = {
    'uid': ctx.state.uuid,
    'validateMethod': ctx.state.method.code,
    'identifier': emailAddress,
    'verifyCode': code
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.activateCardVerifyUrl, null, data: params);
  pr.hide();
  if (result.isSuccess) {
    if (ctx.state.activateType == 0) {
      Navigator.of(ctx.context)
          .pushNamed('allActivatePage', arguments: {'uid': ctx.state.uuid});
    } else if (ctx.state.activateType == 1) {
      Navigator.of(ctx.context)
          .pushNamed('singleActivatePage', arguments: {'uid': ctx.state.uuid});
    } else {
      Navigator.of(ctx.context)
          .pushNamed('packageActivatePage', arguments: {'uid': ctx.state.uuid});
    }
  } else {
    showToast(result.message);
  }
}

Future<void> _onCardActivateChanged(
    Action action, Context<EmailActivateState> ctx) async {
  int activatePackageNum = action.payload;
  int currentActivatePackageNum = ctx.state.activateInfo!.activePackageCount!;
  int totalPackageNum = ctx.state.activateInfo!.totalPackageCount!;
  int newActivatePackageNum = currentActivatePackageNum + activatePackageNum;
  var activateInfo = ctx.state.activateInfo?.copyWith(
      activePackageCount: newActivatePackageNum,
      inActivePackageCount: totalPackageNum - newActivatePackageNum);
  ctx.dispatch(EmailActivateActionCreator.onUpdateActivateInfo(activateInfo));
}

Future<void> _onVerifyEmail(
    Action action, Context<EmailActivateState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  if (emailAddress.isEmpty) {
    showToast(languageResource.enterEmail);
    return;
  }

  if (!StringUtils.isEmail(emailAddress)) {
    showToast(languageResource.emailError);
    return;
  }

  final data = {
    'uid': ctx.state.uuid,
    'validateMethod': ctx.state.method.code,
    'identifier': emailAddress
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.cardholderVerityUrl, null, data: data);

  pr.hide();
  if (result.isSuccess) {
    var activateInfo = ActivateInfo.fromJson(result.data);
    ctx.state.activateInfo = activateInfo;
    ctx.dispatch(EmailActivateActionCreator.onUpdateStep(1));
  } else {
    // ctx.dispatch(EmailActivateActionCreator.onUpdateStep(1));
    showToast(result.message);
  }
}

Future<bool> _onSendVerifyCode(
    Action action, Context<EmailActivateState> ctx) async {
  KeyboardService.dismiss();
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  if (emailAddress.isEmpty) {
    showToast(languageResource.enterEmail);
    return false;
  }

  if (!StringUtils.isEmail(emailAddress)) {
    showToast(languageResource.emailError);
    return false;
  }

  var params = {
    'uid': ctx.state.uuid,
    'validateMethod': ctx.state.method.code,
    'identifier': emailAddress
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.activateVerityUrl, null, data: params);
  pr.hide();
  if (resultData.isSuccess) {
    showToast(languageResource.sendCodeSuccess);
    return true;
  } else {
    showToast(resultData.message);
    return false;
  }
}

Future<void> _onShowVerifyDialog(
    Action action, Context<EmailActivateState> ctx) async {
  ctx.state.activateType = action.payload;
  var languageResource = ctx.state.languageResource!;
  final verifyController = TextEditingController();
  final sendController = VerificationController();

  showDialog(
      context: ctx.context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 200,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageResource
                              .sendCode2Email(ctx.state.emailController.text),
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 12, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: verifyController,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: languageResource.enterEmailCode,
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            VerificationButton(
                              languageResource.send,
                              controller: sendController,
                              onSendClick: () async {
                                var result = await ctx.dispatch(
                                    EmailActivateActionCreator
                                        .onSendVerifyCode());
                                if (result) {
                                  sendController.startCountdown();
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(ctx.context).pop(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            child: Text(
                              languageResource.cancel,
                              style: const TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              var code = verifyController.text;
                              if (code.isEmpty) {
                                showToast(languageResource.enterEmailCode);
                                return;
                              }

                              Navigator.of(ctx.context).pop();
                              ctx.dispatch(
                                  EmailActivateActionCreator.onActivateClick(
                                      code));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            child: Text(
                              languageResource.gotoActivate,
                              style: const TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
