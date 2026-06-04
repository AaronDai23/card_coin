import 'dart:ui';

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/hd_recharge_page/action.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../widget/pretty_qr_animated_view.dart';
import 'state.dart';

Widget buildView(
    HdRechargeState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  // print("HdRechargeState-view-build:");

  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: Text(
          languageResource.recharge,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.of(viewService.context).pop();
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(viewService.context).pushNamed(
                    'transactionDetailPage',
                    arguments: {'wallet': state.currencyInfo, 'type': 0});
              },
              child: Text(
                languageResource.transactionRecord,
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      backgroundColor: Colors.grey[100],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        dispatch(HdRechargeActionCreator.onShowNetworks());
                      },
                      child: Row(
                        children: [
                          Text(
                              "${state.currencyInfo.currencyData.id}-${state.currencyInfo.networkName ?? state.currencyInfo.currencyData.networkId.toUpperCase()}",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          state.bigCurrency.networkLists!.length > 1
                              ? const Icon(Icons.arrow_drop_down)
                              : const SizedBox(
                                  height: 10.0,
                                ),
                        ],
                      ),
                    ),
                    Text(
                      state.currencyInfo.balance ?? "0.0",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 200,
                  child: PrettyQrAnimatedView(
                    qrImage: state.qrImage,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(roundFactor: 0.0),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    // var dataCache = state.qrCode.dataCache;
                    final image = await state.qrImage.toImage(
                        size: 800,
                        decoration: const PrettyQrDecoration(
                            shape: PrettyQrSmoothSymbol(roundFactor: 0.0),
                            background: Colors.white));

                    var byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    if (byteData != null) {
                      final result = await ImageGallerySaver.saveImage(
                          byteData.buffer.asUint8List());
                      if (result['isSuccess']) {
                        showToast('图片保存成功');
                      } else {
                        showToast('图片保存失败');
                      }
                    } else {
                      showToast('图片保存失败');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      languageResource.saveQR,
                      style: const TextStyle(color: Color(0xFF2337f9)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    languageResource.rechargeAddress,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        state.currencyInfo.address ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.copy,
                            ),
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: state.currencyInfo.address ?? ""));
                            showToast(languageResource.copySuccess);
                          },
                        )),
                  ],
                ),
              ],
            ),
          );
        },
      ));
}
