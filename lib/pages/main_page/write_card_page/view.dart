import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../card_base/widgets/gradient_theme.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    WriteCardState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(viewService.context).pop(),
      ),
      title: Text('${state.languageResource?.nfcWritingCard}'),
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        // dispatch(MainActionCreator.onShowLoading());
        // dispatch(MainActionCreator.onLoadDefaultCurrency());
      },
      onLoadSuccess: () {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "写入内容：",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      dispatch(WriteCardActionCreator.onShowCurrencyInfos(
                          state.cardInfo));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                                "${state.currencyInfo.currencyData.id}/${state.currencyInfo.address ?? ""}",
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 3,
                                softWrap: true)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () =>
                          dispatch(WriteCardActionCreator.onWriteClick()),
                      child: Text('${state.languageResource?.write}')),
                  const SizedBox(
                    width: 20.0,
                  )
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}
