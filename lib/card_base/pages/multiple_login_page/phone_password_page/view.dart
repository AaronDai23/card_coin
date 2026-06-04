import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../widgets/password_input_text.dart';
import '../../../widgets/phone_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    PhonePasswordState state, Dispatch dispatch, ViewService viewService) {
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
            dispatch(PhonePasswordActionCreator.onUpdateCountry(value)),
      ),
      const Divider(
        height: 0,
        color: Colors.black,
      ),
      PasswordInputText(
          obscureText: true,
          placeholder: languageResource.enterPwd,
          textController: state.phonePwdController),
      const Divider(
        height: 0,
        color: Colors.black,
      ),
      const SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
          onPressed: () => dispatch(PhonePasswordActionCreator.onLoginClick()),
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
