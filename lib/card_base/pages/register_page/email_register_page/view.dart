import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    EmailRegisterState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30.0,
        ),
        TextField(
          maxLines: 1,
          controller: state.emailController,
          maxLength: 50,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14),
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
                focusNode: state.verifyFocusNode,
                controller: state.verifyController,
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
                dispatch(EmailRegisterActionCreator.onSendVerifyCode());
              },
            )
          ],
        ),
      ],
    ),
  );
}
