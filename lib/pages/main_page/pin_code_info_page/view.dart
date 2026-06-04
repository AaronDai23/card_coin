import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PinCodeInfoState state, Dispatch dispatch, ViewService viewService) {
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
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languageResource.titlePinCode),
              Expanded(
                child: Text(
                  state.pinCodeInfo.isOpen
                      ? languageResource
                          .getPinCodeTips(state.pinCodeInfo.pinCount ?? 3)
                      : languageResource.notSet,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          state.pinCodeInfo.isOpen
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CCButton(
                      child: Text(languageResource.cancelPin),
                      onPressed: () =>
                          dispatch(PinCodeInfoActionCreator.onCancelPinCode()),
                    ),
                    CCButton(
                      child: Text(languageResource.updatePin),
                      onPressed: () =>
                          dispatch(PinCodeInfoActionCreator.onSetPinCode()),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    dispatch(PinCodeInfoActionCreator.onSetPinCode());
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      languageResource.createPin,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )))
        ],
      ),
    ),
  );
}
