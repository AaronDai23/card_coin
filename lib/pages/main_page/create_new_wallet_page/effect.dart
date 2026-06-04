import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../cache/local_storage.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../utils/hex_utils.dart';
import 'action.dart';
import 'state.dart';
import 'package:collection/collection.dart';

Effect<CreateNewWalletState>? buildEffect() {
  return combineEffects(<Object, Effect<CreateNewWalletState>>{
    Lifecycle.initState: _onInit,
    // CreateNewWalletAction.action: _onAction,
    CreateNewWalletAction.loadCardInfo: _onLoadCardInfo,
    CreateNewWalletAction.createWalletClick: _onCreateWalletClick
  });
}

void _onInit(Action action, Context<CreateNewWalletState> ctx) {
  ctx.dispatch(CreateNewWalletActionCreator.onLoadCardInfo(ctx.state.cardInfo));
}

Future<void> _onCreateWalletClick(
    Action action, Context<CreateNewWalletState> ctx) async {
  try {
    final cardMessage = await BlockchainPlatform.instance
        .createWalletAndDerive(ctx.state.defaultCurrencyList);
    final currencies = cardMessage.currencyList
        .map((e) => CurrencyInfo.fromCurrencyMessage(e!))
        .toList();

    List<CurrencyInfo> currentIds = [];

    Map<String, CurrencyInfo> object = {};
    for (var e1 in currencies) {
      if (!object.containsKey(e1.currencyData.id)) {
        object[e1.currencyData.id] = CurrencyInfo.fromJson(e1.toJson());
      }
    }

    currentIds = object.values.toList();
    for (var element in currentIds) {
      List<CurrencyInfo> ids = currencies
          .where((element1) =>
              element1.currencyData.id.toLowerCase() ==
              element.currencyData.id.toLowerCase())
          .toList();
      element.networkLists = ids;
    }

    var cardInfo = ctx.state.cardInfoList
        .firstWhereOrNull((element) => element.cardId == cardMessage.uid);

    for (var element in ctx.state.cardInfoList) {
      element.isSelected = false;
    }
    if (cardInfo == null) {
      cardInfo = CardInfo(
          cardId: cardMessage.uid,
          publicKey: HexUtils.uint8ListToHex(cardMessage.publicKey),
          wallets: currentIds,
          isSelected: true);
      ctx.state.cardInfoList.add(cardInfo);
    } else {
      cardInfo.wallets = currentIds;
      cardInfo.isSelected = true;
    }
    String? cardUuid = await LocalStorage.getCardUuid();
    final cardListStr =
        ctx.state.cardInfoList.map((e) => e.toString()).toList();
    LocalStorage.saveStringList(
        LocalStorage.cardInfoList + cardUuid!, cardListStr);

    Navigator.of(ctx.context).pushReplacementNamed('hdWalletListPage',
        arguments: {'cardInfoList': ctx.state.cardInfoList});
  } catch (error) {
    print('Scan card failed:$error');
    if (error is! PlatformException) {
      showToast(
          '${GlobalStore.store.getState().languageResource!.scanCardFailed}:$error');
    }
  }
}

Future<void> _onLoadCardInfo(
    Action action, Context<CreateNewWalletState> ctx) async {
  var cardInfo = action.payload;
  var result = await HttpManager.getInstance().post(
      NetworkAddress.smartCardDetailUrl, null,
      data: {'uid': cardInfo.cardId});

  if (result.isSuccess) {
    CardDetail? cardDetail;
    if (result.data != null) {
      cardDetail = CardDetail.fromJson(result.data);
      cardInfo.cardDetail = cardDetail;
      ctx.dispatch(CreateNewWalletActionCreator.onLoadSuccess(cardDetail));
    } else {
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(
                '${result.message},uid:${cardInfo.cardId}');
          });
      Navigator.of(ctx.context).pop();
    }
  } else {
    ctx.dispatch(CreateNewWalletActionCreator.onLoadFailure(result.message));
  }
}
