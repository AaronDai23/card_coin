import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widget/device_info_card.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    DeviceSettingsState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.deviceSetting),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 210,
              child: DeviceInfoCard(
                nickname: state.cardInfo?.nickName,
                enableEdit: false,
                cardDetail: state.cardDetail,
                margin: EdgeInsets.zero,
              ),
            ),
            const Spacer(),
            Text(
              languageResource.getReady,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              languageResource.getReadyTips,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20.0),
            CCButton(
              child: Center(child: Text(languageResource.scanCard)),
              onPressed: () {
                dispatch(DeviceSettingsActionCreator.onScanClick());
              },
            )
          ],
        ),
      ),
    ),
  );
}
