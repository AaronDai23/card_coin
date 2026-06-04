import 'dart:convert';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:card_coin/utils/runnable/store_ndef_data_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:oktoast/oktoast.dart';
import '../../../custom_widget/scan_card.dart';
import 'action.dart';
import 'state.dart';
import 'package:collection/src/iterable_extensions.dart';

Effect<WriteCardState>? buildEffect() {
  return combineEffects(<Object, Effect<WriteCardState>>{
    // WriteCardAction.writeClick: _onWriteCard,
    Lifecycle.initState: _onInit,
    WriteCardAction.readCard: _onReadCard,
    WriteCardAction.showCurrencyInfos: _onShowCurrencyInfoList,
    WriteCardAction.update: _onUpdate,
    WriteCardAction.writeClick: _newWriteData,
  });
}

void _onInit(Action action, Context<WriteCardState> ctx) {
  CardInfo info = ctx.state.cardInfo;
  // if (info.address != null) {
  ctx.dispatch(WriteCardActionCreator.onShowCurrencyInfos(info));
  // }
}

Future<void> _onUpdate(Action action, Context<WriteCardState> ctx) async {
  CurrencyInfo info = action.payload;

  if (info.balance != null) {
    ctx.dispatch(WriteCardActionCreator.onLoadSuccess(info));
  } else {
    ctx.dispatch(WriteCardActionCreator.onShowLoading());
  }
}

Future<void> _onShowCurrencyInfoList(
    Action action, Context<WriteCardState> ctx) async {
  await Future.delayed(const Duration(seconds: 0));

  CardInfo info = ctx.state.cardInfo;

  _findShowCoins(action, ctx, info.wallets);
  await showModalBottomSheet(
      context: ctx.context,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      builder: ((_) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("请选择写入NDEF币种"),
                      CloseButton(
                        onPressed: () {
                          Navigator.of(ctx.context).pop();
                          Navigator.of(ctx.context).pop();
                        },
                      )
                    ]),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: ctx.state.currencyInfos.length,
                      itemBuilder: (context, index) {
                        final cardInfo = ctx.state.currencyInfos[index];
                        return GestureDetector(
                            onTap: () {
                              // if (cardInfo.balance == null ||
                              //     cardInfo.address == null) {
                              //   _showTipView(action, ctx);
                              //   return;
                              // }
                              ctx.state.index = index;
                              Navigator.of(ctx.context).pop();
                              ctx.dispatch(
                                  WriteCardActionCreator.onUpate(cardInfo));
                            },
                            child: _itemWidgetBuild(ctx, context, cardInfo));
                      }),
                )
              ],
            ));
      }));
}

int _findShowCoins(
    Action action, Context<WriteCardState> ctx, List<CurrencyInfo> currencys) {
  List<CurrencyInfo> news = [];
  for (CurrencyInfo element in currencys) {
    if (_checkShowCoin(action, element) != null) {
      news.add(_checkShowCoin(action, element)!);
    }
  }

  ctx.state.currencyInfos = news;

  return news.length;
}

CurrencyInfo? _checkShowCoin(Action action, CurrencyInfo currencyInfo) {
  final allCurrencyList = currencyInfo.networkLists!;
  CurrencyInfo? info = allCurrencyList.firstWhereOrNull((element) {
    return element.currencyData.contractAddress == null;
  });
  return info;
}

Widget _itemWidgetBuild(
    Context<WriteCardState> ctx, BuildContext context, CurrencyInfo currency) {
  String coin =
      "${currency.currencyData.id}-${currency.currencyData.networkId.toUpperCase()}";
  return Card(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              coin,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        )),
  );
}

Future<void> _newWriteData(Action action, Context<WriteCardState> ctx) async {
  String ndefStr =
      "${ctx.state.currencyInfo.currencyData.id}/${ctx.state.currencyInfo.address ?? ""}";

  List<int> pukIntList = ndefStr.codeUnits;
  // ;
  // try {
  //   for (int i = 0; i < ndefStr.length; i++) {
  //     pukIntList.add(int.parse(ndefStr[i]));
  //   }
  //   // pukCode = Uint8List.fromList(pukIntList);
  // } catch (error) {
  //   showToast('待写入数据格式错误');
  //   return;
  // }
  if (ndefStr.isNotEmpty) {
    String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
    var response = await ScanUtil.chipScanWithRunnable(
        StoreNdefDataRunnable(ndef: pukIntList),
        expectedCardId: ctx.state.cardId,
        cardNo: cardNo);
    if (response.isSuccess) {
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return const ZenggeTextAlertDialog('Success to "Ndef Write');
          });
      Navigator.of(ctx.context).pop();
    } else {
      // if (response.message != "Session invalidated by user") {
      //   showToast(response.message!);
      // }
    }
  } else {
    showToast("ndef date is empty");
  }
}

Future<void> _onReadCard(Action action, Context<WriteCardState> ctx) async {
  showModalBottomSheet(
    context: ctx.context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (context) => ScanCard(
      appLanguageResource: ctx.state.languageResource,
      onCancel: () {
        Navigator.of(context).pop();
        NfcManager.instance.stopSession();
        // completer.completeError('User cancel');
      },
    ),
  );

  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    var tagData = json.encode(tag.data);
    if (tag.data.keys.contains('isodep')) {
      var isoDep = IsoDep.from(tag);
      if (isoDep != null) {
        var cardId = HexUtils.uint8ListToHex(isoDep.identifier);
        if (ctx.state.cardId != cardId) {
          print('card is wrong');
          NfcManager.instance.stopSession();
          Navigator.of(ctx.context).pop();
          showToast('This card does not contain the current wallet');
          return;
        }
      }
    }
    print('tagData === $tagData');
    ctx.dispatch(WriteCardActionCreator.onUpdateData(tagData));
    NfcManager.instance.stopSession();
    Navigator.of(ctx.context).pop(tag.data);
  });
}
