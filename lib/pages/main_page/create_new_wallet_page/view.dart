import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../widget/base_page_loading.dart';
import '../../../widget/device_info_card.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CreateNewWalletState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.activationCard),
    ),
    body: Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10.0),
          child: state.loadStatus == LoadType.loadSuccess
              ? SizedBox(
                  height: 210,
                  child: DeviceInfoCard(
                    cardDetail: state.cardDetail!,
                    margin: EdgeInsets.zero,
                  ),
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(child: CircularProgressIndicator()),
                ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageResource.createWallet,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  languageResource.createWalletTips,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: state.cardDetail != null
                        ? () => dispatch(
                            CreateNewWalletActionCreator.onCreateWalletClick())
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        languageResource.activationCard,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )))
              ],
            ),
          ),
        )
      ],
    ),
  );
}
