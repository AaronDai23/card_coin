import 'dart:convert';
import 'dart:io';

import 'package:card_coin/card_base/bean/card_info_bean.dart';
import 'package:card_coin/card_base/pages/main_page/action.dart';
import 'package:card_coin/reown_wallet/chain_services/evm_service.dart';
import 'package:card_coin/reown_wallet/deep_link_handler.dart';
import 'package:card_coin/reown_wallet/key_service/i_key_service.dart';
import 'package:card_coin/reown_wallet/models/chain_data.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../app.dart';
import '../../../../../cache/local_storage.dart';
import '../../../../../common/common_action/action.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../http/address.dart';
import '../../../../../http/http_manager.dart';
import '../../../../../reown_wallet/i_walletkit_service.dart';
import '../../../../bean/start_page_info.dart';
import '../../../../utils/card_util.dart';
import 'action.dart';
import 'state.dart';

Effect<TabWebviewState>? buildEffect() {
  return combineEffects(<Object, Effect<TabWebviewState>>{
    Lifecycle.initState: _onInit,
    TabWebviewAction.loadDomain: _onLoadDomain,
    TabWebviewAction.uploadRequestUrl: _onUploadRequestUrl,
    CommonAction.languageChanged: _onLanguageChanged,
    TabWebviewAction.injectedObject: _onInjectedObject,
    MainAction.updateUnReadCount: _onUpdateUnReadCount,
    TabWebviewAction.parsedWalletUrl: _onParsedWalletUrl,
    TabWebviewAction.goMainPage: _onGoMainPage,
  });
}

Future<void> _onInit(Action action, Context<TabWebviewState> ctx) async {
  if (Platform.isAndroid) WebView.platform = AndroidWebView();
  ctx.dispatch(TabWebviewActionCreator.onLoadDomain());
}

Future<void> _onGoMainPage(Action action, Context<TabWebviewState> ctx) async {
  ctx.broadcast(MainActionCreator.onNotificationBackClick());
}

Future<void> _onParsedWalletUrl(
    Action action, Context<TabWebviewState> ctx) async {
  Uri uri = action.payload;
  var parameters = uri.queryParameters;
  if (parameters['requestId'] != null) {
    return;
  }

  var keyService = GetIt.I<IKeyService>();
  if (keyService.getAllAccounts().isEmpty) {
    final blockchains =
        ChainsDataList.eip155Chains.map((e) => e.blockchainId).toList();
    var keyChains = await keyService.loadKeysFromScan(blockchains);
    if (keyChains.isNotEmpty) {
      var cardId = keyService.getCardId()!;
      LocalStorage.saveString('dapp_cardId', cardId);
      var walletKitService = await _initWalletKitService();
      DeepLinkHandler.waiting.value = true;
      walletKitService.walletKit.pair(uri: uri);
    } else {
      return;
    }
  } else {
    var walletKitService = GetIt.I<IWalletKitService>();
    DeepLinkHandler.waiting.value = true;
    walletKitService.walletKit.pair(uri: uri);
  }
}

Future<IWalletKitService> _initWalletKitService() async {
  var walletKitService = GetIt.I<IWalletKitService>();
  await walletKitService.create();
  for (final chainData in ChainsDataList.eip155Chains) {
    if (!GetIt.I.isRegistered<EVMService>(instanceName: chainData.chainId)) {
      GetIt.I.registerSingleton<EVMService>(
        EVMService(chainSupported: chainData),
        instanceName: chainData.chainId,
      );
    }
  }

  await walletKitService.init();
  return walletKitService;
}

Future<void> _onUpdateUnReadCount(
    Action action, Context<TabWebviewState> ctx) async {
  ctx.dispatch(TabWebviewActionCreator.onUpdateUnReadCount(action.payload));
}

Future<void> _onLanguageChanged(
    Action action, Context<TabWebviewState> ctx) async {
  var locale = ctx.state.languageLocale!;

  String pageUrl = ctx.state.categoryItem.target!;
  if (pageUrl.contains("?")) {
    pageUrl = '$pageUrl&language=${locale.languageCode}_${locale.countryCode}';
  } else {
    pageUrl = '$pageUrl?language=${locale.languageCode}_${locale.countryCode}';
  }

  if (ctx.state.categoryItem.token ?? false) {
    pageUrl = '$pageUrl&token=${ctx.state.userInfo.accessToken ?? ''}';
  }

  print('======loadUrl:$pageUrl');

  ctx.state.controller?.loadUrl(pageUrl);
}

void _onUploadRequestUrl(Action action, Context<TabWebviewState> ctx) {
  var params = {'url': action.payload, 'webViewName': 'tab_webview'};

  HttpManager.getInstance()
      .post(NetworkAddress.uploadWebviewUrl, null, data: params)
      .then((result) {
    if (result.isSuccess) {
      print('upload success');
    } else {
      print('upload failure:${result.message}');
    }
  });
}

Future<void> _onLoadDomain(Action action, Context<TabWebviewState> ctx) async {
  var blackListResult =
      await HttpManager.getInstance().get(NetworkAddress.h5BackListUrl);
  if (blackListResult.isSuccess) {
    List<String> blackList =
        blackListResult.data.map((url) => url).toList().cast<String>();
    ctx.dispatch(TabWebviewActionCreator.onLoadSuccess(blackList));
  } else {
    ctx.dispatch(
        TabWebviewActionCreator.onLoadFailure(blackListResult.message));
    return;
  }
}

Future<void> _onInjectedObject(
    Action action, Context<TabWebviewState> ctx) async {
  JavascriptMessage message = action.payload;
  var pageInfo = StartPageInfo.fromJson(json.decode(message.message));
  if (pageInfo.actionType == 'ACTIVITY') {
    if (pageInfo.actionTarget == 'scanCard') {
      BaseCardInfo? cardInfo = await CardUtil.scanPostCard(ctx.context);
      if (cardInfo == null) {
        return;
      }
      var result = await Navigator.of(ctx.context).pushNamed('editMemberPage',
          arguments: {'cardId': cardInfo.identifier, 'cardInfo': cardInfo});
      if (result != null && result == true) {
        ctx.state.controller?.reload();
      }
    } else {
      PageRoutes pageRoutes = AppRoute.global as PageRoutes;
      var canPush = pageRoutes.pages.keys.contains(pageInfo.actionTarget);
      if (canPush) {
        if (pageInfo.operation == 'OPEN') {
          await Navigator.of(ctx.context)
              .pushNamed(pageInfo.actionTarget ?? '');
          ctx.state.controller?.reload();
        } else {
          Navigator.of(ctx.context)
              .pushReplacementNamed(pageInfo.actionTarget ?? '');
        }
      } else {
        showToast(S.current.unsupportActivity(pageInfo.actionTarget ?? ''));
      }
    }
  } else {
    String pageUrl = pageInfo.actionTarget ?? "";
    if (pageInfo.token ?? false) {
      var userInfo = LocalStorage.getCacheUserInfo();
      if (pageInfo.actionTarget!.contains("?")) {
        pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
      } else {
        pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
      }
    }
    var arguments = {
      'pageUrl': pageUrl,
      'title': pageInfo.name,
      'callback': pageInfo.callback
    };

    if (pageInfo.operation == 'OPEN') {
      Navigator.of(ctx.context).pushNamed('webviewPage', arguments: arguments);
    } else {
      Navigator.of(ctx.context)
          .pushReplacementNamed('webviewPage', arguments: arguments);
    }
  }
}
