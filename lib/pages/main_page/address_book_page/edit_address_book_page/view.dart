import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/widget/limited_textfield.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    EditAddressBookState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(state.isAdd
          ? languageResource.addAddressBook
          : languageResource.editAddressBook),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(languageResource.titleName),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: LimitedTextField(
                      controller: state.nameController,
                      maxLength: 15,
                      maxLine: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black, height: 40),
            Text(languageResource.titleWalletAddress),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black),
              ),
              child: LimitedTextField(
                controller: state.addressController,
                maxLength: 100,
                maxLine: 1,
              ),
            ),
            const Divider(color: Colors.black, height: 40),
            Text(languageResource.titleRemarks),
            const SizedBox(height: 10),
            Container(
                // height: 200.0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black),
                ),
                child: LimitedTextField(
                  controller: state.remarkController,
                  maxLength: 250,
                  maxLine: 10,
                )),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity, // 撑满宽度
                child: CCButton(
                  onPressed: () {
                    dispatch(EditAddressBookActionCreator.onSave());
                  },
                  color: Colors.black,
                  borderRadius: 30,
                  verticalPadding: 15,
                  horizontalPadding: 32,
                  child: Text(
                    languageResource.save,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            )
            // ElevatedButton(
            //     onPressed: () {
            //       dispatch(EditAddressBookActionCreator.onSave());
            //     },
            //     style: ElevatedButton.styleFrom(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30.0))),
            //     child: Center(
            //         child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 14.0),
            //       child: Text(
            //         languageResource.save,
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     )))
          ],
        ),
      ),
    ),
  );
}
