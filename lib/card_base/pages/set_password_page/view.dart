import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_service/keyboard_service.dart';

import '../../../custom_widget/verification_button.dart';
import '../../../generated/l10n.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    SetPasswordState state, Dispatch dispatch, ViewService viewService) {
  return KeyboardAutoDismiss(
    scaffold: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(viewService.context).pop(),
        ),
        title: Text(S.current.setPwd),
      ),
      body: BasePageLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onReload: () {
          dispatch(SetPasswordActionCreator.onShowLoading());
          dispatch(SetPasswordActionCreator.onLoadData());
        },
        buildBody: (isSuccess) {
          if (isSuccess) {
            String method = state.verifyMethods[state.index].method!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method == 'PHONE'
                        ? S.current.sendPhoneCode(
                            state.verifyMethods[state.index].brief ?? '')
                        : S.current.sendEmailCode(
                            state.verifyMethods[state.index].brief ?? ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                      visible: state.verifyMethods.length > 1,
                      child: TextButton(
                          onPressed: () => dispatch(
                              SetPasswordActionCreator.onChangeMethod()),
                          child: Text(S.current.changeVerify))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          controller: state.verifyController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: method == 'PHONE'
                                ? S.current.enterPhoneCode
                                : S.current.enterEmailCode,
                            hintStyle:
                                const TextStyle(fontSize: 16, color: Colors.grey),
                            border:
                                const OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      VerificationButton(
                        S.current.send,
                        controller: state.sendController,
                        onSendClick: () {
                          dispatch(
                              SetPasswordActionCreator.onSendVerifiyCode());
                        },
                      )
                    ],
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black,
                  ),
                  TextField(
                    maxLines: 1,
                    controller: state.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: S.current.enterPwd,
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          dispatch(SetPasswordActionCreator.onConfirmClick()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          S.current.comfirm,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    ),
  );
}
