import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../custom_widget/custom_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    UnlockPinCodeState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.unlockPinCode),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(viewService.context).pop();
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languageResource.titlePukCode),
          const SizedBox(
            height: 4,
          ),
          TextField(
            maxLines: 1,
            controller: state.pukCodeController,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: languageResource.inputPukCode,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Text(languageResource.titleNewPinCode),
          const SizedBox(
            height: 4,
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
            height: 8,
          ),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity, // 撑满宽度
              child: CCButton(
                onPressed: () {
                   dispatch(UnlockPinCodeActionCreator.onConfirmClick());
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
          // ElevatedButton(
          //     onPressed: () {
          //       dispatch(UnlockPinCodeActionCreator.onConfirmClick());
          //     },
          //     style: ElevatedButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30.0))),
          //     child: Center(
          //         child: Padding(
          //       padding: EdgeInsets.symmetric(vertical: 14.0),
          //       child: Text(
          //         languageResource.confirm,
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     )))
        ],
      ),
    ),
  );
}
