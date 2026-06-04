import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    EmailActivateState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  if (state.step == 0) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languageResource.verifyEmailAddress),
          TextField(
            maxLines: 1,
            controller: state.emailController,
            maxLength: 50,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                hintText: languageResource.enterEmail,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                counterText: ''),
          ),
          const Divider(
            height: 0,
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                dispatch(EmailActivateActionCreator.onVerifyEmail());
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  languageResource.verify,
                  style: const TextStyle(color: Colors.white),
                ),
              )))
        ],
      ),
    );
  } else if (state.step == 1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      '${languageResource.titleCardNum}${state.activateInfo?.cardNo ?? ''}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleBatchNum}${state.activateInfo?.batchId ?? ''}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleBatchCardNum}${languageResource.getUnitPieces(state.activateInfo?.totalCount?.toString() ?? '')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleActivatedCardNum}${languageResource.getUnitPieces(state.activateInfo?.activeCount?.toString() ?? '')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleInActivateCardNum}${languageResource.getUnitPieces(state.activateInfo?.inActiveCount?.toString() ?? '')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titlePackageNum}${languageResource.getUnitPackage(state.activateInfo?.totalPackageCount?.toString() ?? '')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleActivatedPackageNum}${languageResource.getUnitPackage(state.activateInfo?.activePackageCount?.toString() ?? '')}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${languageResource.titleInActivatedPackageNum}${languageResource.getUnitPackage(state.activateInfo?.inActivePackageCount?.toString() ?? '')}'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CCButton(
                  child: Text(languageResource.allActivate),
                  onPressed: () => dispatch(
                      EmailActivateActionCreator.onShowVerifyDialog(0)),
                ),
                const SizedBox(
                  height: 8,
                ),
                CCButton(
                  child: Text(languageResource.singleActivate),
                  onPressed: () => dispatch(
                      EmailActivateActionCreator.onShowVerifyDialog(1)),
                ),
                const SizedBox(
                  height: 8,
                ),
                CCButton(
                  child: Text(languageResource.packageActivate),
                  onPressed: () => dispatch(
                      EmailActivateActionCreator.onShowVerifyDialog(2)),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}
