import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import '../bottom_sheet/i_bottom_sheet_service.dart';
import '../deep_link_handler.dart';
import '../i_walletkit_service.dart';
import '../widgets/wc_connection_widget/wc_connection_login_widget.dart';
import '../widgets/wc_connection_widget/wc_connection_model.dart';
import '../widgets/wc_connection_widget/wc_connection_widget.dart';
import '../widgets/wc_request_widget/wc_request_widget.dart';
import 'constants.dart';

class MethodsUtils {
  static final walletKit = GetIt.I<IWalletKitService>().walletKit;

  static Future<bool> requestLoginApproval(
      String type, {
        String? data,
        String? title,
        String? method,
        String? chainId,
        String? address,
        required String transportType,
        List<WCConnectionModel> extraModels = const [],
        VerifyContext? verifyContext,
      }) async {
    final bottomSheetService = GetIt.I<IBottomSheetService>();
    final WCBottomSheetResult rs = (await bottomSheetService.queueBottomSheet(
      widget: WCRequestWidget(
        verifyContext: verifyContext,
        child: WCConnectionLoginWidget(
          title: title ?? '登录请求',
          info: [
            WCConnectionModel(
              elements: [
                data??'',
              ],
            ),
            ...extraModels,
          ],
        ),
      ),
    )) ??
        WCBottomSheetResult.reject;

    return rs != WCBottomSheetResult.reject;
  }

  static Future<bool> requestApproval(
    String text, {
    String? title,
    String? method,
    String? chainId,
    String? address,
    required String transportType,
    List<WCConnectionModel> extraModels = const [],
    VerifyContext? verifyContext,
  }) async {
    final bottomSheetService = GetIt.I<IBottomSheetService>();
    final WCBottomSheetResult rs = (await bottomSheetService.queueBottomSheet(
          widget: WCRequestWidget(
            verifyContext: verifyContext,
            child: WCConnectionWidget(
              title: title ?? 'Approve Request',
              info: [
                WCConnectionModel(
                  title: 'Method: $method\n'
                      'Transport Type: ${transportType.toUpperCase()}\n'
                      'Chain ID: $chainId\n'
                      'Address: $address\n\n'
                      'Message:',
                  elements: [
                    text,
                  ],
                ),
                ...extraModels,
              ],
            ),
          ),
        )) ??
        WCBottomSheetResult.reject;

    return rs != WCBottomSheetResult.reject;
  }

  static void handleRedirect(
    String topic,
    Redirect? redirect, [
    String? error,
    bool success = false,
  ]) {
    debugPrint(
        '[SampleWallet] handleRedirect topic: $topic, redirect: $redirect, error: $error');
    openApp(
      topic,
      redirect,
      onFail: (e) => goBackModal(
        title: success ? 'Success' : 'Error',
        message: error,
        success: success,
      ),
    );
  }

  static void openApp(
    String topic,
    Redirect? redirect, {
    int delay = 100,
    Function(ReownSignError? error)? onFail,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));
    DeepLinkHandler.waiting.value = false;
    try {
      await walletKit.redirectToDapp(
        topic: topic,
        redirect: redirect,
      );
    } on ReownSignError catch (e) {
      onFail?.call(e);
    }
  }

  static void goBackModal({
    String? title,
    String? message,
    bool success = true,
  }) async {
    DeepLinkHandler.waiting.value = false;
    await GetIt.I<IBottomSheetService>().queueBottomSheet(
      closeAfter: success ? 3 : 0,
      widget: Container(
        color: Colors.white,
        height: 210.0,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              success ? Icons.check_circle_sharp : Icons.error_outline_sharp,
              color: success ? Colors.green[100] : Colors.red[100],
              size: 80.0,
            ),
            Text(
              title ?? 'Connected',
              style: StyleConstants.subtitleText.copyWith(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            Text(message ?? 'You can go back to your dApp now'),
          ],
        ),
      ),
    );
  }
}
