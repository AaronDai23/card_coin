import 'dart:async';
import 'dart:convert';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:collection/collection.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../bean/coin_message.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../pigeons/blockchain_platform_interface.dart';
import '../../../utils/hex_utils.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<ScanWalletState>? buildEffect() {
  return combineEffects(<Object, Effect<ScanWalletState>>{
    ScanWalletAction.action: _onAction,
    Lifecycle.initState: _onInit,
    ScanWalletAction.scanCard: _onScanCard,
    ScanWalletAction.loadDefaultCurrency: _onLoadDefaultCurrency,
  });
}

void _onAction(Action action, Context<ScanWalletState> ctx) {}

/// 记录后台刷新任务，_onScanCard 扫卡前先等待其完成
Completer<void>? _refreshCompleter;

Future<void> _onInit(Action action, Context<ScanWalletState> ctx) async {
  final cardId = ctx.state.cardId;
  final cached = await _loadCurrencyListFromDisk(cardId);
  if (cached != null && cached.isNotEmpty) {
    cacheCurrencyList(cardId, cached);
    ctx.dispatch(ScanWalletActionCreator.onLoadSuccess(cached));
  }
  // 首次进入也不阻塞首屏，直接后台刷新；但记录 future 以便扫卡时等待
  _refreshCompleter = Completer<void>();
  _refreshCurrencyInBackground(ctx).then((_) {
    if (!(_refreshCompleter?.isCompleted ?? true)) {
      _refreshCompleter!.complete();
    }
  }).catchError((_) {
    if (!(_refreshCompleter?.isCompleted ?? true)) {
      _refreshCompleter!.complete();
    }
  });
}

Future<void> _onLoadDefaultCurrency(
    Action action, Context<ScanWalletState> ctx) async {
  await _fetchAndApplyCurrencyList(ctx, showError: true);
}

/// 后台静默刷新（不更新 loadStatus，不报错）
Future<void> _refreshCurrencyInBackground(Context<ScanWalletState> ctx) async {
  await _fetchAndApplyCurrencyList(ctx, showError: false);
}

Future<void> _fetchAndApplyCurrencyList(Context<ScanWalletState> ctx,
    {required bool showError}) async {
  List list = [];
  // var isProApp = AppConfig.of(navigatorKey.currentContext!).isProApp;
  // if (isProApp) {
  //   final parameters = <String, dynamic>{'asset': true};
  //   final result = await HttpManager.getInstance()
  //       .get(NetworkAddress.allcryptoListUrl, queryParameters: parameters);
  //   if (result.isSuccess) {
  //     list = (result.data as List);
  //   } else {
  //     ctx.dispatch(ScanWalletActionCreator.onLoadFailed(result.message));
  //     return;
  //   }
  // } else {
  var dict = {
    'page': '1',
    'row': 20,
    'uid': ctx.state.cardId,
    'isDefault': true
  };

  final result = await HttpManager.getInstance()
      .get(NetworkAddress.cryptoListUrl, queryParameters: dict);
  if (result.isSuccess) {
    print('22222result.data:${result.data}');
    list = (result.data['rows'] as List);
  } else {
    if (showError) {
      ctx.dispatch(ScanWalletActionCreator.onLoadFailed(result.message));
    }
    return;
  }
  // }

  List<CurrencyInfo> currencyList = [];
  List<CoinMessage> tokens =
      list.map((e) => CoinMessage.fromJson(e)).toList().cast<CoinMessage>();

  for (final token in tokens) {
    final list = token.networks.map((e) {
      String networkId = e.networkId;
      print('networkId_before:$networkId, testnet:${e.testnet}');
      if (networkId.contains('ETH') && e.testnet) {
        networkId = "${e.networkId.toUpperCase()}/test";
      } else {
        networkId = networkId.toUpperCase();
      }
      print('networkId_after:$networkId, testnet:${e.testnet}');
      return CurrencyInfo(
          imageUrl: token.imageUrl,
          networkName: e.networkName,
          isTest: e.testnet,
          currencyData: CurrencyData(
              token.id, e.imageUrl, token.name, token.symbol, networkId,
              decimals: e.decimalCount, contractAddress: e.contractAddress));
    });
    currencyList.addAll(list);
  }

  if (currencyList.isEmpty) {
    currencyList.addAll([
      CurrencyInfo(
          imageUrl: '',
          networkName: 'Bitcoin',
          currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC')),
      CurrencyInfo(
          imageUrl: '',
          networkName: 'Tron',
          currencyData: CurrencyData('tron', '', 'TRON', 'TRX', 'tron')),
    ]);
    ctx.state.needBTC = true;
  } else {
    CurrencyInfo? btcInfo = currencyList.firstWhereOrNull(
        (element) => (element.currencyData.id.toLowerCase() == 'btc'));
    if (btcInfo == null) {
      btcInfo = CurrencyInfo(
          imageUrl: '',
          networkName: 'Bitcoin',
          currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC'));
      btcInfo.isHide = true;
      ctx.state.needBTC = false;
      print("sssss4442222");
      currencyList.add(btcInfo);
    } else {
      ctx.state.needBTC = true;
    }
  }
  ctx.dispatch(ScanWalletActionCreator.onLoadSuccess(currencyList));
  // 写入内存缓存和磁盘缓存
  cacheCurrencyList(ctx.state.cardId, currencyList);
  await _saveCurrencyListToDisk(ctx.state.cardId, currencyList);
}

const _currencyListCachePrefix = 'scan_wallet_currency_v1_';

Future<List<CurrencyInfo>?> _loadCurrencyListFromDisk(String cardId) async {
  try {
    final raw = await LocalStorage.getString(_currencyListCachePrefix + cardId);
    if (raw == null || raw.isEmpty) return null;
    final decoded = json.decode(raw) as List;
    return decoded.map((e) => CurrencyInfo.fromJson(e)).toList();
  } catch (_) {
    return null;
  }
}

Future<void> _saveCurrencyListToDisk(
    String cardId, List<CurrencyInfo> list) async {
  try {
    final encoded = json.encode(list.map((e) => e.toJson()).toList());
    await LocalStorage.saveString(_currencyListCachePrefix + cardId, encoded);
  } catch (_) {}
}

Future<void> _onScanCard(Action action, Context<ScanWalletState> ctx) async {
  // 若后台刷新未完成，先等待，确保 defaultCurrencyList 包含服务器全量币种
  if (_refreshCompleter != null && !(_refreshCompleter!.isCompleted)) {
    await _refreshCompleter!.future;
  }

  CardMessage cardMessage;
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  try {
    cardMessage = await BlockchainPlatform.instance.scanCardAndDerive(
        ctx.state.defaultCurrencyList, '',
        cardId: ctx.state.cardId, cardNo: cardNo);
  } catch (error) {
    if (error is PlatformException) {
      final isWrongCard =
          error.code == 'uid-mismatch' || error.message == 'WrongCardNumber';
      if (isWrongCard) {
        await _showFrontErrorDialog(
            ctx.context, 'Wrong card. Please use the correct card.');
        return;
      }
    }

    String errorToString = error.toString();
    if (errorToString.isNotEmpty && errorToString.length < 100) {
      if (errorToString.contains("user-cancelled")) {
        errorToString = 'Scan cancelled by user.';
      }
      showToast(errorToString);
    }
    return;
  }
  // // 扫卡成功震动反馈
  // if (await Vibration.hasVibrator() ?? false) {
  //   Vibration.vibrate(duration: 200);
  // }
  print(
      "ScanWalletPage-_onScanCard-cardMessage:${cardMessage.toString()}, cardNo:$cardNo");

  Map<String, CurrencyInfo> object = {};

  final currencies = cardMessage.currencyList.map((e) {
    print('cardMessage_name:${e?.id}, isTest:${e?.isTest}');
    if (ctx.state.needBTC == false && e?.id.toLowerCase() == 'btc') {
      return CurrencyInfo.fromCurrencyMessageInBTC(e!, true);
    } else {
      return CurrencyInfo.fromCurrencyMessage(e!);
    }
  }).toList();

  for (var currency in currencies) {
    if (!object.containsKey(currency.currencyData.id)) {
      object[currency.currencyData.id] =
          CurrencyInfo.fromJson(currency.toJson());
    }
  }

  final currentIds = object.values.toList();
  for (var element in currentIds) {
    print(
        'currentIds_name:${element.id}, istest:${element.isTest} networks:${element.networkLists?.length}');
    List<CurrencyInfo> ids = currencies
        .where((element1) =>
            element1.currencyData.id.toLowerCase() ==
            element.currencyData.id.toLowerCase())
        .toList();
    element.networkLists = ids;
  }

  print('currentIds_leng:${currentIds.length}');

  CardInfo cardInfo = CardInfo(
      cardId: ctx.state.cardId,
      publicKey: HexUtils.uint8ListToHex(cardMessage.publicKey),
      wallets: currentIds.isNotEmpty ? currentIds : [],
      isSelected: true);

  if (cardInfo.publicKey.isEmpty) {
    LocalStorage.remove(LocalStorage.cardInfo + ctx.state.cardId);
    Navigator.of(ctx.context).pushNamed('createNewWalletPage', arguments: {
      'cardInfo': cardInfo,
    });
  } else {
    final cardListStr = cardInfo.toString();
    print('_onScanCard-cardListStr:$cardListStr, cardId:${ctx.state.cardId}');
    LocalStorage.saveString(
        LocalStorage.cardInfo + ctx.state.cardId, cardListStr);
    Navigator.of(ctx.context).pushReplacementNamed('cardWalletListPage',
        arguments: {
          'cardInfo': cardInfo,
          'needShowInitStatus': ctx.state.needShowInitStatus
        });
  }
}

Future<void> _showFrontErrorDialog(BuildContext context, String message) async {
  // Allow the native NFC overlay a moment to dismiss before presenting Flutter dialog.
  await Future.delayed(const Duration(milliseconds: 180));
  if (!context.mounted) return;
  await showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (_) => ZenggeTextAlertDialog(
      message,
      confirmText: 'Confirm',
    ),
  );
}
