import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../widgets/password_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    EmailPasswordState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Column(
    children: [
      const SizedBox(
        height: 10.0,
      ),
      TextField(
        maxLines: 1,
        controller: state.emailController,
        style: const TextStyle(fontSize: 14),
        keyboardType: TextInputType.emailAddress,
        maxLength: 50,
        onChanged: (text) {},
        decoration: InputDecoration(
            hintText: languageResource.enterEmail,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            counterText: ''),
      ),
      const Divider(
        height: 0,
        color: Colors.black,
      ),
      PasswordInputText(
          obscureText: true,
          placeholder: languageResource.enterPwd,
          textController: state.emailPwdController),
      const Divider(
        height: 0,
        color: Colors.black,
      ),
      const SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
          onPressed: () => dispatch(EmailPasswordActionCreator.onLoginClick()),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              languageResource.login,
              style: const TextStyle(color: Colors.white),
            ),
          ))),
    ],
  );
}
