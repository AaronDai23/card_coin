import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/card_base/widgets/password_input_text.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    UpdatePasswordState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(state.title ?? languageResource.modifyPwd),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            Text(languageResource.enterOriginPwd),
            PasswordInputText(
                maxLength: 20,
                obscureText: true,
                placeholder: languageResource.enterPwd,
                textController: state.oldPwdController),
            const Divider(
              height: 0,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(languageResource.enterNewPwd),
            PasswordInputText(
                maxLength: 20,
                obscureText: true,
                placeholder: languageResource.enterPwd,
                textController: state.pwdController),
            const Divider(
              height: 0,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(languageResource.enterNewPwdAgain),
            PasswordInputText(
                maxLength: 20,
                obscureText: true,
                placeholder: languageResource.enterPwd,
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
                  dispatch(UpdatePasswordActionCreator.onUpdateClick());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    languageResource.modifyPwd,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))),
          ],
        ),
      ),
    ),
  );
}
