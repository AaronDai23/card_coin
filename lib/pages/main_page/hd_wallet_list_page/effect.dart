import 'dart:async';
import 'dart:convert';

import 'package:card_coin/app.dart';
import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/custom_widget/mutile_select.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/item_state.dart';
import 'package:card_coin/pigeons/blockchain_flutter_api.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/deep_link_manager.dart';
import 'package:card_coin/utils/dialogs.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:collection/collection.dart';
import 'package:vibration/vibration.dart';
import 'package:oktoast/oktoast.dart';
import '../../../utils/string_util.dart';
import '../hd_wallet_page/cryptos_price.dart';
import 'action.dart';
import 'state.dart';

Effect<HDWalletListState>? buildEffect() {
  return combineEffects(<Object, Effect<HDWalletListState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    HDWalletListAction.loadCardInfo: _onLoadCardInfo,
    HDWalletListAction.addBlockchainClick: _onAddBlockchainClick,
    HDWalletListAction.blockchainClick: _onBlockchainClick,
    HDWalletListAction.getNewestPrices: _onGetNewestPrices,
    HDWalletListAction.showCardInfoList: _onShowCardInfoList,
    HDWalletListAction.changeWallet: _onChangeWallet,
    HDWalletListAction.showNickNameAlert: _onShowNickNameAlertClick,
    HDWalletListAction.removeCard: _onRemoveCard,
    HDWalletListAction.scanCard: _onScanCard,
    HDWalletListAction.addWalletClick: _onLoadDefaultCurrency,
    HDWalletListAction.updateCurrency: _onUpdateCurrency,
    HDWalletListAction.refresh: _onRefresh,
    HDWalletListAction.syncWallet: _onSynswallet,
    HDWalletListAction.loadAllcryptoList: _onLoadAllcryptoList,
    HDWalletListAction.getTotalBalance: _onGetTotalBalance,
    HDWalletListAction.addBlockchainTip: _onAddBlockchainTip,
    HDWalletListAction.ndefDomain: _onGetNdefLink,
    HDWalletListAction.lightningNet: _onLightningNet,
    HDWalletListAction.lightningNetDetail: _onLightningNet,
    HDWalletListAction.startTime: _onStartTime,
  });
}

void _onInit(Action action, Context<HDWalletListState> ctx) {
  BlockchainClient blockchainClient = BlockchainClient();
  ctx.state.subscription = blockchainClient.onUpdateBlockchain.listen((event) {
    print('onUpdate Blockchain');
    List<CurrencyInfoResponse> infoList = event;
    print("onUpdateBlockchain${infoList.toString()}");

    final list = ctx.state.currencyList.map((e) {
      final ids = infoList.where((element) {
        return element.currencyInfo.currencyData.id.toLowerCase() ==
            e.bean.currencyData.id.toLowerCase();
      });
      if (ids.isNotEmpty) {
        String? rellayBalance;
        bool ischange = false;
        for (var elementId in ids) {
          if (elementId.currencyInfo.balance != null) {
            ischange = true;
            print("onUpdateBlockchain-change- yes");
          }
          print(
              "onUpdateBlockchain-change ischange:$ischange,ids:${elementId.currencyInfo.currencyData.symbol}");

          if (e.bean.networkLists!.isNotEmpty) {
            var currentInfo =
                e.bean.networkLists!.firstWhereOrNull((elementBen) {
              return elementBen.currencyData.id.toUpperCase() ==
                      elementId.currencyInfo.currencyData.id.toUpperCase() &&
                  elementBen.currencyData.networkId.toUpperCase() ==
                      elementId.currencyInfo.currencyData.networkId
                          .toUpperCase();
            });
            if (currentInfo != null) {
              if (elementId.currencyInfo.currencyData.id.toLowerCase() ==
                  "btc".toLowerCase()) {
                // ctx.state.lightningNetId = elementId.currencyInfo.address!;
              }
              currentInfo.address = elementId.currencyInfo.address;
              currentInfo.balance = elementId.currencyInfo.balance;
              if (elementId.currencyInfo.currencyData.publicKey != null) {
                currentInfo.currencyData.publicKey =
                    elementId.currencyInfo.currencyData.publicKey;
              }

              print("sss:${currentInfo.currencyData.symbol}");
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
    ctx.dispatch(HDWalletListActionCreator.onUpdateCurrencyList(list));
    ctx.dispatch(HDWalletListActionCreator.onGetTotalBalance());
    ctx.dispatch(HDWalletListActionCreator.onSyncWallet(list));
  });

  var cardInfo = ctx.state.cardInfoList[ctx.state.currentIndex];
  for (var element in cardInfo.wallets) {
    element.failCount = "0";
    element.balance = "0";
  }

  cardInfo.fiatInfo = cardInfo.fiatInfo ??
      FiatInfo(
          symbol: 'USDT',
          imageUrl: '',
          name: "USDT",
          currentPrice: "1.00",
          scale: '2',
          currency: '\$');
  ctx.state.currentFiat = cardInfo.fiatInfo!;

  ///获取币种USDT价格
  final codeList = ctx.state.cardInfo.wallets
      .map((e) => e.currencyData.symbol)
      .toSet()
      .toList();
  ctx.dispatch(HDWalletListActionCreator.onGetNewestPrices(codeList));
  ctx.dispatch(HDWalletListActionCreator.onLoadCardInfo());
  ctx.dispatch(HDWalletListActionCreator.onStartTime());
}

Future<void> _onGetNdefLink(
    Action action, Context<HDWalletListState> ctx) async {
  final result = await HttpManager.getInstance()
      .post(NetworkAddress.ndefDomain, null, data: null);

  if (result.isSuccess) {
    LogUtil.d('result.data:${result.data}');
    if (result.data != null) {
      ctx.state.ndefLink = result.data;
    }
  } else {}
}

Future<void> _onGetNewestPrices(
    Action action, Context<HDWalletListState> ctx) async {
  List<String> codes = action.payload;
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.geTokenPrices, null, data: {"codes": codes});

  if (result.isSuccess) {
    List results = result.data;
    List<CryptosPrice> list = results.map((e) {
      return CryptosPrice.fromJson(e);
    }).toList();

    Map<String, CryptosPrice> map = ctx.state.cryptosPriceMap;
    for (CryptosPrice element in list) {
      map[element.code] = element;
    }
    ctx.dispatch(HDWalletListActionCreator.onUpdateNewestPrice(map));
  } else {
    print("价格获取失败");
  }
}

Future<void> _onLoadAllcryptoList(
    Action action, Context<HDWalletListState> ctx) async {
  if (AppConfig.of(navigatorKey.currentContext!).isProApp == false) {
    return;
  }
  // 1.获取本地缓存的支持的完整币种列表md5
  String? localMd5 =
      await LocalStorage.getString(LocalStorage.allCryptoListMd5);

  ResultData allcryptoResult =
      await HttpManager.getInstance().get(NetworkAddress.allcryptoMd5);
  String lastMd5 = '';
  if (allcryptoResult.isSuccess) {
    lastMd5 = allcryptoResult.data ?? '';
  }
  List<CurrencyInfo> currencyList = [];
  if (lastMd5 != localMd5) {
    // 比较本地支持币种的完整列表md5和后台最新支持币种的完整列表md5，如果不一致，则请求后台最新支持币种的完整列表
    final parameters = <String, dynamic>{};
    final result = await HttpManager.getInstance()
        .get(NetworkAddress.allcryptoListUrl, queryParameters: parameters);
    if (result.isSuccess) {
      List<CoinMessage> tokens = (result.data as List)
          .map((e) => CoinMessage.fromJson(e))
          .toList()
          .cast<CoinMessage>();

      for (final token in tokens) {
        final list = token.networks.map((e) {
          String networkId = e.networkId;
          if (networkId.contains('ETH') && e.testnet) {
            networkId = "${e.networkId.toUpperCase()}/test";
          } else {
            networkId = networkId.toUpperCase();
          }
          return CurrencyInfo(
              imageUrl: token.imageUrl,
              isTest: e.testnet,
              currencyData: CurrencyData(
                  token.id, e.imageUrl, token.name, token.symbol, networkId,
                  decimals: e.decimalCount,
                  contractAddress: e.contractAddress));
        });
        currencyList.addAll(list);
      }

      final currencyListStr = currencyList.map((e) => e.toString()).toList();
      await LocalStorage.saveStringList(
          LocalStorage.allCryptoList, currencyListStr);
      await LocalStorage.saveString(LocalStorage.allCryptoListMd5, lastMd5);
      print("load allcryptoLis suc");
    } else {
      // ctx.dispatch(HDWalletListState.(result.message));
      print("load allcryptoLis fail");
    }
  } else {
    print("local md5 equal to network md5");
  }
}

Future<void> _onLoadDefaultCurrency(
    Action action, Context<HDWalletListState> ctx) async {
  if (AppConfig.of(navigatorKey.currentContext!).isProApp == false) {
    ctx.dispatch(HDWalletListActionCreator.onScanCardClick([]));
    return;
  }

  // 先获取完整币种列表
  await ctx.dispatch(HDWalletListActionCreator.onLoadAllcryptoList());

  final parameters = <String, dynamic>{'asset': true}; //获取默认币种列表
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.allcryptoListUrl, queryParameters: parameters);
  if (result.isSuccess) {
    List<CoinMessage> tokens = (result.data as List)
        .map((e) => CoinMessage.fromJson(e))
        .toList()
        .cast<CoinMessage>();
    //2.解析后台默认加密货币列表
    List<CurrencyInfo> currencyList = [];
    for (final token in tokens) {
      final list = token.networks.map((e) {
        String networkId = e.networkId;
        if (networkId.contains('ETH') && e.testnet) {
          networkId = "${e.networkId.toUpperCase()}/test";
        } else {
          networkId = networkId.toUpperCase();
        }
        return CurrencyInfo(
            imageUrl: token.imageUrl,
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
            currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC')),
        CurrencyInfo(
            imageUrl: '',
            currencyData: CurrencyData('tron', '', 'TRON', 'TRX', 'tron')),
      ]);
    } else {
      print("sssss4444");
    }

    // ctx.dispatch(HDWalletListActionCreator.onLoadCardInfo());

    // List<CurrencyInfo> currents = _changeNetworksToTokens(allCurrents);

    ctx.dispatch(HDWalletListActionCreator.onScanCardClick(currencyList));
  } else {
    ctx.dispatch(HDWalletListActionCreator.onLoadFailure(result.message));
  }
}

List<CurrencyInfo> _changeNetworksToTokens(List<CurrencyInfo> currencies) {
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
  return currentIds;
}
//   // 指在完整币种列表内的币种
// List<CurrencyInfo> newCurrencies = [];
// if (allCurrencyList.isNotEmpty) {
//   currencies.forEach((element) {
//     final current = allCurrencyList.firstWhereOrNull((elemen1) =>
//         elemen1.currencyData.id.toLowerCase() ==
//             element.currencyData.id.toLowerCase() &&
//         elemen1.currencyData.networkId.toLowerCase() ==
//             element.currencyData.networkId.toLowerCase());
//     if (current != null) {
//       newCurrencies.add(element);
//     }
//   });
//   currencies = newCurrencies;
// }

Future<void> _onScanCard(Action action, Context<HDWalletListState> ctx) async {
  ///默认币种列表，新卡拍卡时使用
  ///
  ///

  List<CurrencyInfo> currencyList1 = action.payload;
  final languageResource = ctx.state.languageResource!;
  DeepLinkManager().suspend();
  try {
    final cardMessage = await BlockchainPlatform.instance
        .scanCardAndDerive(currencyList1, ctx.state.ndefLink);
    // 扫卡成功震动反馈
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
    }
    var currencies = cardMessage.currencyList.map((e) {
      return CurrencyInfo.fromCurrencyMessage(e!);
    }).toList();

    var cardInfo = ctx.state.cardInfoList
        .firstWhereOrNull((element) => element.cardId == cardMessage.uid);

    List<CurrencyInfo> allcurrencyList = [];
    final stringList =
        await LocalStorage.getStringList(LocalStorage.allCryptoList);
    allcurrencyList = stringList?.map((e) {
          return CurrencyInfo.fromJson(json.decode(e));
        }).toList() ??
        [];
    if (AppConfig.of(navigatorKey.currentContext!).isProApp == false) {
      allcurrencyList = [];
    }
    // // 指在完整币种列表内的币种
    List<CurrencyInfo> newCurrencies = [];
    List<String> newRemovedCurrencies = [];
    if (allcurrencyList.isNotEmpty) {
      for (var element in currencies) {
        final current = allcurrencyList.firstWhereOrNull((elemen1) =>
            elemen1.currencyData.id.toLowerCase() ==
                element.currencyData.id.toLowerCase() &&
            elemen1.currencyData.networkId.toLowerCase() ==
                element.currencyData.networkId.toLowerCase());
        if (current != null) {
          element.imageUrl = current.imageUrl;
          newCurrencies.add(element);
        } else {
          newRemovedCurrencies.add(element.currencyData.id);
        }
      }
      currencies = newCurrencies;
    }
    if (newRemovedCurrencies.isNotEmpty) {
// 清除不在完整列表的币种
      await BlockchainPlatform.instance
          .clearLocalCurrency(cardMessage.uid, newRemovedCurrencies);
    }
    bool isGetCryptoLis = false;
    if (AppConfig.of(navigatorKey.currentContext!).isProApp == false &&
        currencies.isEmpty) {
      var dict = {
        'page': '1',
        'row': 20,
        'uid': cardMessage.uid,
        'isDefault': true
      };
      LogUtil.d('4444result.rquest:$dict');
      isGetCryptoLis = true;
      // lite 需要获取uid对应默认
      final result = await HttpManager.getInstance()
          .get(NetworkAddress.cryptoListUrl, queryParameters: dict);

      if (result.isSuccess) {
        LogUtil.d('4444result.data:${result.data}');
        List<CoinMessage> tokens = (result.data['rows'] as List)
            .map((e) => CoinMessage.fromJson(e))
            .toList()
            .cast<CoinMessage>();

        for (final token in tokens) {
          final list = token.networks.map((e) {
            String networkId = e.networkId;
            if (networkId.contains('ETH') && e.testnet) {
              networkId = "${e.networkId.toUpperCase()}/test";
            } else {
              networkId = networkId.toUpperCase();
            }
            return CurrencyInfo(
                imageUrl: token.imageUrl,
                isTest: e.testnet,
                currencyData: CurrencyData(
                    token.id, e.imageUrl, token.name, token.symbol, networkId,
                    decimals: e.decimalCount,
                    contractAddress: e.contractAddress));
          });
          currencies.addAll(list);
        }

        // final currencyListStr = currencies.map((e) => e.toString()).toList();
        // await LocalStorage.saveStringList(
        //     LocalStorage.liteAllCryptoList, currencyListStr);
      } else {
        showToast("${result.message},code:${result.code}");
        return;
      }
    }

    List<CurrencyInfo> currencys = _changeNetworksToTokens(currencies);

    // 普通版本且不是第一次请求缓存则需要判断弹窗
    if (AppConfig.of(navigatorKey.currentContext!).isProApp == false &&
        isGetCryptoLis) {
      // _showMultiSelect(ctx, currentIds);
      final List<String> items = currencys.map((e) {
        return e.currencyData.id;
      }).toList();

      await showDialog(
        barrierDismissible: false,
        context: ctx.context,
        builder: (BuildContext context) {
          return MultiSelect(items: items);
        },
      );
      List<CurrencyInfo> selectCurrencyList = [];

      for (var coinItem in currencys) {
        final selectItems = coinItem.networkLists;
        final currencyList = selectItems!.map((e) {
          return CurrencyInfo(
              imageUrl: coinItem.imageUrl,
              currencyData: e.currencyData,
              isTest: e.isTest);
        }).toList();
        selectCurrencyList.addAll(currencyList);
      }
      // 再次扫卡
      final cardMessage = await BlockchainPlatform.instance
          .scanCardAndDerive(selectCurrencyList, "");
      print("");
      List<CurrencyInfo> currencies1 = cardMessage.currencyList.map((e) {
        return CurrencyInfo.fromCurrencyMessage(e!);
      }).toList();

      currencys = _changeNetworksToTokens(currencies1);
    }

    for (var element in ctx.state.cardInfoList) {
      element.isSelected = false;
    }
    if (cardInfo == null) {
      cardInfo = CardInfo(
          cardId: cardMessage.uid,
          publicKey: HexUtils.uint8ListToHex(cardMessage.publicKey),
          wallets: currencys,
          isSelected: true);
      ctx.state.cardInfoList.add(cardInfo);
      ctx.state.currentIndex = ctx.state.cardInfoList.length - 1;
    } else {
      cardInfo.wallets = currencys;
      cardInfo.isSelected = true;
      ctx.state.currentIndex = ctx.state.cardInfoList.indexOf(cardInfo);
    }

    final cardListStr =
        ctx.state.cardInfoList.map((e) => e.toString()).toList();
    LocalStorage.saveStringList(LocalStorage.cardInfoList, cardListStr);

    cardInfo.fiatInfo = cardInfo.fiatInfo ??
        FiatInfo(
            symbol: 'USDT',
            imageUrl: '',
            name: "USDT",
            currentPrice: "1.00",
            scale: '2',
            currency: '\$');
    ctx.state.currentFiat = cardInfo.fiatInfo!;

    ///获取币种USDT价格
    final codeList = ctx.state.cardInfo.wallets
        .map((e) => e.currencyData.symbol)
        .toSet()
        .toList();
    ctx.dispatch(HDWalletListActionCreator.onGetNewestPrices(codeList));
    ctx.dispatch(HDWalletListActionCreator.onLoadCardInfo());
    DeepLinkManager().resume();
  } catch (error) {
    DeepLinkManager().resume();
    showToast('${languageResource.scanCardFailed}:$error');
  }
}

Future<void> _onBlockchainClick(
    Action action, Context<HDWalletListState> ctx) async {
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

  ctx.dispatch(
      HDWalletListActionCreator.onUpdateBlockchainSelected(currencyInfo, true));

  var balance = currencyInfo.balance;

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
                    _buidlImageView(currencyInfo),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${currencyInfo.currencyData.name}: $balance",
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
                          Text(ctx.state.languageResource!.recharge)
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: balance != null
                          ? () => Navigator.of(ctx.context).pop(1)
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadAssetImage(
                            balance != null
                                ? 'coin_withdraw_s'
                                : 'coin_withdraw',
                            width: 35.0,
                            height: 35.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(ctx.state.languageResource!.withdraw)
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
                          Text(ctx.state.languageResource!.bugCoin)
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
  ctx.dispatch(HDWalletListActionCreator.onUpdateBlockchainSelected(
      currencyInfo, false));

  if (result == 0) {
    Navigator.of(ctx.context).pushNamed('hdRechargePage', arguments: {
      'currencyInfo': currencyInfo,
      'loadType': 0,
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

Widget _buidlImageView(CurrencyInfo bean) {
  return Stack(
    children: [
      ClipOval(
        //圆形头像
        child: LoadImage(
          bean.imageUrl,
          width: 45.0,
          height: 45.0,
          holderImg: const SizedBox(
            height: 15,
            width: 15,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      // if (bean.currencyData.contractAddress != null)
      //   Positioned(
      //       right: 0,
      //       top: 0,
      //       child: Container(
      //         width: 17.0,
      //         height: 17.0,
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.white, width: 2),
      //             borderRadius: BorderRadius.circular(8.5)),
      //         child: ClipOval(
      //           //圆形头像
      //           child: LoadImage(
      //             bean.currencyData.icon,
      //             width: 15.0,
      //             height: 15.0,
      //             holderImg: const SizedBox(
      //               height: 5,
      //               width: 5,
      //               child: Center(child: CircularProgressIndicator()),
      //             ),
      //           ),
      //         ),
      //       ))
    ],
  );
}

// Future<void> _onLoadDefaultCurrency(
//   ...
// }

Future<void> _onLoadCardInfo(
    Action action, Context<HDWalletListState> ctx) async {
  // 不管如何都应该可以加载币种余额先

  print("_onLoadCardInfo1:${{DateTime.now()}}");
  final cardInfo = ctx.state.cardInfoList[ctx.state.currentIndex];

  List<CurrencyInfo> requestList = [];
  for (var e in cardInfo.wallets) {
    e.failCount = "0";
    e.balance = "0";
    List<CurrencyInfo> networks = e.networkLists!.map((e1) {
      e1.balance = "0";
      return e1;
    }).toList();
    requestList.addAll(networks);
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
      if (appletVersion != null &&
          cardDetail.applet != null &&
          cardDetail.applet!.name != null) {
        cardDetail.applet!.name = appletVersion;
      }

      print("_onLoadCardInfo3:${{DateTime.now()}}");
      ctx.dispatch(HDWalletListActionCreator.onLoadSuccess(cardDetail));
      ctx.dispatch(HDWalletListActionCreator.onLightningNetAction());
      if (requestList.isNotEmpty) {
        BlockchainPlatform.instance.loadCurrencyInfoList(requestList);
      }
    } else {
      showToast("${result.message},code:${result.code}");
      // _showInfoDialog(ctx.context,
      //     'uid:${ctx.state.cardInfoList[ctx.state.currentIndex].cardId}${ctx.state.languageResource!.verifyCardFail}');
    }
  } else {
    showToast("${result.message},code:${result.code}");
    // _showInfoDialog(ctx.context, '${result.message}');
  }
}

void _onDispose(Action action, Context<HDWalletListState> ctx) {
  ctx.state.subscription?.cancel();
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }
}

Future<void> _onAddBlockchainClick(
    Action action, Context<HDWalletListState> ctx) async {
  List<CurrencyItemState> currencyStateList = ctx.state.currencyList.toList();
  final currencyList = currencyStateList.map((e) {
    return e.bean;
  }).toList();
  var result = await Navigator.of(ctx.context).pushNamed('selectCurrencyPage',
      arguments: {
        'currencyList': currencyList,
        'uid': ctx.state.cardInfo.cardId
      });
  // 总代币数
  List<CurrencyInfo> oldCurrencyList = [];
  for (var e in currencyList) {
    oldCurrencyList.addAll(e.networkLists!);
  }
  if (result != null) {
    List<CurrencyInfo> selectList = result as List<CurrencyInfo>;
    _onUpdateWalletAfterSelectBlock(action, ctx, selectList);
  }
}

Future<void> _onUpdateWalletAfterSelectBlock(Action action,
    Context<HDWalletListState> ctx, List<CurrencyInfo> wallets) async {
  final currencyStateList = ctx.state.currencyList.toList();
  List<CurrencyInfo> requestList = [];
  List<CurrencyInfo> selectList = wallets; // 每个代币的列表
  List<CurrencyInfo> totalSelectCurrencyList = []; // 当前代币列表
  ctx.state.cryptoTotalPrice = "0";
  for (var e in currencyStateList) {
    e.bean.failCount = "0";
    e.bean.balance = "0";
    totalSelectCurrencyList.addAll(e.bean.networkLists!);
  }

  ///移除被了取消了的币种
  List<String> coins = [];
  currencyStateList.removeWhere((itemState) {
    final item = selectList.firstWhereOrNull((element) =>
        element.currencyData.id.toLowerCase() ==
        itemState.bean.currencyData.id.toLowerCase());
    if (item != null) {
      coins.add(item.currencyData.id);
    }
    return item == null;
  });

  ///添加新增的币种
  List<CurrencyInfo> newCurrens = [];
  for (var currencyInfo in selectList) {
    final item = totalSelectCurrencyList.firstWhereOrNull((element) =>
        element.currencyData.id == currencyInfo.currencyData.id &&
        element.currencyData.networkId == currencyInfo.currencyData.networkId);
    if (item == null) {
      requestList.add(currencyInfo);
      newCurrens.add(currencyInfo);
    }
  }

  ///获取新选中币种价格
  final codeList =
      newCurrens.map((e) => e.currencyData.symbol).toSet().toList();
  if (codeList.isNotEmpty) {
    await ctx.dispatch(HDWalletListActionCreator.onGetNewestPrices(codeList));
  }

  ///加载币种余额
  BlockchainPlatform.instance.loadCurrencyInfoList(requestList);
  List<CurrencyInfo> currentIds = [];
  Map<String, CurrencyInfo> object = {};
  for (var e1 in requestList) {
    if (!object.containsKey(e1.currencyData.id)) {
      object[e1.currencyData.id] = CurrencyInfo.fromJson(e1.toJson());
    }
  }

  currentIds = object.values.toList();
  for (var element in currentIds) {
    List<CurrencyInfo> ids = requestList
        .where((element1) =>
            element1.currencyData.id.toLowerCase() ==
            element.currencyData.id.toLowerCase())
        .toList();
    if (ids.isNotEmpty) {
      element.networkLists = ids;
    } else {
      element.networkLists = [];
    }
  }

  ///更新币种列表
  var list = currentIds.map((e) => CurrencyItemState()..bean = e).toList();
  currencyStateList.addAll(list);

  ctx.dispatch(
      HDWalletListActionCreator.onUpdateCurrencyList(currencyStateList));

  ctx.dispatch(HDWalletListActionCreator.onSyncWallet(currencyStateList));

  ///更新缓存
  final cardInfo = ctx.state.cardInfo;
  ctx.state.cardInfoList[ctx.state.currentIndex] = cardInfo.copyWidth(
      wallets: currencyStateList.map((e) => e.bean).toList());
  LocalStorage.saveStringList(
    LocalStorage.cardInfoList,
    ctx.state.cardInfoList.map((e) => e.toString()).toList(),
  );
}

Future<void> _onShowNickNameAlertClick(
    Action action, Context<HDWalletListState> ctx) async {
  int index = ctx.state.currentIndex;
  CardInfo info = ctx.state.cardInfoList[index];

  String? nick = await Dialogs.showNickInputDialog(
      languageResource: ctx.state.languageResource!,
      context: ctx.context,
      initText: info.nickName,
      maxLength: 12);
  if (nick != null) {
    info.nickName = nick;
    // print('发生更新别名信号');
    var list = ctx.state.cardInfoList.map((e) => e.toString()).toList();
    // print('别名字符串为:' + nick + '要存储的为:' + list[index]);
    LocalStorage.saveStringList(LocalStorage.cardInfoList, list);

    final data = <String, dynamic>{'uid': info.cardId, "alias": nick};
    HttpManager.getInstance()
        .post(NetworkAddress.syncalias, null, data: data)
        .then((value) {
      // print('syncalias result:${value}');
    });
    ctx.dispatch(HDWalletListActionCreator.onUpdateNickName(info));
  } else {
    print('没有别名');
  }
}

Future<void> _onShowCardInfoList(
    Action action, Context<HDWalletListState> ctx) async {
  final languageResource = ctx.state.languageResource!;
  var cardInfoList = ctx.state.cardInfoList.toList();
  showModalBottomSheet(
      context: ctx.context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              child: Column(
                children: [
                  Text(languageResource.myWallet),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: cardInfoList.length,
                        itemBuilder: (context, index) {
                          final cardInfo = cardInfoList[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(ctx.context).pop();
                                if (ctx.state.currentIndex != index) {
                                  ctx.dispatch(
                                      HDWalletListActionCreator.onChangeWallet(
                                          cardInfo));
                                }
                              },
                              child: _itemWidgetBuild(ctx, context, cardInfo,
                                  onRemove: () async {
                                var languageResource =
                                    ctx.state.languageResource!;
                                bool? value = await showDialog(
                                    context: ctx.context,
                                    builder: (context) {
                                      return ZenggeTextAlertDialog(
                                        languageResource.removeWalletTitle,
                                        enableCancel: true,
                                      );
                                    });
                                if (value == true) {
                                  setState(() {
                                    cardInfoList.removeAt(index);
                                  });
                                  ctx.dispatch(
                                      HDWalletListActionCreator.onRemoveCard(
                                          cardInfo));
                                }
                              }));
                        }),
                  ),
                  CCButton(
                      onPressed: () {
                        Navigator.of(ctx.context).pop();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          ctx.dispatch(
                              HDWalletListActionCreator.onAddWalletClick());
                        });
                      },
                      child: Text(languageResource.addNewWallet)),
                ],
              ),
            );
          },
        );
      });
}

Widget _itemWidgetBuild(
    Context<HDWalletListState> ctx, BuildContext context, CardInfo cardInfo,
    {VoidCallback? onRemove}) {
  CardDetail? cardDetail = cardInfo.cardDetail;
  String nickName = ' ';
  if (cardDetail != null && cardDetail.cardNo!.isNotEmpty) {
    nickName = cardDetail.cardNo!;
  } else {
    nickName = 'Backend not generated';
  }

  return Card(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
            flex: 9,
            child: Row(
              children: [
                if (cardInfo.cardDetail != null)
                  LoadImage(
                    cardInfo.cardDetail!.shape?.imageUrl ?? '',
                    width: 50,
                    height: 30,
                    holderImg: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: cardInfo.nickName.isNotEmpty,
                        child: Text(
                          ctx.state.languageResource!.nickName +
                              (cardInfo.nickName),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cardInfo.isSelected
                                  ? Colors.orange
                                  : Colors.black),
                        )),
                    Text(
                      'Card No: ${StringUtils.addSpaceInString(nickName)}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              cardInfo.isSelected ? Colors.orange : Colors.black),
                    ),
                    Text(
                      '${cardInfo.wallets.length} tokens',
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            )),
        Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete),
                  style: const ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.red)),
                  iconSize: 20,
                )))
      ],
    ),
  ));
}

Future<void> _onChangeWallet(
    Action action, Context<HDWalletListState> ctx) async {
  CardInfo cardInfo = action.payload;
  List<CurrencyInfo> requestList = [];
  for (var e in cardInfo.wallets) {
    e.failCount = "0";
    e.balance = "0";
    List<CurrencyInfo> networks = e.networkLists!.map((e1) {
      e1.balance = "0";
      return e1;
    }).toList();
    requestList.addAll(networks);
  }
  final reslut = await BlockchainPlatform.instance
      .changeWallet(cardInfo.cardId, requestList);
  if (!reslut) {
    return;
  }
  var cardInfoList = ctx.state.cardInfoList.map((e) {
    if (cardInfo.cardId == e.cardId) {
      e.isSelected = true;
    } else {
      e.isSelected = false;
    }
    return e;
  }).toList();
  int index = cardInfoList.indexOf(cardInfo);
  ctx.state.currentIndex = index;
  ctx.state.cryptoTotalPrice = "0";
  ctx.state.currentFiat = cardInfo.fiatInfo ??
      FiatInfo(
          symbol: 'USDT',
          imageUrl: '',
          name: "USDT",
          currentPrice: "1.00",
          scale: '2',
          currency: '\$');
  var list = cardInfoList.map((e) => e.toString()).toList();

  LocalStorage.saveStringList(LocalStorage.cardInfoList, list);
  // ctx.state.loadStatus = LoadType.loading;
  ctx.state.cryptoTotalPrice = "0.00";
  print("_onChangeWallet2:${{DateTime.now()}}");

  ///获取币种USDT价格
  final codeList =
      cardInfo.wallets.map((e) => e.currencyData.symbol).toSet().toList();
  ctx.dispatch(HDWalletListActionCreator.onGetNewestPrices(codeList));
  ctx.dispatch(HDWalletListActionCreator.onLoadCardInfo());
  bool showLightningNet = false;
  showLightningNet = true;
  // lightningNetId = currencyInfo.currencyData.networkId;
  ctx.state.showLightningNet = showLightningNet;
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }
  ctx.dispatch(HDWalletListActionCreator.onStartTime());
}

Future<void> _onGetTotalBalance(
    Action action, Context<HDWalletListState> ctx) async {
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

Future<void> _onUpdateCurrency(
    Action action, Context<HDWalletListState> ctx) async {
  FiatInfo fiatInfo = ctx.state.currentFiat;
  var result1 = await Navigator.of(ctx.context)
      .pushNamed('selectFiatPage', arguments: {'fiatInfo': fiatInfo});
  if (result1 != null) {
    FiatInfo fiatInfo1 = result1 as FiatInfo;
    ctx.state.currentFiat = fiatInfo1;
    ctx.state.cryptoTotalPrice = "0";
    // 存本地
    CardInfo info = ctx.state.cardInfoList[ctx.state.currentIndex];
    info.fiatInfo = fiatInfo1;
    ctx.state.cardInfoList[ctx.state.currentIndex] = info;
    var list1 = ctx.state.cardInfoList.map((e) => e.toString()).toList();
    LocalStorage.saveStringList(LocalStorage.cardInfoList, list1);
// 刷新界面
    var list = ctx.state.currencyList;
    List<CurrencyInfo> requestList = [];
    for (var e in ctx.state.currencyList) {
      requestList.addAll(e.bean.networkLists!);
    }
    ctx.dispatch(HDWalletListActionCreator.onUpdateCurrencyList(list));
    ctx.dispatch(HDWalletListActionCreator.onGetTotalBalance());
    ctx.dispatch(HDWalletListActionCreator.onSyncWallet(list));
  }
}

Future<void> _onRemoveCard(
    Action action, Context<HDWalletListState> ctx) async {
  CardInfo cardInfo = action.payload;
  final stringList =
      await LocalStorage.getStringList(LocalStorage.cardInfoList);
  if (stringList != null) {
    stringList.removeWhere((element) => element.contains(cardInfo.cardId));
    LocalStorage.saveStringList(LocalStorage.cardInfoList, stringList);

    ///清除原生本地缓存数据
    BlockchainPlatform.instance.clearLocalCurrency(cardInfo.cardId, []);
    var list =
        stringList.map((e) => CardInfo.fromJson(json.decode(e))).toList();
    if (list.isEmpty) {
      Navigator.of(ctx.context).popUntil(
          (Route<dynamic> route) => route.settings.name == 'mainPage');
      return;
    }
    CardInfo cardInfo1 = list[0];
    var cardInfoList = list.map((e) {
      if (cardInfo1.cardId == e.cardId) {
        e.isSelected = true;
      } else {
        e.isSelected = false;
      }
      return e;
    }).toList();
    ctx.state.cardInfoList = cardInfoList;
    ctx.dispatch(HDWalletListActionCreator.onChangeWallet(cardInfo1));
    // Navigator.pushNamed(ctx.context, 'hdWalletPage');
  }
}

Future<void> _onRefresh(Action action, Context<HDWalletListState> ctx) async {
  Future.delayed(const Duration(seconds: 1))
      .then((value) => ctx.state.refreshController.refreshCompleted());
  List<CurrencyInfo> requestList = [];
  ctx.state.cryptoTotalPrice = "0";
  for (var e in ctx.state.currencyList) {
    e.bean.failCount = "0";
    e.bean.balance = "0";
    List<CurrencyInfo> networks = e.bean.networkLists!.map((e1) {
      return e1;
    }).toList();
    requestList.addAll(networks);
  }

  // ctx.dispatch(HDWalletListActionCreator.onUpdateCurrencyList(ctx.state.currencyList));
  BlockchainPlatform.instance.loadCurrencyInfoList(requestList);
}

Future<void> _onSynswallet(
    Action action, Context<HDWalletListState> ctx) async {
  // 币种列表
  List<CurrencyItemState> currencyList = action.payload;
  if (currencyList.isEmpty) {
    print('currencyList is empty');
    return;
  }

  List wallletParames = [];
  for (var element in currencyList) {
    for (var network in element.bean.networkLists!) {
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

Future<void> _onAddBlockchainTip(
    Action action, Context<HDWalletListState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(
          languageResource.slecetCoinInPro,
        );
      });
}

Future<void> _onLightningNet(
    Action action, Context<HDWalletListState> ctx) async {
  if (ctx.state.showLightningNet == false) {
    LogUtil.d("闪电网络目前不要查询");
  }
  var params = {
    'uid': ctx.state.cardInfo.cardDetail!.uid!,
  };
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.lightSparkBalance, queryParameters: params);

  if (result.isSuccess) {
    LogUtil.d('result_onLightningNet.data:${result.data}');
    FlashBalance flashBalance = FlashBalance.fromJson(result.data);
    ctx.dispatch(HDWalletListActionCreator.onUpdatelightningNetValueAction(
        flashBalance));
  } else {}
}

Future<void> _onStartTime(Action action, Context<HDWalletListState> ctx) async {
  if (ctx.state.showLightningNet == false) {
    LogUtil.d("闪电网络没有，目前不要启动定时器");
  }
  const oneSec = Duration(seconds: 1);
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }

  ctx.state.homeTimer = Timer.periodic(oneSec, (Timer timer) {
    ctx.state.homeSeconds--;

    if (ctx.state.homeSeconds == 0) {
      ctx.state.homeSeconds = 60;
      ctx.dispatch(HDWalletListActionCreator.onLightningNetAction());
    } else {
      ctx.dispatch(
          HDWalletListActionCreator.onUpdateTime(ctx.state.homeSeconds));
    }
  });
}
