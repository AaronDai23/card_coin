import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import '../../../widgets/password_input_text.dart';
import '../../../widgets/phone_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    PhoneRegisterState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30.0,
        ),
        PhoneInputText(
          controller: state.phoneController,
          selectedIndex: state.selectedIndex,
          countryList: state.countryList,
          onCountryChanged: (value) =>
              dispatch(PhoneRegisterActionCreator.onUpdateCountry(value)),
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
                  hintText: languageResource.enterPhoneCode,
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
                dispatch(PhoneRegisterActionCreator.onSendVerifyCode());
              },
            )
          ],
        ),
        const Divider(
          height: 0,
          color: Colors.black,
        ),
        PasswordInputText(
            placeholder: languageResource.enterPwd,
            obscureText: true,
            textController: state.passwordController),
        const Divider(
          height: 0,
          color: Colors.black,
        ),
      ],
    ),
  );
}
