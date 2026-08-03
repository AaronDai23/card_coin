import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import 'i_walletkit_service.dart';

class DeepLinkHandler {
  static const _methodChannel = MethodChannel(
    'com.walletconnect.flutterwallet/methods',
  );
  static const _eventChannel = EventChannel(
    'com.walletconnect.flutterwallet/events',
  );
  static final waiting = ValueNotifier<bool>(false);
  static StreamSubscription? _subscription;
  static bool _listening = false;

  static void initListener() {
    if (kIsWeb || _listening) return;
    _listening = true;
    // iOS channel 可能略晚于 Dart main 注册；失败时短延迟重试一次
    _startListening(retry: true);
  }

  static void _startListening({required bool retry}) {
    try {
      _subscription?.cancel();
      _subscription = _eventChannel.receiveBroadcastStream().listen(
        _onLink,
        onError: (Object error) {
          _onError(error);
          if (retry && error is MissingPluginException) {
            _listening = false;
            Future<void>.delayed(const Duration(milliseconds: 400), () {
              if (!_listening) {
                _listening = true;
                _startListening(retry: false);
              }
            });
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('[SampleWallet] [DeepLinkHandler] initListener $e');
      _listening = false;
      if (retry) {
        Future<void>.delayed(const Duration(milliseconds: 400), () {
          if (!_listening) {
            _listening = true;
            _startListening(retry: false);
          }
        });
      }
    }
  }

  static void checkInitialLink() async {
    if (kIsWeb) return;
    try {
      final initialLink = await _methodChannel.invokeMethod('initialLink');
      if (initialLink != null) {
        _onLink(initialLink);
      }
    } catch (e) {
      debugPrint('[SampleWallet] [DeepLinkHandler] checkInitialLink $e');
    }
  }

  static IReownWalletKit get _walletKit =>
      GetIt.I<IWalletKitService>().walletKit;
  static Uri get nativeUri =>
      Uri.parse(_walletKit.metadata.redirect?.native ?? '');
  static Uri get universalUri =>
      Uri.parse(_walletKit.metadata.redirect?.universal ?? '');
  static String get host => universalUri.host;

  static void _onLink(dynamic link) async {
    debugPrint('[SampleWallet] _onLink $link');
    try {
      return await _walletKit.dispatchEnvelope('$link');
    } catch (e) {
      final decodedUri = Uri.parse(Uri.decodeFull('$link'));
      if (decodedUri.isScheme('wc')) {
        debugPrint('[SampleWallet] is legacy uri $decodedUri');
        waiting.value = true;
        await _walletKit.pair(uri: decodedUri);
      } else {
        final uriParam = ReownCoreUtils.getSearchParamFromURL(
          decodedUri.toString(),
          'uri',
        );
        if (decodedUri.isScheme(nativeUri.scheme) && uriParam.isNotEmpty) {
          debugPrint('[SampleWallet] is custom uri $decodedUri');
          waiting.value = true;
          final pairingUri = decodedUri.query.replaceFirst('uri=', '');
          await _walletKit.pair(uri: Uri.parse(pairingUri));
        }
      }
    }
  }

  static void _onError(Object error) {
    waiting.value = false;
    debugPrint('[SampleWallet] [DeepLinkHandler] _onError $error');
  }
}
