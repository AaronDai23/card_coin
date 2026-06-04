import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_service/keyboard_service.dart';

import '../../../custom_widget/verification_button.dart';
import '../../../generated/l10n.dart';
import '../../widgets/phone_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    BindPhoneState state, Dispatch dispatch, ViewService viewService) {
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
        title: Text(state.title ?? S.current.bindPhone),
      ),
      body: PageDataLoadingView(
        onLoadSuccess: () {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                children: [
                  PhoneInputText(
                    controller: state.phoneController,
                    countryList: state.countryList,
                    selectedIndex: state.selectedIndex,
                    onCountryChanged: (value) =>
                        dispatch(BindPhoneActionCreator.onUpdateCountry(value)),
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
                          controller: state.verifyController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: S.current.enterPhoneCode,
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
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
                          dispatch(BindPhoneActionCreator.onSendVerifiyCode());
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
                      controller: state.passwordController,
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: S.current.enterPwd,
                        hintStyle:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                    ),
                  if (state.systemConfig?.customerPasswordVerify ?? false)
                    const Divider(
                      height: 0,
                      color: Colors.black,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        KeyboardService.dismiss();
                        dispatch(BindPhoneActionCreator.onBindClick());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          S.current.bind,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))),
                ],
              ),
            ),
          );
        },
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
      ),
    ),
  );
}
