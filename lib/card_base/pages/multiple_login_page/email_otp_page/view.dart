import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    EmailOtpState state, Dispatch dispatch, ViewService viewService) {
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
      Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 1,
              controller: state.emailOtpController,
              focusNode: state.verifyFocusNode,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: languageResource.enterEmailCode,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          VerificationButton(
            languageResource.send,
            controller: state.sendController,
            onSendClick: () {
              dispatch(EmailOtpActionCreator.onSendLoginVerifyCode());
            },
          )
        ],
      ),
      const Divider(
        height: 0,
        color: Colors.black,
      ),
      const SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
          onPressed: () => dispatch(EmailOtpActionCreator.onLoginClick()),
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
