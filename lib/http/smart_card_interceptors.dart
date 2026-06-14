import 'dart:convert';
import 'dart:io';
import 'package:card_coin/app.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/managers/encryption_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../cache/local_storage.dart';
import '../global_store/state.dart';
import '../global_store/store.dart';
import '../widget/app_config.dart';
import '../widget/custom_alert_dialog.dart';
import 'result_data.dart';

class SmartCardInterceptors extends InterceptorsWrapper {
  static const Map<String, String> _startupCriticalPathLabels = {
    NetworkAddress.localeMessageMd5Url: 'locale_md5',
    NetworkAddress.homeBannerUrl: 'home_banner',
    NetworkAddress.pageCategoryUrl: 'tab_category',
  };

  static const Set<String> _startupBlockingLabels = {
    'home_banner',
    'tab_category',
  };

  static final Set<String> _startupCriticalCompleted = <String>{};
  static bool _startupFirstRequestMarked = false;
  static bool _startupFirstResponseMarked = false;
  static bool _startupFirstDecryptMarked = false;
  static bool _startupCriticalAllDoneMarked = false;

  bool _isStartupWindow() {
    final elapsed = StartupTime.elapsedMs();
    return elapsed != null && elapsed <= 15000;
  }

  String _buildLanguageCode(Locale? locale) {
    if (locale == null) return 'en_US';
    final countryCode = locale.countryCode;
    if (countryCode == null || countryCode.isEmpty) {
      return locale.languageCode;
    }
    return '${locale.languageCode}_$countryCode';
  }

  String? _matchStartupCriticalLabel(String path) {
    for (final entry in _startupCriticalPathLabels.entries) {
      if (path.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  void _markStartupNetworkRequest(RequestOptions options) {
    if (!_isStartupWindow()) return;

    if (!_startupFirstRequestMarked) {
      _startupFirstRequestMarked = true;
      StartupTime.mark('startup_network_first_request_begin');
    }

    final label = _matchStartupCriticalLabel(options.path);
    if (label == null) return;

    options.extra['startupCriticalLabel'] = label;
    StartupTime.mark('startup_network_${label}_request_begin');
  }

  void _markStartupNetworkResponse(RequestOptions options) {
    if (!_isStartupWindow()) return;

    if (!_startupFirstResponseMarked) {
      _startupFirstResponseMarked = true;
      StartupTime.mark('startup_network_first_response_done');
    }

    final label = options.extra['startupCriticalLabel'] as String?;
    if (label == null) return;

    StartupTime.mark('startup_network_${label}_response_done');
  }

  void _markStartupNetworkDecryptDone(RequestOptions options) {
    if (!_isStartupWindow()) return;

    if (!_startupFirstDecryptMarked) {
      _startupFirstDecryptMarked = true;
      StartupTime.mark('startup_network_first_decrypt_done');
    }

    final label = options.extra['startupCriticalLabel'] as String?;
    if (label == null) return;

    StartupTime.mark('startup_network_${label}_decrypt_done');
    // locale_md5 仅做观测，不阻塞关键链路完成判定。
    if (_startupBlockingLabels.contains(label)) {
      _startupCriticalCompleted.add(label);
    }

    if (!_startupCriticalAllDoneMarked &&
        _startupCriticalCompleted.length == _startupBlockingLabels.length) {
      _startupCriticalAllDoneMarked = true;
      StartupTime.mark('startup_network_critical_all_done');
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // -----------------------------------------------------------------------
    // 第一步：构建业务请求头（公钥请求和业务请求共用同一套 headers）
    // -----------------------------------------------------------------------
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String domain = "t32344x17.goho.co";
    var signature = EncryptUtil.encodeMd5('$timestamp${domain}DANARAJA');

    String token = '';
    final userInfo = await LocalStorage.getUserInfo();
    if (userInfo != null) {
      token = 'Bearer ${userInfo.accessToken ?? ''}';
    }

    var packageInfo = await PackageInfo.fromPlatform();

    var stringResource =
        AppConfig.of(navigatorKey.currentContext!).stringResource;
    final uid = await LocalStorage.getCardUuid();
    final cachedLocale = await LocalStorage.getLocale();
    // 请求语言仅跟随用户已保存的语言；未保存时强制英文，避免首启被系统语言带偏。
    final effectiveLocale = cachedLocale ?? const Locale('en', 'US');
    final language = _buildLanguageCode(effectiveLocale);
    final Map<String, dynamic> requestHeaders = {
      'Authorization': token,
      'timestamp': timestamp,
      'domain': domain,
      'signature': signature,
      'orgId': stringResource.signature,
      'App-Platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
      'App-Version': packageInfo.version,
      'App-Version-Code': packageInfo.buildNumber,
      'App-Package-Name': packageInfo.packageName,
      'X-Accept-UID': uid ?? '',
      'X-Accept-Language': language,
      'X-Trace-Id': HexUtils.generateRandomId(), // 10 位随机字符串，作为每次请求的唯一标识
    };
    options.headers.addAll(requestHeaders);

    // 记录原始 uid（加密前），供业务错误分支（如 830016）回退使用，避免 option.data 类型不匹配异常。
    if (options.data is Map<String, dynamic>) {
      final uid = (options.data as Map<String, dynamic>)['uid'];
      if (uid != null) {
        options.extra['request_uid'] = uid.toString();
      }
    }

    // -----------------------------------------------------------------------
    // 第二步：先将 language、_t 加入查询参数，以便一起参与加密
    // -----------------------------------------------------------------------
    var parameters = options.queryParameters;

    parameters['language'] = language;
    parameters['module'] = "CLIENT";

    String time =
        DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd HH:mm:ss');

    parameters['_t'] = time;

    // -----------------------------------------------------------------------
    // 第三步：加密层（跳过公钥接口本身，避免循环依赖）
    // -----------------------------------------------------------------------
    final isPublicKeyEndpoint =
        options.path.contains(NetworkAddress.systemPublicKeyUrl);
    if (!isPublicKeyEndpoint) {
      final encryption = EncryptionManager.instance;
      // 未初始化 或 初始化了但未启用（可能上次失败，允许重试）时，再次调用 initialize
      if (!encryption.isInitialized || !encryption.isEnabled) {
        await encryption.initialize(options.baseUrl, headers: requestHeaders);
      }
      if (encryption.isEnabled) {
        final method = options.method.toUpperCase();
        if (method == 'POST' || method == 'PUT') {
          // 加密 body
          if (options.data != null) {
            final plaintext = options.data is String
                ? options.data as String
                : jsonEncode(options.data);
            final encrypted = encryption.encryptToBase64(plaintext);
            print('[Encrypt] POST body plaintext: $plaintext');
            print('[Encrypt] POST body encrypted length: ${encrypted.length}');
            options.data = encrypted;
          }
          // 加密路径参数（包含 language、_t）
          final params = Map<String, dynamic>.from(options.queryParameters);
          if (params.isNotEmpty) {
            final plaintext = jsonEncode(params);
            final encrypted = encryption.encryptToBase64(plaintext);
            print('[Encrypt] POST params plaintext: $plaintext');
            print(
                '[Encrypt] POST params encrypted length: ${encrypted.length}');
            options.queryParameters = {'params': encrypted};
          }
        } else if (method == 'GET' || method == 'DELETE') {
          // 加密路径参数（包含 language、_t）
          final params = Map<String, dynamic>.from(options.queryParameters);
          if (params.isNotEmpty) {
            final sortedKeys = params.keys.toList()..sort();
            final plaintext =
                sortedKeys.map((k) => '$k=${params[k]}').join('&');
            final encrypted = encryption.encryptToBase64(plaintext);
            print('[Encrypt] GET params plaintext: $plaintext');
            print('[Encrypt] GET params encrypted length: ${encrypted.length}');
            options.queryParameters = {'params': encrypted};
          }
        }
      }
    }

    parameters = options.queryParameters;

    List<String> keys = parameters.keys.toList();
    // key排序
    keys.sort((a, b) {
      List<int> al = a.codeUnits;
      List<int> bl = b.codeUnits;
      for (int i = 0; i < al.length; i++) {
        if (bl.length <= i) return 1;
        if (al[i] > bl[i]) {
          return 1;
        } else if (al[i] < bl[i]) return -1;
      }
      return 0;
    });

    String signData = '';

    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      signData = '$signData$key=${parameters[key]}';
      if (i < keys.length - 1) {
        signData = '$signData&';
      } // Dio 会自动对 queryParameters 进行 URL 编码，无需手动编码
      // 手动编码会导致双重编码，加密后的 base64 中 +/=/  会变成 %252B/%253D/%252F
    }

    signData = '${signData}D0NB8ietxpCkdRCy';
    print('sign data:$signData');

    parameters['_s'] = EncryptUtil.encodeMd5(signData);

    print("请求baseUrl：${options.baseUrl}");
    print("请求url：${options.path}");
    print('请求头: ${options.headers}');
    print('请求方式: ${options.method}');
    if (options.data != null) {
      print('post 请求参数: ${options.data}');
    }

    _markStartupNetworkRequest(options);

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions option = response.requestOptions;
    print('${option.path} http end <- ${response.data}');
    _markStartupNetworkResponse(option);

    // LogUtil.d('${option.path} http end <- ${response.data}');
    Map<String, dynamic> data;
    if (response.data is String) {
      data = json.decode(response.data);
    } else {
      data = response.data;
    }

    var code = data["errcode"];
    // code = '830016';
    // if (option.path.contains("/smartCard/detail")) {
    //   code = '82000';
    // }
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    // errcode 可能是 String '0' 或 int 0，统一 toString() 后比较
    if (code?.toString() == '0') {
      if (data['data'] != '') {
        Map<String, dynamic> params = {};
        for (var key in option.queryParameters.keys) {
          if (key != '_t' && key != '_s' && key != 'language') {
            params[key] = option.queryParameters[key];
          }
        }
      }
      // 解密服务端私钥加密的响应 data 字段
      final encryption = EncryptionManager.instance;
      if (encryption.isEnabled && data['data'] is String) {
        final dataStr = data['data'] as String;
        if (dataStr.isNotEmpty) {
          final decrypted = encryption.decryptResponseBase64(dataStr);
          if (decrypted != null) {
            try {
              data['data'] = json.decode(decrypted);
            } catch (_) {
              data['data'] = decrypted; // 纯字符串（如 MD5 hash）
            }
            print('[Decrypt] Response data decrypted for ${option.path}');
            _markStartupNetworkDecryptDone(option);
          } else {
            print(
                '[Decrypt] Failed to decrypt response data for ${option.path}, using raw value');
          }
        }
      }
      handler.resolve(Response(
          data: ResultData(true, 0, data['errmsg'], data: data['data']),
          requestOptions: option));
    } else if (code == '40000') {
      GlobalState globalState = GlobalStore.store.getState();
      final dialogContext = navigatorKey.currentContext;
      final expiredTip = globalState.languageResource?.expiredTip ??
          'The login status has expired, please login again.';
      if (dialogContext != null) {
        showDialog(
            context: dialogContext,
            builder: (context) {
              return ZenggeTextAlertDialog(expiredTip);
            }).then((value) {
          LocalStorage.cleanUserInfo();
          final state = navigatorKey.currentState;
          if (state != null) {
            state.pushNamedAndRemoveUntil('scanLoginPage', (route) => false);
          }
        });
      } else {
        LocalStorage.cleanUserInfo();
      }
      handler.resolve(Response(
          data: ResultData(false, int.parse(code.toString()), data['errmsg'],
              data: data['data']),
          requestOptions: option));
    } else if (code == '830016' || code == 830016) {
      final optionUid = option.extra['request_uid']?.toString() ?? '';
      print('optionuid: $optionUid');
      final navigatorState = navigatorKey.currentState;
      if (navigatorState?.canPop() ?? false) {
        navigatorState!.pop();
      }
      final dialogContext = navigatorKey.currentContext;
      if (dialogContext != null) {
        final errmsg = (data['errmsg'] as String?)?.isNotEmpty == true
            ? data['errmsg'] as String
            : 'Wallet address not synced. Please initialize your wallet first.';
        showDialog(
            context: dialogContext,
            builder: (context) {
              return ZenggeTextAlertDialog(
                errmsg,
                confirmText: 'Go to Initialize',
                enableCancel: true,
              );
            }).then((value) {
          if (value == true && optionUid.isNotEmpty) {
            navigatorKey.currentState?.pushNamed(
              'scanWalletPage',
              arguments: {'cardId': optionUid},
            );
          }
        });
      }
      handler.resolve(Response(
          data: ResultData(false, int.parse(code.toString()), data['errmsg'],
              data: data['data']),
          requestOptions: option));
    } else if (code == '10003333' || code == 10003333) {
      final dialogContext = navigatorKey.currentContext;
      if (dialogContext != null) {
        showDialog(
            context: dialogContext,
            builder: (context) {
              return ZenggeTextAlertDialog(data['errmsg']);
            }).then((value) {});
      }
      handler.resolve(Response(
          data: ResultData(false, int.parse(code.toString()), data['errmsg'],
              data: data['data']),
          requestOptions: option));
    } else if (code == '74000' || code == 74000) {
      handler.resolve(Response(
          data: ResultData(false, int.parse(code.toString()), data['errmsg'],
              data: data['data']),
          requestOptions: option));
    } else if (code == '82000' || code == 82000) {
      handler.resolve(Response(
          data: ResultData(false, int.parse(code.toString()), data['errmsg'],
              data: data['data']),
          requestOptions: option));
    } else {
      // code 可能是 int 或 String，统一用 tryParse 避免 TypeError
      final codeInt = int.tryParse(code?.toString() ?? '') ?? 0;
      if (code != null &&
          code.toString().isNotEmpty &&
          data['errmsg'] != null) {
        final noTip = option.extra['noTip'] == true;
        if (!noTip) showToast(data['errmsg']);
        handler.resolve(Response(
            data:
                ResultData(false, codeInt, data['errmsg'], data: data['data']),
            requestOptions: option));
      } else {
        // handler.resolve(Response(
        //     data: _getErrorMessage(int.parse(code)), requestOptions: option));
        handler.resolve(Response(
            data:
                ResultData(false, codeInt, data['errmsg'], data: data['data']),
            requestOptions: option));
      }
    }
  }
}

// await pr.show();

void scanCardAndUpdateWalletInfo(BuildContext context,
    List<CurrencyInfo> currencyList, bool needBTC, String cardId) async {
  CardMessage cardMessage;
  String? cardNo = await LocalStorage.getCardNo(cardId);
  try {
    print("cardMessage_index");
    cardMessage = await BlockchainPlatform.instance
        .scanCardAndDerive(currencyList, '', cardId: cardId, cardNo: cardNo);
    print("cardMessage_index:${cardMessage.currencyList.length}");
    for (var i = 0; i < cardMessage.currencyList.length; i++) {
      print(
          'cardMessage_index$i,address:${cardMessage.currencyList[i]?.address}');
    }
  } catch (error) {
    if (error is PlatformException) {
      final isWrongCard =
          error.code == 'uid-mismatch' || error.message == 'WrongCardNumber';
      if (isWrongCard) {
        showToast('Wrong card. Please use the correct card.');
        return;
      }
    }
    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    showToast(error.toString());
    return;
  }
  ProgressDialog pr = ProgressDialog(context);

  await pr.show();

  String addressStr = "";
  try {
    addressStr = await BlockchainPlatform.instance.makeAddresses("", needBTC);
    await pr.hide();
  } catch (error) {
    await pr.hide();
    if (error is PlatformException && error.message == 'UserCancelled') {
      showToast('User Cancelled the scan');
      return;
    }
    String errorToString = error.toString();
    if (errorToString.isNotEmpty && errorToString.length < 100) {
      showToast(errorToString);
    }

    return;
  }
  print("makeAddresses:$addressStr");
  // ctx.state.address = addressStr;
  Map<String, CurrencyInfo> object = {};

  final validCurrencyMessages =
      cardMessage.currencyList.whereType<CurrencyInfoMessage>().toList();
  if (validCurrencyMessages.isEmpty) {
    showToast('No valid wallet data found, please try again.');
    return;
  }

  final currencies = validCurrencyMessages.map((e) {
    LogUtils.i("scanCardAndUpdateWalletInfo",
        "cardMessage_name:${e.id},needBTC:$needBTC, makeAddresses:$addressStr");

    if (needBTC == false && e.id.toLowerCase() == 'btc') {
      return CurrencyInfo.fromCurrencyMessageInBTC(e, true);
    } else {
      if (e.id.toLowerCase() == 'btc') {
        return CurrencyInfo.fromCurrencyMessage(e);
      } else {
        CurrencyInfo info = CurrencyInfo.fromCurrencyMessage(e);
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
      cardId: cardId,
      publicKey: HexUtils.uint8ListToHex(cardMessage.publicKey),
      wallets: currentIds.isNotEmpty ? currentIds : [],
      isSelected: true);

  if (cardInfo.publicKey.isEmpty) {
    LocalStorage.remove(LocalStorage.cardInfo + cardId);
    showToast('Scan failed, please try again');
    await pr.hide();
    return;
  } else {
    final cardListStr = cardInfo.toString();
    LocalStorage.saveString(LocalStorage.cardInfo + cardId, cardListStr);
  }
  await pr.hide();
  _onSysnWalletInfo(context, currentIds, needBTC, cardId);
}

void _onSysnWalletInfo(BuildContext context, List<CurrencyInfo> currencyList,
    bool needBTC, String cardId) async {
  // 币种列表
  if (currencyList.isEmpty) {
    print('currencyList is empty');
    return;
  }

  ProgressDialog pr = ProgressDialog(context);
  await pr.show();
  List wallletParames = [];
  for (var element in currencyList) {
    final networks = element.networkLists ?? const <CurrencyInfo>[];
    for (var network in networks) {
      var networkId = network.currencyData.networkId;
      if (networkId.contains('/test')) {
        networkId = networkId.split('/')[0];
      }
      LogUtils.i("_onSysnWalletInfo",
          "networkId:$networkId,code:${network.currencyData.symbol}, network.address:${network.address}");

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
    await pr.hide();
    return;
  }

  final data = <String, dynamic>{'uid': cardId, "wallets": wallletParames};
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.syncWallet, null, data: data);
  await pr.hide();
  if (result.isSuccess) {
    showToast('Sync wallet success');
    print('sysn wallet success');
    // ctx.dispatch(InvestmentActiveActionCreator.onPreActiviteCard());
  } else {
    showToast(result.message);
    return;
  }
}

// ignore: unused_element
void _onLoadDefaultCurrency(BuildContext context, String cardId) async {
  ProgressDialog pr = ProgressDialog(context);
  await pr.show();
  List list = [];

  var dict = {'page': '1', 'row': 20, 'uid': cardId, 'isDefault': true};

  final result = await HttpManager.getInstance()
      .get(NetworkAddress.cryptoListUrl, queryParameters: dict);
  if (result.isSuccess) {
    await pr.hide();
    print('22222result.data:${result.data}');
    final resultData = result.data;
    if (resultData is Map && resultData['rows'] is List) {
      list = resultData['rows'] as List;
    } else {
      showToast('No default currency found.');
      return;
    }
  } else {
    await pr.hide();
    showToast(result.message);
    return;
  }
  // }

  List<CurrencyInfo> currencyList = [];
  List<CoinMessage> tokens =
      list.map((e) => CoinMessage.fromJson(e)).toList().cast<CoinMessage>();

  for (final token in tokens) {
    final list = token.networks.map((e) {
      String networkId = e.networkId;
      if (networkId.toUpperCase().contains('ETH') && e.testnet) {
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
  bool needBTC = false;
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
    needBTC = true;
  } else {
    // CurrencyInfo? btcInfo = currencyList.firstWhereOrNull(
    //     (element) => (element.currencyData.id.toLowerCase() == 'btc'));
    // if (btcInfo == null) {
    //   btcInfo = CurrencyInfo(
    //       imageUrl: '',
    //       networkName: 'Bitcoin',
    //       currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'btc'));
    //   btcInfo.isHide = true;
    //   needBTC = false;
    //   print("sssss4442222");
    //   currencyList.add(btcInfo);
    // }
  }
  await pr.hide();
  scanCardAndUpdateWalletInfo(context, currencyList, needBTC, cardId);
}
