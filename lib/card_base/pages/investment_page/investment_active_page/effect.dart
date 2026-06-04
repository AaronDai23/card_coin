import 'package:card_coin/app.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<InvestmentActiveState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentActiveState>>{
    InvestmentActiveAction.action: _onAction,
    Lifecycle.initState: _onInit,
    InvestmentActiveAction.scanCard: _onScanCard,
    InvestmentActiveAction.synsWalletInfo: _onSysnWalletInfo,
    InvestmentActiveAction.activiteCard: _onActiveCard,
    InvestmentActiveAction.approvalDCA: _onApprovalActiveCard,
    InvestmentActiveAction.preActiviteCard: _onPreActiveCard,
    InvestmentActiveAction.loadDefaultCurrency: _onLoadDefaultCurrency,
    InvestmentActiveAction.backClick: _onBackAction,
    InvestmentActiveAction.pushActivtedView: _onCheckPushView,
    InvestmentActiveAction.normalSynsWalletInfo: _onNormalSysnWalletInfo,
    InvestmentActiveAction.normalPushActivtedView: _onNormalCheckPushView,
    InvestmentActiveAction.normalActiviteCard: _onNormalActiveCard
  });
}

void _onAction(Action action, Context<InvestmentActiveState> ctx) {}

Future<void> _onInit(Action action, Context<InvestmentActiveState> ctx) async {
  ctx.dispatch(InvestmentActiveActionCreator.onLoadDefaultCurrency());
}

Future<void> _onLoadDefaultCurrency(
    Action action, Context<InvestmentActiveState> ctx) async {
  List list = [];
  var isProApp = AppConfig.of(navigatorKey.currentContext!).isProApp;
  if (isProApp) {
    final parameters = <String, dynamic>{'asset': true};
    final result = await HttpManager.getInstance()
        .get(NetworkAddress.allcryptoListUrl, queryParameters: parameters);
    if (result.isSuccess) {
      list = (result.data as List);
    } else {
      ctx.dispatch(InvestmentActiveActionCreator.onLoadFailed(result.message));
      return;
    }
  } else {
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
      ctx.dispatch(InvestmentActiveActionCreator.onLoadFailed(result.message));
      return;
    }
  }

  List<CurrencyInfo> currencyList = [];
  List<CoinMessage> tokens =
      list.map((e) => CoinMessage.fromJson(e)).toList().cast<CoinMessage>();

  for (final token in tokens) {
    final list = token.networks.map((e) {
      String networkId = e.networkId;
      if (networkId.contains('ETH') && e.testnet) {
        networkId = "${e.networkId.toUpperCase()}/test";
        print('${e.networkId} is testnet');
      } else {
        networkId = networkId.toUpperCase();
      }
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
      // CurrencyInfo(
      //     imageUrl: '',
      //     networkName: 'Tron',
      //     currencyData: CurrencyData('tron', '', 'TRON', 'TRX', 'tron')),
    ]);
    ctx.state.needBTC = true;
  } else {
    // CurrencyInfo? btcInfo = currencyList.firstWhereOrNull(
    //     (element) => (element.currencyData.id.toLowerCase() == 'btc'));
    // if (btcInfo == null) {
    //   btcInfo = CurrencyInfo(
    //       imageUrl: '',
    //       networkName: 'Bitcoin',
    //       currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'btc'));
    //   btcInfo.isHide = true;
    //   ctx.state.needBTC = false;
    print("sssss4442222");
    // currencyList.add(btcInfo);
    // }
  }
  ctx.dispatch(InvestmentActiveActionCreator.onLoadSuccess(currencyList));
  ctx.dispatch(InvestmentActiveActionCreator.onScanCard());
}

Future<void> _onBackAction(
    Action action, Context<InvestmentActiveState> ctx) async {
  Navigator.of(ctx.context).pop(true);
}

Future<void> _onCheckPushView(
    Action action, Context<InvestmentActiveState> ctx) async {
  if (ctx.state.pushed) {
    return;
  }
  if (ctx.state.progress != 100) {
    ctx.dispatch(InvestmentActiveActionCreator.onUpdateActivedStatus(
        ActivitedStatus.scanActivite));
  }

  if (ctx.state.progress == 100) {
    ctx.state.pushed = true;
    // ctx.dispatch(InvestmentActiveActionCreator.onUpdateActivedStatus(
    //     ActivitedStatus.scanActivite));
    // ctx.dispatch(InvestmentActiveActionCreator.onActivitedSucCard());
    // Future.delayed(const Duration(seconds: 2), () {
    // 2秒后执行的代码
    print('1秒后执行的操作');
    Navigator.of(ctx.context)
        .popAndPushNamed('investmentProcessPage', arguments: {
      'uid': ctx.state.cardId,
      'formIndex': "0",
      'investmentConfig': ctx.state.investmentConfig,
      'isSingle': ctx.state.isSingle,
      'id': ctx.state.id,
    });
    // });
  } else {
    if (ctx.state.activedErrorMsg.isNotEmpty) {
      showToast(ctx.state.activedErrorMsg);
    }
  }
}

Future<void> _onActiveCard(
    Action action, Context<InvestmentActiveState> ctx) async {
  var publicKey = "";
  if (ctx.state.assetFrom!.toUpperCase().contains('BTC')) {
    publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();
  } else {
    publicKey = await BlockchainPlatform.instance.getEthPublicKey();
  }

  var data = <String, dynamic>{
    'uid': ctx.state.cardId,
    'signId': ctx.state.activedDSignId,
    'publicKey': publicKey,
    'signResult': ctx.state.activedDSignReslut,
  };
  print(
      "_onActiveCard:signid:${ctx.state.activedDSignId}, signresult:${ctx.state.activedDSignReslut}");
  print(
      '_onActiveCard_intervalExtend1:${ctx.state.intervalExtend1},intervalExtend2:${ctx.state.intervalExtend2},intervalExtend3:${ctx.state.intervalExtend3}');

  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      (ctx.state.intervalExtend2 == null ||
          ctx.state.intervalExtend2!.isEmpty) &&
      (ctx.state.intervalExtend3 == null ||
          ctx.state.intervalExtend3!.isEmpty)) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
  }
  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      ctx.state.intervalExtend2 != null &&
      ctx.state.intervalExtend2!.isNotEmpty &&
      (ctx.state.intervalExtend3 == null ||
          ctx.state.intervalExtend3!.isEmpty)) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
    data['intervalExtend2'] = ctx.state.intervalExtend2;
  }
  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      ctx.state.intervalExtend2 != null &&
      ctx.state.intervalExtend2!.isNotEmpty &&
      ctx.state.intervalExtend3 != null &&
      ctx.state.intervalExtend3!.isNotEmpty) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
    data['intervalExtend2'] = ctx.state.intervalExtend2;
    data['intervalExtend3'] = ctx.state.intervalExtend3;
  }
  print('investmentActivation:data:${data.toString()}');
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.investmentActivation, null, data: data);
  print('investmentActivation result:$result');
  if (result.isSuccess) {
    ctx.state.progress = 100;
  } else {
    ctx.state.activedErrorMsg = result.message;
  }
  ctx.dispatch(InvestmentActiveActionCreator.onPushActivtedView());
}

Future<void> _onApprovalActiveCard(
    Action action, Context<InvestmentActiveState> ctx) async {
  var publicKey = "";
  if (ctx.state.assetFrom!.toUpperCase().contains('BTC')) {
    publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();
  } else {
    publicKey = await BlockchainPlatform.instance.getEthPublicKey();
  }

  var data = <String, dynamic>{
    'uid': ctx.state.cardId,
    'signId': ctx.state.activedSignId,
    'publicKey': publicKey,
    'signResult': ctx.state.activedSignReslut,
  };
  print(
      "_onActiveCard:signid:${ctx.state.activedSignId}, signresult:${ctx.state.activedSignReslut}");

  print('investmentActivation:data:${data.toString()}');
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.approvalDCA, null, data: data);
  print('investmentapprovalDCA result:${result.isSuccess}');
  if (result.isSuccess) {
    // ctx.state.activedDSignId = result.data['signMessage']['signId'];
    // ctx.state.activedDSignMessage = result.data['signMessage']['signMessage'];
    // String signReslut = "";
    // try {
    //   print("cardMessage_index");
    //   signReslut = await BlockchainPlatform.instance
    //       .signLightning(ctx.state.activedDSignMessage, false);
    //   ctx.state.activedDSignReslut = signReslut;
    ctx.state.progress = 100;
    ctx.dispatch(InvestmentActiveActionCreator.onPushActivtedView());
    // ctx.dispatch(InvestmentActiveActionCreator.onActiviteCard());
    // } catch (error) {
    //   if (error is PlatformException && error.message == 'WrongCardNumber') {
    //     return;
    //   }
    //   showToast(error.toString());
    // }
  } else {
    ctx.state.activedErrorMsg = result.message;
  }
}

Future<void> _onPreActiveCard(
    Action action, Context<InvestmentActiveState> ctx) async {
  var data = <String, dynamic>{
    'uid': ctx.state.cardId,
  };
  print('_onPreActiveCard:data:$data');

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.preApprovalDCA, null, data: data);
  print('_onPreActiveCard result:${result.isSuccess}');
  if (result.isSuccess) {
    ctx.state.activedSignId = result.data['signMessage']['signId'];
    ctx.state.activedSignMessage = result.data['signMessage']['signMessage'];
  } else {
    ctx.state.activedErrorMsg = result.message;
  }
  String signReslut = "";
  try {
    print("cardMessage_index");
    signReslut = await BlockchainPlatform.instance
        .signLightning(ctx.state.activedSignMessage, false);
    ctx.state.activedSignReslut = signReslut;
    ctx.state.progress = 60;
    ctx.dispatch(InvestmentActiveActionCreator.onPushActivtedView());
    ctx.dispatch(InvestmentActiveActionCreator.onApprovalDCA());
  } catch (error) {
    if (error is PlatformException && error.message == 'WrongCardNumber') {
      return;
    }
    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    String errorToString = error.toString();
    if (errorToString.isNotEmpty && errorToString.length < 100) {
      showToast(errorToString);
    }
  }
}

Future<void> _onSysnWalletInfo(
    Action action, Context<InvestmentActiveState> ctx) async {
  // 币种列表
  List<CurrencyInfo> currencyList = action.payload;
  if (currencyList.isEmpty) {
    print('currencyList is empty');
    return;
  }

  List wallletParames = [];
  for (var element in currencyList) {
    for (var network in element.networkLists!) {
      var networkId = network.currencyData.networkId;
      if (networkId.contains('/test')) {
        networkId = networkId.split('/')[0];
      }
      if (network.address == null || network.address!.isEmpty) {
        continue;
      }
      var dict = {
        "chainId": networkId,
        "code": network.currencyData.symbol,
        "name": network.currencyData.name,
      };
      if (element.address != null && element.address!.isNotEmpty) {
        dict["address"] = element.address!;
      }
      wallletParames.add(dict);
    }
  }

  if (wallletParames.isEmpty) {
    print('synswallet data is empty');
    return;
  }

  final data = <String, dynamic>{
    'uid': ctx.state.cardId,
    "wallets": wallletParames
  };
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.syncWallet, null, data: data);
  if (result.isSuccess) {
    ctx.state.progress = 100;
    ctx.dispatch(InvestmentActiveActionCreator.onPushActivtedView());
    // ctx.dispatch(InvestmentActiveActionCreator.onPreActiviteCard());
  } else {
    if (ctx.state.activedErrorMsg.isEmpty) {
      ctx.state.activedErrorMsg = result.message;
    }
  }
}

Future<void> _onScanCard(
    Action action, Context<InvestmentActiveState> ctx) async {
  CardMessage cardMessage;
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  try {
    print("cardMessage_index");
    cardMessage = await BlockchainPlatform.instance.scanCardAndDerive(
        ctx.state.defaultCurrencyList, '',
        cardId: ctx.state.cardId, cardNo: cardNo);
    print("cardMessage_index:${cardMessage.currencyList.length}");
    for (var i = 0; i < cardMessage.currencyList.length; i++) {
      print(
          'cardMessage_index$i,address:${cardMessage.currencyList[i]!.address}');
    }
  } catch (error) {
    if (error is PlatformException && error.message == 'WrongCardNumber') {
      return;
    }
    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    showToast(error.toString());
    return;
  }

  String addressStr = "";
  try {
    addressStr = await BlockchainPlatform.instance
        .makeAddresses("", ctx.state.assetFrom!.toUpperCase().contains('BTC'));
  } catch (error) {
    showToast(error.toString());
    return;
  }
  print("makeAddresses:$addressStr");
  ctx.state.address = addressStr;
  Map<String, CurrencyInfo> object = {};

  final currencies = cardMessage.currencyList.map((e) {
    print('cardMessage_name:${e?.id}');
    if (ctx.state.needBTC == false && e?.id.toLowerCase() == 'btc') {
      return CurrencyInfo.fromCurrencyMessageInBTC(e!, true);
    } else {
      if (e?.id.toLowerCase() == 'btc') {
        return CurrencyInfo.fromCurrencyMessage(e!);
      } else {
        CurrencyInfo info = CurrencyInfo.fromCurrencyMessage(e!);
        info.address = addressStr;
        return info;
      }
    }
  }).toList();

  for (var currency in currencies) {
    if (!object.containsKey(currency.currencyData.id)) {
      print(
          'currency.currencyData.id:${currency.currencyData.id}  ${currency.toJson()}');
      object[currency.currencyData.id] =
          CurrencyInfo.fromJson(currency.toJson());
    }
  }

  final currentIds = object.values.toList();
  for (var element in currentIds) {
    print('currentIds_name:${element.id}');
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
    LocalStorage.saveString(
        LocalStorage.cardInfo + ctx.state.cardId, cardListStr);
    ctx.state.wallets = currentIds;
    ctx.dispatch(InvestmentActiveActionCreator.onUpdateActivedStatus(
        ActivitedStatus.scanActivite));
    if (ctx.state.investmentConfig!.investmentAssetDestination == 'WITHDRAW' ||
        ctx.state.investmentConfig!.investmentAssetDestination ==
            'CENTRALIZED') {
      ctx.dispatch(
          InvestmentActiveActionCreator.onNormalSynsWalletInfo(currentIds));
    } else {
      ctx.dispatch(InvestmentActiveActionCreator.onSynsWalletInfo(currentIds));
    }

    // ScanResponse? result = await showModalBottomSheet<ScanResponse>(
    //   context: ctx.context,
    //   isDismissible: true,
    //   enableDrag: false,
    //   builder: (_) {
    //     return InvestmentActiveCardDialogPage().buildPage({
    //       'cardId': ctx.state.cardId,
    //       'isPinSet': false,
    //       'languageResource': ctx.state.languageResource
    //     });
    //   },
    // );

    // print('showModalBottomSheet result:$result');
    // if (result != null) {

    // }
  }
}

// 普通流程

Future<void> _onNormalSysnWalletInfo(
    Action action, Context<InvestmentActiveState> ctx) async {
  // 币种列表
  List<CurrencyInfo> currencyList = action.payload;
  if (currencyList.isEmpty) {
    print('currencyList is empty');
    return;
  }

  List wallletParames = [];
  for (var element in currencyList) {
    for (var network in element.networkLists!) {
      var networkId = network.currencyData.networkId;
      if (networkId.contains('/test')) {
        networkId = networkId.split('/')[0];
      }

      if (network.address == null || network.address!.isEmpty) {
        continue;
      }

      var dict = {
        "chainId": networkId,
        "code": network.currencyData.symbol,
        "name": network.currencyData.name,
      };
      if (element.address != null && element.address!.isNotEmpty) {
        dict["address"] = element.address!;
      }
      wallletParames.add(dict);
    }
  }

  if (wallletParames.isEmpty) {
    print('synswallet data is empty');
    return;
  }

  final data = <String, dynamic>{
    'uid': ctx.state.cardId,
    "wallets": wallletParames
  };
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.syncWallet, null, data: data);
  if (result.isSuccess) {
    ctx.state.progress = 50;
    ctx.dispatch(InvestmentActiveActionCreator.onNormalPushActivtedView());

    ctx.dispatch(InvestmentActiveActionCreator.onNormalActiviteCard());
  } else {
    if (ctx.state.activedErrorMsg.isEmpty) {
      ctx.state.activedErrorMsg = result.message;
    }
  }
}

Future<void> _onNormalCheckPushView(
    Action action, Context<InvestmentActiveState> ctx) async {
  if (ctx.state.pushed) {
    return;
  }
  if (ctx.state.progress != 100) {
    ctx.dispatch(InvestmentActiveActionCreator.onUpdateActivedStatus(
        ActivitedStatus.scanActivite));
  }

  if (ctx.state.progress == 100) {
    ctx.state.pushed = true;
    ctx.dispatch(InvestmentActiveActionCreator.onUpdateActivedStatus(
        ActivitedStatus.scanActivite));
    ctx.dispatch(InvestmentActiveActionCreator.onActivitedSucCard());
    Future.delayed(const Duration(seconds: 2), () {
      // 2秒后执行的代码
      print('1秒后执行的操作');
      Navigator.of(ctx.context).popAndPushNamed('investmentPage', arguments: {
        'uid': ctx.state.cardId,
        'formIndex': "0",
        'investmentConfig': ctx.state.investmentConfig
      });
    });
  } else {
    if (ctx.state.activedErrorMsg.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    if (ctx.state.activedErrorMsg.isNotEmpty) {
      showToast(ctx.state.activedErrorMsg);
    }
  }
}

Future<void> _onNormalActiveCard(
    Action action, Context<InvestmentActiveState> ctx) async {
  var publicKey = "";
  if (ctx.state.assetFrom!.toUpperCase().contains('BTC')) {
    publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();
  }

  var data = <String, dynamic>{
    'uid': ctx.state.cardId,
    'publicKey': publicKey,
  };
  print(
      '_onActiveCard_intervalExtend1:${ctx.state.intervalExtend1},intervalExtend2:${ctx.state.intervalExtend2},intervalExtend3:${ctx.state.intervalExtend3}');

  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      (ctx.state.intervalExtend2 == null ||
          ctx.state.intervalExtend2!.isEmpty) &&
      (ctx.state.intervalExtend3 == null ||
          ctx.state.intervalExtend3!.isEmpty)) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
  }
  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      ctx.state.intervalExtend2 != null &&
      ctx.state.intervalExtend2!.isNotEmpty &&
      (ctx.state.intervalExtend3 == null ||
          ctx.state.intervalExtend3!.isEmpty)) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
    data['intervalExtend2'] = ctx.state.intervalExtend2;
  }
  if (ctx.state.intervalExtend1 != null &&
      ctx.state.intervalExtend1!.isNotEmpty &&
      ctx.state.intervalExtend2 != null &&
      ctx.state.intervalExtend2!.isNotEmpty &&
      ctx.state.intervalExtend3 != null &&
      ctx.state.intervalExtend3!.isNotEmpty) {
    //  data
    data['intervalExtend1'] = ctx.state.intervalExtend1;
    data['intervalExtend2'] = ctx.state.intervalExtend2;
    data['intervalExtend3'] = ctx.state.intervalExtend3;
  }
  print('investmentActivation:data:${data.toString()}');
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.investmentActivation, null, data: data);
  print('investmentActivation result:$result');
  if (result.isSuccess) {
    ctx.state.progress = 100;
  } else {
    ctx.state.activedErrorMsg = result.message;
  }
  ctx.dispatch(InvestmentActiveActionCreator.onNormalPushActivtedView());
}
