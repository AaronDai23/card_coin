import 'package:card_coin/card_base/widgets/password_input_text.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(InvestmentActiveCardDialogState state, Dispatch dispatch,
    ViewService viewService) {
  var languageResource = state.languageResource!;
  return LayoutBuilder(
    builder: (_, constraints) {
      return Container(
        height: constraints.maxHeight / 2,
        constraints: const BoxConstraints(minHeight: 500),
        child: state.showPwdInput
            ? Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 12.0, left: 12.0),
                child: Column(
                  children: [
                    PasswordInputText(
                        maxLength: 20,
                        obscureText: true,
                        placeholder: 'Please enter Pin code',
                        textController: state.pwdController),
                    const Divider(
                      height: 0,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CCButton(
                      child: const Text('Confirm'),
                      onPressed: () => dispatch(
                          InvestmentActiveCardDialogActionCreator
                              .onPwdBtnClick()),
                    )
                  ],
                ),
              )
            : state.scanned
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration:
                            const BoxDecoration(color: Color(0xfff3f2f7)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${languageResource.cardId}:${state.cardId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.2,
                            vertical: 20,
                          ),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 3,
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        LayoutBuilder(
                                          builder: (_, constraints) {
                                            return SizedBox(
                                              width: constraints.maxWidth * 0.7,
                                              height:
                                                  constraints.maxWidth * 0.7,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 6,
                                                value: (5 - state.count) / 5,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xff002dfc)),
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          '${5 - state.count}',
                                          style: const TextStyle(
                                            color: Color(0xff002dfc),
                                            fontSize: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Activing card... ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          languageResource.readyToScan,
                          style: const TextStyle(fontSize: 30.0, color: Colors.grey),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: LoadAssetImage(
                            '1/nfc_scan',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Text(languageResource.longTapTips),
                        const SizedBox(height: 20.0)
                      ],
                    ),
                  ),
      );
    },
  );
}
