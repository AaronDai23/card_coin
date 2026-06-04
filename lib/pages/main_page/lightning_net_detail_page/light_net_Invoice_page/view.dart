import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:card_coin/widget/pretty_qr_animated_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    LightNetInvoiceState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Lightning Network Invoice'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(viewService.context).pop();
              // dispatch(HDWalletListActionCreator.onShowCardInfoList());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: PageDataLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {},
          onLoadSuccess: () {
            return _buildFlashDetail(state, dispatch);
          }));
}

Widget _buildFlashDetail(LightNetInvoiceState state, Dispatch dispatch) {
  return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      state.qrImage != null
          ? SizedBox(
              height: 200,
              child: PrettyQrAnimatedView(
                qrImage: state.qrImage!,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(roundFactor: 0.0),
                ),
              ),
            )
          : const SizedBox(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.invoiceInfo != null
              ? state.invoiceInfo!.usdDisplayAmount
              : "~ \$ 0")
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 90,
                child: ElevatedButton(
                    onPressed: () {
                      dispatch(LightNetInvoiceActionCreator.copyOnAction());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Row(children: [
                      Image(
                          image: AssetImage('assets/images/copy.png'),
                          height: 12,
                          width: 12),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Copy')
                    ])),
              ),
              SizedBox(
                width: 90,
                child: ElevatedButton(
                    onPressed: () async {
                      dispatch(LightNetInvoiceActionCreator.editOnAction());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Row(children: [
                      Image(
                          image: AssetImage('assets/images/edit.png'),
                          height: 12,
                          width: 12),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Edit')
                    ])),
              )
            ],
          ))
    ],
  ));
}
