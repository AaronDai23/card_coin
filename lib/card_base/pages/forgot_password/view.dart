import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../custom_widget/verification_button.dart';
import '../../widgets/password_input_text.dart';
import '../../widgets/phone_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    ForgotPasswordState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.forgotPwd),
      actions: [
        TextButton(
          onPressed: () => dispatch(
              ForgotPasswordActionCreator.onSwitchType(!state.isPhone)),
          style: TextButton.styleFrom(backgroundColor: Colors.white),
          child: Text(state.isPhone ? '邮箱找回' : '手机号找回'),
        )
      ],
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      onLoadSuccess: () {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                state.isPhone
                    ? PhoneInputText(
                        controller: state.phoneController,
                        selectedIndex: state.selectedIndex,
                        countryList: state.countryList,
                        onCountryChanged: (value) => dispatch(
                            ForgotPasswordActionCreator.onUpdateCountry(value)),
                      )
                    : TextField(
                        maxLines: 1,
                        controller: state.emailController,
                        style: const TextStyle(fontSize: 16),
                        maxLength: 50,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: languageResource.enterEmail,
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            counterText: '')),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        controller: state.codeController,
                        focusNode: state.verifyFocusNode,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: languageResource.enterPhoneCode,
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
                      controller: state.verificationController,
                      onSendClick: () =>
                          dispatch(ForgotPasswordActionCreator.onSendClick()),
                    )
                  ],
                ),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                PasswordInputText(
                    maxLength: 20,
                    obscureText: true,
                    placeholder: languageResource.enterPwd,
                    textController: state.pwdController),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                PasswordInputText(
                    maxLength: 20,
                    obscureText: true,
                    placeholder: languageResource.enterNewPwdAgain,
                    textController: state.confirmPwdController),
                const Divider(
                  height: 0,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      dispatch(ForgotPasswordActionCreator.onResetClick());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        languageResource.resetPwd,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))),
              ],
            ),
          ),
        );
      },
    ),
  );
}
