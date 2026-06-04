import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    BackupDataState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.createBackup),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: LoadImage(
                state.cardDetail.shape?.imageUrl ?? '',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    languageResource.prepareDevice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    languageResource.preparePrimaryDevice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff929292),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CCButton(
              onPressed: () {
                dispatch(BackupDataActionCreator.onScanCard());
              },
              color: Colors.black,
              borderRadius: 6,
              verticalPadding: 10,
              horizontalPadding: 32,
              child: Text(
                languageResource.scanPrimaryCard,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
