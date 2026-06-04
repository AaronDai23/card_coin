import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import '../../../widgets/phone_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    PhoneOtpState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Column(
    children: [
      const SizedBox(
        height: 10.0,
      ),
      PhoneInputText(
        controller: state.phoneController,
        selectedIndex: state.selectedIndex,
        countryList: state.countryList,
        onCountryChanged: (value) =>
            dispatch(PhoneOtpActionCreator.onUpdateCountry(value)),
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
              controller: state.phoneOtpController,
              focusNode: state.verifyFocusNode,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: languageResource.enterPhoneCode,
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
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
              dispatch(PhoneOtpActionCreator.onSendLoginVerifyCode());
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
          onPressed: () => dispatch(PhoneOtpActionCreator.onLoginClick()),
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
