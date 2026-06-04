import 'dart:convert';
import 'dart:io';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/bean/update_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/custom_widget/mutile_select.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';

// import 'package:card_coin/pages/main_page/hd_wallet_page/action.dart';
import 'package:card_coin/pages/main_page/reset_factory_settings_page/action.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/utils/hex_utils.dart';

import 'package:card_coin/widget/app_config.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:card_coin/widget/upgrade_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bean/card_info_bean.dart';
import 'action.dart';
import 'state.dart';
import 'package:collection/collection.dart';
import '../../app.dart';
import 'package:card_coin/utils/deep_link_manager.dart';

Effect<MainState>? buildEffect() {
  return combineEffects(<Object, Effect<MainState>>{
    Lifecycle.initState: _onInit,
    MainAction.biometricClick: _onBiometricClick,
    MainAction.scanCard: _onScanCard,
    ResetFactorySettingsAction.updateCardList: _onUpdateCardList,
    MainAction.loadDefaultCurrency: _onLoadDefaultCurrency,
    MainAction.allcrypto: _onLoadAllcryptoList,
    MainAction.upgrade: _onUpgrade,
    MainAction.upgradeApp: _onUpgradeApp,
    MainAction.ndefDomain: _onNdefDomain,
    MainAction.healCheck: _onHealCheck,
    MainAction.getInitBlockchain: _onGetInitBlockchain

    // HdWalletAction.updateCardList: _onUpdateCardList,
  });
}

Future<void> _onLoadAllcryptoList(Action action, Context<MainState> ctx) async {
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
        final list = token.networks.map((e) => CurrencyInfo(
            imageUrl: token.imageUrl,
            currencyData: CurrencyData(
                token.id, e.imageUrl, token.name, token.symbol, e.networkId,
                decimals: e.decimalCount, contractAddress: e.contractAddress)));
        currencyList.addAll(list);
      }

      final currencyListStr = currencyList.map((e) => e.toString()).toList();
      await LocalStorage.saveStringList(
          LocalStorage.allCryptoList, currencyListStr);
      await LocalStorage.saveString(LocalStorage.allCryptoListMd5, lastMd5);
    } else {
      ctx.dispatch(MainActionCreator.onLoadFailed(result.message));
    }
  } else {
    print("local md5 equal to network md5");
  }

  // if (currencyList.isEmpty) {
  //   final stringList =
  //       await LocalStorage.getStringList(LocalStorage.allCryptoList);
  //   currencyList = stringList?.map((e) {
  //         return CurrencyInfo.fromJson(json.decode(e));
  //       }).toList() ??
  //       [];
  // }
}

Future<void> _onLoadDefaultCurrency(
    Action action, Context<MainState> ctx) async {
  List<CurrencyInfo> currencyList = [];

  if (AppConfig.of(navigatorKey.currentContext!).isProApp == false) {
    ctx.dispatch(MainActionCreator.onLoadSuccess(currencyList));
    return;
  }
  final parameters = <String, dynamic>{'asset': true};
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
                decimals: e.decimalCount, contractAddress: e.contractAddress));
      });
      currencyList.addAll(list);
    }
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
    print("sssss55555");
  }
  ctx.dispatch(MainActionCreator.onLoadSuccess(currencyList));

  // ctx.dispatch(MainActionCreator.onScanCard());
}

Future<List<CurrencyInfo>> _onGetInitBlockchain(
    Action action, Context<MainState> ctx) async {
  String uuid = action.payload;
  List<CurrencyInfo> currencies = [];
  var params = {'page': '1', 'row': 20, 'uid': uuid, 'isDefault': true};

  // lite 需要获取uid对应默认
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.cryptoListUrl, queryParameters: params);

  if (result.isSuccess) {
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
                decimals: e.decimalCount, contractAddress: e.contractAddress));
      });
      currencies.addAll(list);
    }
    print('_onGetInitBlockchain_main');
  } else {
    showToast("${result.message},code:${result.code}");
  }
  return currencies;
}

Future<void> _onInit(Action action, Context<MainState> ctx) async {
  try {
    // ctx.dispatch(MainActionCreator.onUpdateCardList(cardInfoList ?? []));
    ctx.dispatch(MainActionCreator.onAllcrypto());

    ctx.dispatch(MainActionCreator.onLoadDefaultCurrency());

    ctx.dispatch(MainActionCreator.onNdefDomain());
    // 升级加载
    ctx.dispatch(MainActionCreator.onUpGrade());
  } catch (error) {
    ctx.dispatch(MainActionCreator.onLoadFailed(error.toString()));
  }
  // _sharetraceHandle();
}

Future<void> _onUpdateCardList(Action action, Context<MainState> ctx) async {
  ctx.dispatch(MainActionCreator.onUpdateCardList(action.payload));

  ///加载完整支持币种的数字币列表
  ctx.dispatch(MainActionCreator.onLoadDefaultCurrency());
}

Future<void> _onUpgrade(Action action, Context<MainState> ctx) async {
  if (Platform.isAndroid) {
    var appConfig = AppConfig.of(navigatorKey.currentContext!);
    var marketCode = appConfig.stringResource.marketCode;
    // final type = appConfig.appInternalId.name.toUpperCase();
    Map<String, dynamic> params;
    if (marketCode.isNotEmpty) {
      params = {'source': marketCode};
    } else {
      params = {};
    }
    var date1 = DateTime.now();
    print('upgrade http1 :$date1');

    ResultData result = await HttpManager.getInstance()
        .get(NetworkAddress.appUpgradeUrl, queryParameters: params);
    if (result.isSuccess) {
      var date2 = DateTime.now();
      print('upgrade http2 :$date2');
      try {
        var updateInfo = UpdateInfo.fromJson(result.data);
        if (updateInfo.appTypeName!
                .toUpperCase()
                .contains("Lite".toUpperCase()) &&
            (AppConfig.of(navigatorKey.currentContext!).isProApp != false)) {
          return;
        }

        if (updateInfo.appTypeName!
                .toUpperCase()
                .contains("pro".toUpperCase()) &&
            (AppConfig.of(navigatorKey.currentContext!).isProApp == false)) {
          return;
        }
        var packageInfo = await PackageInfo.fromPlatform();
        var buildNumber = int.parse(packageInfo.buildNumber);
        if (buildNumber < updateInfo.versionCode!) {
          if (updateInfo.status == 'ACTIVE') {
            if (((updateInfo.forceUpgrade ?? false) &&
                marketCode != 'GOOGLE')) {
              ctx.dispatch(MainActionCreator.onUpgradeApp(updateInfo));
            } else {
              var languageResource =
                  GlobalStore.store.getState().languageResource!;
              // var languageResource = ctx.state.languageResource!;
              var result = await showDialog(
                  context: ctx.context,
                  builder: (context) {
                    return ZenggeTextAlertDialog(
                      '${languageResource.appVersion}：\n${updateInfo.description}',
                      titleText:
                          '${languageResource.versionAvailable} ${updateInfo.versionName ?? ''}',
                      enableCancel: true,
                      confirmText: languageResource.upgradeNow,
                      cancelText: languageResource.cancel,
                    );
                  });
              if (result != null && result) {
                if (marketCode == 'GOOGLE') {
                  launchUrlString(updateInfo.fileFullPath!);
                } else {
                  ctx.dispatch(MainActionCreator.onUpgradeApp(updateInfo));
                }

                return;
              }
            }
          }
        }
      } catch (error) {
        print('upgrade failure:$error');
      }
    } else {
      print('upgrade failure:${result.message}');
    }
  }
}

Future<void> _onBiometricClick(Action action, Context<MainState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  try {
    bool canCheckBiometrics = await ctx.state.auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await ctx.state.auth.authenticate(
        localizedReason: languageResource.unlockVerify,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: languageResource.vaultUnlocking,
            cancelButton: languageResource.cancel,
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        final stringList = await LocalStorage.getStringList(
          LocalStorage.cardInfoList,
        );
        List<CardInfo> cardInfoList = [];
        if (stringList != null) {
          cardInfoList = stringList.map((e) {
            return CardInfo.fromJson(json.decode(e));
          }).toList();
        }
        Navigator.pushNamed(ctx.context, 'hdWalletPage', arguments: {
          'biometric': false,
          'cardInfoList': cardInfoList,
        });
      }
    }
  } on PlatformException catch (e) {
    showToast('${languageResource.unlockFailureError}:$e');
    print(e);
  }
}

Future<void> _onScanCard(Action action, Context<MainState> ctx) async {
  ///默认币种列表，新卡拍卡时使用
  var currencyList = ctx.state.defaultCurrencyList;

  bool isProApp = AppConfig.of(navigatorKey.currentContext!).isProApp;

  if (currencyList.isEmpty) {
    if (isProApp) {
      currencyList.addAll([
        CurrencyInfo(
            imageUrl: '',
            currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC')),
        CurrencyInfo(
            imageUrl: '',
            currencyData: CurrencyData('tron', '', 'TRON', 'TRX', 'tron')),
      ]);
    } else {
      // 如果为空，普通版本获取本地币种数据
      // final stringList =
      //     await LocalStorage.getStringList(LocalStorage.liteAllCryptoList);
      // currencyList = stringList?.map((e) {
      //       return CurrencyInfo.fromJson(json.decode(e));
      //     }).toList() ??
      //     [];
      currencyList = [];
    }
  }
  print("scanCardAndDerive-domain:${ctx.state.domain}");
  final CardMessage cardMessage;
  DeepLinkManager().suspend();
  try {
    cardMessage = await BlockchainPlatform.instance
        .scanCardAndDerive(currencyList, ctx.state.domain);
  } catch (error) {
    DeepLinkManager().resume();
    if (error is PlatformException && error.code == 'user-cancelled') {
      return;
    }
    final msg = error is PlatformException ? error.message : error.toString();
    if (msg != null && msg.isNotEmpty && msg.length < 100) {
      showToast(msg);
    }
    return;
  }
  DeepLinkManager().resume();
  print("");
  // 扫卡成功震动反馈
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 200);
  }
  List<CurrencyInfo> currencies = cardMessage.currencyList.map((e) {
    return CurrencyInfo.fromCurrencyMessage(e!);
  }).toList();

  // 默认币种和完整币种列表比较，如果完整币种没有该币种，则不展示该币种

  final stringList =
      await LocalStorage.getStringList(LocalStorage.allCryptoList);
  var allCurrencyList = stringList?.map((e) {
        return CurrencyInfo.fromJson(json.decode(e));
      }).toList() ??
      [];

  if (!isProApp) {
    allCurrencyList = [];
  }

  // // 指在完整币种列表内的币种
  List<CurrencyInfo> newCurrencies = [];
  List<String> newRemovedCurrencies = [];
  if (allCurrencyList.isNotEmpty) {
    for (var element in currencies) {
      final current = allCurrencyList.firstWhereOrNull((elemen1) =>
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

  List<CurrencyInfo> currentIds = [];

  Map<String, CurrencyInfo> object = {};
  bool isGetCryptoLis = false;
  if (!isProApp && currencies.isEmpty) {
    isGetCryptoLis = true;
    currencies = await ctx
        .dispatch(MainActionCreator.onGetInitBlockchain(cardMessage.uid));
    ctx.state.defaultCurrencyList = currencies;
  }

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

  // 普通版本则需要判断弹窗
  if (!isProApp && isGetCryptoLis) {
    final List<String> items = currentIds.map((e) {
      return e.currencyData.id;
    }).toList();

    final bool? result = await showDialog(
      barrierDismissible: false,
      context: ctx.context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    if (result != true) {
      return;
    }

    List<CurrencyInfo> selectCurrencyList = [];

    for (var coinItem in currentIds) {
      final selectItems = coinItem.networkLists;
      final currencyList = selectItems!.map((e) {
        return CurrencyInfo(
            imageUrl: coinItem.imageUrl, currencyData: e.currencyData);
      }).toList();
      selectCurrencyList.addAll(currencyList);
    }
    // 再次扫卡
    final CardMessage cardMessage;
    try {
      cardMessage = await BlockchainPlatform.instance
          .scanCardAndDerive(selectCurrencyList, ctx.state.domain);
    } catch (error) {
      if (error is PlatformException && error.code == 'user-cancelled') {
        return;
      }
      final msg = error is PlatformException ? error.message : error.toString();
      if (msg != null && msg.isNotEmpty && msg.length < 100) {
        showToast(msg);
      }
      return;
    }
    print("");
    List<CurrencyInfo> currencies = cardMessage.currencyList.map((e) {
      return CurrencyInfo.fromCurrencyMessage(e!);
    }).toList();

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
  }

  CardInfo cardInfo = CardInfo(
      cardId: cardMessage.uid,
      publicKey: HexUtils.uint8ListToHex(cardMessage.publicKey),
      wallets: currentIds.isNotEmpty ? currentIds : [],
      isSelected: true);

  ///加载所有本地缓存的卡片数据
  final cardInfoListStr =
      await LocalStorage.getStringList(LocalStorage.cardInfoList);

  List<CardInfo> cardInfoList = cardInfoListStr?.map((e) {
        return CardInfo.fromJson(json.decode(e));
      }).toList() ??
      [];

  if (cardInfo.publicKey.isEmpty) {
    Navigator.of(ctx.context).pushNamed('createNewWalletPage', arguments: {
      'cardInfoList': cardInfoList,
      'cardInfo': cardInfo,
      'defaultCurrencyList': currencies,
    });
  } else {
    for (var element in cardInfoList) {
      element.isSelected = false;
    }
    var localCardInfo = cardInfoList
        .firstWhereOrNull((element) => element.cardId == cardInfo.cardId);
    if (localCardInfo == null) {
      // 如果没有选中,默认同步，则使用默认，如果有则用网络的
      localCardInfo = cardInfo;
      cardInfoList.add(cardInfo);
      // // 获取网络同步数据，如果有选中，则
    } else {
      localCardInfo.wallets = currentIds;
      if (localCardInfo.publicKey != cardInfo.publicKey) {
        localCardInfo.isNewDevice = true;
        localCardInfo.publicKey = cardInfo.publicKey;
      } else {
        localCardInfo.isNewDevice = false;
      }
    }
    localCardInfo.isSelected = true;

    if (localCardInfo.isNewDevice) {
      _showInitialDialog(ctx);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(ctx.context).pop();
    }
    final cardListStr = cardInfoList.map((e) => e.toString()).toList();
    await LocalStorage.saveStringList(LocalStorage.cardInfoList, cardListStr);

    Navigator.of(ctx.context).pushNamed('hdWalletListPage',
        arguments: {'cardInfoList': cardInfoList});
  }
}

void _showInitialDialog(Context<MainState> ctx) {
  var languageResource = ctx.state.languageResource!;
  showDialog(
    context: ctx.context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(width: 10),
              Text(languageResource.initWallet),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _onUpgradeApp(Action action, Context<MainState> ctx) async {
  UpdateInfo updateInfo = action.payload;

  showDialog<bool>(
    context: ctx.context,
    builder: (BuildContext context) {
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: const EdgeInsets.all(12.0),
            title: Text(
              'Updating…',
              style: TextStyle(color: Colors.grey[800]),
            ),
            children: <Widget>[
              UpgradeDialog(updateInfo.fileFullPath!),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
          onWillPop: () async => false);
    },
  ).then((val) {
    print(val);
  });
}

Future<void> _onNdefDomain(Action action, Context<MainState> ctx) async {
  final result = await HttpManager.getInstance()
      .post(NetworkAddress.ndefDomain, null, data: null);

  if (result.isSuccess) {
    LogUtil.d('result.data:${result.data}');
    if (result.data != null) {
      ctx.state.domain = result.data;
    }
  } else {}
}

Future<void> _onHealCheck(Action action, Context<MainState> ctx) async {
  Navigator.of(ctx.context)
      .pushNamed('checkCardPage', arguments: {'from': 1, 'cardId': ""});
}
