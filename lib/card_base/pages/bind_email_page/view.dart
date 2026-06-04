import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_service/keyboard_service.dart';

import '../../../custom_widget/verification_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    BindEmailState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;

  final gradientTheme =
      Theme.of(viewService.context).extension<GradientTheme>()!;
  return KeyboardAutoDismiss(
    scaffold: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradientTheme.primaryGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(viewService.context).pop(),
        ),
        title: Text(state.title ?? languageResource.bindEmail),
      ),
      body: PageDataLoadingView(
        onLoadSuccess: () {
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.userInfo?.customer?.email?.isNotEmpty ?? false)
                  Text(
                    '${languageResource.currentEmail}${state.userInfo?.customer?.email}',
                    style: const TextStyle(color: Colors.black),
                  ),
                TextField(
                  maxLines: 1,
                  controller: state.emailController,
                  style: const TextStyle(fontSize: 16),
                  maxLength: 50,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: languageResource.enterEmail,
                      hintStyle:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      counterText: ''),
                ),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        controller: state.emailVerifyController,
                        focusNode: state.verifyFocusNode,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: languageResource.enterEmailCode,
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    VerificationButton(
                      languageResource.send,
                      controller: state.emailSendController,
                      onSendClick: () {
                        dispatch(
                            BindEmailActionCreator.onSendEmailVerifiyCode());
                      },
                    )
                  ],
                ),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                if (state.systemConfig?.customerPasswordVerify ?? false)
                  TextField(
                    maxLines: 1,
                    controller: state.pwdController,
                    style: const TextStyle(fontSize: 16),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: languageResource.enterPwd,
                      hintStyle:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                if (state.systemConfig?.customerPasswordVerify ?? false)
                  const Divider(
                    height: 0,
                    color: Colors.black,
                  ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      KeyboardService.dismiss();
                      dispatch(BindEmailActionCreator.onEmailBindClick());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        languageResource.bind,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))),
              ],
            ),
          );
        },
        loadStatus: state.loadStatus,
      ),
    ),
  );
}
