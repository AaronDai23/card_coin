import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SetPinCodeState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(state.pinCodeInfo.isOpen
          ? languageResource.updatePin
          : languageResource.createPin),
      actions: [
        if (state.pinCodeInfo.isOpen)
          TextButton(
              onPressed: () =>
                  dispatch(SetPinCodeActionCreator.onCancelPinCode()),
              child: Text(
                languageResource.cancelPin,
                style: const TextStyle(color: Colors.white),
              ))
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languageResource.titlePinCode),
          const SizedBox(
            height: 1,
          ),
          TextField(
            maxLines: 1,
            controller: state.pinCodeController,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: languageResource.inputPinCode,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 18,
          ),
          if (state.pinCodeInfo.isOpen)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languageResource.titleNewPinCode),
                const SizedBox(
                  height: 1,
                ),
                TextField(
                  maxLines: 1,
                  controller: state.newPinCodeController,
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: languageResource.inputNewPinCode,
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                const Divider(),
                Text(
                  '* ${languageResource.pinFormat}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity, // 撑满宽度
              child: CCButton(
                onPressed: () {
                  dispatch(SetPinCodeActionCreator.onSetPinCodeClick());
                },
                color: Colors.black,
                borderRadius: 30,
                verticalPadding: 15,
                horizontalPadding: 32,
                child: Text(
                  languageResource.confirm,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
