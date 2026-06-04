import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/utils/runnable/bean/compatibility_info.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../bean/balance_detail.dart';
import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../bean/fiat_bean.dart';
import '../../../cache/local_storage.dart';
import '../../../custom_widget/load_image.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../pages/main_page/hd_wallet_list_page/item_state.dart';
import '../../../pages/main_page/hd_wallet_page/cryptos_price.dart';
import '../../../pigeons/blockchain_flutter_api.dart';
import '../../../pigeons/blockchain_platform_interface.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/number_util.dart';
import '../../../widget/base_page_loading.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<CardWalletListState>? buildEffect() {
  return combineEffects(<Object, Effect<CardWalletListState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    CardWalletListAction.action: _onAction,
    CardWalletListAction.refresh: _onRefresh,
    CardWalletListAction.syncWallet: _onSynswallet,
    CardWalletListAction.getNewestPrices: _onGetNewestPrices,
    CardWalletListAction.loadCardInfo: _onLoadCardInfo,
    CardWalletListAction.updateCurrency: _onUpdateCurrency,
    CardWalletListAction.getTotalBalance: _onGetTotalBalance,
    CardWalletListAction.blockchainClick: _onBlockchainClick,
    CardWalletListAction.lightningNet: _onLightningNet,
    CardWalletListAction.startTime: _onStartTime,
    CardWalletListAction.showNickNameAlert: _onShowNickNameAlertClick,
    CardWalletListAction.checkIncompatible: _onCheckIncompatible,
    CardWalletListAction.showIncompatibleHelp: _onShowIncompatibleHelp,
  });
}

void _onInit(Action action, Context<CardWalletListState> ctx) {
  BlockchainClient blockchainClient = BlockchainClient();
  ctx.state.subscription = blockchainClient.onUpdateBlockchain.listen((event) {
    List<CurrencyInfoResponse> infoList = event;
    CurrencyInfoResponse? btc = infoList.firstWhereOrNull((element) {
      return element.currencyInfo.currencyData.id.toLowerCase() == 'btc';
    });
    if (btc != null) {
      String initSucStatus = btc.currencyInfo.balance != null ? "1" : "0";
      GlobalState globalState = GlobalStore.store.getState();
      print('GlobalState_isInitBTC:${globalState.isInitBTC}');
      if ((globalState.isInitBTC == null ||
              globalState.isInitBTC != null &&
                  globalState.isInitBTC == false) &&
          initSucStatus == "1") {
        globalState.isInitBTC = true;
        // showToast("Wallet init finish");
      }

      print(
          "btcaddrcode:${btc.code},btc-addrcodeess:${btc.currencyInfo.address}");
    }

    final list = ctx.state.currencyList.map((e) {
      print('_onInitwalee33333t:${e.bean.currencyData.id}');
      final ids = infoList.where((element) {
        print(
            'flutter-updateCurre-currencyInfo:address${element.currencyInfo.currencyData.address}},id:${element.currencyInfo.currencyData.id},symbol:${element.currencyInfo.currencyData.symbol},e.bean.currencyData.id:${e.bean.currencyData.id},symbol:${e.bean.currencyData.symbol},isTest:${element.currencyInfo.isTest},isTest-e:${e.bean.isTest}');
        if (element.currencyInfo.currencyData.id.contains('test')) {
          // 去掉test
          var id = element.currencyInfo.currencyData.id.split('/')[0];
          print(
              'flutter-updateCurre-currencyInfo:address${element.currencyInfo.currencyData.address}},id:${element.currencyInfo.currencyData.id},symbol:${element.currencyInfo.currencyData.symbol}');
          return id.toLowerCase() == e.bean.currencyData.id.toLowerCase();
        }

        if (element.currencyInfo.isTest == true) {
          // 去掉test

          return element.currencyInfo.currencyData.id.toLowerCase() ==
              e.bean.currencyData.id.toLowerCase();
        }

        // if (element.currencyInfo.currencyData.networkId.contains('test')) {
        //   // 去掉test
        //   var id = element.currencyInfo.currencyData.networkId.split('/')[0];
        //   print(
        //       'flutter-updateCurre-currencyInfo:address${element.currencyInfo.currencyData.address}},id:${element.currencyInfo.currencyData.id},symbol:${element.currencyInfo.currencyData.symbol}');
        //   return id.toLowerCase() == e.bean.currencyData.id.toLowerCase();
        // }

        return element.currencyInfo.currencyData.id.toLowerCase() ==
            e.bean.currencyData.id.toLowerCase();
      });
      print('flutter-updatecuttttt:${ids.length}');
      if (ids.isNotEmpty) {
        print(
            'flutter-updatecuttttt-ids:${ids.map((e) => e.currencyInfo.toJson()).toList()}');
      }
      if (ids.isNotEmpty) {
        String? rellayBalance;
        bool ischange = false;
        for (var elementId in ids) {
          print(
              "flutter-updateCurre-_onInitcurrencyDataId:${elementId.currencyInfo.currencyData.id}, address:${elementId.currencyInfo.address},balance:${elementId.currencyInfo.balance}");
          if (elementId.currencyInfo.balance != null) {
            ischange = true;
          }

          if (e.bean.networkLists!.isNotEmpty) {
            var currentInfo =
                e.bean.networkLists!.firstWhereOrNull((elementBen) {
              print(
                  "flutter-updateCurre-_onInitcurrencyDataId-comparision:${elementBen.currencyData.id}==${elementId.currencyInfo.currencyData.id},isTest:${elementId.currencyInfo.isTest},Platform.isIOS:${Platform.isIOS}");

              if (Platform.isIOS && elementId.currencyInfo.isTest == true) {
                print(
                    "flutter-updateCurre-_onInitcurrencyDataId-comparision-ios-test:${elementBen.currencyData.id}==${elementId.currencyInfo.currencyData.id}");
                return elementBen.currencyData.id.toUpperCase() ==
                    elementId.currencyInfo.currencyData.id.toUpperCase();
              }

              if (elementId.currencyInfo.currencyData.id.contains('test')) {
                // 去掉test
                var id = elementId.currencyInfo.currencyData.id.split('/')[0];
                return id.toLowerCase() == e.bean.currencyData.id.toLowerCase();
              } else if (elementId.currencyInfo.isTest == true) {
                if (Platform.isIOS) {
                  return elementBen.currencyData.id.toUpperCase() ==
                      elementId.currencyInfo.currencyData.id.toUpperCase();
                }
                // 去掉test
                if (elementId.currencyInfo.currencyData.networkId
                    .contains('/test')) {
                  var id = elementId.currencyInfo.currencyData.networkId
                      .split('/')[0];

                  return elementBen.currencyData.id.toUpperCase() ==
                          elementId.currencyInfo.currencyData.id
                              .toUpperCase() &&
                      elementBen.currencyData.networkId.toUpperCase() ==
                          id.toUpperCase();
                } else {
                  //    var id =
                  // elementId.currencyInfo.currencyData.networkId.split('/')[0];

                  // return elementBen.currencyData.id.toUpperCase() ==
                  //         elementId.currencyInfo.currencyData.id
                  //             .toUpperCase() &&
                  //     elementBen.currencyData.networkId.toUpperCase() ==
                  //         elementId.currencyInfo.currencyData.networkId
                  //             .toUpperCase();
                  return elementBen.currencyData.id.toUpperCase() ==
                      elementId.currencyInfo.currencyData.id.toUpperCase();
                }
              } else {
                return elementBen.currencyData.id.toUpperCase() ==
                        elementId.currencyInfo.currencyData.id.toUpperCase() &&
                    elementBen.currencyData.networkId.toUpperCase() ==
                        elementId.currencyInfo.currencyData.networkId
                            .toUpperCase();
              }
            });

            if (currentInfo != null) {
              if ((currentInfo.address == null ||
                      currentInfo.address!.isEmpty) &&
                  elementId.currencyInfo.address != null &&
                  elementId.currencyInfo.address!.isNotEmpty) {
                // 如果当前地址为空，则更新地址
                currentInfo.address = elementId.currencyInfo.address;
              }
              if ((currentInfo.address == null ||
                      currentInfo.address!.isEmpty) &&
                  elementId.currencyInfo.currencyData.address != null &&
                  elementId.currencyInfo.currencyData.address!.isNotEmpty) {
                // 如果当前地址为空，则更新地址
                currentInfo.address =
                    elementId.currencyInfo.currencyData.address;
              }
              currentInfo.balance = elementId.currencyInfo.balance;
              if (elementId.currencyInfo.currencyData.publicKey != null) {
                currentInfo.currencyData.publicKey =
                    elementId.currencyInfo.currencyData.publicKey;
              }
              print(
                  "flutter-updateCurre-_onInitcurrencyDataId:${currentInfo.currencyData.id}, address:${currentInfo.address},balance:${currentInfo.balance}");
            }
          }
        }

        if (ischange) {
          // 从 networkLists 汇总各网络余额，避免重复轮询时累加导致余额虚增
          final totalBalance = e.bean.networkLists!
              .where((n) => n.balance != null)
              .fold(
                  0.0, (sum, n) => sum + (double.tryParse(n.balance!) ?? 0.0));
          rellayBalance = totalBalance.toString();
          e.bean.balance = rellayBalance;
          print(
              "flutter-updateCurre:${e.bean.currencyData.symbol}, rellayBalance:$rellayBalance");
          e.loadType = LoadType.loadSuccess;
        } else {
          int failCount =
              e.bean.failCount != null ? int.parse(e.bean.failCount!) : 0;
          failCount += 1;
          if (failCount >= e.bean.networkLists!.length) {
            e.loadType = LoadType.loadFailure;
            e.bean.failCount = "${e.bean.networkLists!.length}";
          } else {
            e.bean.failCount = failCount.toString();
          }

          e.bean.balance = e.bean.balance ?? rellayBalance;
        }
        return e.clone()..bean = e.bean;
      } else {
        return e;
      }
    }).toList();
    ctx.dispatch(CardWalletListActionCreator.onIncompatibleAction());
    ctx.dispatch(CardWalletListActionCreator.onUpdateCurrencyList(list));
    ctx.dispatch(CardWalletListActionCreator.onGetTotalBalance());
    ctx.dispatch(CardWalletListActionCreator.onSyncWallet(list));
  });

  var cardInfo = ctx.state.cardInfo;
  cardInfo.fiatInfo ??= FiatInfo.empty();
  ctx.state.currentFiat = cardInfo.fiatInfo!;

  ///获取币种USDT价格
  final codeList = ctx.state.cardInfo.wallets
      .map((e) => e.currencyData.symbol)
      .toSet()
      .toList();
  ctx.dispatch(CardWalletListActionCreator.onGetNewestPrices(codeList));
  ctx.dispatch(CardWalletListActionCreator.onLoadCardInfo());
  ctx.dispatch(CardWalletListActionCreator.onStartTime());
}

void _onDispose(Action action, Context<CardWalletListState> ctx) {
  ctx.state.subscription?.cancel();
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }
}

Future<void> _onRefresh(Action action, Context<CardWalletListState> ctx) async {
  Future.delayed(const Duration(seconds: 1))
      .then((value) => ctx.state.refreshController.refreshCompleted());
  List<CurrencyInfo> requestList = [];
  ctx.state.cryptoTotalPrice = "0";
  for (var e in ctx.state.currencyList) {
    e.bean.failCount = "0";
    e.bean.balance = "0";
    List<CurrencyInfo> networks = e.bean.networkLists!.map((e1) {
      LogUtils.i("CardWalletListPage-_onRefresh",
          "currencyDataId:${e1.currencyData.id}, address:${e1.address}");
      return e1;
    }).toList();
    requestList.addAll(networks);
  }

  CurrencyInfo? btc = requestList.firstWhereOrNull((element) {
    return element.currencyData.id.toLowerCase() == 'btc';
  });
  if (btc == null) {
    btc = CurrencyInfo(
        imageUrl: '',
        networkName: 'Bitcoin',
        currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'btc'));
    btc.isHide = true;
    requestList.add(btc);
  }

  // ctx.dispatch(HDWalletListActionCreator.onUpdateCurrencyList(ctx.state.currencyList));
  BlockchainPlatform.instance.loadCurrencyInfoList(requestList);
}

Future<void> _onUpdateCurrency(
    Action action, Context<CardWalletListState> ctx) async {
  FiatInfo fiatInfo = ctx.state.currentFiat;
  var result1 = await Navigator.of(ctx.context)
      .pushNamed('selectFiatPage', arguments: {'fiatInfo': fiatInfo});
  if (result1 != null) {
    FiatInfo fiatInfo1 = result1 as FiatInfo;
    ctx.state.currentFiat = fiatInfo1;
    ctx.state.cryptoTotalPrice = "0";
    // 存本地
    ctx.state.cardInfo.fiatInfo = fiatInfo1;
    final cardListStr = ctx.state.cardInfo.toString();
    LocalStorage.saveString(
        LocalStorage.cardInfo + ctx.state.cardInfo.cardId, cardListStr);
// 刷新界面
    var list = ctx.state.currencyList;
    List<CurrencyInfo> requestList = [];
    for (var e in ctx.state.currencyList) {
      requestList.addAll(e.bean.networkLists!);
    }
    ctx.dispatch(CardWalletListActionCreator.onUpdateCurrencyList(list));
    ctx.dispatch(CardWalletListActionCreator.onGetTotalBalance());
    ctx.dispatch(CardWalletListActionCreator.onSyncWallet(list));
  }
}

Future<void> _onSynswallet(
    Action action, Context<CardWalletListState> ctx) async {
  // 币种列表
  List<CurrencyItemState> currencyList = action.payload;
  if (currencyList.isEmpty) {
    print('currencyList is empty');
    return;
  }

  List wallletParames = [];
  for (var element in currencyList) {
    for (var network in element.bean.networkLists!) {
      print(
          'syswallet;network.address:${network.address}, networkId:${network.currencyData.networkId}, symbol:${network.currencyData.symbol}');
      if (network.address == null || network.address!.isEmpty) {
        continue;
      }
      var networkId = network.currencyData.networkId;
      if (networkId.contains('/test')) {
        networkId = networkId.split('/')[0];
      }
      wallletParames.add(<String, dynamic>{
        "address": network.address,
        "chainId": networkId,
        "code": network.currencyData.symbol,
        "name": network.currencyData.name,
      });
    }
  }

  if (wallletParames.isEmpty) {
    print('synswallet data is empty');
    return;
  }

  final data = <String, dynamic>{
    'uid': ctx.state.cardInfo.cardId,
    "wallets": wallletParames
  };
  HttpManager.getInstance()
      .post(NetworkAddress.syncWallet, null, data: data)
      .then((value) {
    print('synswallet result:$value');
  });
}

Future<void> _onGetNewestPrices(
    Action action, Context<CardWalletListState> ctx) async {
  List<String> codes = action.payload;
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.geTokenPrices, null, data: {"codes": codes});

  if (result.isSuccess) {
    List results = result.data;
    Map<String, CryptosPrice> map = ctx.state.cryptosPriceMap;
    for (final element in results) {
      final cryptosPrice = CryptosPrice.fromJson(element);
      map[cryptosPrice.code] = cryptosPrice;
    }

    ctx.dispatch(CardWalletListActionCreator.onUpdateNewestPrice(map));
  } else {
    print("价格获取失败");
  }
}

Future<void> _onShowNickNameAlertClick(
    Action action, Context<CardWalletListState> ctx) async {
  CardInfo info = ctx.state.cardInfo;
  String? nick = await Dialogs.showNickInputDialog(
      languageResource: ctx.state.languageResource!,
      context: ctx.context,
      initText: info.nickName,
      maxLength: 12);
  if (nick != null) {
    info = info.copyWidth(nickName: nick);
    final cardListStr = info.toString();
    LocalStorage.saveString(LocalStorage.cardInfo + info.cardId, cardListStr);

    final data = <String, dynamic>{'uid': info.cardId, "alias": nick};
    HttpManager.getInstance()
        .post(NetworkAddress.syncalias, null, data: data)
        .then((value) {
      // print('syncalias result:${value}');
    });
    ctx.dispatch(CardWalletListActionCreator.onUpdateNickName(info));
  } else {
    print('没有别名');
  }
}

Future<void> _onLoadCardInfo(
    Action action, Context<CardWalletListState> ctx) async {
  // 不管如何都应该可以加载币种余额先

  print("_onLoadCardInfo1:${{DateTime.now()}}");
  final cardInfo = ctx.state.cardInfo;

  List<CurrencyInfo> requestList = [];
  for (var e in cardInfo.wallets) {
    e.failCount = "0";
    e.balance = "0";
    List<CurrencyInfo> networks = e.networkLists!.map((e1) {
      e1.balance = "0";
      LogUtils.i("CardWalletListPage-_onRefresh",
          "currencyDataId:${e1.currencyData.id}, isTest:${e1.isTest}");
      return e1;
    }).toList();
    requestList.addAll(networks);
  }

  CurrencyInfo? btc = requestList.firstWhereOrNull((element) {
    return element.currencyData.id.toLowerCase() == 'btc';
  });
  if (btc == null) {
    btc = CurrencyInfo(
        imageUrl: '',
        networkName: 'Bitcoin',
        currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'btc'));
    btc.isHide = true;
    requestList.add(btc);
  }

  if (requestList.isNotEmpty) {
    BlockchainPlatform.instance.loadCurrencyInfoList(requestList);
  }

  var result = await HttpManager.getInstance().post(
      NetworkAddress.smartCardDetailUrl, null,
      data: {'uid': cardInfo.cardId});
  print("_onLoadCardInfo2:${{DateTime.now()}}");
  if (result.isSuccess) {
    if (result.data != null) {
      CardDetail cardDetail = CardDetail.fromJson(result.data);
      var appletVersion =
          await LocalStorage.getString("${cardInfo.cardId}_appleVersion");
      if (Platform.isIOS && appletVersion == null) {
        appletVersion =
            await LocalStorage.getString("${cardInfo.cardId}_appleVersion1");
      }
      if (appletVersion != null &&
          cardDetail.applet != null &&
          cardDetail.applet!.name != null) {
        cardDetail.applet!.name = appletVersion;
      }
      print("_onLoadCardInfo3:${{DateTime.now()}}");

      if (ctx.state.cardInfo.nickName != (cardDetail.alias ?? '')) {
        final cardInfo =
            ctx.state.cardInfo.copyWidth(nickName: cardDetail.alias ?? '');
        final cardListStr = cardInfo.toString();
        print("_onLoadCardInfo4:${{cardListStr}}");
        LocalStorage.saveString(LocalStorage.cardInfo + cardInfo.cardId,
            json.encode(cardInfo.toJson()));
      }
      ctx.dispatch(CardWalletListActionCreator.onLoadSuccess(cardDetail));

      ctx.dispatch(CardWalletListActionCreator.onIncompatibleAction());
      ctx.dispatch(CardWalletListActionCreator.onLightningNetAction());
    } else {
      showToast(result.message);
    }
  } else {
    showToast(result.message);
  }
}

Future<void> _onGetTotalBalance(
    Action action, Context<CardWalletListState> ctx) async {
  var result = NumberUtils.getFullCount("0");
  for (int i = 0; i < ctx.state.currencyList.length; i++) {
    CurrencyItemState itemState = ctx.state.currencyList[i];
    CryptosPrice? price =
        ctx.state.cryptosPriceMap[itemState.bean.currencyData.symbol];
    if (price == null) {
      continue;
    }
    var temp2 = NumberUtils.getFullCountBetweenTwoNumber(
        ctx.state.currentFiat.currentPrice, price.price.toString(), 2);
    var temp1 = NumberUtils.getFullCountBetweenTwoNumber(
        temp2, itemState.bean.balance ?? "0.0", 2);
    result = NumberUtils.getFullCountBetweenTwoNumber(result, temp1, 0);
  }
  result = NumberUtils.getFullCount(result);
  ctx.state.cryptoTotalPrice = result;
  // print("totoa:" + result);
}

Future<void> _onBlockchainClick(
    Action action, Context<CardWalletListState> ctx) async {
  CurrencyInfo currencyInfo = action.payload;
  final languageResource = ctx.state.languageResource!;
  if (currencyInfo.balance == null) {
    showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(languageResource.notrechargeSend);
        }).then((value) {});
    print("网络问题，该币种暂时不支持充提币操作");
    return;
  }

  ctx.dispatch(CardWalletListActionCreator.onUpdateBlockchainSelected(
      currencyInfo, true));

  double balance = double.tryParse(currencyInfo.balance ?? '') ?? 0;

  String balanceStr = NumberUtils.getEValue(balance);

  var result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: ctx.context,
      builder: (_) {
        return SafeArea(
            child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 100.0, vertical: 10.0),
                height: 4.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                child: Row(
                  children: [
                    ClipOval(
                      //圆形头像
                      child: LoadImage(
                        currencyInfo.imageUrl,
                        width: 45.0,
                        height: 45.0,
                        holderImg: const SizedBox(
                          height: 15,
                          width: 15,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${currencyInfo.currencyData.name}: $balanceStr",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   'IDR 243212',
                        //   style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        // )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(ctx.context).pop(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LoadAssetImage(
                            'coin_recharge_s',
                            width: 35.0,
                            height: 35.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(languageResource.recharge)
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: balance != 0
                          ? () => Navigator.of(ctx.context).pop(1)
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadAssetImage(
                            balance != 0 ? 'coin_withdraw_s' : 'coin_withdraw',
                            width: 35.0,
                            height: 35.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(languageResource.withdraw)
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(ctx.context).pushNamed('webviewPage',
                            arguments: {
                              'pageUrl': NetworkAddress.buyCoinUrl,
                              'title': languageResource.bugCoin
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LoadAssetImage(
                            'coin_withdraw',
                            width: 35.0,
                            height: 35.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(languageResource.bugCoin)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
      });

  await Future.delayed(const Duration(milliseconds: 200));
  ctx.dispatch(CardWalletListActionCreator.onUpdateBlockchainSelected(
      currencyInfo, false));

  if (result == 0) {
    Navigator.of(ctx.context).pushNamed('hdRechargePage', arguments: {
      'currencyInfo': currencyInfo,
      'loadType': 1,
      "isPasswordSet": ctx.state.cardInfo.isPasswordSet
    });
  } else if (result == 1) {
    Navigator.of(ctx.context).pushNamed('hdSendPage', arguments: {
      'currencyInfo': currencyInfo,
      'loadType': 1,
      "isPasswordSet": ctx.state.cardInfo.isPasswordSet
    });
    // Navigator.of(ctx.context).pushNamed('hdRechargeMainPage', arguments: {
    //   'currencyInfo': currencyInfo,
    //   'loadType': 1,
    //   "isPasswordSet": ctx.state.cardInfo.isPasswordSet
    // });
  }
}

Future<void> _onLightningNet(
    Action action, Context<CardWalletListState> ctx) async {
  if (ctx.state.showLightningNet == false) {
    LogUtil.d("闪电网络目前不要查询");
    return;
  }

  final cardDetail = ctx.state.cardInfo.cardDetail;
  if (cardDetail?.uid == null || cardDetail!.uid!.isEmpty) {
    LogUtil.d("闪电网络没有cardDetail.uid，跳过本次查询");
    return;
  }

  LogUtil.d('request light balance');
  var params = {
    'uid': cardDetail.uid!,
  };
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.lightSparkBalance, queryParameters: params);

  if (result.isSuccess) {
    FlashBalance flashBalance = FlashBalance.fromJson(result.data);
    ctx.dispatch(CardWalletListActionCreator.onUpdatelightningNetValueAction(
        flashBalance));
  } else {
    print(result.message);
  }
}

Future<void> _onStartTime(
    Action action, Context<CardWalletListState> ctx) async {
  if (ctx.state.showLightningNet == false) {
    LogUtil.d("闪电网络没有，目前不要启动定时器");
    return;
  }

  const oneSec = Duration(seconds: 1);
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }

  ctx.state.homeTimer = Timer.periodic(oneSec, (Timer timer) {
    ctx.state.homeSeconds--;

    if (ctx.state.homeSeconds == 0) {
      ctx.state.homeSeconds = 60;
      ctx.dispatch(CardWalletListActionCreator.onLightningNetAction());
    } else {
      ctx.dispatch(
          CardWalletListActionCreator.onUpdateTime(ctx.state.homeSeconds));
    }
  });
}

void _onAction(Action action, Context<CardWalletListState> ctx) {}

Future<void> _onCheckIncompatible(
    Action action, Context<CardWalletListState> ctx) async {
  final cardDetail = ctx.state.cardInfo.cardDetail;
  if (cardDetail?.uid == null || cardDetail!.uid!.isEmpty) {
    return;
  }

  String uid = cardDetail.uid!;
  String keyAppletVersionCode = "${uid}_appletVersionCode";
  String appletVersionCode =
      await LocalStorage.getString(keyAppletVersionCode) ?? "";
  var packageInfo = await PackageInfo.fromPlatform();
  String key = "${uid}_${appletVersionCode}_${packageInfo.buildNumber}";
  print("CardWalletListPage:_onCheckIncompatible:key:$key");
  CompatibilityInfo? compatibility = await LocalStorage.getCompatibility(key);
  if (compatibility != null) {
    print(
        "CardWalletListPage:_onCheckIncompatible:compatibility:${compatibility.data}");
    var isIncompatible = compatibility.data.targetName != null ? true : false;
    print(
        "CardWalletListPage:_onCheckIncompatible:isIncompatible:$isIncompatible");
    ctx.state.incompatibleTip =
        compatibility.message != null ? compatibility.message! : "";
    ctx.dispatch(
        CardWalletListActionCreator.onShowIncompatibleAction(isIncompatible));
  }
}

Future<void> _onShowIncompatibleHelp(
    Action action, Context<CardWalletListState> ctx) async {
  final cardDetail = ctx.state.cardInfo.cardDetail;
  if (cardDetail?.uid == null || cardDetail!.uid!.isEmpty) {
    return;
  }

  String uid = cardDetail.uid!;
  String keyAppletVersionCode = "${uid}_appletVersionCode";
  String appletVersionCode =
      await LocalStorage.getString(keyAppletVersionCode) ?? "";
  var packageInfo = await PackageInfo.fromPlatform();
  String key = "${uid}_${appletVersionCode}_${packageInfo.buildNumber}";
  print("CardWalletListPage:_onShowIncompatibleHelp:key:$key");
  CompatibilityInfo? compatibility = await LocalStorage.getCompatibility(key);
  if (compatibility != null && ctx.state.isIncompatible) {
    PageCategoryItem menuItem = compatibility.data;
    if (menuItem.type == 'HREF') {
      var uri = Uri.tryParse(menuItem.target!);
      if (uri != null) {
        String pageUrl = menuItem.target!;
        if (menuItem.token ?? false) {
          var userInfo = LocalStorage.getCacheUserInfo();
          if (menuItem.target!.contains("?")) {
            pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
          } else {
            pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
          }
        }
        Navigator.of(ctx.context).pushNamed('webviewPage',
            arguments: {'pageUrl': pageUrl, 'title': menuItem.name});
      } else {
        showToast("不是有效的url1111");
      }
    } else {
      showToast("不是有效的url000");
    }
  }
}
