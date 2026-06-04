import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/reown_wallet/deep_link_handler.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:oktoast/oktoast.dart';

import '../../reown_wallet/chain_services/evm_service.dart';
import '../../reown_wallet/i_walletkit_service.dart';
import '../../reown_wallet/key_service/i_key_service.dart';
import '../../reown_wallet/models/chain_data.dart';
import 'action.dart';
import 'state.dart';

Effect<WebviewState>? buildEffect() {
  return combineEffects(<Object, Effect<WebviewState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    WebviewAction.parsedWalletUrl: _onParsedWalletUrl,
  });
}

void _onDispose(Action action, Context<WebviewState> ctx) {
  ctx.state.pageLoadTimeoutTimer?.cancel();
  ctx.state.pageLoadTimeoutTimer = null;
  ctx.state.progressStallTimer?.cancel();
  ctx.state.progressStallTimer = null;
  // var walletKitService = GetIt.I<IWalletKitService>();
  // walletKitService.onDispose();
  // walletKitService.walletKit.disconnectSession(topic: topic, reason: reason)
}

Future<void> _onInit(Action action, Context<WebviewState> ctx) async {
  var lang = ctx.state.languageResource!;

  if (ctx.state.pageUrl == null) {
    showToast(lang.notSetNetworkLink);
    return;
  }
  // SurfaceAndroidWebView（Virtual Display）让 WebView 在独立线程渲染，
  // 不占用 Flutter 帧预算，避免加载重 H5 时大量掉帧（Quality Skipped）。
  // WebView.platform 已在 mainCommon() 全局初始化，此处无需重复设置。
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

Future<void> _onParsedWalletUrl(
    Action action, Context<WebviewState> ctx) async {
  Uri uri = action.payload;
  var parameters = uri.queryParameters;
  if (parameters['requestId'] != null) {
    return;
  }

  var keyService = GetIt.I<IKeyService>();
  print(
      'keyService.getAllAccounts().isEmpty ${keyService.getAllAccounts().isEmpty}');
  if (keyService.getAllAccounts().isEmpty) {
    final blockchains =
        ChainsDataList.eip155Chains.map((e) => e.blockchainId).toList();
    var keyChains = await keyService.loadKeysFromScan(blockchains);
    if (keyChains.isNotEmpty) {
      var cardId = keyService.getCardId()!;
      LocalStorage.saveString('dapp_cardId', cardId);
      print('loadKeysFromScan:cardId $cardId');
      var walletKitService = await _initWalletKitService();
      DeepLinkHandler.waiting.value = true;
      walletKitService.walletKit.pair(uri: uri);
      // launchUrl(uri);
    } else {
      return;
    }
  } else {
    var walletKitService = GetIt.I<IWalletKitService>();
    DeepLinkHandler.waiting.value = true;
    walletKitService.walletKit.pair(uri: uri);
  }
}
