import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SelectFiatState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource!.changeFialt),
    ),
    body: state.fiats.isNotEmpty
        ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    itemBuilder: (context, index) {
                      FiatInfo info = state.fiats[index];
                      return GestureDetector(
                          onTap: () {
                            dispatch(
                                SelectFiatActionCreator.onSelectedAction(info));
                          },
                          child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              shadowColor: const Color(0x88000000),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${info.name}(${info.symbol})'),
                                            Text(info.currentPrice)
                                          ]),
                                      const Expanded(
                                        child: Text(''), // 中间用Expanded控件
                                      ),
                                      state.currentFiat.symbol == info.symbol
                                          ? Container(
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.check_box,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ))));
                    },
                    itemCount: state.fiats.length),
              )
            ],
          )
        : const Center(child: CircularProgressIndicator()),
  );
}
