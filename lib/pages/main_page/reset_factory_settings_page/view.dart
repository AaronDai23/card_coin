import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(ResetFactorySettingsState state, Dispatch dispatch,
    ViewService viewService) {
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
      title: Text(languageResource.resetFactory),
    ),
    body: SafeArea(
      child: state.scanned
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${languageResource.cardNo}:${state.cardNo}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.topCenter, // 定位在顶部
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 30), // 离顶部30像素
                              child: LayoutBuilder(
                                builder: (_, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth * 0.5,
                                    height: constraints.maxWidth * 0.5,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 6,
                                      value: (10 - state.count) / 10,
                                      backgroundColor: Colors.grey[200],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xff002dfc)),
                                    ),
                                  );
                                },
                              ),
                            )),
                        Align(
                          alignment: Alignment.topCenter, // 居中显示
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80), // 离顶部80
                            child: SizedBox(
                              width: 50, // 设置大小
                              height: 50, // 设置大小
                              child: Center(
                                // Center 使文本居中
                                child: Text(
                                  '${10 - state.count}',
                                  style: const TextStyle(
                                    color: Color(0xff002dfc),
                                    fontSize: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            languageResource.resetFactory,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            languageResource.attention,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            languageResource.resetFactoryTips,
                            style: const TextStyle(color: Color(0xff929292)),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            onTap: () {
                              dispatch(ResetFactorySettingsActionCreator
                                  .onUpdateCheck(!state.check));
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: state.check
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.radio_button_off),
                            title: Text(
                              languageResource.agreeTips,
                              style: const TextStyle(color: Color(0xff929292)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: !state.check
                        ? null
                        : () {
                            dispatch(ResetFactorySettingsActionCreator
                                .onResetCard());
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(languageResource.resetDevice),
                  ),
                ],
              ),
            ),
    ),
  );
}
